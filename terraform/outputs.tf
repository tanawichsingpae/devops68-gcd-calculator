output "api_url" {
  description = "URL for testing the GCD API"
  value       = "http://${aws_instance.gcd_server.public_ip}:3017/calculate?a=48&b=18"
}

output "ssh_command" {
  description = "Command to SSH into the EC2 instance"
  value       = "ssh -i ${var.key_name}.pem ubuntu@${aws_instance.gcd_server.public_ip}"
}