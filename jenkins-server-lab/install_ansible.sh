#!/bin/bash
    sudo yum update
    sudo amazon-linux-extras list | grep ansible2
    sudo amazon-linux-extras enable ansible2
    sudo yum install -y ansible
    