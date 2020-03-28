variable "environment" {
  type = string
  description = "Environment in which terraform commands are run in"
  validation {
      condition = var.environment == "local" || var.environment == "prod"
      error_message = "The environment value must either be local or prod."
  }
}


variable "postgres_credentials_name" {
  type = string
  description = "Name of postgres credentials k8s secret"
  default = "postgres-credentials"
}

variable "postgres_credentials_data" {
  type = object({
    username = string
    password = string
  })
  description = "Data to be stored in postgres credentials k8s secret"
}

variable "image_repo" {
  type = string
  description = "Image repo URI"
  default = "gcr.io/composite-keel-269505/trippin"
}

variable "image_tag" {
  type = string
  description = "Image tag"
}

variable "helm_repo_uri" {
  type = string
  description = "Helm repo URI"
  default = "https://test-helm-bucket01.storage.googleapis.com"
}

variable "helm_chart_path" {
  type = string
  description = "Path to helm charts"
}

variable "helm_chart_tag" {
  type = string
  description = "Version tag of helm charts"
}

variable "gcp_project_name" {
  type = string
  description = "Name of GCP project"
  default = "composite-keel-269505"
}

variable "gcp_project_zone" {
  type = string
  description = "Zone of GCP project"
  default = "us-west1"
}
