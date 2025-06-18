<#
.SYNOPSIS
Automates the installation and initial setup of Windows Subsystem for Linux (WSL) and copies configuration files if WSL is newly installed.

.DESCRIPTION
This script checks for required Windows features, installs WSL if no distribution is present, and prompts the user to complete the initial WSL setup. 
If WSL is newly installed, it automatically runs a secondary script to copy .ssh keys and shell scripts into the WSL user's home directory.

.PARAMETER ExecutionPolicy
Specifies the execution policy to use when running the script. In this case, 'Bypass' is recommended to allow the script to run without restrictions.

.PARAMETER File
Indicates the path to the PowerShell script file to execute. Here, 'wsl-install.ps1' is the script being run.

.NOTES
Usage:
    powershell -ExecutionPolicy Bypass -File .\scripts\wsl-install.ps1

This command is useful for initializing or configuring a WSL environment where the default execution policy may prevent script execution.
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
    Write-Warning "A WSL distro is already installed. Exiting setup. No files will be copied."
    exit 0
}

# 6. Install WSL
Write-Host "No WSL distros installed. Installing the default WSL distro..."
& wsl.exe --install --no-launch
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to install WSL distro. Exit code: $LASTEXITCODE"
    exit $LASTEXITCODE
}
Write-Host ""
Write-Host "====================================================================="
Write-Host "WSL distro installed. The Ubuntu setup will now start in this window."
Write-Host "Please complete the initial Linux user setup (username and password)."
Write-Host "When you see the Ubuntu prompt, type 'exit' and press Enter to return."
Write-Host "====================================================================="
Write-Host ""
& wsl.exe

Write-Host ""
Write-Host "====================================================================="
Write-Host "WSL initial user setup appears complete."
Write-Host "Press SPACE then Enter to continue and copy configuration files."
Write-Host "====================================================================="
Read-Host

# 7. Run the Copy Script
$copyScript = Join-Path $PSScriptRoot "wsl-copy.ps1"
Write-Host ""
Write-Host "====================================================================="
Write-Host "Running file copy script: $copyScript"
Write-Host "====================================================================="
& powershell -ExecutionPolicy Bypass -File $copyScript