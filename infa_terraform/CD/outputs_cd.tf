output "aws_EC2_instance_details" {
  value = aws_instance.devops_server[*].public_ip
}

output "aws_EC2_instance_ids" {
  value = aws_instance.devops_server[*].id
}