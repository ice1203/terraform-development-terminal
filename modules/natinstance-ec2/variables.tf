variable "prefix" {
  type        = string
  description = "resource name prefix"
}
variable "vpc_id" {
  type        = string
  description = "vpc id"

}
variable "private_subnet_route_table_ids" {
  type        = list(string)
  description = "private subnet route table ids"

}
variable "ec2_instance_info" {
  type = object({
    instance_type = string
    subnet_id     = string
    key_pair_name = string
  })
  description = "ec2 instance information"

}
variable "security_group_rules" {
  type = object({
    inbound_rules = map(object({
      from_port                    = number
      to_port                      = number
      ip_protocol                  = string
      cidr_ipv4                    = string
      referenced_security_group_id = string
    }))
    outbound_rules = map(object({
      from_port   = number
      to_port     = number
      ip_protocol = string
      cidr_ipv4   = string
    }))
  })
}
