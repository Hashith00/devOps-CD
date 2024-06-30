resource "aws_default_vpc" "default" {

}

# Retrieve subnets for the default VPC
data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

# Security group for load balancer
resource "aws_security_group" "load_balancer_sg" {
  name   = "load_balancer_sg"
  vpc_id = aws_default_vpc.default.id

  # Allow HTTP ingress on port 8080
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
  # Allow all egress traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the ELB
resource "aws_elb" "elb" {
  name               = "devops-elb"
  subnets            = data.aws_subnets.default_subnets.ids
  security_groups    = [aws_security_group.load_balancer_sg.id]
  instances          = ["i-03041d3a90549762c", "i-006de0aa80d6ec40c" ]

  listener {
    instance_port     = 8080
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    target              = "HTTP:8080/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "devops-elb"
  }
}



