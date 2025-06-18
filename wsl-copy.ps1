# 1. Determine User and Paths
$wslUser = [System.Environment]::UserName
$windowsSsh   = Join-Path $PSScriptRoot ".ssh"
$templatesDir = Join-Path $PSScriptRoot "wsl-bash-scripts"
$wslHome     = "/home/$wslUser"
$wslSsh      = "$wslHome/.ssh"

Write-Host ""
Write-Host "====================================================================="
Write-Host "Copying configuration files to your new WSL environment..."
Write-Host "====================================================================="

# 2. Copy .ssh Files
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

# 3. Copy wsl-bash-scripts Files
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
Write-Host "File copy operation completed. Your WSL environment is ready!"
Write-Host "You can now launch Ubuntu from the Start Menu or with 'wsl' in PowerShell."
Write-Host "====================================================================="