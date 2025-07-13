variable "github_runner_vm_configs" {
  description = "A map of VM configurations for the GitHub runner VMs"
  type = map(object({
    vmid        = number
    name        = string
    cpu_cores   = number
    memory      = number
    storage     = string
    clone       = string
    ipconfig0   = string
    vm_state    = string
  }))
  default = {
    github-runner-1 = { vmid = 2001, name = "github-runner-1", cpu_cores = 2, memory = 2048, storage = "20G", clone = "ubuntu-24-04-cloudinit", ipconfig0 = "ip=dhcp,ip6=dhcp", vm_state = "running" }
    github-runner-2 = { vmid = 2002, name = "github-runner-2", cpu_cores = 2, memory = 2048, storage = "20G", clone = "ubuntu-24-04-cloudinit", ipconfig0 = "ip=192.168.1.202/24,gw=192.168.1.254,ip6=dhcp", vm_state = "running" }
  }
}

variable "ssh_key" {
  type = string
  description = "SSH public key for the GitHub runner VMs"
  sensitive = true
}

variable "cipassword" {
  type = string
  description = "Password for the cloud-init user"
  sensitive = true
}

variable "ciuser" {
  type = string
  description = "Password for the cloud-init user"
  sensitive = true
}
