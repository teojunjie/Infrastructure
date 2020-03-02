variable "name" {
  default = "trippin-cluster"
}
variable "project" {
  default = "composite-keel-269505"
}

variable "location" {
  default = "us-central1"
}

variable "initial_node_count" {
  default = 1
}

variable "machine_type" {
  default = "n1-standard-1"  
}