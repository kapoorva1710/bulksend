# BulkSend One-Click Launcher
# Run this on any Windows PC with: irm https://raw.githubusercontent.com/kapoorva1710/bulksend/master/run.ps1 | iex

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "   BulkSend - Bulk SMS Broadcasting App" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# ── Check Prerequisites ──────────────────────────────────────────

function Check-Command($cmd) {
    return [bool](Get-Command $cmd -ErrorAction SilentlyContinue)
}

if (-not (Check-Command "git")) {
    Write-Host "[ERROR] Git is not installed. Download from https://git-scm.com" -ForegroundColor Red
    exit 1
}

if (-not (Check-Command "mvn")) {
    Write-Host "[ERROR] Maven is not installed. Download from https://maven.apache.org/download.cgi" -ForegroundColor Red
    exit 1
}

if (-not (Check-Command "java")) {
    Write-Host "[ERROR] Java 17+ is not installed. Download from https://adoptium.net" -ForegroundColor Red
    exit 1
}

Write-Host "[OK] All prerequisites found." -ForegroundColor Green

# ── Clone or Update Repo ─────────────────────────────────────────

$repoUrl = "https://github.com/kapoorva1710/bulksend.git"
$appDir  = "$env:USERPROFILE\bulksend"

if (Test-Path "$appDir\.git") {
    Write-Host ""
    Write-Host "[INFO] BulkSend already cloned. Pulling latest changes..." -ForegroundColor Yellow
    Set-Location $appDir
    git pull origin master
} else {
    Write-Host ""
    Write-Host "[INFO] Cloning BulkSend from GitHub..." -ForegroundColor Yellow
    git clone $repoUrl $appDir
    Set-Location $appDir
}

# ── Build & Run ──────────────────────────────────────────────────

Write-Host ""
Write-Host "[INFO] Building the application (first run may take a few minutes)..." -ForegroundColor Yellow
Set-Location "$appDir\bulksender"
mvn clean package -DskipTests -q

Write-Host ""
Write-Host "===============================================" -ForegroundColor Green
Write-Host "   Launching BulkSend on http://localhost:8081" -ForegroundColor Green
Write-Host "   Press Ctrl+C to stop the server." -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green
Write-Host ""

# Open browser after 3 seconds
Start-Job -ScriptBlock {
    Start-Sleep -Seconds 5
    Start-Process "http://localhost:8081/dashboard.html"
} | Out-Null

# Start the app
mvn spring-boot:run
