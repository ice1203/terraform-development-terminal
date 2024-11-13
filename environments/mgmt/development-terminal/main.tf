# 7
locals {
  subname = "developterminal"
  module_devterm_info = {
    #instance_type     = "c6a.large"
    instance_type     = "t3.micro"
    ec2_key_pair_name = "<your_key_pair_name>"
    security_group_rules = {
      inbound_rules = {
      }
      outbound_rules = {
        all = {
          from_port   = -1
          to_port     = -1
          ip_protocol = "-1"
          cidr_ipv4   = "0.0.0.0/0"
        }
      }
    }
  }
}
module "development-terminal" {
  source = "../../../modules/development-terminal"

  prefix = "${local.prefix}-${local.subname}"
  vpc_id = var.vpc_id
  ec2_instance_info = {
    instance_type = local.module_devterm_info.instance_type
    subnet_id     = var.private_subnets[0]
    key_pair_name = local.module_devterm_info.ec2_key_pair_name
  }
  security_group_rules = local.module_devterm_info.security_group_rules

}
