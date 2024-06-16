# # This automation creates an AWS instance, and install jenkins inside with ansible automation
# # we should have ansible installed in local terrafrm box.
# # ansi.tf

# resource "aws_key_pair" "mykey" {
#   key_name   = "mykey"
#   public_key = file(var.public_key)
# }

# data "aws_security_group" "selected" {
#   id = "sg-0feb061c6059de1d6"
# }

# resource "aws_instance" "jenkins_master" {
#   #   count = var.instance_count
#   count = 1
#   ami   = lookup(var.amis, var.aws_region)
#   #ami                   = "${var.ami}"
#   instance_type          = var.instance_type
#   key_name               = aws_key_pair.mykey.key_name
#   vpc_security_group_ids = [data.aws_security_group.selected.id]

#   provisioner "file" {
#     source      = "script.sh"
#     destination = "/tmp/script.sh"
#   }
#   provisioner "remote-exec" {
#     inline = [
#       "chmod +x /tmp/script.sh",
#       "sudo sed -i -e 's/\r$//' /tmp/script.sh", # Remove the spurious CR characters.
#       "sudo /tmp/script.sh",
#     ]
#   }
#   connection {
#     host        = coalesce(self.public_ip, self.private_ip)
#     type        = "ssh"
#     user        = var.ansible_user
#     private_key = file(var.private_key)
#   }

#   #   # This is where we configure the instance with ansible-playbook
#   #   provisioner "local-exec" {
#   #     command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.ansible_user} --private-key ${var.private_key} -i '${self.public_ip},' ../playbooks/jenkins.yml"
#   #   }

#   provisioner "local-exec" {
#     command     = <<-EOT
#       sleep 30;
# 	  >java.ini;
# 	  echo "[java]" | tee -a java.ini;
# 	  echo "${self.public_ip} ansible_user=${var.ansible_user} ansible_ssh_private_key_file=${var.private_key}" | tee -a java.ini;
#       export ANSIBLE_HOST_KEY_CHECKING=False;
# 	  ansible-playbook -u ${var.ansible_user} --private-key ${var.private_key} -i java.ini ../playbooks/jenkins.yaml
#     EOT
#   }

#   tags = {
#     Name        = "Terraform"
#     Environment = "Dev"
#   }
# }



