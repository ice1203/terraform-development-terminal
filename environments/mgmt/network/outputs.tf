output "vpc_id" {
  value       = module.main_vpc.vpc_id
  description = "vpc id"
}
output "vpc_cidr_block" {
  value       = module.main_vpc.vpc_cidr_block
  description = "vpc cidr block"
}
output "public_subnets" {
  value       = module.main_vpc.public_subnets
  description = "List of public Subnets information"
}
output "private_subnets" {
  value       = module.main_vpc.private_subnets
  description = "List of private Subnets information"
}
output "public_subnet_route_table_ids" {
  value       = module.main_vpc.public_route_table_ids
  description = "List of public Subnet Route Table IDs"
}
output "private_subnet_route_table_ids" {
  value       = module.main_vpc.private_route_table_ids
  description = "List of private Subnet Route Table IDs"
}
