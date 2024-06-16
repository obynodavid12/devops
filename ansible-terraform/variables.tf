variable "aws_region" {
  description = "Region in which AWS resource to be created"
  type        = string
  default     = "us-east-2"
}

variable "instance_type" {
  description = "EC2 Instance type "
  type        = string
  default     = "t2.micro"
}

# variable "instance_tags" {
#   type    = list(any)
#   default = ["Dev", "Prod"]
# }
# variable "instance_keypair" {
#   description = "AWS EC2 Key Pair that need to be associated with EC2 Instance"
#   type        = string
#   default     = "Instance-Key"
# }

variable "instance_count" {
  default = "1"
}

variable "public_key" {
  default = "mykey.pub"
}

variable "private_key" {
  default = "mykey.pem"
}

variable "ansible_user" {
  default = "ubuntu"
}

variable "amis" {
  type = map(string)

  default = {
    us-east-1 = "ami-04b70fa74e45c3917" # North Virginia
    us-east-2 = "ami-09040d770ffe2224f" # Ohio
    us-west-2 = "ami-0cf2b4e024cdb6960" # Oregon
  }
}

variable "ami" {
  default = "ami-09040d770ffe2224f"
}