resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = file(var.public_key)
}

data "aws_security_group" "selected" {
  id = "sg-0feb061c6059de1d6"
}

resource "aws_instance" "dev" {
  tags = {
    Name = "test"
    env  = "dev"
  }
  ami                    = lookup(var.amis, var.aws_region)
  instance_type          = var.instance_type
  key_name               = aws_key_pair.mykey.key_name
  vpc_security_group_ids = [data.aws_security_group.selected.id]
  count                  = 1
  user_data              = <<-EOF
                           #!/bin/bash
                           cd /tmp ; wget https://raw.githubusercontent.com/lerndevops/labs/master/scripts/setupUser.sh
                           sudo bash /tmp/setupUser.sh
                          EOF
  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo sed -i -e 's/\r$//' /tmp/script.sh", # Remove the spurious CR characters.
      "sudo /tmp/script.sh",
    ]
  }
  connection {
    host        = self.public_ip
    type        = "ssh"
    user        = var.ansible_user
    private_key = file(var.private_key)
  }
  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ./myinv"
  }
}
resource "null_resource" "dev" {

  depends_on = [aws_instance.dev]

  provisioner "local-exec" {
    command = <<-EOT
               sleep 60;
               export ANSIBLE_HOST_KEY_CHECKING=False;
               ansible -i myinv all -m ping -u ubuntu --private-key mykey.pem;
	       ansible-playbook -i myinv jenkins.yaml --user ubuntu --key-file mykey.pem
              EOT
  }
}
