#create security group
module "security_group" {
  source          = "./modules/security-group"
  for_each        = var.ec2_instance
  vpc_name        = var.vpc_name
  subnet_name     = var.subnet_name
  name            = each.key
  ingress_ports   = each.value["server_port"] 
}
resource "aws_route53_zone" "private_db_dns" {
  name = "db.manupanand.online"

  vpc {
    vpc_id = module.security_group[each.key].vpc_id
  }
}
#create iam role
module "iam_role" {
  source          = "./modules/iam-rule"
  for_each        = var.ec2_instance
  name            = each.key 
  policy_name     = each.value["policy_name"]

}
#create ec2-instance
module "ec2-instance" {
  depends_on = [ module.iam_role,module.security_group ]
  source                = "./modules/ec2-instance"
  for_each              = var.ec2_instance
  env                   = var.env
  name                  = each.key
  instance_type         = each.value["instance_type"]
  volume_size           = each.value["volume_size"] 
  ami_id                = var.ami_id
  subnet_id_map         = module.security_group[each.key].subnet_id_map
  security_group_id     = module.security_group[each.key].security_group_id
  iam_instance_profile  = module.iam_role[each.key].iam_instance_profile
  aws_user              = var.aws_user
  aws_password          = var.aws_password  

}
# route 53
module "dns" {

  depends_on            = [ module.ec2-instance ,module.security_group,aws_route53_zone.private_db_dns]
  source                = "./modules/dns"
  for_each              = var.ec2_instance 
  name                  = each.key
  private_ip            = module.ec2-instance[each.key].instance_ip_map
  zone_id               = aws_route53_zone.private_db_dns.zone_id
  
  
}

