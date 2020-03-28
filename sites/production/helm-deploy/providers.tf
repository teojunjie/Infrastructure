provider "google" {
 credentials = "${file("service_account.json")}"
 project     = var.gcp_project_name
 region      = var.gcp_project_zone
}

terraform {
  experiments = [variable_validation]
  required_providers {
    helm = "~> 0.10.0"
  }
}
