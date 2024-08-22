# TODO: Designate a cloud provider, region, and credentials
# Input correct credentials account login by aws cli
provider "aws" {
key_sample_1 = "..."
key_sample_2 = "..."
region = "us-east-1"
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "Udacity_T2" {
count = "4"
ami = "ami-0323c3dd2da7fb37d"
instance_type = "t2.micro"
tags = {
name = "Udacity T2"
}
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
resource "aws_instance" "Udacity_M4" {
count = "2"
ami = "ami-0323c3dd2da7fb37d"
instance_type = "m4.large"
tags = {
name = "Udacity M4"
}
}