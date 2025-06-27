output "node_group_names" {
  value = [for ng in aws_eks_node_group.main : ng.node_group_name]
}
