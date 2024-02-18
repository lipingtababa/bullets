terraform {
  backend "s3" {
    bucket = "lipingtababa-tf-statefiles"
    // Eveery app has its own statefile.
    key    = "$APP_NAME/service/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "$APP_NAME-terraform-lock-table"
  }
}