provider "aws" {
  region = "us-east-1"
}

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "credit"
}

variable "stage" {
  description = "Stage of the application"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_account" {
  description = "AWS account"
  type        = string
  default     = "339713007259"
}

variable "app_version" {
  description = "AWS account"
  type        = string
  default     = "initial"
}

locals {
  # The ECS cluster is pre-existing
  cluster_name = "overview"

  # The network is pre-existing
  subnet_ids = [
    "subnet-0510dc3e9b9d9e987",
    "subnet-0c5b58dd62c87065b"
  ]
  vpc_default_security_group_id = "sg-0e5a3cc3f26bbcc96"
  vpc_id = "vpc-0a520c498b461f697"

  # The service discovery namespace is pre-existing
  namespace_id = "ns-2kxtkn7qxlwrqzfs"
}
