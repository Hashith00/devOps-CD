# Get the AWS default VPC
resource "aws_default_vpc" "default" {

}


resource "aws_security_group" "jenkins_server_sg" {
  name   = "jenkins_server_sg"
  vpc_id = "vpc-0068854d8e244643a"
  # vpc_id = aws_default_vpc.default.id
  tags = {
    name = "jenkins_server_sg"
  }
  # HTTP 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #FOR JENKINS
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # GET Traffic from anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Create EC2 instance
resource "aws_instance" "jenkins_server" {
  ami                    = "ami-080660c9757080771"
  key_name               = "default-ec2"
  instance_type          = "t2.small"
  vpc_security_group_ids = [aws_security_group.jenkins_server_sg.id]
  subnet_id              = "subnet-05e6e75fdf831de1f"

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.aws_key_pair)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update"
    ]
  }
}