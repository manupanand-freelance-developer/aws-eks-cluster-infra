output "vpc_id" {
  value = data.aws_vpc.vpc_id.id
}
output "subnet_id_map" {
  value ={ for k, s in data.aws_subnet.subnet_id : k=>s.id}
}
output "security_group_id" {
  value = aws_security_group.ec2_security_group.id
}