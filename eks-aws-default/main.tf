module "eks" {
  source            = "./modules/eks"
  env               = var.env 
  vpc_name          = var.vpc_name 
  subnet_name_2a    = var.subnet_name_2a
  subnet_name_2b    = var.subnet_name_2b
  subnet_name_2c    = var.subnet_name_2c  
  node_groups       = var.eks["node_groups"]
  eks_version       = var.eks["eks_version"]
  add_ons           = var.eks["add_ons"]
  eks-iam-access    = var.eks["eks-iam-access"]
  vault_token       = var.vault_token 
}

module "dns" {
  depends_on        = [ module.eks ]
  source            = "./modules/dns"
  node_name         = data.aws_instances.eks_nodes.instances
  zone_id           = var.zone_id 
  env               = var.env 
}