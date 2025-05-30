resource "aws_eks_access_entry" "bastion_access" {
  cluster_name      = var.cluster_name 
  principal_arn     = var.bastion_role_arn
  kubernetes_groups = var.kubernetes_groups
  type              = "STANDARD"
}
resource "aws_eks_access_policy_association" "bastion_attach_policy" {
    depends_on = [ aws_eks_access_entry.bastion_access ]
  cluster_name  = var.cluster_name 
  policy_arn    = var.bastion_policy
  principal_arn = var.bastion_role_arn

  access_scope {
    type       = "cluster"
    
  }
}