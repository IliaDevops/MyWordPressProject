terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.4.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}




#backend "s3" {
#bucket = "23k-state-bucket"
#key = "23k/class4/root-class4/terraform.tfstate"
#region = "us-east-1"
#}
