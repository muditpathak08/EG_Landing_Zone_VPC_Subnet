resource "aws_vpc" "aws-vpc" {
  cidr_block           = var.cidr
  tags = {
    Name        = "${var.service} vpc"
	Purpose     = "Terraform"
  }
}
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = true
  tags = {
    Name        = "${var.service}-public-${var.availability_zones[count.index]}"
    Terraform   = "true"
  }
}
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.aws-vpc.id
  count             = length(var.private_subnets)
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name        = "${var.service}-private-${count.index + 1}"
    Terraform   = "true"
  }
}
###################
## Internet Gateway
###################
resource "aws_internet_gateway" "aws-igw" {
vpc_id = aws_vpc.aws-vpc.id
  tags = {
    Name        = "${var.service}-igw"
    Terraform   = "true"
  }
}
##########################
## Routing(public subnets)
##########################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.aws-vpc.id
  tags = {
    Name        = "${var.service}-public-route-table"
  }
}
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aws-igw.id
}
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
##############
## Elastic IP
##############
resource "aws_eip" "eip" {
  count = var.create ? 1: 0
  tags = {
      Name = "${var.service}-eip"
      Terraform   = "true"
  }
}
##############
## Nat Gateway
##############
resource "aws_nat_gateway" "nat" {
  count = var.create ? 1: 0
  allocation_id = "${aws_eip.eip[count.index].id}"
  subnet_id = "${aws_subnet.public.*.id}"
  depends_on = [aws_eip.eip, aws_internet_gateway.aws-igw, aws_subnet.public]
  tags ={
    Name = "${var.service}-ngw"
    Terraform   = "true"
  } 
}
##########################
## Routing(private subnets)
##########################
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.aws-vpc.id
  tags = {
    Name        = "${var.service}-private-route-table"
  }
}
resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat.*.id
}
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

