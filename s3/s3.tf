provider "aws" {
  region = "us-east-2"
  profile = "default"
}
resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket"
}
