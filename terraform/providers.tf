provider "google" {
  project = ""
  region  = "us-central1"
}

terraform {
  required_version = "> 1.0.1"
    required_providers {
        google = {
        source  = "hashicorp/google"
        version = "6.7.0"
        }
    }
  backend "gcs" {
    bucket      = "terraform-dwf"
    prefix      = "test-cluster"
  }
 }