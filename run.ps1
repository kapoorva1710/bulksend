# BulkSend One-Click Launcher
# Download and run with:
#   irm https://raw.githubusercontent.com/kapoorva1710/bulksend/master/run.ps1 -OutFile "$env:TEMP\bulksend.ps1"; powershell -File "$env:TEMP\bulksend.ps1"

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
    Read-Host "Press Enter to exit"
    exit 1
}

if (-not (Check-Command "mvn")) {
    Write-Host "[ERROR] Maven is not installed. Download from https://maven.apache.org/download.cgi" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

if (-not (Check-Command "java")) {
    Write-Host "[ERROR] Java 17+ is not installed. Download from https://adoptium.net" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "[OK] All prerequisites found." -ForegroundColor Green

# ── MySQL Credentials ────────────────────────────────────────────

Write-Host ""
Write-Host "-----------------------------------------------" -ForegroundColor DarkCyan
Write-Host "   MySQL Database Configuration" -ForegroundColor DarkCyan
Write-Host "-----------------------------------------------" -ForegroundColor DarkCyan
Write-Host ""

$dbUser = Read-Host "  MySQL username (press Enter for default: root)"
if ([string]::IsNullOrWhiteSpace($dbUser)) { $dbUser = "root" }

$dbPass = Read-Host "  MySQL password"

$dbName = Read-Host "  Database name (press Enter for default: bulksend)"
if ([string]::IsNullOrWhiteSpace($dbName)) { $dbName = "bulksend" }

# Set as environment variables so Spring Boot picks them up via application.properties
$env:DB_USERNAME = $dbUser
$env:DB_PASSWORD = $dbPass
$env:DB_URL      = "jdbc:mysql://localhost:3306/$dbName"

Write-Host ""
Write-Host "[OK] Credentials set. Username: $dbUser | DB: $dbName" -ForegroundColor Green

# ── Try to create database ───────────────────────────────────────

Write-Host ""
Write-Host "[INFO] Creating database '$dbName' if it doesn't exist..." -ForegroundColor Yellow

if (Check-Command "mysql") {
    try {
        echo "CREATE DATABASE IF NOT EXISTS $dbName;" | mysql -u$dbUser -p$dbPass 2>$null
        Write-Host "[OK] Database '$dbName' is ready." -ForegroundColor Green
    } catch {
        Write-Host "[WARN] Could not auto-create DB. Make sure '$dbName' exists in MySQL." -ForegroundColor Yellow
    }
} else {
    Write-Host "[WARN] mysql CLI not in PATH. Skipping auto-create. Make sure '$dbName' database exists." -ForegroundColor Yellow
}

# ── Clone or Update Repo ─────────────────────────────────────────

$repoUrl = "https://github.com/kapoorva1710/bulksend.git"
$appDir  = "$env:USERPROFILE\bulksend"

Write-Host ""
if (Test-Path "$appDir\.git") {
    Write-Host "[INFO] BulkSend already cloned. Pulling latest changes..." -ForegroundColor Yellow
    Set-Location $appDir
    git pull origin master 2>&1 | Write-Host
} else {
    Write-Host "[INFO] Cloning BulkSend from GitHub..." -ForegroundColor Yellow
    git clone $repoUrl $appDir
    Set-Location $appDir
}

# ── Build ────────────────────────────────────────────────────────

Write-Host ""
Write-Host "[INFO] Building the application (first run may take a few minutes)..." -ForegroundColor Yellow
Set-Location "$appDir\bulksender"
mvn clean package -DskipTests -q

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Build failed! Check the output above." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "[OK] Build successful!" -ForegroundColor Green

# ── Launch ───────────────────────────────────────────────────────

Write-Host ""
Write-Host "===============================================" -ForegroundColor Green
Write-Host "   Launching BulkSend on http://localhost:8081" -ForegroundColor Green
Write-Host "   Dashboard: http://localhost:8081/dashboard.html" -ForegroundColor Green
Write-Host "   Press Ctrl+C to stop the server." -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green
Write-Host ""

# Open browser after 6 seconds
Start-Job -ScriptBlock {
    Start-Sleep -Seconds 6
    Start-Process "http://localhost:8081/dashboard.html"
} | Out-Null

# Run app — Spring Boot reads $env:DB_URL, $env:DB_USERNAME, $env:DB_PASSWORD automatically
mvn spring-boot:run
