resource "aws_vpc" "mc_server_vpc" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "mc_server_vpc"
  }
}

resource "aws_internet_gateway" "mc_server_igw" {
  vpc_id = aws_vpc.mc_server_vpc.id

  tags = {
    Name = "mc_server_igw"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.mc_server_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.mc_server_vpc.id

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mc_server_igw.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
