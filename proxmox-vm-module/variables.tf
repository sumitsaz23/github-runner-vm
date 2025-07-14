variable "vmid" {}
variable "name" {}
variable "target_node" { default = "pve01" }
variable "cpu_cores" {}
variable "memory" {}
variable "clone" {}
variable "full_clone" { default = false }
variable "vm_state" {}
variable "cicustom" { default = "vendor=local:snippets/qemu-guest-agent.yml" }
variable "nameserver" { default = "1.1.1.1 8.8.8.8" }
variable "ipconfig0" {}
variable "ciuser" { default = "root" }
variable "cipassword" {}
variable "ssh_key" {}
variable "efidisk_storage" { default = "hdd-vm-data" }
variable "disk_storage" { default = "hdd-vm-data" }
variable "disk_size" {}
variable "network_bridge" { default = "vmbr0" }
variable "desc" { default = "GitHub Runner VM" }
variable "RUNNER_CFG_PAT" {
  type        = string
  description = "GitHub Runner Personal Access Token"
  sensitive   = true
}
