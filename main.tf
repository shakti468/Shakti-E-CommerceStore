provider "aws" {
  region = var.aws_region
}

# 1. Security Group Block – place this first
resource "aws_security_group" "ecommerce_sg" {
  name        = "ecommerce-sg"
  description = "Allow frontend + internal service ports"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to the world for frontend access
  }

  ingress {
    from_port   = 3001
    to_port     = 3004
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # You can restrict this to VPC CIDR later
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecommerce-sg"
  }
}

# 2. EC2 Instance Block
resource "aws_instance" "ecommerce_instance" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.ecommerce_sg.id]

  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install docker.io -y
              systemctl start docker
              systemctl enable docker

              docker pull shakti827/user-service
              docker pull shakti827/product-service
              docker pull shakti827/cart-service
              docker pull shakti827/order-service
              docker pull shakti827/frontend

              docker run -d -p 3001:3001 shakti827/user-service
              docker run -d -p 3002:3002 shakti827/product-service
              docker run -d -p 3003:3003 shakti827/cart-service
              docker run -d -p 3004:3004 shakti827/order-service
              docker run -d -p 3000:3000 shakti827/frontend
              EOF

  tags = {
    Name = "Ecommerce-Instance"
  }
}
