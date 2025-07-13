variable "vm_configs" {
    description = "A map of VM configurations for the Kubernetes nodes"
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
        k8s-master-1 = { vmid = 1001, name = "k8s-master-1", cpu_cores = 4, memory = 4096, storage = "20G", clone = "ubuntu-24-04-cloudinit", ipconfig0 = "ip=192.168.1.191/24,gw=192.168.1.254,ip6=dhcp", vm_state = "running" }
        k8s-node-1 = { vmid = 1002, name = "k8s-node-1", cpu_cores = 4, memory = 4096, storage = "20G", clone = "ubuntu-24-04-cloudinit", ipconfig0 = "ip=192.168.1.192/24,gw=192.168.1.254,ip6=dhcp", vm_state = "running" }
        k8s-node-2 = { vmid = 1003, name = "k8s-node-2", cpu_cores = 4, memory = 4096, storage = "20G", clone = "ubuntu-24-04-cloudinit", ipconfig0 = "ip=192.168.1.193/24,gw=192.168.1.254,ip6=dhcp", vm_state = "running" }
    }
}

variable "ssh-key" {
    type = string
    description = "SSH public key for the VMs"
    sensitive = true
  
}