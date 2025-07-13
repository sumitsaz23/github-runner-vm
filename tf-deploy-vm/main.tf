module "vms" {
  source = "../proxmox-vm-module"
  for_each = var.vm_configs

  vmid        = each.value.vmid
  name        = each.value.name
  cpu_cores   = each.value.cpu_cores
  memory      = each.value.memory
  clone       = each.value.clone
  vm_state    = each.value.vm_state
  ipconfig0   = each.value.ipconfig0
  disk_size   = each.value.storage
  ssh_key     = var.ssh-key
  cipassword  = "sur"
  # Optional: override defaults if needed
  # cicustom    = "vendor=local:snippets/qemu-guest-agent.yml"
  # nameserver  = "1.1.1.1 8.8.8.8"
  # efidisk_storage = "hdd-vm-data"
  # disk_storage    = "hdd-vm-data"
  # network_bridge  = "vmbr0"
}