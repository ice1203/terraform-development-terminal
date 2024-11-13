remote_state {
  backend = "s3"
  generate = {
    path      = "_backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "<your-bucket-name>"
    region = "ap-northeast-1"
    key = "terraform-development-terminal/environments/manual_resources/${path_relative_to_include()}/terraform.tfstate"
  }
}
inputs = {
  env = "manual_resources"
  system      = "<your_system_name>"
}

generate "provider" {
  path = "_providers.tf"
  if_exists = "overwrite_terragrunt"
  contents = file("../../shared/providers.tf")
}

generate "version" {
  path      = "_terraform.tf"
  if_exists = "overwrite_terragrunt"
  contents  = file("../../shared/terraform.tf")
}

generate "variables" {
  path      = "_variables.tf"
  if_exists = "overwrite_terragrunt"
  contents  = file("../../shared/variables.tf")
}
