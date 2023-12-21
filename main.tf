module "network" {
  source             = "./modules/network"
  cidr               = var.cidr
  eip_id             = var.eip_id
  service            = var.service
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
  private_subnets    = var.private_subnets
  public_subnet_name = var.public_subnet_name
  private_subnet_name = var.private_subnet_name
}
