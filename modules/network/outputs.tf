output "nat" {
  value       = aws_nat_gateway.nat.*.id
  description = "Nat Gateway for Route Table for  Subnet"
}


output "igw" {
  value       = aws_internet_gateway.aws-igw.*.id
  description = "Internet Gateway for Route Table for  Subnet"
}

output "private_subnets" {  
  value       = ["${aws_subnet.private.*.id}"]
  description = "Private Subnet"
}

output "public_subnets" {
  value       =["${aws_subnet.public.*.id}"]
  description = "Public Subnet"
}
output "vpc_id" {
  description = "VPC Id"
  value       = "${aws_vpc.aws-vpc.id}"
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = var.cidr
}


output "az" {
  value       = var.availability_zones
  description = "Availability Zone"
}
