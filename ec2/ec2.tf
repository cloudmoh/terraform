provider "aws" {
  region = "us-east-2"
  profile = "default"
}

resource "aws_instance" "ec2" {
    ami = "ami-024e6efaf93d85776"
    instance_type = "t2.micro"
    key_name = "prd01"
}
