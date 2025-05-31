output "instance_ip_map" {
  value = {for k,s in aws_instance.main : k=>s.private_ip}
}