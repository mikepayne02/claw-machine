# claw-machine

OpenTofu IaC for deploying [OpenClaw](https://github.com/openclaw) on Incus. Provisions a Debian 12 LXC container with Docker, configures it via cloud-init + openclaw-ansible, and persists `~/.openclaw` on a dedicated storage volume.

## Stack

- **IaC**: OpenTofu with the [lxc/incus](https://registry.terraform.io/providers/lxc/incus) provider
- **CI**: GitHub Actions on a self-hosted runner
- **OS provisioning**: cloud-init
- **App provisioning**: [openclaw-ansible](https://github.com/openclaw/openclaw-ansible)

## Usage

```bash
cd tofu
tofu init
tofu plan
tofu apply
```

The container gets an IP from Incus (NAT'd bridge) and port 18789 is forwarded to the host for LAN access.

## CI Setup

1. Copy `runner/.env.example` to `runner/.env` and fill in your GitHub PAT and Incus GID
2. `cd runner && docker compose up -d`
3. Pushes to `main` touching `tofu/` or `cloud-init/` trigger deploy automatically

## Variables

All variables have defaults. Override via `tofu/terraform.tfvars` (gitignored):

| Variable | Default | Description |
|---|---|---|
| `storage_pool` | `default` | Incus storage pool |
| `data_volume_size` | `5GiB` | Persistent `~/.openclaw` volume |
| `root_disk_size` | `40GiB` | Container root disk |
| `cpu_cores` | `2` | CPU limit |
| `memory` | `4GiB` | Memory limit |
