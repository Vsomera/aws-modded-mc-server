terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

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

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.mc_server_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false
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

resource "aws_instance" "mc_server_ec2" {
  # ami           = "ami-0606dd43116f5ed57" // ubuntu 22.04
  # instance_type = "t2.large"              // 2vcpu, 8gb ram

  // DEBUG
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"


  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "mc_server_ec2"
  }

}

resource "aws_s3_bucket" "mc_server_s3bucket" {
  bucket = "server-bucket-mc"

  tags = {
    Name = "mc_server_s3bucket"
  }
}

resource "aws_s3_object" "setup_folder" {
  bucket = aws_s3_bucket.mc_server_s3bucket.id
  key    = "setup/"
}
