# Second Screen System - Dependency Installation Script for Windows
# Run this with: powershell -ExecutionPolicy Bypass -File install_deps.ps1

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Second Screen System - Dependency Installer" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "WARNING: Not running as Administrator. Some installations may fail." -ForegroundColor Yellow
    Write-Host "Consider running: powershell -ExecutionPolicy Bypass -File install_deps.ps1" -ForegroundColor Yellow
    Write-Host ""
}

# Function to check if command exists
function Test-CommandExists {
    param($command)
    $null = Get-Command $command -ErrorAction SilentlyContinue
    return $?
}

# 1. Install Chocolatey (Windows Package Manager)
Write-Host "[1/8] Checking Chocolatey..." -ForegroundColor Green
if (-not (Test-CommandExists choco)) {
    Write-Host "Installing Chocolatey..." -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Host "✓ Chocolatey already installed" -ForegroundColor Green
}

# 2. Install Rust
Write-Host "`n[2/8] Checking Rust..." -ForegroundColor Green
if (-not (Test-CommandExists rustc)) {
    Write-Host "Installing Rust..." -ForegroundColor Yellow
    Write-Host "Please follow the rustup installer prompts..." -ForegroundColor Yellow
    
    # Download and run rustup-init.exe
    $rustupUrl = "https://win.rustup.rs/x86_64"
    $rustupInstaller = "$env:TEMP\rustup-init.exe"
    Invoke-WebRequest -Uri $rustupUrl -OutFile $rustupInstaller
    Start-Process -FilePath $rustupInstaller -ArgumentList "-y" -Wait
    
    # Add Rust to PATH for this session
    $env:Path += ";$env:USERPROFILE\.cargo\bin"
    
    Write-Host "✓ Rust installed" -ForegroundColor Green
} else {
    Write-Host "✓ Rust already installed ($(rustc --version))" -ForegroundColor Green
}

# 3. Install Go
Write-Host "`n[3/8] Checking Go..." -ForegroundColor Green
if (-not (Test-CommandExists go)) {
    Write-Host "Installing Go..." -ForegroundColor Yellow
    choco install golang -y
    refreshenv
    Write-Host "✓ Go installed" -ForegroundColor Green
} else {
    Write-Host "✓ Go already installed ($(go version))" -ForegroundColor Green
}

# 4. Install Git
Write-Host "`n[4/8] Checking Git..." -ForegroundColor Green
if (-not (Test-CommandExists git)) {
    Write-Host "Installing Git..." -ForegroundColor Yellow
    choco install git -y
    refreshenv
    Write-Host "✓ Git installed" -ForegroundColor Green
} else {
    Write-Host "✓ Git already installed ($(git --version))" -ForegroundColor Green
}

# 5. Install FFmpeg (with development libraries)
Write-Host "`n[5/8] Checking FFmpeg..." -ForegroundColor Green
if (-not (Test-CommandExists ffmpeg)) {
    Write-Host "Installing FFmpeg..." -ForegroundColor Yellow
    choco install ffmpeg -y
    refreshenv
    Write-Host "✓ FFmpeg installed" -ForegroundColor Green
} else {
    Write-Host "✓ FFmpeg already installed" -ForegroundColor Green
}

# Download FFmpeg development libraries
Write-Host "Downloading FFmpeg development libraries..." -ForegroundColor Yellow
$ffmpegDevUrl = "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl-shared.zip"
$ffmpegDevZip = "$env:TEMP\ffmpeg-dev.zip"
$ffmpegDevPath = "C:\ffmpeg-dev"

if (-not (Test-Path $ffmpegDevPath)) {
    Invoke-WebRequest -Uri $ffmpegDevUrl -OutFile $ffmpegDevZip
    Expand-Archive -Path $ffmpegDevZip -DestinationPath "C:\" -Force
    Rename-Item -Path "C:\ffmpeg-master-latest-win64-gpl-shared" -NewName "ffmpeg-dev" -Force
    
    # Add to system environment variables
    [Environment]::SetEnvironmentVariable("FFMPEG_DIR", "C:\ffmpeg-dev", "User")
    $env:FFMPEG_DIR = "C:\ffmpeg-dev"
    
    Write-Host "✓ FFmpeg development libraries installed at C:\ffmpeg-dev" -ForegroundColor Green
} else {
    Write-Host "✓ FFmpeg development libraries already at C:\ffmpeg-dev" -ForegroundColor Green
}

