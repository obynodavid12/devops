provider "aws" {
  region = var.aws_region
}

data "aws_ssm_parameter" "instance_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Creating the VPC
resource "aws_vpc" "project_vpc" {
  cidr_block              = var.vpc_cidr_block
  enable_dns_hostnames    = true
  enable_dns_support      = true
  tags = {
    Name = "project_vpc"
  }
}

# Creating the Internet Gateway
resource "aws_internet_gateway" "project_igw" {
  vpc_id = aws_vpc.project_vpc.id
  tags = {
    Name = "project_igw"
  }
}

# Creating the public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = var.public_subnet_cidr_block
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet"
  }
}

# Creating the public route table
resource "aws_route_table" "project_public_rt" {
  vpc_id = aws_vpc.project_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project_igw.id
  }
}


# Associating our public subnet with our public route table
resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.project_public_rt.id
  subnet_id      = aws_subnet.public_subnet.id
}


# Creating a security group for the Jenkins server
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Security group for jenkins server"
  vpc_id      = aws_vpc.project_vpc.id

  ingress {
    description = "allow anyone on port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow anyone on port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tutorial_jenkins_sg"
  }
}

# Creating a security group for the Ansible server
resource "aws_security_group" "ansible_sg" {
  name        = "ansible_sg"
  description = "Security group for ansible server"
  vpc_id      = aws_vpc.project_vpc.id

  ingress {
    description = "allow anyone on port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ansible_sg"
  }
}

# Creating a security group for the K8s server
resource "aws_security_group" "k8s_sg" {
  name        = "k8s_sg"
  description = "Security group for k8s cluster"
  vpc_id      = aws_vpc.project_vpc.id

  ingress {
    description = "allow anyone on port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k8s_sg"
  }
}

# Creating an EC2 instance called jenkins_server
resource "aws_instance" "jenkins_server" {
  ami                    = data.aws_ssm_parameter.instance_ami.value
  subnet_id              = aws_subnet.public_subnet.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  key_name               = var.aws_key_pair[0]
  user_data              = fileexists("install_jenkins.sh") ? file("install_jenkins.sh") : null
  #count                  = 2
  tags = {
    Name = "jenkins_server"
  }
}

# Creating an EC2 instance called ansible_server
resource "aws_instance" "ansible_server" {
  ami                    = data.aws_ssm_parameter.instance_ami.value
  subnet_id              = aws_subnet.public_subnet.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ansible_sg.id]
  key_name               = var.aws_key_pair[1]
  user_data              = fileexists("install_ansible.sh") ? file("install_ansible.sh") : null
  count = 2
  tags = {
    Name = "ansible_server"
  }
}

# Creating an EC2 instance called k8s_server
resource "aws_instance" "k8s_cluster" {
  ami                    = data.aws_ssm_parameter.instance_ami.value
  subnet_id              = aws_subnet.public_subnet.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]
  key_name               = var.aws_key_pair[2]
  user_data              = fileexists("install_k8s.sh") ? file("install_k8s.sh") : null
  count                  = 2
  tags = {
    Name = "k8s_server"
  }
}

# Creating an Elastic IP called jenkins_eip
resource "aws_eip" "jenkins_eip" {
  instance = aws_instance.jenkins_server.id
  vpc      = true
  tags = {
    Name = "jenkins_eip"
  }
}