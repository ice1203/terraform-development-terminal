# tflint-ignore: terraform_unused_declarations
variable "env" {
  description = "環境のプレフィックス"
  type        = string
}

# tflint-ignore: terraform_unused_declarations
variable "system" {
  description = "システム名称(-区切り)"
  type        = string
}

locals {
  # tflint-ignore: terraform_unused_declarations
  prefix = "${var.system}-${var.env}"
  # tflint-ignore: terraform_unused_declarations
  tags = {
    "Terraform"   = "true"
    "Environment" = var.env
    "System"      = var.system
  }
}
