output "aws_EC2_instance_details" {
  value = aws_instance.jenkins_server.public_ip
}
