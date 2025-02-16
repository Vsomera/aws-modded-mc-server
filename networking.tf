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

resource "aws_security_group" "mc_server_sg" {
  name        = "mc_server_sg"
  description = "Allow Minecraft server TCP/UDP traffic"
  vpc_id      = aws_vpc.mc_server_vpc.id

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # allowing all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "mc_server_sg"
  }
}

resource "aws_eip" "mc-ec2-eip" {
  vpc = true
  instance = aws_instance.mc_server_ec2.id

  tags = {
    Name = "mc_server_elastic_ip"
  }
}

output "mc_ip_address" {
  value = aws_eip.mc-ec2-eip.public_ip
  description = "ip address for minecraft server"
}
