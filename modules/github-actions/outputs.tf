output "github_actions_role_name" {
  value       = aws_iam_role.main.name
  description = "The role name for the GitHub Actions service"
}
