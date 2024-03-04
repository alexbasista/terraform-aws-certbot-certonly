terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.39.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.94.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "azurerm" {
  environment = "public"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}


module "certbotter" {
  source = "../"

  # --- DNS --- #
  cloud_provider      = var.cloud_provider
  route53_hosted_zone = var.route53_hosted_zone
  azure_dns_zone_name = var.azure_dns_zone_name
  azure_dns_zone_rg   = var.azure_dns_zone_rg

  # --- Cert --- #
  cert_fqdn        = var.cert_fqdn
  cert_email       = var.cert_email
  s3_output_bucket = var.s3_output_bucket

  # --- Common --- #
  common_tags = var.common_tags
}