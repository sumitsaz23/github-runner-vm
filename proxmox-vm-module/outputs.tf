
output "vm_ip" {
  value = proxmox_vm_qemu.this.default_ipv4_address
}

# output "private_key_length" {
#   value = length(file(var.ssh_private_key_path))
# }
