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
  region  = var.region
  profile = var.profile
}

module "ec2" {
  source = "./ec2"
  instance_type = var.instance_type
  ami_id        = var.ami_id
  key_name      = var.key_name
}

output "ec2_instance_id" {
  description = "The ID of the EC2 instance created by the EC2 module"
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance created by the EC2 module"
  value       = module.ec2.public_ip
}