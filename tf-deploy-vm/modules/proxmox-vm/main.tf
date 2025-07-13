resource "proxmox_vm_qemu" "this" {
  vmid        = var.vmid
  name        = var.name
  target_node = var.target_node
  agent       = 1
  cpu {
    cores   = var.cpu_cores
    sockets = 1
    numa    = true
    type    = "x86-64-v2-AES"
  }
  memory      = var.memory
  bios        = "ovmf"
  boot        = "order=scsi0"
  clone       = var.clone
  scsihw      = "virtio-scsi-single"
  vm_state    = var.vm_state
  automatic_reboot = true

  cicustom   = var.cicustom
  ciupgrade  = true
  nameserver = var.nameserver
  ipconfig0  = var.ipconfig0
  skip_ipv6  = true
  ciuser     = var.ciuser
  cipassword = var.cipassword
  sshkeys    = var.ssh_key

  serial {
    id = 0
  }

  efidisk {
    efitype = "4m"
    storage = var.efidisk_storage
  }

  disks {
    scsi {
      scsi0 {
        disk {
          storage = var.disk_storage
          size    = var.disk_size
        }
      }
      scsi1 {
        cloudinit {
          storage = var.disk_storage
        }
      }
    }
  }

  network {
    id     = 0
    bridge = var.network_bridge
    model  = "virtio"
  }
}
