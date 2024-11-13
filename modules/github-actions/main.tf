# for githubactions oidc provider
# tflint-ignore: terraform_required_providers
data "tls_certificate" "main" {
  url = "${var.github_oidc_url}/.well-known/openid-configuration"
}

resource "aws_iam_openid_connect_provider" "main" {
  count = var.create_oidc_provider ? 1 : 0

  url             = var.github_oidc_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.main.certificates[0].sha1_fingerprint]
}

# 既存の OIDC プロバイダーを参照するためのデータソース
data "aws_iam_openid_connect_provider" "existing" {
  count = var.create_oidc_provider ? 0 : 1
  arn   = var.existing_oidc_provider_arn
}

# OIDC プロバイダーの ARN を決定するためのローカル値
locals {
  oidc_provider_arn = var.create_oidc_provider ? aws_iam_openid_connect_provider.main[0].arn : data.aws_iam_openid_connect_provider.existing[0].arn
}

# for githubactions iam role
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_owner}/${var.github_repo}:*"]
    }
    principals {
      type        = "Federated"
      identifiers = [local.oidc_provider_arn]
    }
  }
}

resource "aws_iam_role" "main" {
  name               = "${var.prefix}-githubactions"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "administrator" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
