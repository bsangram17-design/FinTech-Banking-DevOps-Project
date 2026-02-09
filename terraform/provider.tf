provider "aws" {
  region = "ap-south-1"
}

data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}
