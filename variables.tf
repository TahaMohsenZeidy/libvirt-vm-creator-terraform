# Define a variable to know whether or not to use a public IP
variable "use_public_ip" {
  description = "Whether to use a public IP or not"
  type        = bool
  default     = false
}

# Define a variable to know whether or not to use a local base image instead of downloading
variable "use_local_image" {
  description = "Whether to use a local base image instead of downloading"
  type        = bool
  default     = true
}

# Define a variable for local image path if use_local_image is true
variable "local_image_path" {
  description = "Path to local base image if use_local_image is true"
  type        = string
  default     = "/var/lib/libvirt/images_new/ubuntu-22.04-server-cloudimg-amd64.img"
}

# Define a variable for the VM name
variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "terraform-vm"
}

variable "vm_ram" {
  description = "Amount of RAM in GB"
  type        = number
  default     = 2
}

variable "vm_vcpus" {
  description = "Number of virtual CPUs"
  type        = number
  default     = 2
}

# Define a variable for the VM Disk size
variable "vm_disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 20
}

# Variables to connecting to the host of the VMs
variable "remote_host_username" {
  description = "Username for the remote host"
  type        = string
}

variable "remote_host_ip" {
  description = "IP address of the remote host"
  type        = string
}

# Variables for the VM
variable "vm_public_ip" {
  description = "Public IP address of the VM"
  type        = string
}

variable "vm_gateway" {
  description = "Gateway of the VM"
  type        = string
}

variable "vm_dns" {
  description = "DNS of the VM"
  type        = string
}

variable "vm_ssh_key" {
  description = "SSH public key content"
  type        = string
}

variable "vm_username" {
  description = "Username for the VM"
  type        = string
  default     = "user"
}

variable "vm_password" {
  description = "Password for the VM user"
  type        = string
  sensitive   = true
}

variable "public_ip_bridge" {
  description = "Bridge name for public IP"
  type        = string
}

variable "private_ip_bridge" {
  description = "Bridge name for private IP"
  type        = string
}

variable "public_ssh_key_file" {
  description = "Path to SSH public key file"
  type        = string
}