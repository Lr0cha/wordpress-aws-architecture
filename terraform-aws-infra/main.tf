terraform {
  required_version = ">= 1.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.17.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      owner      = "lr0cha"
      managed-by = "terraform"
    }
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.5.0"

  name = "${var.project}-vpc"
  cidr = "10.0.0.0/16" # default

  azs = ["us-east-1a", "us-east-1b"]

  # ---------- Public Subnet----------
  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]

  public_subnet_names = [
    "${var.project}-public-1a",
    "${var.project}-public-1b",
  ]

  # ---------- Private (APP) ----------
  private_subnets = [
    "10.0.10.0/24",
    "10.0.11.0/24",
  ]

  private_subnet_names = [
    "${var.project}-app-1a",
    "${var.project}-app-1b",
  ]

  # ---------- Private (DATA) ----------
  database_subnets = [
    "10.0.20.0/24",
    "10.0.21.0/24",
  ]

  database_subnet_names = [
    "${var.project}-data-1a",
    "${var.project}-data-1b",
  ]

  # NAT per AZ
    enable_nat_gateway = true
    single_nat_gateway = false

  enable_dns_hostnames = true
  enable_dns_support   = true
}