resource "aws_route53_record" "dns_public" {
  for_each = var.dns_name
  zone_id = var.zone_id
  name    = each.value
  type    = "A"
  ttl     = 15
  records = [var.public_ip]
}