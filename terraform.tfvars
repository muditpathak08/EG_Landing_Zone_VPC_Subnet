availability_zones = ["us-east-2a", "us-east-2b"]
public_subnets     = ["10.41.10.0/24", "10.41.11.0/24"]
private_subnets    = ["10.41.20.0/24", "10.41.21.0/24"]
service            =  "terraform"
cidr               = "10.41.0.0/16"
private_subnet_name = ["10.41.10.0-terraform-private-us-east-2a", "10.41.11.0-terraform-private-us-east-2b"]
public_subnet_name =  ["10.41.20.0-terraform-public-us-east-2a", "10.41.21.0-terraform-public-us-east-2b"]
