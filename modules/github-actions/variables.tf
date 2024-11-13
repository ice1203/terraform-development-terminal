variable "prefix" {
  type        = string
  description = "resource name prefix"

}
variable "github_owner" {
  type        = string
  description = "github owner"
}
variable "github_repo" {
  type        = string
  description = "github repo"

}
# 新しい変数を追加
variable "create_oidc_provider" {
  description = "Flag to determine whether to create a new OIDC provider"
  type        = bool
  default     = true
}

# GitHub OIDC プロバイダーの URL を変数として定義
variable "github_oidc_url" {
  description = "The URL of the GitHub OIDC provider"
  type        = string
  default     = "https://token.actions.githubusercontent.com"
}
# 既存の OIDC プロバイダーの ARN（create_oidc_provider が false の場合に使用）
variable "existing_oidc_provider_arn" {
  description = "ARN of an existing OIDC provider (used when create_oidc_provider is false)"
  type        = string
  default     = ""
}
