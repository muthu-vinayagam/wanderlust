variable "aws_region" {
  default = "ap-south-1"  # Change this to your desired region
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr_blocks" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "availability_zones" {
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "eks_cluster_role_name" {
  default = "eks_cluster_role_new"  # Changed role name
}

variable "eks_node_role_name" {
  default = "eks_node_role"
}

