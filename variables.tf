variable "service" {
  type        = string
  description = "Application Name"
}
variable "public_subnet_name" {
  type        = list
  description = "public subnet name"
}

variable "private_subnet_name" {
  type        = list
  description = "private subnet name"
}
variable "cidr" {
  description = "The CIDR block for the VPC."
  type = string
}
variable "public_subnets" {
  type = list
  description = "List of public subnets"
}

variable "private_subnets" {
  type =list
  description = "List of private subnets"
}

variable "availability_zones" {
  description = "List of availability zones"
}
