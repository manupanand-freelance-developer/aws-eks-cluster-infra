output "node_group_ip" {
  depends_on = [ aws_eks_node_group.main ]
  value = [for ng in aws_eks_node_group.main : ng.node_group_name]
}