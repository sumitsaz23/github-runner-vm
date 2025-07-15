terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc01"
    }
  }
}


provider "proxmox" {
  pm_api_url      = "https://192.168.1.190:8006/api2/json"
  pm_parallel     = 1
  pm_debug        = false
  pm_tls_insecure = true

}