
resource "aws_route53_zone" "private_db_dns" {
  name = "db.manupanand.online"

  vpc {
    vpc_id = aws_vpc.example.id
  }
}




resource "aws_route53_record" "dns_private" {
  depends_on = [ aws_route53_zone.private_db_dns ]
  for_each=var.private_ip 
  zone_id = aws_route53_zone.private_db_dns.zone_id
  name    = "${var.name}.${each.key}"
  type    = "A"
  ttl     = 15
  records = [each.value]
}