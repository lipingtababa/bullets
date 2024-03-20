terraform {
  backend "s3" {
    bucket = "lipingtababa-tf-statefiles"
    key    = "bullets/service/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "lipingtababa-terraform-lock-table"
  }
}
