#------------------------------------------------------------------------------
# AWS Route53
#------------------------------------------------------------------------------
data "aws_route53_zone" "public" {
  count = var.cloud_provider == "aws" ? 1 : 0

  name         = var.route53_hosted_zone
  private_zone = false
}

resource "aws_route53_record" "dns" {
  count = var.cloud_provider == "aws" ? 1 : 0

  name    = var.cert_fqdn
  zone_id = data.aws_route53_zone.public[0].zone_id
  type    = "A"
  ttl     = 60
  records = [aws_instance.certbotter.public_ip]
}

#------------------------------------------------------------------------------
# Azure
#------------------------------------------------------------------------------
resource "azurerm_private_dns_a_record" "public" {
  count = var.cloud_provider == "azure" ? 1 : 0

  name                = azurerm_redis_cache.tfe.name
  resource_group_name = var.azure_dns_zone_rg
  zone_name           = var.azure_dns_zone_name
  ttl                 = 300
  records             = [aws_instance.certbotter.public_ip]
}