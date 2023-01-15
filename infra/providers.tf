terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.45.0"
    }
  }
}

provider "aws" {
  default_tags {
    tags = local.tags
  }
  region = local.region
}
