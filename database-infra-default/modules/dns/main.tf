





resource "aws_route53_record" "dns_private" {
  
  for_each=var.public_ip 
  zone_id = var.zone_id
  name    = "${var.name}.${each.key}"
  type    = "A"
  ttl     = 15
  records = [each.value]
}