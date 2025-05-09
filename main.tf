terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.3"
    }
  }
}

# Configure the libvirt provider and the connection uri
provider "libvirt" {
  uri = "qemu+ssh://${var.remote_host_username}@${var.remote_host_ip}/system"
}

# Use the default storage pool and the bridge name
locals {
  storage_pool_name = "default"
}

# Create cloud-init disk also the network config
resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit.iso"
  pool      = local.storage_pool_name
  user_data = templatefile("${path.module}/templates/cloud_init.tftpl", {
    hostname = var.vm_name
    username = var.vm_username
    password = var.vm_password
    ssh_key  = var.vm_ssh_key != "" ? var.vm_ssh_key : file(pathexpand(var.public_ssh_key_file))
  })
  network_config = var.use_public_ip ? templatefile("${path.module}/templates/network_config.tftpl", {
    ip      = var.vm_public_ip
    gateway = var.vm_gateway
    dns     = var.vm_dns
  }) : null
}

# Fetch the base image from the Internet if you are not using a local image
resource "libvirt_volume" "ubuntu-qcow2" {
  count = var.use_local_image ? 0 : 1
  name   = "ubuntu-qcow2"
  pool   = local.storage_pool_name
  source = "https://cloud-images.ubuntu.com/minimal/releases/jammy/release/ubuntu-22.04-minimal-cloudimg-amd64.img"
  format = "qcow2"
}

# Define the VM disk
resource "libvirt_volume" "vm_disk" {
  name           = "${var.vm_name}.qcow2"
  base_volume_id = var.use_local_image ? var.local_image_path : libvirt_volume.ubuntu-qcow2[0].id
  pool           = local.storage_pool_name
  size           = var.vm_disk_size * 1073741824  # Convert GB to bytes
}

# Define the VM
resource "libvirt_domain" "vm_domain" {
  name      = var.vm_name
  memory    = var.vm_ram * 1024
  vcpu      = var.vm_vcpus
  qemu_agent = true

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  # First network interface (I want the vm to be able to access the local network anyway)
  network_interface { # Private network
    bridge     = var.private_ip_bridge
    wait_for_lease = true
  }

  # Second network interface for public IP
  dynamic "network_interface" {
    for_each = var.use_public_ip ? [1] : []
    content {
      bridge = var.public_ip_bridge
    }
  }

  # Add console configuration (sometimes it doesn't work without console)
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  disk {
    volume_id = libvirt_volume.vm_disk.id
  }
}









