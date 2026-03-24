# claw-machine

OpenTofu IaC for deploying [OpenClaw](https://github.com/openclaw) on Incus. Provisions a Debian 13 LXC container with Docker, configures it via cloud-init's native ansible module + [openclaw-ansible](https://github.com/openclaw/openclaw-ansible), and persists `~/.openclaw` on a dedicated storage volume.

## Stack

- **IaC**: OpenTofu with the [lxc/incus](https://registry.terraform.io/providers/lxc/incus) provider
- **CI**: GitHub Actions on a self-hosted runner ([myoung34/docker-github-actions-runner](https://github.com/myoung34/docker-github-actions-runner))
- **OS provisioning**: cloud-init (ansible module)
- **App provisioning**: [openclaw-ansible](https://github.com/openclaw/openclaw-ansible)

## Usage

```bash
cd tofu
tofu init
tofu plan
tofu apply
```

The container gets an IP from Incus (NAT'd bridge via `incusbr0`) and port 18789 is proxied to the host for LAN access. After cloud-init completes (~5 min), access the UI at `http://<host-ip>:18789`.

## CI Setup

1. Copy `runner/.env.example` to `runner/.env` and fill in your GitHub PAT (fine-grained, needs **Administration read/write** repo permission) and Incus GID
2. `cd runner && docker compose up -d`
3. Pushes to `main` touching `tofu/` or `cloud-init/` trigger deploy automatically

## Variables

All variables have defaults. Override via `tofu/terraform.tfvars` (gitignored):

| Variable | Default | Description |
|---|---|---|
| `storage_pool` | `default` | Incus storage pool |
| `data_volume_size` | `16GiB` | Persistent `~/.openclaw` volume |
| `root_disk_size` | `32GiB` | Container root disk |
| `cpu_cores` | `2` | CPU limit |
| `memory` | `4GiB` | Memory limit |
