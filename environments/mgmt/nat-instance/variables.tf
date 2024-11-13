variable "vpc_id" {
  description = "VPC ID"
  type        = string

}
variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  type        = string

}
variable "private_subnet_route_table_ids" {
  description = "Private Subnet Route Table IDs"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public Subnets"
  type        = list(string)
}
