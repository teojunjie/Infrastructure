locals {
  repository = "gcr.io/composite-keel-269505/trippin"
  image_tag  = "9a442be8769c9ec2f43008b3898c72b9e42f9fec"
  chart_tag  = "0.1.0"
}

resource "helm_release" "auth" {
  repository = "https://trippinchartmuseum.storage.googleapis.com"
  keyring    = "/dev/null"

  name    = "auth"
  chart   = "auth"
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