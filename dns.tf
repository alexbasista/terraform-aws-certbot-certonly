#------------------------------------------------------------------------------
# Locals - determine the hostname and domain name
#------------------------------------------------------------------------------
locals {
  aws_hostname = var.cloud_provider_dns == "aws" && var.route53_hosted_zone != null ? trimsuffix(substr(var.cert_fqdn, 0, length(var.cert_fqdn) - length(var.route53_hosted_zone) - 1), ".") : null

  azure_hostname = var.cloud_provider_dns == "azure" && var.azure_dns_zone_name != null ? trimsuffix(substr(var.cert_fqdn, 0, length(var.cert_fqdn) - length(var.azure_dns_zone_name) - 1), ".") : null
}

#------------------------------------------------------------------------------
# AWS Route53
#------------------------------------------------------------------------------
data "aws_route53_zone" "public" {
  count = var.cloud_provider_dns == "aws" ? 1 : 0

  name         = var.route53_hosted_zone
  private_zone = false
}

resource "aws_route53_record" "dns" {
  count = var.cloud_provider_dns == "aws" ? 1 : 0

  name    = local.aws_hostname
  zone_id = data.aws_route53_zone.public[0].zone_id
  type    = "A"
  ttl     = 60
  records = [aws_instance.certbotter.public_ip]
}

#------------------------------------------------------------------------------
# Azure
#------------------------------------------------------------------------------
resource "azurerm_dns_a_record" "public" {
  count = var.cloud_provider_dns == "azure" ? 1 : 0

  name                = local.azure_hostname
  resource_group_name = var.azure_dns_zone_rg
  zone_name           = var.azure_dns_zone_name
  ttl                 = 60
  records             = [aws_instance.certbotter.public_ip]
}