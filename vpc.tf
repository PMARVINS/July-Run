# VPC
resource "aws_vpc" "PaulMarvin-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "PaulMarvin-vpc"
  }
}

# Public Subnets
resource "aws_subnet" "public_sub1" { 
  vpc_id     = aws_vpc.PaulMarvin-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public_sub1"
  }
}

resource "aws_subnet" "public_sub2" { 
  vpc_id     = aws_vpc.PaulMarvin-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "public_sub2"
  }
}

#Private Subnets
resource "aws_subnet" "private_sub1" { 
  vpc_id     = aws_vpc.PaulMarvin-vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "private_sub1"
  }
}

resource "aws_subnet" "private_sub2" { 
  vpc_id     = aws_vpc.PaulMarvin-vpc.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "private_sub2"
  }
}

# Public Route table
resource "aws_route_table" "Public-route-table" {
  vpc_id = aws_vpc.PaulMarvin-vpc.id

  tags = {
    Name = "Public-route-table"
  }
}

# Private route table
resource "aws_route_table" "Private-route-table" {
  vpc_id = aws_vpc.PaulMarvin-vpc.id

  tags = {
    Name = "Private-route-table"
  }
}

#Route association -Public
resource "aws_route_table_association" "Public-route-table-1" {
  subnet_id      = aws_subnet.public_sub1.id
  route_table_id = aws_route_table.Public-route-table.id
}

resource "aws_route_table_association" "Public-route-table-2" {
  subnet_id      = aws_subnet.public_sub2.id
  route_table_id = aws_route_table.Public-route-table.id
}

# Route association-Private
resource "aws_route_table_association" "Private-route-table-1" {
  subnet_id      = aws_subnet.private_sub1.id
  route_table_id = aws_route_table.Private-route-table.id
}

resource "aws_route_table_association" "Private-route-table-2" {
  subnet_id      = aws_subnet.private_sub2.id
  route_table_id = aws_route_table.Private-route-table.id
}

# Internet gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.PaulMarvin-vpc.id

  tags = {
    Name = "IGW"
  }
}

#AWS Route
resource "aws_route" "public-igw-route" {
  route_table_id            = aws_route_table.Public-route-table.id
  gateway_id                = aws_internet_gateway.IGW.id
  destination_cidr_block    = "0.0.0.0/0"
}

#Elastic IP
resource "aws_eip" "EIP-NAT" {
  vpc      = true

  tags     ={
    name   ="EIP-NAT"
  } 
}

#Nat Gateway
resource "aws_nat_gateway" "NAT-1" {
  allocation_id = aws_eip.EIP-NAT.id
  subnet_id     = aws_subnet.public_sub1.id

  tags   ={
    Name ="NAT-Public-1"
  }
}

