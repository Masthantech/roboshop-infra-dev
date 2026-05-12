terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.40.0"
    }
  }

  
  backend "s3" {
    bucket = "84remote-state-dev"
    key    = "roboshop-dev-backend-alb"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
    
  }

}

provider "aws" {

  region = "us-east-1" 
  
}




