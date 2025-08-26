output "ssh_access" {
  value = "ssh -i ~/.ssh/hashicorp ubuntu@${aws_instance.vm.public_ip}"
  description = "SSH Access"
}

output "public_ip" {
  value = aws_instance.vm.public_ip
  description = "Virtual Machine Public IP address"
}

output "private_ip" {
  value = aws_instance.vm.private_ip
  description = "Virtual Machine Private IP address"
}