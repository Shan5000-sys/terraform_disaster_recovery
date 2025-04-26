terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

provider "aws" {
  alias  = "primary"
  region = var.primary_region
}

provider "aws" {
  alias  = "secondary"
  region = var.secondary_region
}

module "vpc_primary" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"
  name    = "primary-vpc"
  cidr    = "10.0.0.0/16"
  azs     = ["${var.primary_region}a", "${var.primary_region}b"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  providers = { aws = aws.primary }
}

module "vpc_secondary" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"
  name    = "secondary-vpc"
  cidr    = "10.1.0.0/16"
  azs     = ["${var.secondary_region}a", "${var.secondary_region}b"]
  public_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
  providers = { aws = aws.secondary }
}

resource "aws_security_group" "web_primary" {
  name   = "web-sg-primary"
  vpc_id = module.vpc_primary.vpc_id
  provider = aws.primary

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web_secondary" {
  name   = "web-sg-secondary"
  vpc_id = module.vpc_secondary.vpc_id
  provider = aws.secondary

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "primary_web" {
  source            = "./modules/web_server"
  name              = "primary-web"
  ami_id            = var.ami_id_primary
  subnet_id         = element(module.vpc_primary.public_subnets, 0)
  security_group_id = aws_security_group.web_primary.id
  key_name          = var.key_name_primary
  providers         = { aws = aws.primary }
}

module "secondary_web" {
  source            = "./modules/web_server"
  name              = "secondary-web"
  ami_id            = var.ami_id_secondary
  subnet_id         = element(module.vpc_secondary.public_subnets, 0)
  security_group_id = aws_security_group.web_secondary.id
  key_name          = var.key_name_secondary
  providers         = { aws = aws.secondary }
}

resource "null_resource" "stop_secondary" {
  provisioner "local-exec" {
    command = "aws ec2 stop-instances --instance-ids ${module.secondary_web.instance_id} --region ${var.secondary_region}"
  }

  depends_on = [module.secondary_web]
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  default     = "disaster_recovery"  # Replace with your actual key pair name
}


