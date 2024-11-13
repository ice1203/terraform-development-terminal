variable "vpc_id" {
  description = "VPC ID"
  type        = string

}
variable "public_subnets" {
  description = "Public Subnets"
  type        = list(string)
}

