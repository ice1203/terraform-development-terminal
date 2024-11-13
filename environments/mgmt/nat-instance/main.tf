locals {
  module_natinstance_info = {
    instance_type     = "t4g.micro"
    ec2_key_pair_name = "<your_key_pair_name>"
    security_group_rules = {
      inbound_rules = {
        80 = {
          from_port                    = 80
          to_port                      = 80
          ip_protocol                  = "tcp"
          cidr_ipv4                    = var.vpc_cidr_block
          referenced_security_group_id = null
        }
        443 = {
          from_port                    = 443
          to_port                      = 443
          ip_protocol                  = "tcp"
          cidr_ipv4                    = var.vpc_cidr_block
          referenced_security_group_id = null
        }
      }
      outbound_rules = {
        80 = {
          from_port   = 80
          to_port     = 80
          ip_protocol = "tcp"
          cidr_ipv4   = "0.0.0.0/0"
        }
        443 = {
          from_port   = 443
          to_port     = 443
          ip_protocol = "tcp"
          cidr_ipv4   = "0.0.0.0/0"
        }
      }
    }
  }
}
module "natinstance" {
  source = "../../../modules/natinstance-ec2"

  prefix                         = "${local.prefix}-nat"
  vpc_id                         = var.vpc_id
  private_subnet_route_table_ids = var.private_subnet_route_table_ids
  ec2_instance_info = {
    instance_type = local.module_natinstance_info.instance_type
    subnet_id     = var.public_subnets[0]
    key_pair_name = local.module_natinstance_info.ec2_key_pair_name
  }
  security_group_rules = local.module_natinstance_info.security_group_rules

}
