resource "google_compute_network" "vpc" {

 name                    = "${var.env_name}-vpc"
 auto_create_subnetworks = "false"
 project                 = var.project_name
 mtu                     = 1460
 description             = "VPC for the Infrastucture"

}

resource "google_compute_subnetwork" "kubernetes_subnet" {
  name          = "${var.env_name}-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}
resource "google_container_cluster" "primary" {
  name                     = "${var.env_name}-cluster"
  deletion_protection      = var.deletion_protection
  project                  = var.project_name
  location                 = var.region
  network                  = google_compute_network.vpc.id
  subnetwork               = google_compute_subnetwork.kubernetes_subnet.id
  remove_default_node_pool = true
  initial_node_count       = 1

  release_channel {
    channel = var.release_channel
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.pod_ipv4_cidr
    services_ipv4_cidr_block = var.service_ipv4_cidr
  }
}

resource "google_container_node_pool" "pools" {
  for_each = { for np in var.gke_node_pools : np.name => np }

  name           = "${each.key}"
  location       = var.region
  cluster        = google_container_cluster.primary.name
  project        = var.project_name
  node_locations = each.value.node_locations
  node_count     = (each.value.enable_autoscaling != true) ? each.value.desired_size : null


  management {
    auto_repair  = each.value.auto_repair
    auto_upgrade = each.value.auto_upgrade
  }

  node_config {
    machine_type = each.value.machine_type
    disk_size_gb = each.value.disk_size_gb
    disk_type    = each.value.disk_type
    preemptible  = each.value.preemptible
    spot         = each.value.spot

    oauth_scopes = each.value.oauth_scopes

    labels = merge(
      {
        env = var.env_name
      },
      each.value.labels != null ? each.value.labels : {}
    )

    resource_labels = merge(
      {
        env     = var.env_name
        cluster = google_container_cluster.primary.name
        pool    = "${each.key}"
      },
      each.value.resource_labels != null ? each.value.resource_labels : {}
    )

    service_account = each.value.service_account
  }

  dynamic "autoscaling" {
    for_each = each.value.enable_autoscaling ? [1] : []
    content {
      min_node_count = each.value.min_size
      max_node_count = each.value.max_size
    }
  }
}