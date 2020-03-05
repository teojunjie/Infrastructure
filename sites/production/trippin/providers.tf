provider "google" {
 credentials = "${file("service_account.json")}"
 project     = "composite-keel-269505"
 region      = "us-west1"
}

terraform {
  required_providers {
    helm = "~> 0.10.0"
  }
}
