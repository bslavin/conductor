# Conductor Services Reference

This file is the canonical reference for all services running on the Conductor infrastructure.
Share this with any Claude Code session, agent, or team member that needs to connect.

## Connection Info

### From LAN (home network)
| Service | URL |
|---|---|
| Proxmox UI | https://192.168.2.172:8006 |
| Nginx Proxy Manager | http://192.168.2.177:81 |
| Infisical | https://192.168.2.177:8443 |
| Mem0 API | http://192.168.2.177:8070 |

### From Anywhere (Tailscale)
| Service | URL |
|---|---|
| Nginx Proxy Manager | http://conductor-main:81 |
| Infisical | https://conductor-main:8443 |
| Mem0 API | http://conductor-main:8070 |
| SSH | ssh brad@conductor-main |

## Mem0 — Shared Agent Memory

REST API for storing and retrieving memories across all agents.

**Base URL:** `http://conductor-main:8070`

| Endpoint | Method | Purpose |
|---|---|---|
| `/health` | GET | Health check |
| `/v1/memories` | POST | Add memories |
| `/v1/memories` | GET | List memories (filter by user_id, agent_id) |
| `/v1/memories/search` | POST | Semantic search |
| `/v1/memories/{id}` | DELETE | Delete a memory |

**Agent IDs in use:**
- `oliver-marketing` — Oliver, marketing/advertising agent
- (more to come)

## Infisical — Secrets Management

Web UI for managing API keys, tokens, and credentials across all agents and services.

**URL:** https://conductor-main:8443

## Nginx Proxy Manager

Reverse proxy for clean URLs. Admin UI at port 81.

**Default login:** admin@example.com / changeme (change immediately)

## VM Details

- **OS:** Ubuntu 24.04 LTS (minimized server)
- **Resources:** 12 cores, 64GB RAM, 100GB disk
- **Docker:** 29.3.0 with Compose v5.1.1
- **User:** brad (passwordless sudo)
- **SSH key:** brad@Brads-MacBook-Pro.local (ed25519)
