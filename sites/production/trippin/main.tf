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
locals {
    chart_tag = "0.1.0"
}

resource "helm_release" "trippin" {
  repository = "https://trippin-chartmuseum.storage.googleapis.com"
  keyring    = "/dev/null"

  name    = "trippin"
  chart   = "trippin"
  version = local.chart_tag

  timeout       = 300
  reuse_values  = false
  wait          = true
  recreate_pods = false

  values = [
    <<EOF
global:
  service:
    type: NodePort
    port: 8080
  image:
    pullPolicy: IfNotPresent
  replicaCount: 1
  charts:
    env: prod
    volume:
      name: postgres-volume-mount
  repository: gcr.io/composite-keel-269505/trippin
EOF
    ,
  ]
}