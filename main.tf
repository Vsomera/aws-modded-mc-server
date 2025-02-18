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

resource "aws_key_pair" "mc_ec2_key" {
  key_name   = "mc-ec2-key"
  public_key = file("~/.ssh/mc-ec2-key.pub")
}

module "networking" {
  source = "./modules/networking/"
}

module "access" {
  source = "./modules/access/"
}

resource "aws_instance" "mc_server_ec2" {
  ami           = "ami-0606dd43116f5ed57" // ubuntu 22.04
  instance_type = "c5a.xlarge"            // 4vcpu, 8gb ram

  vpc_security_group_ids = [module.networking.mc_server_sg_id]
  subnet_id              = module.networking.public_subnet_id

  iam_instance_profile = module.access.iam_instance_profile_name
  user_data            = file("${path.module}/scripts/user_data.sh")

  key_name = aws_key_pair.mc_ec2_key.key_name

  tags = {
    Name = "mc_server_ec2"
  }
}

resource "aws_s3_bucket" "mc_ec2_bucket" {
  bucket = "s3-bucket-name" // CHANGE S3 BUCKET NAME

  tags = {
    Name = "mc_ec2_bucket"
  }
}

resource "aws_s3_object" "setup_folder" {
  bucket = aws_s3_bucket.mc_ec2_bucket.id
  key    = "setup/"
}

resource "aws_eip" "mc-ec2-eip" {
  vpc      = true
  instance = aws_instance.mc_server_ec2.id

  tags = {
    Name = "mc_server_elastic_ip"
  }
}

output "mc_ip_address" {
  value       = aws_eip.mc-ec2-eip.public_ip
  description = "ip address for minecraft server"
}

