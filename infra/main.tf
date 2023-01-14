terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["Amazon Linux 2"]
  }
}

resource "aws_instance" "foo" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "m5.large"
  key_name             = aws_key_pair.deployer.key_name
  iam_instance_profile = aws_iam_instance_profile.profile.name
  subnet_id  = "subnet-06c1d24952e5f22ce"
  user_data            = <<EOF

  EOF
}
