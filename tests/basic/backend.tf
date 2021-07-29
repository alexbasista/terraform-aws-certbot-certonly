terraform {
  backend "remote" {
    organization = "terraform-tom"

    workspaces {
      name = "module-terraform-aws-certbot-certonly-test"
    }
  }
}