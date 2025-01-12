provider "aws" {
  region  = "ap-northeast-2"
  profile = "jaehwan.lee-labs"
}

terraform {
  required_version = "~> 1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.83.1"
    }
  }

  backend "local" {}
}
