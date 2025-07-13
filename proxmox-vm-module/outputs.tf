
output "vm_ip" {
  value = proxmox_vm_qemu.this.default_ipv4_address
}