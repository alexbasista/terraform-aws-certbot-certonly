# Certbotter
Terraform module to automatically generate a [Let's Encrypt](https://letsencrypt.org/) certificate via [Certbot](https://certbot.eff.org/) from within an AWS EC2 instance, and then output (copy) the certificate files to an existing S3 bucket of choice.

## Usage
```hcl
module "certbotter" {
  source = "github.com/alexbasista/terraform-aws-certbotter"

  cert_fqdn           = "my-new-cert.example.com"
  cert_email          = "my-email-addr@example.com"
  route53_hosted_zone = "example.com"
  output_bucket       = "my-s3-bucket-name"
}
```

## Roadmap
- Add ability to output certs directly to AWS Secrets Manager
- Add multi-cloud options


