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
    Name        = "${var.public_subnet_name}"
    Terraform   = "true"
  }
}
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.aws-vpc.id
  count             = length(var.private_subnets)
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name        = "${var.private_subnet_name}"
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
## Nat Gateway
##############
resource "aws_nat_gateway" "nat" {
  allocation_id  = var.eip_id
  subnet_id      = aws_subnet.public[0].id
  depends_on = [aws_internet_gateway.aws-igw, aws_subnet.public]
  tags ={
    Name = "${var.service}-ngw"
    Terraform   = "true"
  } 
}
##########################
## Routing(private subnets)
##########################

resource "aws_route_table" "private_route" {
  count = "${length(var.private_subnets)}"
  vpc_id = aws_vpc.aws-vpc.id

  # Default route through NAT
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "${var.service}-private-route-table"
    Environment = "${var.tag_environment}"
    Application = "${var.tag_application}"
    Terraform   = "true"
   }
}

resource "aws_route_table_association" "private_route" {
  count = "${length(var.private_subnets)}"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private_route.*.id, count.index)}"
}


