provider "aws" {
  region = var.aws_region
}

# ===============================
# Generate SSH Key Pair
# ===============================
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.example.public_key_openssh

  lifecycle {
    ignore_changes = [public_key]
  }
}

resource "local_file" "private_key" {
  content         = tls_private_key.example.private_key_pem
  filename        = "${path.module}/${var.key_name}.pem"
  file_permission = "0400"
}

# ===============================
# Security Group
# ===============================
resource "aws_security_group" "app_sg" {
  name_prefix = "gcd_api_sg"
  description = "Security Group for GCD API"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "API Port"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ===============================
# EC2 Instance
# ===============================
resource "aws_instance" "gcd_server" {

  ami           = "ami-0e5b9e1afa5e50e27"
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<-EOF
#!/bin/bash

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
set -e

echo "===== Starting EC2 Bootstrap ====="

export DEBIAN_FRONTEND=noninteractive

echo "Updating system packages..."
apt-get update -y

echo "Installing dependencies..."
apt-get install -y git curl

echo "Installing Node.js 20..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

echo "Node version:"
node -v
npm -v

cd /home/ubuntu

echo "Cloning application repository..."
rm -rf app
git clone ${var.repo_url} app


cd app

echo "Installing npm dependencies..."
npm install

echo "Starting Node API..."

nohup npm start > app.log 2>&1 &

echo "===== Deployment Finished ====="
EOF

  user_data_replace_on_change = true

  tags = {
    Name = "gcd-api-server"
  }
}