output "node_group_ip" {
 
  value = keys(aws_eks_node_group.main)
  }