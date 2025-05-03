output vm_name {
  value       = libvirt_domain.vm_domain.name
  description = "the name you gave to your domain"
  depends_on  = [libvirt_domain.vm_domain]
}

# output the private ip of the vm (always)
output vm_ip {
  value       = libvirt_domain.vm_domain.network_interface.0.addresses[0]
  description = "the produced ip address"
  depends_on  = [libvirt_domain.vm_domain]
}

output ssh_command {
  value       = "to ssh into the vm, run: ssh ${var.vm_username}@${libvirt_domain.vm_domain.network_interface.0.addresses[0]} -J ${var.remote_host_username}@${var.remote_host_ip}"
  description = "description"
  depends_on  = [libvirt_domain.vm_domain]
}
