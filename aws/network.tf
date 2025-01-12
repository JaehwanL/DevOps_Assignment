module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "test"
  cidr = "10.21.0.0/16"

  azs             = ["ap-northeast-2a", "ap-northeast-2c"]
  public_subnets  = ["10.21.0.0/24", "10.21.1.0/24"]
  private_subnets = ["10.21.32.0/24", "10.21.33.0/24"]

  public_subnet_tags = {
    "kubernetes.io/cluster/test" = "owned" # AWS LB Controller 사용을 위한 요구 사항
    "kubernetes.io/role/elb"     = 1
  }

  enable_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
