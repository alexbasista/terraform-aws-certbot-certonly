terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.8.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "certbotter" {
  source = "../"

  cert_fqdn           = var.cert_fqdn
  cert_email          = var.cert_email
  route53_hosted_zone = var.route53_hosted_zone
  output_bucket       = var.output_bucket
}