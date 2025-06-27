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

output "test" {
  value = [
                        for instance in data.aws_instances.eks_nodes.instances :
                        {
                          public_ip = instance.public_ip
                        }
                      ]
}