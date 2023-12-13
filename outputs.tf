output "eip" {
  value       = module.network.eip
  description = "Elastic IP for NGW"
}

output "nat" {
  value       = module.network.nat
  description = "Nat Gateway for Route Table for  Subnet"
}


output "igw" {
  value       = module.network.igw
  description = "Internet Gateway for Route Table for  Subnet"
}

output "private_subnets" {  
  value       = module.network.private_subnets
  description = "Private Subnet"
}

output "public_subnets" {
  value       = module.network.public_subnets
  description = "Public Subnet"
}
output "vpc_id" {
  description = "VPC Id"
  value       = module.network.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = module.network.vpc_cidr
}
output "az" {
  value       = module.network.az
  description = "Availability Zone"
}
