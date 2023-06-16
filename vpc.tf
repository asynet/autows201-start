module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"
  name    = "F5-Terraform-201-Workshop"
  cidr    = "10.0.0.0/16"

  #azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  azs             = ["eu-west-2a"]
  private_subnets = ["10.0.3.0/24"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]

  #enable_nat_gateway = true
  #enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
    user        = "richard@asynet.es"
  }
}
