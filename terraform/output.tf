output "cluster_id" {
  value = aws_eks_cluster.example.id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.example.endpoint
}

output "cluster_kubeconfig_certificate_authority" {
  value = aws_eks_cluster.example.certificate_authority[0].data
}

output "cluster_arn" {
  value = aws_eks_cluster.example.arn
}

