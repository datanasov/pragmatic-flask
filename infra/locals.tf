locals {
  name   = "flask"
  my_ip  = "0.0.0.0/0"
  region = "us-east-1"
  tags = {
    environment = "dev"
    team        = "devops"
    purpose     = "test jenkins"
    Name        = local.name
  }
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  azs            = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_cidr       = "10.0.0.0/16"
  instance_type  = "m5.large"
}