# output "jenkins_master_ip" {
#   value = ["${aws_instance.jenkins_master.*.public_ip}"]
# }

output "dev_ip" {
  value = ["${aws_instance.dev.*.public_ip}"]
}