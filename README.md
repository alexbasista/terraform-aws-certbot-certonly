# terraform-aws-certbotter
Terraform module to automatically create a Let's Encrypt certificate via Certbot on an AWS EC2 instance, and then output (copy) the certificate files to an existing S3 bucket of choice.

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
- Add ability to output certs to Secrets Manager in specific formats
- Add multi-cloud options


