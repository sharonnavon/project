variable "region" {
  default = "us-east-1"
}
variable "private_key_path" {
  default = "/home/osboxes/.ssh/aws_ec2.pem"
}
variable "key_name" {
  default = "aws_ec2"
}
variable "instance_username" {
  default = "ubuntu"
}
variable "network_address" {
  default = "10.0.0.0/16"
}
variable "subnet1_address" {
  default = "10.0.1.0/24"
}
variable "ami" {
  default = "ami-0ac019f4fcb7cb7e6"
}
variable "ami_ubuntu16" {
  default = "ami-0f9cf087c1f27d9b1"
}

### Consul ###
variable "consul_version" {
  description = "The version of Consul to install (server and client)"
  default     = "1.4.0"
}
variable "consul_servers" {
  description = "The number of consul servers"
  default = 3
}
variable "consul_clients" {
  description = "The number of consul client instances"
  default = 1
}
