provider "google" {
 credentials = "${file("service_account.json")}"
 project     = "composite-keel-269505"
 region      = "us-west1"
}

variable "db_name" {
  type        = string
  description = "database name"
  default     = "trippin-database-postgres"
}

variable "db_password" {
  type        = string
  description = "database password"
  default     = "postpass"
}

resource "google_sql_database" "database" {
  project  = "composite-keel-269505"
  name     = "trippin-database"
  instance = google_sql_database_instance.master.name
}

resource "google_sql_database_instance" "master" {
  project = "composite-keel-269505"
  region  = "us-central1"
  name    = "trippin-database-instance"

  database_version = "POSTGRES_9_6"

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_user" "users" {
  project  = "composite-keel-269505"
  instance = google_sql_database_instance.master.name
  name     = var.db_name
  password = var.db_password
}
