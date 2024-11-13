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
    public_subnets = ["subnet-eeeeeeeeeeeeeeeee"]
  }
}
# 依存関係のテスト用
dependency "nat_instance" {
  config_path = "../nat-instance"

  mock_outputs_merge_strategy_with_state = "shallow"
  mock_outputs = {
    nat_instance_sg_id = "sg-1xxxxxxxxxxxxxxxx"
  }

}
inputs = {
  vpc_id = dependency.network.outputs.vpc_id
  public_subnets                       = dependency.network.outputs.public_subnets
}
