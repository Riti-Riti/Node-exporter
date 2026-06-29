terraform {
  backend "s3" {
    bucket       = "terraform-statelock-file"
    key          = "Nodeexporter/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
