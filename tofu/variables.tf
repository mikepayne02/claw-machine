variable "storage_pool" {
  description = "Incus storage pool name"
  type        = string
  default     = "default"
}

variable "data_volume_size" {
  description = "Size of the persistent ~/.openclaw volume"
  type        = string
  default     = "16GiB"
}

variable "root_disk_size" {
  description = "Size of the container root disk"
  type        = string
  default     = "32GiB"
}

variable "cpu_cores" {
  description = "CPU core limit for the container"
  type        = string
  default     = "2"
}

variable "memory" {
  description = "Memory limit for the container"
  type        = string
  default     = "4GiB"
}
