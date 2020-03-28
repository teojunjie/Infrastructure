data "helm_repository" "trippin" {
  name = "trippin"
  url  = var.helm_repo_uri
}

resource "helm_release" "auth" {
  keyring    = "/dev/null"

  name    = "auth"
  chart = var.helm_chart_path
  repository = "${var.environment == "prod" ? data.helm_repository.trippin.metadata[0].url : ""}"
  version = var.helm_chart_tag

  values = [
    "${file("values.yaml")}"
  ]
  set_string {
    name = "auth.image.repository"
    value = "${var.image_repo}:${var.image_tag}"
  }
}

data "helm_repository" "jetstack" {
  name = "jetstack"
  url = "https://charts.jetstack.io"
}

# cert-manager is used for TLS cert-rotation in the cluster
resource "helm_release" "cert-manager" {
  name    = "cert-manager"
  namespace = "kube-system"
  chart = "cert-manager"
  repository = data.helm_repository.jetstack.metadata[0].name
  version = "v0.12.0"
}

data "helm_repository" "stable" {
  name = "stable"
  url = "https://kubernetes-charts.storage.googleapis.com"
}

# nginx resource will only be created for a gke cluster i.e. when environment is prod
# since minikube already has an nginx controller when `minikube addons enable ingress`. 
resource "helm_release" "nginx-ingress" {
  count = var.environment == "prod" ? 1 : 0
  name    = "nginx-ingress"
  namespace = "kube-system"
  chart = "nginx-ingress"
  repository = data.helm_repository.stable.metadata[0].name

  set {
    name = "rbac.create"
    value = true
  }

  set {
    name = "controller.publishService.enabled"
    value = true
  }
}
