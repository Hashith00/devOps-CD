# Output the DNS name of the ELB
output "elb_dns_name" {
  value = aws_elb.elb.dns_name
}

output "elb_dns_name_ip" {
  value = aws_elb.elb
}