provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./vpc"
}

module "Networking" {
  source = "./network"
  vpc_id = module.vpc.vpc_id
  igw_id = module.vpc.igw_id
}

module "sggroup" {
  source = "./sggroup"
  vpc_id = module.vpc.vpc_id
  aws_subnet_id1 = module.Networking.aws_subnet_id1
  aws_subnet_id2 = module.Networking.aws_subnet_id2
}

module "routetable" {
  source = "./routetable"
  vpc_id = module.vpc.vpc_id
  igw_id = module.vpc.igw_id
  aws_subnet_id1 = module.Networking.aws_subnet_id1
  aws_subnet_id2 = module.Networking.aws_subnet_id2
  aws_subnet_pvid1 = module.Networking.aws_subnet_pvid1
  aws_subnet_pvid2 = module.Networking.aws_subnet_pvid2
  Nat_Gateway1_id = module.Networking.Nat_Gateway1_id
}

module "db" {
  source = "./db"
  vpc_id = module.vpc.vpc_id
  aws_db_subnet_group_id = module.Networking.aws_db_subnet_group_id
}

module "alb" {
  source = "./alb"
  vpc_id = module.vpc.vpc_id
  Allow_ELB_Web_Traffic_id = module.sggroup.Allow_ELB_Web_Traffic
  Allow_ELB_App_Traffic_id = module.sggroup.Allow_ELB_App_Traffic
  aws_subnet_id1 = module.Networking.aws_subnet_id1
  aws_subnet_id2 = module.Networking.aws_subnet_id2
  aws_subnet_pvid1 = module.Networking.aws_subnet_pvid1
  aws_subnet_pvid2 = module.Networking.aws_subnet_pvid2
}

module "autoscale" {
  source = "./autoscale"
  Allow_Web_Traffic_id = module.sggroup.Allow_Web_Traffic
  Allow_APP_Traffic_id = module.sggroup.Allow_APP_Traffic
  aws_subnet_id1 = module.Networking.aws_subnet_id1
  aws_subnet_id2 = module.Networking.aws_subnet_id2
  aws_subnet_pvid1 = module.Networking.aws_subnet_pvid1
  aws_subnet_pvid2 = module.Networking.aws_subnet_pvid2
  aws_lb_target_group_1 = module.alb.aws_lb_target_group_1
  aws_lb_target_group_2 = module.alb.aws_lb_target_group_2
}