# Define the AWS provider
provider "aws" {
  region = "ap-south-1" # Replace with your desired AWS region
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16" # Replace with your desired VPC CIDR block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "my-vpc"
  }
}

# Create three subnets in different availability zones
resource "aws_subnet" "subnet1" {
  count = 3
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = element(["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"], count.index)
  availability_zone = element(["ap-south-1a", "ap-south-1b", "ap-south-1c"], count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-${count.index + 1}"
  }
}

# Create security group for EC2 instances
resource "aws_security_group" "my_security_group" {
  name_prefix = "my-ec2-sg-"
  description = "Allow SSH and HTTP inbound traffic"
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch two EC2 instances in different subnets
resource "aws_instance" "instance1" {
  ami           = "ami-0f5ee92e2d63afc18" # Replace with your desired AMI ID
  instance_type = "t2.micro"             # Replace with your desired instance type
  subnet_id     = aws_subnet.subnet1[0].id
  security_groups = [aws_security_group.my_security_group.id]
  key_name      = "gitguvi"           # Replace with your SSH key name
  tags = {
    Name = "web-server-1"
  }
}

resource "aws_instance" "instance2" {
  ami           = "ami-0f5ee92e2d63afc18" # Replace with your desired AMI ID
  instance_type = "t2.micro"             # Replace with your desired instance type
  subnet_id     = aws_subnet.subnet1[1].id
  security_groups = [aws_security_group.my_security_group.id]
  key_name      = "gitguvi"           # Replace with your SSH key name
  tags = {
    Name = "web-server-2"
  }
}

In this script:

The AWS provider is configured with your desired region.
A VPC is created with a specified CIDR block.
Three subnets are created in different availability zones within the VPC.
A security group is created to allow inbound traffic for SSH and HTTP.
Two EC2 instances are launched in two different subnets using the specified security group and SSH key pair.

