#!/bin/bash
# -----------------------------------------------------------------------------
# Script Name: wsl-init.sh
#
# Description:
#   This script initializes and configures the Windows Subsystem for Linux (WSL)
#   environment. It automates essential setup tasks to ensure a consistent and
#   reliable WSL configuration for users.
#
# Usage:
#   ./wsl-init.sh
#
# Prerequisites:
#   - Must be run inside a WSL environment.
#   - Requires Bash shell.
#   - Script must have executable permissions (chmod +x wsl-init.sh).
#
# Notes:
#   - Uses 'set -euo pipefail' for robust error handling.
# -----------------------------------------------------------------------------

set -euo pipefail

# Check if running inside WSL
if [ -z "$WSL_DISTRO_NAME" ]; then
  echo "This script should be run inside a WSL terminal."
  exit 1
fi

echo "====================================================================="
echo "Starting initial configuration for your new Ubuntu WSL environment..."
echo "====================================================================="

# 1. Update and upgrade packages
echo "[1/6] Updating package lists and upgrading packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

# 2. Install common developer tools
echo "[2/6] Installing developer tools (git, curl, build-essential, etc.)..."
sudo apt-get install -y git curl wget build-essential unzip zip htop

# 3. Set up .ssh directory
echo "[3/6] Ensuring ~/.ssh directory exists and has correct permissions..."
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# 4. (Optional) Add more setup steps here, e.g., language runtimes, editors, aliases, etc.

echo "[4/6] Initial WSL configuration complete!"
echo "====================================================================="
echo "You may want to:"
echo " - Add your SSH keys to ~/.ssh"
echo " - Customize your shell or install more packages"
echo " - Restart your terminal for all changes to take effect"
echo "====================================================================="

touch ~/.wsl-init-complete

