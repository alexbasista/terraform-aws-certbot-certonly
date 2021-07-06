# terraform-aws-certbot-certonly
Terraform module to automatically create a Let's Encrypt certificate via Certbot on an AWS EC2 instance, and then copy the certificate files to an existing S3 bucket of choice.

## Usage
```hcl
module "certbot" {
  source = "github.com/alexbasista/terraform-aws-certbot-certonly.git"

  cert_fqdn              = "my-new-cert.example.com"
  cert_email             = "my-email-addr@example.com"
  route53_hosted_zone    = "example.com"
  subnet_id              = "subnet-abcdefghijk123456"
  output_bucket          = "my-s3-bucket-name"
}
