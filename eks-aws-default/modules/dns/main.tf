resource "aws_route53_record" "eks_node_dns" {
  for_each = {
    for idx, ip in var.node_ip:
    "node-${idx}" => ip.public_ip
  }
#idx index of instance 0,1 etc in list
# var.node_name = [
#   { public_ip = "1.2.3.4" },
#   { public_ip = "5.6.7.8" }
# ]
  zone_id = var.zone_id
  name    = "${each.key}.${var.env}"
  type    = "A"
  ttl     = 25
  records = [each.value]
}
