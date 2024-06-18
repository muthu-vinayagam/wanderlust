# Define the provider
provider "aws" {
  region = var.aws_region
}

# Configure Terraform backend to store state file in S3
terraform {
  backend "s3" {
    bucket         = "vinayterraformstate"  # Replace with your S3 bucket name
    key            = "terraform.tfstate"            # Name of the state file in the bucket
    region         = "ap-south-1"
    dynamodb_table = "terraform_locks"              # Optional: DynamoDB table for state locking
    encrypt        = true                           # Optional: Encrypt the state file
  }
}

# Create a VPC
resource "aws_vpc" "eks_vpc" {
  cidr_block = var.vpc_cidr_block
}

# Create subnets
resource "aws_subnet" "eks_subnet" {
  count = length(var.subnet_cidr_blocks)

  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
}

# Create an internet gateway
resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id
}

# Create a route table
resource "aws_route_table" "eks_route_table" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }
}

# Associate route table with subnets
resource "aws_route_table_association" "eks_route_table_assoc" {
  count = length(var.subnet_cidr_blocks)

  subnet_id      = aws_subnet.eks_subnet[count.index].id
  route_table_id = aws_route_table.eks_route_table.id
}

# Create IAM roles and policies for EKS
resource "aws_iam_role" "eks_role" {
  name = var.eks_cluster_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy_attachment" "eks_policy_attachment" {
  name       = "eks_policy_attachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  roles      = [aws_iam_role.eks_role.name]
}

resource "aws_iam_role" "eks_node_role" {
  name = var.eks_node_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy_attachment" "eks_node_policy_attachment" {
  name       = "eks_node_policy_attachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  roles      = [aws_iam_role.eks_node_role.name]
}

resource "aws_iam_policy_attachment" "eks_cni_policy_attachment" {
  name       = "eks_cni_policy_attachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"  # Corrected policy ARN
  roles      = [aws_iam_role.eks_node_role.name]
}

resource "aws_iam_policy_attachment" "eks_registry_policy_attachment" {
  name       = "eks_registry_policy_attachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  roles      = [aws_iam_role.eks_node_role.name]
}

# Create the EKS cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "my_eks_cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.eks_subnet[0].id,
      aws_subnet.eks_subnet[1].id,
      aws_subnet.eks_subnet[2].id
    ]
  }
}

# Create EKS node group
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "my_eks_node_group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [
    aws_subnet.eks_subnet[0].id,
    aws_subnet.eks_subnet[1].id,
    aws_subnet.eks_subnet[2].id
  ]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
}

# Output EKS cluster endpoint
output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

# Output EKS cluster name
output "eks_cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

