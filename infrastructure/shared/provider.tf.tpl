terraform {
  backend "s3" {
    bucket = "lipingtababa-tf-statefiles"
    key    = "APP_NAME_PLACEHOLDER/shared/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "lipingtababa-terraform-lock-table"
  }
}