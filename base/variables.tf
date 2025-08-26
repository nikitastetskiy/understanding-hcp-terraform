variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "instance_name" {
  type        = string
  description = "EC2 instance name"
  default     = "default-instance"
}

variable "ami_id" {
  type        = string
  description = "AMI ID (must be provided, avoids DescribeImages)"
  default     = "ami-09b024e886d7bbe74"
}