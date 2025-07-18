resource "proxmox_vm_qemu" "this" {
  vmid        = var.vmid
  name        = var.name
  target_node = var.target_node
  agent       = 1
  agent_timeout = 120
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
  full_clone = var.full_clone
  scsihw      = "virtio-scsi-single"
  vm_state    = var.vm_state
  automatic_reboot = true
  desc       = var.desc

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


# resource "time_sleep" "wait_for_agent" {
#   depends_on       = [proxmox_vm_qemu.this]
#   create_duration  = "1m"          # adjust based on your VM’s startup time
# }


resource "null_resource" "provision_runner" {
  #depends_on = [time_sleep.wait_for_agent]


  connection {
    type        = "ssh"
    host        = proxmox_vm_qemu.this.ssh_host
    user        = "gitrunner"
    private_key = file(var.ssh_private_key_path)
    port        = 22
    timeout     = "2m"
  }
  provisioner "remote-exec" {
    inline = [
      "curl -O https://raw.githubusercontent.com/actions/runner/main/scripts/create-latest-svc.sh",
      "if [ ! -f create-latest-svc.sh ]; then echo 'create-latest-svc.sh not found after download'; exit 1; fi",
      "chmod +x create-latest-svc.sh",
      "RUNNER_CFG_PAT=${var.RUNNER_CFG_PAT} bash ./create-latest-svc.sh ${var.desc}"
    ]
  }
}




resource "null_resource" "destroy_runner" {
  
  # Capture remote host and any other needed runtime values
  triggers = {
    ssh_host = proxmox_vm_qemu.this.ssh_host
    cfg_pat  = var.RUNNER_CFG_PAT
    desc     = var.desc
    priv_key = file(var.ssh_private_key_path)
  }

  connection {
    type        = "ssh"
    host        = self.triggers.ssh_host
    user        = "gitrunner"
    private_key = self.triggers.priv_key
    port        = 22
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    when    = destroy
    inline  = [
      "curl -O https://raw.githubusercontent.com/actions/runner/refs/heads/main/scripts/remove-svc.sh",
      "if [ ! -f remove-svc.sh ]; then echo 'remove-svc.sh not found after download'; exit 1; fi",
      "chmod +x remove-svc.sh",
      "RUNNER_CFG_PAT=${self.triggers.cfg_pat} bash ./remove-svc.sh ${self.triggers.desc}",
      "echo cleanup completed"
    ]
    # omit on_failure if you want failures to block destroy
  }
}


