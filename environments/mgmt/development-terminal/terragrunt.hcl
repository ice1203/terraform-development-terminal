include {
  path = find_in_parent_folders()
}
dependencies {
  paths = ["../network", "../nat-instance"]
}
dependency "network" {
  config_path = "../network"

  mock_outputs_merge_strategy_with_state = "shallow"
  mock_outputs = {
    vpc_id = "vpc-000000000000000"
    private_subnets = ["subnet-eeeeeeeeeeeeeeeee"]
  }
}
inputs = {
  vpc_id = dependency.network.outputs.vpc_id
  private_subnets                       = dependency.network.outputs.private_subnets
}
