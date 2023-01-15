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

  access_key = "AKIAWHTMV27QW6GYLF74"
  secret_key = "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"
}