# 6. Install Protocol Buffers Compiler
Write-Host "`n[6/8] Checking protoc (Protocol Buffers)..." -ForegroundColor Green
if (-not (Test-CommandExists protoc)) {
    Write-Host "Installing protoc..." -ForegroundColor Yellow
    choco install protoc -y
    refreshenv
    Write-Host "✓ protoc installed" -ForegroundColor Green
} else {
    Write-Host "✓ protoc already installed ($(protoc --version))" -ForegroundColor Green
}

# 7. Install Visual Studio Build Tools (required for Rust on Windows)
Write-Host "`n[7/8] Checking Visual Studio Build Tools..." -ForegroundColor Green
$vsPath = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools"
if (-not (Test-Path $vsPath)) {
    Write-Host "Installing Visual Studio Build Tools..." -ForegroundColor Yellow
    Write-Host "This may take a while (2-5 GB download)..." -ForegroundColor Yellow
    
    choco install visualstudio2022buildtools -y
    choco install visualstudio2022-workload-vctools -y
    
    Write-Host "✓ Visual Studio Build Tools installed" -ForegroundColor Green
} else {
    Write-Host "✓ Visual Studio Build Tools already installed" -ForegroundColor Green
}

# 8. Install libimobiledevice (for iOS USB support)
Write-Host "`n[8/8] Checking libimobiledevice..." -ForegroundColor Green
$libimobiledevicePath = "C:\Program Files\libimobiledevice"
if (-not (Test-Path $libimobiledevicePath)) {
    Write-Host "Installing libimobiledevice..." -ForegroundColor Yellow
    Write-Host "Downloading from GitHub..." -ForegroundColor Yellow
    
    # Download libimobiledevice Windows binaries
    $libimobileUrl = "https://github.com/libimobiledevice-win32/imobiledevice-net/releases/download/v1.3.17/libimobiledevice.1.2.1-r1116-win-x64.zip"
    $libimobileZip = "$env:TEMP\libimobiledevice.zip"
    
    Invoke-WebRequest -Uri $libimobileUrl -OutFile $libimobileZip
    Expand-Archive -Path $libimobileZip -DestinationPath "C:\Program Files\libimobiledevice" -Force
    
    # Add to PATH
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*libimobiledevice*") {
        [Environment]::SetEnvironmentVariable("Path", "$currentPath;C:\Program Files\libimobiledevice", "User")
    }
    
    Write-Host "✓ libimobiledevice installed" -ForegroundColor Green
} else {
    Write-Host "✓ libimobiledevice already installed" -ForegroundColor Green
}

# Summary
Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "Installation Complete!" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Installed components:" -ForegroundColor Green
Write-Host "  ✓ Rust (rustc, cargo)" -ForegroundColor White
Write-Host "  ✓ Go" -ForegroundColor White
Write-Host "  ✓ Git" -ForegroundColor White
Write-Host "  ✓ FFmpeg + development libraries" -ForegroundColor White
Write-Host "  ✓ Protocol Buffers (protoc)" -ForegroundColor White
Write-Host "  ✓ Visual Studio Build Tools" -ForegroundColor White
Write-Host "  ✓ libimobiledevice" -ForegroundColor White
Write-Host ""
Write-Host "IMPORTANT: Please restart your terminal/PowerShell for PATH changes to take effect!" -ForegroundColor Yellow
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Restart your terminal" -ForegroundColor White
Write-Host "  2. Run: git clone <your-repo-url>" -ForegroundColor White
Write-Host "  3. Run: cd second-screen" -ForegroundColor White
Write-Host "  4. Run: .\scripts\build_all.ps1" -ForegroundColor White
Write-Host ""
Write-Host "Verify installations:" -ForegroundColor Cyan
Write-Host "  rustc --version" -ForegroundColor White
Write-Host "  cargo --version" -ForegroundColor White
Write-Host "  go version" -ForegroundColor White
Write-Host "  git --version" -ForegroundColor White
Write-Host "  ffmpeg -version" -ForegroundColor White
Write-Host "  protoc --version" -ForegroundColor White
Write-Host ""

# Pause to let user read the output
Read-Host "Press Enter to exit"