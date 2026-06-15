# VPC
resource "aws_vpc" "this" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "${var.project}-${var.environment}-vpc"
  }
}


# AVAILABILITY ZONES
data "aws_availability_zones" "available" {
  state = "available"
}


# PUBLIC SUBNETS (A & B)
resource "aws_subnet" "public_a" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.public_a_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-${var.environment}-public-a-subnet"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.public_b_cidr
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-${var.environment}-public-b-subnet"
  }
}


# PRIVATE SUBNETS (A & B)
resource "aws_subnet" "private_a" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.private_a_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.project}-${var.environment}-private-a-subnet"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.private_b_cidr
  availability_zone = data.aws_availability_zones.available.names[1]


  tags = {
    Name = "${var.project}-${var.environment}-private-b-subnet"
  }
}

# INTERNET GATEWAY

# NAT GATEWAY

# PUBLIC ROUTE TABLE


# PRIVATE ROUTE TABLE


# PUBLIC ROUTE TABLE ASSOCIATION

# PRIVATE ROUTE TABLE ASSOCIATION
