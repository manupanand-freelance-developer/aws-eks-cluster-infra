data "aws_instances" "eks_nodes" {
  filter {
    name   = "tag:eks:nodegroup-name"
    values = ["main_spot"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

