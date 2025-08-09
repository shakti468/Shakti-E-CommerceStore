variable "ami_id" {
  type        = string
  description = "The AMI ID for the EC2 instance"
  default     = "ami-0f918f7e67a3323f0"  # Replace with your actual AMI ID
}

variable "subnet_id" {
  type        = string
  description = "The Subnet ID to launch the instance in"
  default     = "subnet-0c1842aca7dc1b6b0"  # Replace with your Subnet ID
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID"
  default     = "vpc-0056d809452f9f8ea"   # Replace with your VPC ID
}

variable "security_group_id" {
  type        = string
  description = "The Security Group ID"
  default     = "sg-062db673284b7eda2"   # Replace with your SG ID
}

variable "instance_type" {
  type        = string
  description = "The instance type"
  default     = "t2.micro"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
  default     = "Shakti-b10" 
}