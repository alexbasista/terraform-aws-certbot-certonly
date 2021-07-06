variable "cert_fqdn" {
    type        = string
    description = "FQDN (Subject Common Name) for new certificate."
}

variable "cert_email" {
    type        = string
    description = "Email address to associate with new certificate."
}

variable "route53_hosted_zone" {
    type        = string
    description = "Route53 Hosted Zone to create DNS record in."
}

variable "subnet_id" {
    type        = string
    description = "ID of Subnet to deploy EC2 instance in."
}

variable "cidr_ingress_ssh_allow" {
    type        = list(string)
    description = "Optional list of CIDR ranges to allow SSH inbound to EC2 instance."
    default     = []
}

variable "ssh_key_pair" {
    type        = string
    description = "Optional existing SSH Key Pair to attach to EC2 instance."
    default     = null
}

variable "output_bucket" {
    type        = string
    description = "Existing S3 bucket to write the certificate files to."
}