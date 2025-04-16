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


# Public Route Table - Web SN ASC
resource "aws_route_table_association" "login-web-sn-asc" {
  subnet_id      = aws_subnet.login-web-sn.id
  route_table_id = aws_route_table.login-pub-rt.id
}

# Public Route Table - API SN ASC
resource "aws_route_table_association" "login-api-sn-asc" {
  subnet_id      = aws_subnet.login-api-sn.id
  route_table_id = aws_route_table.login-pub-rt.id
}

# Private Route Table
resource "aws_route_table" "login-pvt-rt" {
  vpc_id = aws_vpc.login-vpc.id

  tags = {
    Name = "login-private-rt"
  }
}

# Private Route Table - DB SN ASC
resource "aws_route_table_association" "login-db-sn-asc" {
  subnet_id      = aws_subnet.login-db-sn.id
  route_table_id = aws_route_table.login-pvt-rt.id
}

# Web NACL
resource "aws_network_acl" "login-web-nacl" {
  vpc_id = aws_vpc.login-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "login-web-nacl"
  }
}

# Web NACL Association
resource "aws_network_acl_association" "login-web-nacl-asc" {
  network_acl_id = aws_network_acl.login-web-nacl.id
  subnet_id      = aws_subnet.login-web-sn.id
}

# API NACL
resource "aws_network_acl" "login-api-nacl" {
  vpc_id = aws_vpc.login-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "login-api-nacl"
  }
}

# API NACL Association
resource "aws_network_acl_association" "login-api-nacl-asc" {
  network_acl_id = aws_network_acl.login-api-nacl.id
  subnet_id      = aws_subnet.login-api-sn.id
}