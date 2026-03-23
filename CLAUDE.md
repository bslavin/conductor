# Conductor

Orchestration hub for Brad's AI agent workforce and Dockerized tools, running on Proxmox (Minisforum MS-A2, 96GB RAM, 16C/32T).

## Architecture

```
MS-A2 (192.168.2.167) — Proxmox
└── Ubuntu Server VM
    └── Docker
        ├── Mem0 (shared agent memory) — port 8070
        ├── Infisical (secrets management) — port 8080
        ├── Nginx Proxy Manager — ports 80/443/81
        ├── Google Ads MCP — port 3100
        ├── Oliver (marketing agent, OpenClaw) — port 18789
        └── [future agents and tools]
```

## Key Commands

```bash
# Start everything
docker compose up -d

# Start specific service
docker compose up -d mem0

# Start Oliver
docker compose -f agents/oliver/docker-compose.yml up -d

# View logs
docker compose logs -f mem0
```

## Directory Structure

- `agents/` — Agent definitions (each agent has its own docker-compose + config)
- `services/` — Service-specific configs and Dockerfiles
- `infrastructure/` — Proxmox and Tailscale setup notes
- `scripts/` — Setup and migration scripts

## Network

- Proxmox host: 192.168.2.167 (Tailscale for remote access)
- All services on `conductor_proxy` Docker network for inter-service communication
- Nginx Proxy Manager handles external routing

## Secrets

All secrets in `.env` (gitignored). Moving to Infisical once migrated.
Never commit API keys, tokens, or passwords.
