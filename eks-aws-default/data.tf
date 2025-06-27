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
                        for ip in data.aws_instances.eks_nodes.public_ips :
                        {
                          public_ip = ip
                        }
                      ]
}