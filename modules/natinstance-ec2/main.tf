# security groupの作成
resource "aws_security_group" "main" {
  name_prefix = var.prefix
  description = "for ${var.prefix}-server"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.prefix}-ec2-sg"
  }
  lifecycle {
    create_before_destroy = true
  }
}
#trivy:ignore:AVD-AWS-0104 dockerhubやパッケージ取得のための通信があるので全ての通信を許可
resource "aws_vpc_security_group_egress_rule" "main" {
  for_each          = var.security_group_rules.outbound_rules
  security_group_id = aws_security_group.main.id

  cidr_ipv4   = each.value.cidr_ipv4
  from_port   = each.value.from_port
  ip_protocol = each.value.ip_protocol
  to_port     = each.value.to_port
}
resource "aws_vpc_security_group_ingress_rule" "main" {
  for_each          = var.security_group_rules.inbound_rules
  security_group_id = aws_security_group.main.id

  cidr_ipv4                    = each.value.cidr_ipv4
  referenced_security_group_id = each.value.referenced_security_group_id
  from_port                    = each.value.from_port
  ip_protocol                  = each.value.ip_protocol
  to_port                      = each.value.to_port
}
data "aws_ssm_parameter" "ubuntu" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-arm64"
}

## ec2 role
data "aws_iam_policy_document" "main" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "main" {
  name               = "${var.prefix}-ec2-role01"
  assume_role_policy = data.aws_iam_policy_document.main.json
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "main" {
  name = "${var.prefix}-ec2-role01"
  role = aws_iam_role.main.name
}

resource "aws_instance" "main" {
  ami                    = data.aws_ssm_parameter.ubuntu.value
  instance_type          = var.ec2_instance_info.instance_type
  subnet_id              = var.ec2_instance_info.subnet_id
  source_dest_check      = false
  vpc_security_group_ids = [aws_security_group.main.id]
  user_data              = templatefile("${path.module}/templates/user_data.sh.tftpl", {})
  key_name               = var.ec2_instance_info.key_pair_name
  iam_instance_profile   = aws_iam_instance_profile.main.name
  # user_dataの変更があった場合にインスタンスを再作成するかどうか。falseにすると変更があっても停止・起動の動作となる
  user_data_replace_on_change = true

  # ebs定義
  root_block_device {
    volume_size = 10
    encrypted   = true
  }
  # IMDSv2の設定
  metadata_options {
    http_tokens = "required"
  }
  tags = {
    Name = "${var.prefix}-server"
  }
}

# Elastic IP for NAT Instance
resource "aws_eip" "main" {
  instance = aws_instance.main.id
  domain   = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

# プライベートサブネットのルートテーブルにNATインスタンスを設定
resource "aws_route" "main" {
  for_each = { for i, l in var.private_subnet_route_table_ids : i => l }

  route_table_id         = each.value
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.main.primary_network_interface_id
}
