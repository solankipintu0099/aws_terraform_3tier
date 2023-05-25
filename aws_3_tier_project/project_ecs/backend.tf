# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket    = "solankiashish009876543212"
    key       = "project_ecs.tfstate"
    region    = "ap-south-1"
  }
}