#!/bin/bash
    sudo yum update –y
    sudo yum install java-1.8.0-openjdk-devel -y
    curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
    sudo systemctl daemon-reload
    sudo amazon-linux-extras install epel -y
    sudo yum install jenkins -y
    sudo systemctl start jenkins
    sudo systemctl status jenkins
    sudo systemctl enable jenkins
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword
    sudo yum install git -y
    sudo wget https://mirrors.estointernet.in/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz