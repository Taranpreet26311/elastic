variable "project_name" {
  description = "GCP Project Name"
  type        = string
}

variable "env_name" {
  description = "GCP Environment Name"
  type = string
}


variable "subnet_cidr" {
  description = "Subnets CIDR Range"
  type = string
  }

variable "region" {
  description = "GCP Region"
  type        = string
}


variable "pod_ipv4_cidr" {
  description = "Pod IPv4 address"
  type        = string
}

variable "service_ipv4_cidr" {
  description = "Pod IPv4 address"
  type        = string
}


variable "deletion_protection" {
  type        = string
  description = "Whether to enable deletion protection for the cluster"
}

variable "release_channel" {
  description = "value of release channel"
  type        = string
}


variable "gke_node_pools" {
  description = "GKE node pools to be created for the cluster. Each node pool can be customized independently."
  type = list(object({
    name               = string
    enable_autoscaling = optional(bool, false)
    min_size           = optional(number, 0)
    max_size           = optional(number, 3)
    desired_size       = optional(number, 1)
    machine_type       = string
    disk_size_gb       = number
    disk_type          = optional(string, "pd-standard")
    preemptible        = optional(bool, false)
    spot               = optional(bool, false)
    auto_repair        = optional(bool, true)
    auto_upgrade       = optional(bool, true)
    node_locations     = optional(list(string), ["us-central1-c", "us-central1-f", "us-central1-a"])
    service_account    = optional(string, "default")
    oauth_scopes       = optional(list(string), ["https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring"])
    labels             = optional(map(string), {})
    resource_labels    = optional(map(string), {})
    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])
  }))
  default = []
}