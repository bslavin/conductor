#!/usr/bin/env bash
# Setup script for the Conductor Ubuntu VM on Proxmox
# Run this INSIDE the VM after creating it via Proxmox UI
#
# Usage: curl -sSL <raw-github-url> | bash
# Or:    bash setup-proxmox-vm.sh

set -euo pipefail

echo "=== Conductor VM Setup ==="
echo ""

# Update system
echo "[1/5] Updating system..."
sudo apt update && sudo apt upgrade -y

# Install Docker
echo "[2/5] Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com | sh
    sudo usermod -aG docker "$USER"
    echo "  Docker installed. You'll need to log out/in for group changes."
else
    echo "  Docker already installed."
fi

# Install Docker Compose plugin
echo "[3/5] Verifying Docker Compose..."
if docker compose version &> /dev/null; then
    echo "  Docker Compose $(docker compose version --short) ready."
else
    sudo apt install -y docker-compose-plugin
fi

# Install Tailscale
echo "[4/5] Installing Tailscale..."
if ! command -v tailscale &> /dev/null; then
    curl -fsSL https://tailscale.com/install.sh | sh
    echo "  Tailscale installed. Run: sudo tailscale up"
else
    echo "  Tailscale already installed."
    tailscale status | head -5
fi

# Install basic tools
echo "[5/5] Installing utilities..."
sudo apt install -y \
    git \
    curl \
    htop \
    jq \
    net-tools \
    unzip

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "  1. Log out and back in (for Docker group)"
echo "  2. sudo tailscale up"
echo "  3. git clone your conductor repo"
echo "  4. cd conductor && cp .env.example .env"
echo "  5. Fill in .env with your secrets"
echo "  6. docker compose up -d"
echo ""
