# Terraform Block
terraform {
  required_version = "~> 0.14"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
    null = {
    source = "hashicorp/null"
    version = "~> 3.0"
    }
     random = {
      source = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  #backend as S3 for remote state storage
  backend "s3" {}
}

#Provider Block
provider "aws" {
  region = var.aws_region
  profile = "default"
}


#Random_pet resource
resource "random_pet" "this" {
  length = 2
}