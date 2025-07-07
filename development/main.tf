provider "aws" {
  region = var.aws_region
}
terraform {
  backend "s3" {
    bucket = "test-bucket-terraform-sidd"
    key    = "Development.tfstate"
    region = "us-east-1"
  }
}

module "dev_vpc_1" {
  source             = "../modules/network"
  vpc_cidr           = "10.0.0.0/16"
  vpc_name           = "dev_vpc_1"
  environment        = "development"
  public_cidr_block  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_cidr_block = ["10.0.10.0/24", "10.0.20.0/24"]
  azs                = ["us-east-1a", "us-east-1b"]
  nat_gateway        = module.dev_nat_1.nat_gateway_id
}

module "dev_sg_1" {
  source             = "../modules/sg"
  vpc_name           = module.dev_vpc_1.vpc_name
  ingress_port_value = ["80", "443", "22","8080"]
  vpc_id             = module.dev_vpc_1.vpc_id
  environment        = module.dev_vpc_1.environment
}

module "dev_compute_1" {
  source = "../modules/compute"
  amis = {
    "us-east-1" = "ami-020cba7c55df1f615"
  }
  region            = "us-east-1"
  key_name          = "aws_login"
  vpc_name          = module.dev_vpc_1.vpc_name
  environment       = module.dev_vpc_1.environment
  sg_id             = module.dev_sg_1.sg_id
  public_subnets_id = module.dev_vpc_1.public-subnet_id
}

module "dev_nat_1" {
  source           = "../modules/nat"
  az               = module.dev_vpc_1.azs
  public_subnet_id = module.dev_vpc_1.public-subnet_id
}

module "dev_net_lb" {
  source            = "../modules/elb"
  lb_name           = "dev-alb-public"
  subnet_ids        = module.dev_vpc_1.public-subnet_id
  environment       = module.dev_vpc_1.environment
  target_group_name = "dev-alb-tg-public"
  vpc_id            = module.dev_vpc_1.vpc_id
  public_servers    = module.dev_compute_1.public_server
}
