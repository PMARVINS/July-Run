# creating aws networking for a project

resource "aws_vpc" "Rock-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "rock-vpc"
  }
}

# creating public subnet

resource "aws_subnet" "Prod-pub-sub1" {
  vpc_id            = aws_vpc.Rock-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "rock_public_subnet"
  }
}

# creating public subnet 2

resource "aws_subnet" "prod-pub-sub2" {
  vpc_id            = aws_vpc.Rock-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "rock_public_subnet"
  }
}

# creating public subnet 3

resource "aws_subnet" "prod-pub-sub3" {
  vpc_id            = aws_vpc.Rock-vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "rock_public_subnet"
  }
}

# creating private subnet 

resource "aws_subnet" "Prod-priv-sub1" {
  vpc_id            = aws_vpc.Rock-vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "rock_private_subnet"
  }
}

# creating private subnet 2

resource "aws_subnet" "prod-priv-sub2" {
  vpc_id            = aws_vpc.Rock-vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "rock_private_subnet"
  }
}

# public route table

resource "aws_route_table" "prod-pub-route-table" {
  vpc_id = aws_vpc.Rock-vpc.id


  route = []

  tags = {
    Name = "Rock-public-route-table"
  }
}

# private route table

resource "aws_route_table" "prod-priv-route-table" {
  vpc_id = aws_vpc.Rock-vpc.id


  route = []

  tags = {
    Name = "Rock-private-route-table"
  }
}


# associate Public subnet 1 with Public route table

resource "aws_route_table_association" "prod-pub-route-association1" {
  subnet_id      = aws_subnet.Prod-pub-sub1.id
  route_table_id = aws_route_table.prod-pub-route-table.id
}

# associate Public subnet 2 with Public route table

resource "aws_route_table_association" "prod-pub-route-association2" {
  subnet_id      = aws_subnet.prod-pub-sub2.id
  route_table_id = aws_route_table.prod-pub-route-table.id
}

# associate Public subnet 3 with Public route table

resource "aws_route_table_association" "prod-pub-route-association3" {
  subnet_id      = aws_subnet.prod-pub-sub3.id
  route_table_id = aws_route_table.prod-pub-route-table.id
}


# associate Private subnet 1 with Private route table

resource "aws_route_table_association" "prod-priv-route-association1" {
  subnet_id      = aws_subnet.Prod-priv-sub1.id
  route_table_id = aws_route_table.prod-priv-route-table.id
}

# associate Private subnet 2 with Private route table

resource "aws_route_table_association" "prod-priv-route-association2" {
  subnet_id      = aws_subnet.prod-priv-sub2.id
  route_table_id = aws_route_table.prod-priv-route-table.id
}

# Internet gateway

resource "aws_internet_gateway" "Prod-igw" {
  vpc_id = aws_vpc.Rock-vpc.id

  tags = {
    Name = "Rock_IGW"
  }
}

# associate internet gateway to public route table

resource "aws_route" "Prod-igw-association" {
  route_table_id         = aws_route_table.prod-pub-route-table.id
  gateway_id             = aws_internet_gateway.Prod-igw.id
  destination_cidr_block = "0.0.0.0/0"
}

#create Elastic IP

resource "aws_eip" "Prod-EIP" {
  vpc = true
}

#Creating NAT gateway.

resource "aws_nat_gateway" "Prod-Nat-gateway" {
  allocation_id = aws_eip.Prod-EIP.id
  subnet_id     = aws_subnet.Prod-pub-sub1.id

  tags = {
    Name = "Prod-Nat-gateway"
  }
}

#Associating NATgateway with private route table

resource "aws_route" "prod-Nat-association" {
  route_table_id         = aws_route_table.prod-priv-route-table.id
  nat_gateway_id         = aws_nat_gateway.Prod-Nat-gateway.id
  destination_cidr_block = "0.0.0.0/0"
}


