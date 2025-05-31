





resource "aws_route53_record" "dns_private" {
  depends_on = [ aws_route53_zone.private_db_dns ]
  for_each=var.private_ip 
  zone_id = var.zone_id
  name    = "${var.name}.${each.key}"
  type    = "A"
  ttl     = 15
  records = [each.value]
}