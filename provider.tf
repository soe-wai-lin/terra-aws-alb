terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.0.0-beta3"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile # Optional: if using a named profile from ~/.aws/credentials
}