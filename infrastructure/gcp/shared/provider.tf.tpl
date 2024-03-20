provider "google" {
  project = "jkmsimulator"
  region  = "us-central1"
}

terraform {
  backend "gcs" {
    bucket  = "lipingtababa-tf-statefiles"
    prefix  = "APP_NAME_PLACEHOLDER/service/terraform.tfstate"
  }
}
