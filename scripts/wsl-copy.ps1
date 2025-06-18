# 1. Determine User and Paths
$wslUser = [System.Environment]::UserName
$windowsSsh   = Join-Path $PSScriptRoot ".ssh"
$templatesDir = Join-Path $PSScriptRoot ".scripts"
$wslHome     = "/home/$wslUser"
$wslSsh      = "$wslHome/.ssh"

Write-Host "`n====================================================================="
Write-Host "Provisioning your WSL environment with configuration files..."
Write-Host "====================================================================="

# 2. Verify WSL user home exists
$homeExists = & wsl.exe test -d "$wslHome"; if ($LASTEXITCODE -ne 0) {
    Write-Warning "WSL user home directory ($wslHome) does not exist. Please complete WSL user setup first."
    exit 1
}

# 3. Copy .ssh Files
if (Test-Path $windowsSsh) {
    Write-Host "Copying .ssh files from $windowsSsh to WSL: $wslSsh"
    & wsl.exe mkdir -p "$wslSsh"
    Get-ChildItem -Path $windowsSsh -File | ForEach-Object {
        $src = $_.FullName
        $srcWsl = "/mnt/c" + ($src.Substring(2) -replace '\\','/')
        Write-Host "Copying $srcWsl to $wslSsh/"
        & wsl.exe cp "$srcWsl" "$wslSsh/"
    }
    Write-Host ".ssh files copied to WSL home directory."
    & wsl.exe sudo chown -R ${wslUser}: "$wslSsh"
} else {
    Write-Warning "No .ssh directory found at $windowsSsh. Skipping SSH key copy."
}

# 4. Copy .scripts Files
if (Test-Path $templatesDir) {
    $shFiles = Get-ChildItem -Path $templatesDir -Filter *.sh -File
    if ($shFiles) {
        foreach ($file in $shFiles) {
            $src = $file.FullName
            $srcWsl = "/mnt/c" + ($src.Substring(2) -replace '\\','/')
            Write-Host "Copying $srcWsl to $wslHome/"
            & wsl.exe cp "$srcWsl" "$wslHome/"
        }
        Write-Host "Shell script files copied to WSL home directory."
        & wsl.exe sudo chown -R ${wslUser}: "$wslHome"
    } else {
        Write-Warning "=== WARNING: No .sh files found in $templatesDir. ==="
    }
} else {
    Write-Warning "Templates directory not found: $templatesDir. Skipping shell script copy."
}

Write-Host ""
Write-Host "====================================================================="
Write-Host "Provisioning complete. Your WSL environment is ready!"
Write-Host "You can now launch Ubuntu from the Start Menu or with 'wsl' in PowerShell."
Write-Host "====================================================================="