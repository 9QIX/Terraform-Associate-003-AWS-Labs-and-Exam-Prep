output "hello-world" {
  description = "Print hello world as text output"
  value       = "Hello, World!"
}

output "vpc_id" {
  description = "Output the ID for the primary VPC"
  value       = aws_vpc.vpc.id
}

output "public_url" {
  description = "Public IP address for our web server"
  value       = "http://${aws_instance.ubuntu_server.public_ip}:8080/"
}

output "vpc_information" {
  description = "VPC Information about Environment"
  value       = "Your ${aws_vpc.vpc.tags["Environment"]} VPC ID is ${aws_vpc.vpc.id} in region ${data.aws_region.current.name}"
}