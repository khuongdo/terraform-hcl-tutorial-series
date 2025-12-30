# Outputs for Part 3

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "Public IP address of EC2 instance (if assigned)"
  value       = aws_instance.web.public_ip
}

output "instance_state" {
  description = "Current state of the EC2 instance"
  value       = aws_instance.web.instance_state
}

output "ami_id" {
  description = "AMI ID used for the instance"
  value       = aws_instance.web.ami
}
