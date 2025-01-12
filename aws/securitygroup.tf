resource "aws_security_group" "worker" {
  name        = "worker"
  description = "worker nodegroup security group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "All Allow in VPC Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" : "worker-nodegroup-sg"
  }
}

resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "worker nodegroup security group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "All Allow all traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" : "alb-sg"
  }
}
