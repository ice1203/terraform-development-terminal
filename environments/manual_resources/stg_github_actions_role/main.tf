locals {
  github_actions_role = {
    github_owner = "<your_github_username>"
    github_repo  = "<your_github_repo>"
  }
}
# AWSアカウントIDを取得
data "aws_caller_identity" "current" {}
module "github_actions_role" {
  source = "../../../modules/github-actions"

  prefix                     = local.prefix
  github_owner               = local.github_actions_role.github_owner
  github_repo                = local.github_actions_role.github_repo
  create_oidc_provider       = false
  existing_oidc_provider_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"

}
