terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.46.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "certbot" {
  source = "../.."

  cert_fqdn              = var.cert_fqdn
  cert_email             = var.cert_email
  route53_hosted_zone    = var.route53_hosted_zone
  subnet_id              = var.subnet_id
  cidr_ingress_ssh_allow = var.cidr_ingress_ssh_allow
  ssh_key_pair           = var.ssh_key_pair
  output_bucket          = var.output_bucket
}