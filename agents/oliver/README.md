# Oliver — Marketing Agent

Autonomous marketing manager for usedmarcreport.com (DMARC Report lead capture).

## What Oliver Does

- Manages Google Ads campaigns (spend, keywords, negatives)
- Builds and optimizes landing pages
- Tracks conversions (Calendly bookings → ad campaigns)
- Sends weekly Telegram reports to Brad
- Researches competitor strategies and marketing tactics

## Migration from Mac Mini

Oliver was originally deployed on a standalone Mac Mini at 192.168.10.243 running OpenClaw as a launchd daemon. This Docker setup replaces that.

### To migrate:

1. Copy config from Mac Mini:
   ```bash
   scp oliver@192.168.10.243:~/.openclaw/openclaw.json ./config/
   scp oliver@192.168.10.243:~/.openclaw/agents/main/agent/auth-profiles.json ./config/
   ```

2. Move API keys to `.env` (or Infisical once migrated)

3. Start:
   ```bash
   docker compose up -d
   ```

4. Verify Telegram bot responds

5. Decommission Mac Mini

## Shared Memory

Oliver connects to the Mem0 shared memory service at `conductor-mem0:8070`.
- Agent ID: `oliver-marketing`
- Shared org knowledge is available under the `organization` scope
