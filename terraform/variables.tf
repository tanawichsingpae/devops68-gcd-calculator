# ===============================
# AWS Region
# ===============================
variable "aws_region" {
  description = "AWS Region for deployment"
  type        = string
  default     = "ap-southeast-7"
}

# ===============================
# EC2 Instance Type
# ===============================
variable "instance_type" {
  description = "EC2 instance size"
  type        = string
  default     = "t3.micro"
}

# ===============================
# SSH Key Name
# ===============================
variable "key_name" {
  description = "Name of SSH key pair"
  type        = string
  default     = "my-terraform-key"
}

# ===============================
# Application Port
# ===============================
variable "app_port" {
  description = "Port where API runs"
  type        = number
  default     = 3017
}

# ===============================
# Git Repository URL
# ===============================
variable "repo_url" {
  description = "GitHub repository URL of the API"
  type        = string
  default     = "https://github.com/tanawichsingpae/devops68-gcd-calculator.git"
}