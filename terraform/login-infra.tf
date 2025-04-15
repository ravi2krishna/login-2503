# VPC
resource "aws_vpc" "login-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "login-vpc"
  }
}

# Web Subnet
resource "aws_subnet" "login-web-sn" {
  vpc_id     = aws_vpc.login-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "login-web-subnet"
  }
}

# API Subnet
resource "aws_subnet" "login-api-sn" {
  vpc_id     = aws_vpc.login-vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "login-api-subnet"
  }
}

# DB Subnet
resource "aws_subnet" "login-db-sn" {
  vpc_id     = aws_vpc.login-vpc.id
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "login-database-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "login-igw" {
  vpc_id = aws_vpc.login-vpc.id

  tags = {
    Name = "login-internet-gateway"
  }
}

# Public Route Table
resource "aws_route_table" "login-pub-rt" {
  vpc_id = aws_vpc.login-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.login-igw.id
  }

  tags = {
    Name = "login-public-rt"
  }
}
