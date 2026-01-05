#!/usr/bin/env pwsh
# Quick test script untuk troubleshooting koneksi backend

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "  Backend Connection Test" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# 1. Check if backend is running
Write-Host "1. Checking if backend is running..." -ForegroundColor Yellow
$nodeProcesses = Get-Process -Name node -ErrorAction SilentlyContinue
if ($nodeProcesses) {
    Write-Host "   ✓ Node.js processes found:" -ForegroundColor Green
    foreach ($proc in $nodeProcesses) {
        $connections = Get-NetTCPConnection -OwningProcess $proc.Id -ErrorAction SilentlyContinue | Where-Object LocalPort -eq 3000
        if ($connections) {
            Write-Host "     - PID $($proc.Id) listening on port 3000" -ForegroundColor Green
        } else {
            Write-Host "     - PID $($proc.Id) (not on port 3000)" -ForegroundColor Gray
        }
    }
} else {
    Write-Host "   ✗ No Node.js process found!" -ForegroundColor Red
    Write-Host "   Run: cd backend; npm start" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# 2. Get local IP address
Write-Host "2. Getting local IP address..." -ForegroundColor Yellow
$ipInfo = ipconfig | Select-String "IPv4" | Select-Object -First 1
if ($ipInfo) {
    $ip = ($ipInfo -split ':')[1].Trim()
    Write-Host "   ✓ Your IP: $ip" -ForegroundColor Green
} else {
    Write-Host "   ✗ Could not detect IP" -ForegroundColor Red
    $ip = "192.168.1.10"
}

Write-Host ""

# 3. Test health endpoint (localhost)
Write-Host "3. Testing health endpoint (localhost)..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:3000/api/health" -Method GET -TimeoutSec 5
    if ($response.success) {
        Write-Host "   ✓ Health check OK: $($response.message)" -ForegroundColor Green
    }
} catch {
    Write-Host "   ✗ Health check failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# 4. Test login endpoint (localhost)
Write-Host "4. Testing login endpoint (localhost)..." -ForegroundColor Yellow
try {
    $body = @{
        nim = '202210370311'
        password = 'password123'
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "http://localhost:3000/api/auth/login" -Method POST -ContentType "application/json" -Body $body -TimeoutSec 10
    
    if ($response.success) {
        Write-Host "   ✓ Login successful!" -ForegroundColor Green
        Write-Host "     User: $($response.data.user.name)" -ForegroundColor Gray
    }
} catch {
    Write-Host "   ✗ Login failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# 5. Test from IP address (for real device)
Write-Host "5. Testing from IP address ($ip)..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://${ip}:3000/api/health" -Method GET -TimeoutSec 5
    if ($response.success) {
        Write-Host "   ✓ Can access via IP: http://${ip}:3000/api" -ForegroundColor Green
    }
} catch {
    Write-Host "   ✗ Cannot access via IP" -ForegroundColor Red
    Write-Host "   Check Windows Firewall settings!" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "  Configuration Summary" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "For Android Emulator, use in api_config.dart:" -ForegroundColor Yellow
Write-Host "  static const String baseUrl = 'http://10.0.2.2:3000/api';" -ForegroundColor White
Write-Host ""
Write-Host "For Real Device, use in api_config.dart:" -ForegroundColor Yellow
Write-Host "  static const String baseUrl = 'http://${ip}:3000/api';" -ForegroundColor White
Write-Host ""
Write-Host "Test credentials:" -ForegroundColor Yellow
Write-Host "  NIM: 202210370311" -ForegroundColor White
Write-Host "  Password: password123" -ForegroundColor White
Write-Host ""
