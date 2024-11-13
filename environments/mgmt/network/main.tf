module "main_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "${local.prefix}-vpc"
  cidr = "172.18.0.0/16"

  azs             = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  private_subnets = ["172.18.0.0/24", "172.18.1.0/24", "172.18.2.0/24"]
  public_subnets  = ["172.18.128.0/24", "172.18.129.0/24", "172.18.130.0/24"]
  intra_subnets   = ["172.18.131.0/24", "172.18.132.0/24", "172.18.133.0/24"]

  enable_nat_gateway                   = false
  single_nat_gateway                   = false
  enable_vpn_gateway                   = false
  enable_dns_hostnames                 = true
  manage_default_network_acl           = true
  enable_flow_log                      = false
  flow_log_max_aggregation_interval    = 60
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true
  public_dedicated_network_acl         = true

  tags = merge(local.tags, {
    Endpoint = "true"
  })
}
# VPC Endpoint
## for S3 (Gateway Endpoint)
module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.8.1"

  vpc_id = module.main_vpc.vpc_id

  create_security_group = false

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = flatten([module.main_vpc.intra_route_table_ids, module.main_vpc.private_route_table_ids, module.main_vpc.public_route_table_ids])
      tags            = { Name = "s3-vpc-endpoint" }
    },
    dynamodb = {
      service         = "dynamodb"
      service_type    = "Gateway"
      route_table_ids = flatten([module.main_vpc.intra_route_table_ids, module.main_vpc.private_route_table_ids, module.main_vpc.public_route_table_ids])
      tags = { Name = "dynamodb-vpc-endpoint" }
    },
  }

  tags = merge(local.tags, {
    Endpoint = "true"
  })
}
