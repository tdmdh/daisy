
# Build script for Second Screen System
# Builds both Rust and Go services

param(
    [switch]$Release,  # Build in release mode
    [switch]$Clean     # Clean before building
)

$ErrorActionPreference = "Stop"

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Second Screen System - Build Script" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$rootDir = Split-Path -Parent $PSScriptRoot
$rustDir = Join-Path $rootDir "rust-capture"
$goDir = Join-Path $rootDir "go-server"
$binDir = Join-Path $rootDir "bin"

# Create bin directory if it doesn't exist
if (-not (Test-Path $binDir)) {
    New-Item -ItemType Directory -Path $binDir | Out-Null
}

# Clean if requested
if ($Clean) {
    Write-Host "🧹 Cleaning previous builds..." -ForegroundColor Yellow
    
    if (Test-Path (Join-Path $rustDir "target")) {
        Remove-Item -Path (Join-Path $rustDir "target") -Recurse -Force
        Write-Host "  Cleaned Rust target/" -ForegroundColor Gray
    }
    
    if (Test-Path $binDir) {
        Remove-Item -Path $binDir -Recurse -Force
        New-Item -ItemType Directory -Path $binDir | Out-Null
        Write-Host "  Cleaned bin/" -ForegroundColor Gray
    }
    
    Write-Host ""
}

# Build Rust service
Write-Host "[1/2] Building Rust capture service..." -ForegroundColor Green
Push-Location $rustDir

try {
    if ($Release) {
        Write-Host "  Building in RELEASE mode..." -ForegroundColor Yellow
        cargo build --release
        $rustExe = Join-Path "target" "release" "capture-service.exe"
    } else {
        Write-Host "  Building in DEBUG mode..." -ForegroundColor Yellow
        cargo build
        $rustExe = Join-Path "target" "debug" "capture-service.exe"
    }
    
    # Copy executable to bin directory
    $rustOutput = Join-Path $binDir "capture-service.exe"
    Copy-Item -Path $rustExe -Destination $rustOutput -Force
    
    Write-Host "  ✓ Rust service built successfully" -ForegroundColor Green
    Write-Host "    Output: $rustOutput" -ForegroundColor Gray
} catch {
    Write-Host "  ✗ Failed to build Rust service" -ForegroundColor Red
    Write-Host "    Error: $_" -ForegroundColor Red
    Pop-Location
    exit 1
}

Pop-Location
Write-Host ""

# Build Go service
Write-Host "[2/2] Building Go server..." -ForegroundColor Green
Push-Location $goDir

try {
    # Download dependencies
    Write-Host "  Downloading Go dependencies..." -ForegroundColor Yellow
    go mod download
    go mod tidy
    
    # Build
    Write-Host "  Building Go service..." -ForegroundColor Yellow
    $goOutput = Join-Path $binDir "server.exe"
    
    if ($Release) {
        # Release build with optimizations
        go build -ldflags="-s -w" -o $goOutput ./cmd/server
    } else {
        # Debug build
        go build -o $goOutput ./cmd/server
    }
    
    Write-Host "  ✓ Go service built successfully" -ForegroundColor Green
    Write-Host "    Output: $goOutput" -ForegroundColor Gray
} catch {
    Write-Host "  ✗ Failed to build Go service" -ForegroundColor Red
    Write-Host "    Error: $_" -ForegroundColor Red
    Pop-Location
    exit 1
}

Pop-Location
Write-Host ""

# Summary
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Build Complete!" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Built binaries:" -ForegroundColor Green
Write-Host "  • $(Join-Path $binDir 'capture-service.exe')" -ForegroundColor White
Write-Host "  • $(Join-Path $binDir 'server.exe')" -ForegroundColor White
Write-Host ""
Write-Host "To run the services:" -ForegroundColor Cyan
Write-Host "  .\scripts\run_dev.ps1" -ForegroundColor White
Write-Host ""

# Check file sizes
$rustSize = (Get-Item (Join-Path $binDir "capture-service.exe")).Length
$goSize = (Get-Item (Join-Path $binDir "server.exe")).Length

Write-Host "Binary sizes:" -ForegroundColor Gray
Write-Host "  Rust service: $([math]::Round($rustSize / 1MB, 2)) MB" -ForegroundColor Gray
Write-Host "  Go service:   $([math]::Round($goSize / 1MB, 2)) MB" -ForegroundColor Gray
Write-Host ""