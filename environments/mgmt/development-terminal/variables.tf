variable "vpc_id" {
  description = "VPC ID"
  type        = string

}
variable "private_subnets" {
  description = "Private Subnets"
  type        = list(string)
}

