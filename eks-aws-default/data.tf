# data "aws_autoscaling_groups" "eks_asgs" {}
# data "aws_autoscaling_instances" "eks_nodes" {}

# data "aws_instances" "eks_nodes" {
#     depends_on = [ module.eks]
#   filter {
#     name   = "tag:eks:nodegroup-name"
#     values = module.eks.node_group_names
#   }
# }