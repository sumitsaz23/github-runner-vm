# Terraform configuration for deploying GitHub Runner VMs using Proxmox module

module "github_runner_vms" {
  source = "../proxmox-vm-module"
  for_each = var.github_runner_vm_configs

  vmid        = each.value.vmid
  name        = each.value.name
  cpu_cores   = each.value.cpu_cores
  memory      = each.value.memory
  clone       = each.value.clone
  full_clone =  each.value.full_clone
  vm_state    = each.value.vm_state
  ipconfig0   = each.value.ipconfig0
  disk_size   = each.value.storage
  ssh_key     = var.ssh_key
  cipassword  = var.cipassword
  ciuser      = var.ciuser
  # Optional: override defaults if needed
  # cicustom    = "vendor=local:snippets/qemu-guest-agent.yml"
  # nameserver  = "1.1.1.1 8.8.8.8"
  # efidisk_storage = "hdd-vm-data"
  # disk_storage    = "hdd-vm-data"
  # network_bridge  = "vmbr0"
}

output "vm_ips" {
  description = "All outputs from myvm module"
  value       = module.github_runner_vms
}
