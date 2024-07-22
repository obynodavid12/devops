variable "aws_region" {
  default = "us-east-2"
}

variable "availability_zone" {
  type = string
  default = "us-east-2a"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "aws_key_pair" {
  description = "keypair for Jenkins"
  type        = list(string)
  default     = ["jenkins_keyname", "ansible_keyname", "k8s_keyname"]
}

#variable "aws_key_pair" "ansible_keyname" {
#  description = "keypair for ansible"
#  type        = string
#  default     = "ansible_keyname"
#}

#variable "aws_key_pair" "k8s_keyname" {
#  description = "keypair for kubernetes"
#  type        = string
#  default     = "k8s_keyname"
#}