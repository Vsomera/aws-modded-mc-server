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

resource "aws_instance" "mc_server_ec2" {
  ami           = "ami-0606dd43116f5ed57" // ubuntu 22.04
  instance_type = "t2.large"              // 2vcpu, 8gb ram
  subnet_id     = aws_subnet.public_subnet.id
  
  tags = {
    Name = "mc_server_ec2"
  }
}

resource "aws_s3_bucket" "mc_server_s3bucket" {
  bucket = "server-bucket-mc" // may need to change this name if it is already in use
  
  tags = {
    Name = "mc_server_s3bucket"
  }
}

resource "aws_s3_object" "setup_folder" {
  bucket = aws_s3_bucket.mc_server_s3bucket.id
  key    = "setup/"
}
