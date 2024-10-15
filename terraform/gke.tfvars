
  # Cluster variables
  pod_ipv4_cidr                      = "10.36.0.0/14"
  service_ipv4_cidr                  = "10.40.0.0/20"
  deletion_protection                = true
  release_channel                    = "REGULAR"
  region                             = "us-central1"
  env_name                           = "test"
  project_name                       = ""
  subnet_cidr                        = "10.5.0.0/24"


  gke_node_pools = [
    {
      name               = "test-pool-n2ds8"
      machine_type       = "n2d-standard-8"
      node_locations     = ["us-central1-f", "us-central1-a", "us-central1-c", "us-central1-b"]
      spot               = true
      enable_autoscaling = true
      min_size           = 0
      max_size           = 1
      disk_size_gb       = 100
    }
  ]