<#
.SYNOPSIS
Automates installation and configuration of Windows Subsystem for Linux (WSL) and required Windows features.

.DESCRIPTION
Checks for WSL and necessary Windows features. If missing, prompts user. Installs WSL if no distros exist. Guides user through next steps.

.USAGE
Run from elevated PowerShell:
    powershell -ExecutionPolicy Bypass -File .\scripts\wsl-install.ps1

.NOTES
- Requires admin privileges, Windows 10 2004+ or Windows 11, and internet connection.
- After running, complete Ubuntu setup, then run `wsl-init.sh` in WSL and `wsl-provision.ps1` in PowerShell.
#>

function Assert-Admin {
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Error "Script must be run as Administrator."
        exit 1
    }
}

Assert-Admin
Write-Host "Confirmed: Running as Administrator on Windows."

# Check Required Windows Features
$features = @{
    "Microsoft-Windows-Subsystem-Linux" = "WSL"
    "VirtualMachinePlatform"            = "WSL 2"
}
foreach ($feature in $features.Keys) {
    $state = (Get-WindowsOptionalFeature -Online -FeatureName $feature).State
    if ($state -ne "Enabled") {
        Write-Error "$($features[$feature]) is not enabled. Enable it and reboot, then rerun this script."
        exit 1
    }
    Write-Host "Confirmed: $($features[$feature]) feature is enabled."
}

# Check for wsl.exe
if (-not (Get-Command wsl.exe -ErrorAction SilentlyContinue)) {
    Write-Error "wsl.exe not found in PATH."
    exit 1
}
Write-Host "Confirmed: wsl.exe is available in PATH."

# Check for Existing WSL Distributions
$wslDistros = & wsl.exe --list --quiet
if ($wslDistros) {
    Write-Host "`nA WSL distro is already installed. No further action needed."
    Write-Host @"
Next steps:
1. Launch your Linux distribution (e.g., Ubuntu) from the Start Menu or by running 'wsl' in PowerShell.
2. In the WSL terminal, run: bash ~/wsl-init.sh
3. Return to PowerShell and run: .\scripts\wsl-provision.ps1
"@
    exit 0
}

# Install WSL
Write-Host "`nNo WSL distros installed. Installing the default WSL distro..."
& wsl.exe --install --no-launch
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to install WSL distro. Exit code: $LASTEXITCODE"
    exit $LASTEXITCODE
}
Write-Host "WSL distro installed."

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