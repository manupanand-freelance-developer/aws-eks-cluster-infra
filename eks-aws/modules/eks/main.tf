resource "aws_eks_cluster" "main" {
  name                      = "${var.env}-eks-cluster"

# optional if need to auth via API or SSO
#   access_config {
#     authentication_mode = "API"
#   }

  role_arn                  = aws_iam_role.eks_cluster.arn
  version                   = var.eks_version 

  vpc_config {
                subnet_ids  = [
                                data.aws_subnet.kube_subnet_a.id,
                                data.aws_subnet.kube_subnet_b.id,
                                data.aws_subnet.kube_subnet_c.id

                                ]
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSVPCResourceController
  ]
}

resource "aws_eks_node_group" "main" {
  for_each        = var.node_groups
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = each.key
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = [data.aws_subnet.kube_subnet_a.id,data.aws_subnet.kube_subnet_b.id,data.aws_subnet.kube_subnet_c.id]
  instance_types  = each.value["instance_types"]
  capacity_type   = each.value["capacity_type"]
  ami_type        = each.value["ami_type"] 

  scaling_config {
    desired_size = each.value["min_size"]
    max_size     = each.value["max_size"]
    min_size     = each.value["min_size"]
  }

  

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks_node_group_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node_group_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_node_group_AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_eks_addon" "eks_addons" {
    depends_on     = [ aws_eks_cluster.main,aws_eks_node_group.main ]
    for_each       = var.add_ons 
    cluster_name   = aws_eks_cluster.main.name
    addon_name     = each.key
    addon_version  = each.value 
}