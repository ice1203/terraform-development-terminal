include {
  path = find_in_parent_folders()
}
dependency "network" {
  config_path = "../network"

  mock_outputs_merge_strategy_with_state = "shallow"
  mock_outputs = {
    vpc_id = "vpc-0xxxxxxxxxxxx"
    vpc_cidr_block = "10.0.0.0/24"
    public_subnets = ["subnet-eeeeeeeeeeeeeeeee"]
    private_subnet_route_table_ids = ["subnet-eeeeeeeeeeeeeeeee"]
  }
}

inputs = {
  vpc_id = dependency.network.outputs.vpc_id
  vpc_cidr_block = dependency.network.outputs.vpc_cidr_block
  public_subnets                       = dependency.network.outputs.public_subnets
  private_subnet_route_table_ids                       = dependency.network.outputs.private_subnet_route_table_ids
}
