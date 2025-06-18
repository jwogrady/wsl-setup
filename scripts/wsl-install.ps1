<#
.SYNOPSIS
Installs Windows Subsystem for Linux (WSL) and required features if not already present.

.DESCRIPTION
This script checks for required Windows features and WSL. If WSL is not installed, it installs WSL and prompts the user to launch Ubuntu from the Start Menu and complete the initial Linux user setup. After setup, the user should run wsl-init.sh in the WSL terminal, then wsl-provision.ps1 in PowerShell to copy configuration files.

.NOTES
Usage:
    powershell -ExecutionPolicy Bypass -File .\scripts\wsl-install.ps1
#>

# 1. Check for Administrator Privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as Administrator."
    exit 1
}

# 2. Check Operating System
if ($env:OS -ne "Windows_NT") {
    Write-Error "This script must be run on Windows."
    exit 1
}
Write-Host "Confirmed: Running as Administrator on Windows."

# 3. Check Required Windows Features
$features = @{
    "Microsoft-Windows-Subsystem-Linux" = "WSL"
    "VirtualMachinePlatform"            = "WSL 2"
}
foreach ($feature in $features.Keys) {
    $state = (Get-WindowsOptionalFeature -Online -FeatureName $feature).State
    if ($state -ne "Enabled") {
        Write-Error "$($features[$feature]) is not enabled. Please enable it first."
        exit 1
    }
    Write-Host "Confirmed: $($features[$feature]) feature is enabled."
}

# 4. Check for wsl.exe
if (-not (Get-Command wsl.exe -ErrorAction SilentlyContinue)) {
    Write-Error "wsl.exe not found in PATH."
    exit 1
}
Write-Host "Confirmed: wsl.exe is available in PATH."

# 5. Check for Existing WSL Distributions
$wslDistros = & wsl.exe --list --quiet
if ($wslDistros) {
    Write-Host "A WSL distro is already installed. No further action needed."
    Write-Host "Next steps:"
    Write-Host "1. Launch your Linux distribution (e.g., Ubuntu) from the Start Menu or by running 'wsl' in PowerShell."
    Write-Host "2. In the WSL terminal, run: bash ~/wsl-init.sh"
    Write-Host "3. Return to PowerShell and run: .\scripts\wsl-provision.ps1"
    exit 0
}

# 6. Install WSL
Write-Host "`n===================================================================="
Write-Host "No WSL distros installed. Installing the default WSL distro..."
& wsl.exe --install --no-launch
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to install WSL distro. Exit code: $LASTEXITCODE"
    exit $LASTEXITCODE
}
Write-Host "WSL distro installed."
Write-Host "===================================================================="
Write-Host ""
Write-Host @"
====================================================================
WSL installation complete.

Next steps:
1. Launch your Linux distribution (e.g., Ubuntu) from the Start Menu or by running 'wsl' in PowerShell.
2. Complete the initial Linux user setup (username and password).
3. In the WSL terminal, run: bash ~/wsl-init.sh
4. Return to PowerShell and run: .\scripts\wsl-provision.ps1

You can safely close this window.
====================================================================
"@