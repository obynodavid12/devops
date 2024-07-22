#!/bin/bash

# Update and install required packages
sudo yum update -y
sudo yum install -y curl wget unzip

# Install Docker
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker $USER

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

# Install Minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo install minikube /usr/local/bin/
rm minikube

# Enable and start Docker service
sudo systemctl enable docker.service
sudo systemctl start docker.service

# Add the user to the docker group so you can execute Docker commands without sudo
sudo usermod -aG docker $USER

# Confirm installation
kubectl version --client
docker --version
minikube version

echo "kubectl, docker, and minikube installation completed successfully."
echo "Please log out and log back in so that your group membership is re-evaluated."


    