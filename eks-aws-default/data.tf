data "aws_instances" "eks_nodes" {
  filter {
    name   = "tag:eks:nodegroup-name"
    values = module.eks.node_group_names
  }

  # Optional: limit to only running instances
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}
