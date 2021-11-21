data "aws_route53_zone" "public" {
  name         = var.route53_hosted_zone
  private_zone = false
}

resource "aws_route53_record" "dns" {
  name    = var.cert_fqdn
  zone_id = data.aws_route53_zone.public.zone_id
  type    = "A"
  ttl     = 60
  records = [aws_instance.certbotter.public_ip]
}