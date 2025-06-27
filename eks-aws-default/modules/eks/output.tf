output "node_group_ip" {
  depends_on = [ aws_eks_node_group.main ]
  value = keys(aws_eks_node_group.main)
  }