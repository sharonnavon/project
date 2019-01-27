provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  region = "${var.region}"
}

### Data ###
data "aws_availability_zones" "available" {}

resource "aws_vpc" "MyVPC" {
  cidr_block = "${var.network_address}"
  enable_dns_hostnames = true
  tags {
    Name = "MyVPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.MyVPC.id}"
}
