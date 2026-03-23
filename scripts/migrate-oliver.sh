#!/usr/bin/env bash
# Migrate Oliver's config from Mac Mini to Conductor
# Run this from the Conductor repo on the Proxmox VM
#
# Prerequisites:
#   - SSH access to oliver@192.168.10.243
#   - Brad's SSH key in authorized_keys (already set up)

set -euo pipefail

OLIVER_HOST="oliver@192.168.10.243"
CONFIG_DIR="./agents/oliver/config"

echo "=== Migrating Oliver from Mac Mini ==="
echo ""

# Create config directory
mkdir -p "$CONFIG_DIR"

# Copy OpenClaw config
echo "[1/4] Copying OpenClaw config..."
scp "$OLIVER_HOST":~/.openclaw/openclaw.json "$CONFIG_DIR/"
echo "  ✓ openclaw.json"

# Copy agent auth profiles
echo "[2/4] Copying auth profiles..."
scp "$OLIVER_HOST":~/.openclaw/agents/main/agent/auth-profiles.json "$CONFIG_DIR/"
echo "  ✓ auth-profiles.json"

# Copy any skills/tools
echo "[3/4] Copying skills..."
scp -r "$OLIVER_HOST":~/.openclaw/agents/main/agent/skills "$CONFIG_DIR/" 2>/dev/null || echo "  (no custom skills found)"

# Extract API keys for .env (display only, don't write)
echo ""
echo "[4/4] Extracting environment variables..."
echo ""
echo "Add these to your .env file:"
echo "---"

# Parse keys from the config (display, don't store in script)
ssh "$OLIVER_HOST" 'cat ~/.openclaw/.env 2>/dev/null' || echo "  (no .env found on Mac Mini)"

echo ""
echo "---"
echo ""
echo "=== Migration Complete ==="
echo ""
echo "Next steps:"
echo "  1. Add extracted API keys to .env"
echo "  2. Remove plaintext keys from config files"
echo "  3. docker compose -f agents/oliver/docker-compose.yml up -d"
echo "  4. Verify Telegram bot responds"
echo "  5. Stop Oliver on Mac Mini: ssh $OLIVER_HOST 'launchctl unload ~/Library/LaunchDaemons/ai.openclaw.gateway.plist'"
echo ""
