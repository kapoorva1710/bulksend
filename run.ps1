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

# ── MySQL Setup ───────────────────────────────────────────────────

Write-Host ""
Write-Host "-----------------------------------------------" -ForegroundColor DarkCyan
Write-Host "   MySQL Database Setup" -ForegroundColor DarkCyan
Write-Host "-----------------------------------------------" -ForegroundColor DarkCyan
Write-Host ""

# Ask for MySQL credentials
$dbUsername = Read-Host "  Enter MySQL username (default: root)"
if ([string]::IsNullOrWhiteSpace($dbUsername)) { $dbUsername = "root" }

$dbPasswordSecure = Read-Host "  Enter MySQL password" -AsSecureString
$dbPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($dbPasswordSecure)
)

$dbName = Read-Host "  Enter database name (default: bulksend)"
if ([string]::IsNullOrWhiteSpace($dbName)) { $dbName = "bulksend" }

$dbUrl = "jdbc:mysql://localhost:3306/$dbName"

Write-Host ""
Write-Host "[INFO] Creating database '$dbName' if it does not exist..." -ForegroundColor Yellow

# Try to create the DB automatically
try {
    $mysqlCmd = "mysql -u$dbUsername -p$dbPassword -e `"CREATE DATABASE IF NOT EXISTS $dbName;`" 2>&1"
    Invoke-Expression $mysqlCmd | Out-Null
    Write-Host "[OK] Database '$dbName' is ready." -ForegroundColor Green
} catch {
    Write-Host "[WARN] Could not auto-create DB. Please ensure '$dbName' exists in MySQL." -ForegroundColor Yellow
}

# ── Clone or Update Repo ─────────────────────────────────────────

$repoUrl = "https://github.com/kapoorva1710/bulksend.git"
$appDir  = "$env:USERPROFILE\bulksend"

Write-Host ""
if (Test-Path "$appDir\.git") {
    Write-Host "[INFO] BulkSend already cloned. Pulling latest changes..." -ForegroundColor Yellow
    Set-Location $appDir
    git pull origin master
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

# ── Launch ───────────────────────────────────────────────────────

Write-Host ""
Write-Host "===============================================" -ForegroundColor Green
Write-Host "   Launching BulkSend on http://localhost:8081" -ForegroundColor Green
Write-Host "   Press Ctrl+C to stop the server." -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green
Write-Host ""

# Open browser after 5 seconds
Start-Job -ScriptBlock {
    Start-Sleep -Seconds 6
    Start-Process "http://localhost:8081/dashboard.html"
} | Out-Null

# Start the app with DB credentials passed as JVM args
mvn spring-boot:run `
    "-Dspring-boot.run.jvmArguments=-Dspring.datasource.url=$dbUrl -Dspring.datasource.username=$dbUsername -Dspring.datasource.password=$dbPassword"
