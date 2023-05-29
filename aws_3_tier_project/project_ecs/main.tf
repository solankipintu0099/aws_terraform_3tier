# configure the aws provider
provider "aws" {
    region = var.region
}

# create vpc
module "vpc1" {
  source                            = "../module/vpc"
  region                            = var.region
  project_name                      = var.project_name
  vpc_cidr                          = var.vpc_cidr
  public_subnet_az1_cidr            = var.public_subnet_az1_cidr
  public_subnet_az2_cidr            = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr       = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr       = var.private_app_subnet_az2_cidr
  private_data_subnet_az1_cidr      = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr      = var.private_data_subnet_az2_cidr
}

# create natgateway

module "nat_gateway1" {
  source                            = "../module/nat_gatway"
  public_subnet_az1_id              = module.vpc1.public_subnet_az1_id
  internet_gateway                  = module.vpc1.internet_gateway
  public_subnet_az2_id              = module.vpc1.public_subnet_az2_id
  vpc_id                            = module.vpc1.vpc_id
  private_app_subnet_az1_id         = module.vpc1.private_app_subnet_az1_id
  private_data_subnet_az1_id        = module.vpc1.private_data_subnet_az1_id
  private_app_subnet_az2_id         = module.vpc1.private_app_subnet_az2_id
  private_data_subnet_az2_id        = module.vpc1.private_data_subnet_az2_id
  
}
      
# create security group

module "security_group" {
  source = "../module/security_group"
  vpc_id = module.vpc1.vpc_id
}
    
# create iam role

module "ecs_task" {
  source            = "../module/ecs_task"
  project_name      = module.vpc1.project_name
  
}

# create acm 
module "acm" {
  source            = "../module/acm"
  domain_name       = var.domain_name
  alternative_name  = var.alternative_name
}
