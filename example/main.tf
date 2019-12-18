terraform {
  required_version = ">= 0.12, < 0.13"
}


provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {

    # This backend configuration is filled in automatically at test time by Terratest. If you wish to run this example
    # manually, uncomment and fill in the config below.

    bucket         = "<bucket_name>"
    key            = "<key_path>/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "<table_name>"
    encrypt        = true

  }
}

resource "aws_instance" "example" {
  ami = "ami-0ab1d87ce9286b9a4"

  instance_type = terraform.workspace == "default" ? "t2.medium" : "t2.micro"

}