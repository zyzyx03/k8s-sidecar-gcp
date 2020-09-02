// root module

provider "google" {
  credentials = file("./secret/pyzine-terraform.json")
  project = var.gcp_project_name
  region  = var.gcp_region
  zone    = var.gcp_zone
}

module "db" {

  source = "./modules/db"
  disk_size     = 10
  instance_type = "db-f1-micro"
  password      = var.db_password 
  user          = var.db_username

}

module "gke" {

  source = "./modules/gke"
  name   = var.k8s_name
  project = var.gcp_project_name
  location = var.gcp_region
  initial_node_count = 1

}

