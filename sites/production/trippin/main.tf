locals {
  repository = "gcr.io/composite-keel-269505/trippin"
  image_tag  = "45b6c54fe221c55ebda38acc74ec7491e7b164e9"
  chart_tag  = "0.2.0"
}

resource "kubernetes_secret" "postgres-credentials" {
  metadata {
    name = "postgres-credentials"
  }

  data = {
    user = "trippin-database-postgres"
    password = "postpass"
  }

  type = "kubernetes.io/basic-auth"
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
service:
  type: LoadBalancer
global:
  postgresHost: 10.79.224.3
  postgresDB: trippin-database-postgres
  service:
    type: NodePort
    port: 8080
  image:
    repository: "${local.repository}"
    tag: "${local.image_tag}"
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