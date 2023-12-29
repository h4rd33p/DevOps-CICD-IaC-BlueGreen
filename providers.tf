terraform {
  backend "s3" {
    bucket         = "278a3444-2f91-4ff1-aa43-3aae673c19ce-tf-cicd"
    key            = "DevOps-CICD-IaC-BlueGreen"
    dynamodb_table = "terraform-state-lock"
    region         = "eu-west-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.23.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.2"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4.1"
    }


  }

  required_version = "~> 1.2"
}

provider "aws" {
  region = var.region
}
