module "network" {
  source             = "./modules/network"
  cidr               = var.cidr
  service            = var.service
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
  private_subnets    = var.private_subnets
}
