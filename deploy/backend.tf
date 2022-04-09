terraform {
  cloud {
    organization = "abasista-tfc"

    workspaces {
      name = "aws-certbotter-deploy"
    }
  }
}