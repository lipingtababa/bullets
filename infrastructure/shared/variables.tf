provider "aws" {
  region = "us-east-1"
}

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "credit"
}
