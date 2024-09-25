variable "aws_region" {
  description = "The AWS region to create resources in"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
}

variable "iam_instance_profile" {
  description = "The IAM instance profile to associate with the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "The key pair name to use for the instance"
  type        = string
}

variable "ebs_encrypted" {
  description = "Whether or not to encrypt the EBS volume"
  type        = bool
}

variable "ebs_volume_size" {
  description = "The size of the EBS volume, in GiB"
  type        = number
}

variable "instance_name" {
  description = "The name to use for the instance"
  type        = string
}

variable "my_ip_cidr" {
  description = "Your IP address in CIDR format"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route 53 hosted zone"
  type        = string
}

variable "hosted_zone_name" {
  description = "Route 53 hosted zone name"
  type        = string
}

variable "world_security_group" {
  description = "Security group for world"
  type        = string
}

variable "subnets" {
  description = "List of subnet ids for the load balancer"
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC for the target group"
  type        = string
}

variable "target_group_name" {
  description = "The name of the target group"
  type        = string
}

variable "alb_name" {
  description = "The name of the application load balancer"
  type        = string
}

variable "certificate_arn" {
  description = "The ARN of the ACM certificate"
  type        = string
}
variable "bitbucket_ips" {
  type        = list(string)
  description = "The CIDR blocks for Bitbucket IPs"
}
