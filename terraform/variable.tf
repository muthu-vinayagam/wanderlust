variable "region" {
  description = "The AWS region to create the EKS cluster in."
  type        = string
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "wl-app-demo"
}

variable "node_group_name" {
  description = "The name of the node group."
  type        = string
  default     = "my-eks-node-group"
}

variable "node_instance_type" {
  description = "The instance type for the nodes."
  type        = string
  default     = "t3.medium"
}

variable "desired_capacity" {
  description = "The desired capacity of the node group."
  type        = number
  default     = 2
}

variable "max_size" {
  description = "The max size of the node group."
  type        = number
  default     = 3
}

variable "min_size" {
  description = "The min size of the node group."
  type        = number
  default     = 1
}

