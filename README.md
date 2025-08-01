# 🛒 E-Commerce Microservices Deployment using Docker and Terraform

This project demonstrates the deployment of a full-stack E-Commerce application using **Docker** and **Terraform** on **AWS EC2**. The application consists of microservices built with **Node.js** and a React **frontend**, all containerized and deployed on a single EC2 instance for demonstration purposes.

---

## 📦 Microservices Included

- **User Service** (`port 3001`)
- **Product Service** (`port 3002`)
- **Cart Service** (`port 3003`)
- **Order Service** (`port 3004`)
- **Frontend (React App)** (`port 80` → accessible via `http://<EC2-IP>`)

---

## 🛠️ Project Structure

```bash
.
├── terraform/                   # Terraform configurations
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── ...
├── docker-compose.yml           # (Optional) Compose setup (not used here)
├── frontend/                    # React frontend app
├── user-service/                # User microservice
├── product-service/             # Product microservice
├── cart-service/                # Cart microservice
├── order-service/               # Order microservice
└── README.md
```
# 🚀 Deployment Steps
## Step 1: Push Docker Images
```bash
# Example for one service
docker build -t shakti827/user-service ./user-service
docker push shakti827/user-service

# Repeat for:
# - product-service
# - cart-service
# - order-service
# - frontend-service
```
# Terraform 
## main.tf
```bash
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
```
## variable.tf
```bash
output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.ecommerce_instance.public_ip
}
```
## output.tf
```bash
output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.ecommerce_instance.public_ip
}

```



#  Step 2: Provision AWS EC2 using Terraform
```bash
cd terraform
```
## Initialize Terraform
```bash
terraform init
```
### Screenshot
<img width="763" height="337" alt="image" src="https://github.com/user-attachments/assets/60c29bc4-687c-40dc-bd12-36c3d658b42a" />

-----

## Preview changes
```bash
terraform plan
```
### Screenshots
<img width="860" height="496" alt="image" src="https://github.com/user-attachments/assets/351d0248-7b9c-4236-a07f-ca4cbae09d6e" />

---

## Apply the infrastructure
```bash
terraform apply
```
### Screenshots 
<img width="818" height="515" alt="image" src="https://github.com/user-attachments/assets/8e1f362f-45a6-4f79-8390-b061620f42cc" />


---

# Running ec2 instance 
<img width="1833" height="703" alt="image" src="https://github.com/user-attachments/assets/9892c9a5-abe9-481b-8f33-0dc88646047e" />

---

# Output of docker ps showing all services running
<img width="1888" height="297" alt="image" src="https://github.com/user-attachments/assets/9c7def00-88ce-41b1-928a-e0d941ab9600" />

---

# Frontend UI in browser

<img width="1732" height="957" alt="image" src="https://github.com/user-attachments/assets/adf88698-35ac-4058-81ad-331b65331b96" />

---
