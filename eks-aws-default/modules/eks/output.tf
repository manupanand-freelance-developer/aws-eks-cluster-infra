output "node_group_names" {
  value = keys(aws_eks_node_group.main)
}
