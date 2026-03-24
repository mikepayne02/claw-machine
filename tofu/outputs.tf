output "container_ipv4" {
  description = "IPv4 address of the OpenClaw container"
  value       = incus_instance.openclaw.ipv4_address
}

output "container_name" {
  description = "Name of the Incus instance"
  value       = incus_instance.openclaw.name
}

output "control_ui_url" {
  description = "OpenClaw control UI URL"
  value       = "http://${incus_instance.openclaw.ipv4_address}:18789"
}
