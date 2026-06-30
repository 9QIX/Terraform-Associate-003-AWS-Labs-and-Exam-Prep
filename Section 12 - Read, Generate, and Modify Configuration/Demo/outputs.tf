output "hello-world" {
  value = "Hello World"
}

output "public_url" {
  value = "https://${aws_instance.web_server.public_ip}:8080/index.html"
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_information" {
  value = "Your ${aws_vpc.vpc.tags.Environment} VPC has an ID of ${aws_vpc.vpc.id}"
}

output "public_ip" {
  description = "This is the public IP of my web server"
  value = aws_instance.web_server.public_ip
}

output "ec2_instance_arn" {
  value = aws_instance.web_server.arn
  sensitive = true
}