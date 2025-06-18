# WSL Setup Script

This README provides step-by-step instructions for setting up your Windows Subsystem for Linux (WSL) environment using the scripts in this repository.

---

## Overview

The setup process consists of three main scripts, each to be run in a specific order and environment (Windows PowerShell or the WSL terminal):

| Step | Script                  | Where to Run         | Purpose                                 |
|------|-------------------------|----------------------|-----------------------------------------|
| 1    | wsl-install.ps1         | PowerShell (Admin)   | Install WSL and Linux distribution      |
| 2    | wsl-init.sh             | WSL Terminal         | Configure Linux environment             |
| 3    | wsl-provision.ps1       | PowerShell           | Copy config files from Windows to WSL   |

---

## Detailed Instructions

### 1. Initial WSL Installation (PowerShell)

**Purpose:** Enable WSL and install your Linux distribution.

- Open **PowerShell as Administrator**.
- Run the `wsl-install.ps1` script:
  - Enables the Windows Subsystem for Linux and Virtual Machine Platform features.
  - Installs your chosen Linux distribution (e.g., Ubuntu).
  - Guides you through the initial WSL configuration.

### 2. Linux Environment Setup (WSL Terminal)

**Purpose:** Configure and customize your Linux environment.

- Launch your installed Linux distribution (e.g., Ubuntu) from the Start Menu or by running `wsl` in PowerShell.
- Inside the WSL terminal, run the `wsl-init.sh` script:
  - Updates package lists and upgrades existing packages.
  - Installs essential development tools (e.g., build tools, editors).
  - Configures Git and SSH keys.
  - Installs programming languages and related tools.
  - Sets up your preferred shell and environment customizations.

### 3. Windows-to-WSL Integration (PowerShell)

**Purpose:** Copy configuration files or resources from Windows into WSL.

- Return to **PowerShell**.
- Run the `wsl-provision.ps1` script:
  - Copies configuration files (dotfiles, settings) from Windows to your WSL home directory.
  - Transfers any additional resources needed for your development workflow.

---

## Quick Start

1. **Open PowerShell as Administrator** and run:
   ```powershell
   .\scripts\wsl-install.ps1
   ```
2. **Complete the initial Linux user setup** when prompted.
3. **Open your WSL terminal** (e.g., Ubuntu) and run:
   ```bash
   bash ~/wsl-init.sh
   ```
4. **Return to PowerShell** and run:
   ```powershell
   .\scripts\wsl-provision.ps1
   ```

---

**Note:**  
Follow each step in order and in the correct environment (PowerShell or WSL terminal) for a smooth setup experience.  
For more details or troubleshooting, refer to the comments within each script.
