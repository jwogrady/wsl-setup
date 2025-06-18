<#
.SYNOPSIS
    Copies configuration files into the WSL user's home directory after initial setup.

.DESCRIPTION
    This script is intended to be run after the initial setup of a WSL (Windows Subsystem for Linux) environment.
    It automates the process of copying predefined configuration files into the home directory of the WSL user,
    ensuring a consistent and ready-to-use environment.

.PARAMETER None
    This script does not accept any parameters.

.EXAMPLE
    .\wsl-provision.ps1

    Runs the script and copies the configuration files to the WSL user's home directory.

.NOTES
    Author: jwogrady
    Date: 2025-06-18
    File: wsl-provision.ps1

.PREREQUISITES
    - Must be run inside a WSL environment or with access to the WSL filesystem.
    - Requires the configuration files to be present in the expected source directory.
#>
# Copies configuration files into the WSL user's home directory after initial setup.

param (
    [string]$WslUser = "your-wsl-username" # <-- Set your WSL username here or pass as parameter
)

function Test-WslHome {
    $wslHome = "/home/$WslUser"
    & wsl.exe test -d "$wslHome"
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "WSL user home directory ($wslHome) does not exist. Please complete WSL user setup first."
        exit 1
    }
    return $wslHome
}

function Copy-SshFiles {
    param($windowsSsh, $wslSsh)
    if (-not (Test-Path $windowsSsh)) {
        Write-Warning "No .ssh directory found at $windowsSsh. Skipping SSH key copy."
        return
    }
    $purge = Read-Host "Do you want to delete the SSH keys from the Windows .ssh directory? (y/n)"
    if ($purge -match '^[yY]$') {
        Remove-Item -Path (Join-Path $windowsSsh '*') -Force
        Write-Host "SSH keys deleted from Windows .ssh directory."
    } else {
        Write-Host "SSH keys left in Windows .ssh directory. Remember to remove them for security."
    }
    Write-Host "Copying .ssh files from $windowsSsh to WSL: $wslSsh"
    & wsl.exe mkdir -p "$wslSsh"
    Get-ChildItem -Path $windowsSsh -File | ForEach-Object {
        $srcWsl = "/mnt/c" + ($_.FullName.Substring(2) -replace '\\','/')
        & wsl.exe cp "$srcWsl" "$wslSsh/"
    }
    & wsl.exe sudo chown -R ${WslUser}: "$wslSsh"
    Write-Host ".ssh files copied to WSL home directory."
}

function Copy-ShellScripts {
    param($templatesDir, $wslHome)
    if (-not (Test-Path $templatesDir)) {
        Write-Warning "Templates directory not found: $templatesDir. Skipping shell script copy."
        return
    }
    $shFiles = Get-ChildItem -Path $templatesDir -Filter *.sh -File
    if (-not $shFiles) {
        Write-Warning "No .sh files found in $templatesDir."
        return
    }
    foreach ($file in $shFiles) {
        $srcWsl = "/mnt/c" + ($file.FullName.Substring(2) -replace '\\','/')
        & wsl.exe cp "$srcWsl" "$wslHome/"
    }
    & wsl.exe sudo chown -R ${WslUser}: "$wslHome"
    Write-Host "Shell script files copied to WSL home directory."
}

Write-Host "`n================ Provisioning your WSL environment ================"

$windowsSsh = "$env:USERPROFILE\.ssh"
$templatesDir = "$PSScriptRoot\..\templates"
$wslHome = Test-WslHome
$wslSsh = "$wslHome/.ssh"

Copy-SshFiles -windowsSsh $windowsSsh -wslSsh $wslSsh
Copy-ShellScripts -templatesDir $templatesDir -wslHome $wslHome

Write-Host "`n================ Provisioning complete. Your WSL environment is ready! ================"
Write-Host "You can now launch Ubuntu from the Start Menu or with 'wsl' in PowerShell."
