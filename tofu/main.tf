terraform {
  required_version = ">= 1.9.0"

  required_providers {
    incus = {
      source  = "lxc/incus"
      version = "~> 0.4"
    }
  }

  backend "local" {
    path = "/home/michael/claw-machine/tofu/terraform.tfstate"
  }
}

provider "incus" {}

# ---------- Persistent data volume ----------
resource "incus_storage_volume" "openclaw_data" {
  name = "openclaw-data"
  pool = var.storage_pool

  config = {
    "size" = var.data_volume_size
  }
}

# ---------- Instance ----------
# Uses the default profile's eth0 on incusbr0 (managed bridge with NAT + DHCP).
# Incus assigns the IP — no VLAN config needed on the host.
resource "incus_instance" "openclaw" {
  name    = "openclaw"
  image   = "images:debian/13/cloud"
  type    = "container"
  running = true

  config = {
    "security.nesting"     = "true"
    "limits.cpu"           = var.cpu_cores
    "limits.memory"        = var.memory
    "cloud-init.user-data" = file("${path.module}/../cloud-init/cloud-init.yaml")
  }

  # Root disk on the LVM-thin pool, overrides default profile size
  device {
    name = "root"
    type = "disk"

    properties = {
      path = "/"
      pool = var.storage_pool
      size = var.root_disk_size
    }
  }

  # Persistent data volume at ~/.openclaw
  device {
    name = "openclaw-data"
    type = "disk"

    properties = {
      path   = "/root/.openclaw"
      source = incus_storage_volume.openclaw_data.name
      pool   = var.storage_pool
    }
  }

  # Port forward: LAN hits vault:18789 → container:18789
  device {
    name = "proxy-openclaw"
    type = "proxy"

    properties = {
      listen  = "tcp:0.0.0.0:18789"
      connect = "tcp:127.0.0.1:18789"
    }
  }

  wait_for {
    type = "ipv4"
    nic  = "eth0"
  }
}
