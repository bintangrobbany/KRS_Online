# Troubleshooting Login Timeout

## Masalah: Request Timeout Error

Jika mendapat error "Request timeout", ikuti langkah berikut:

### 1. Pastikan Backend Running
```bash
cd backend
npm start
```

Backend harus menampilkan:
```
╔════════════════════════════════════════╗
║   KRS Online Backend Server Running    ║
║   Port: 3000                           ║
╚════════════════════════════════════════╝
```

### 2. Konfigurasi URL Sesuai Device

Edit `lib/config/api_config.dart`:

**Untuk Android Emulator:**
```dart
static const String baseUrl = 'http://10.0.2.2:3000/api';
```

**Untuk iOS Simulator:**
```dart
static const String baseUrl = 'http://localhost:3000/api';
```

**Untuk Real Device (Android/iOS):**
```dart
static const String baseUrl = 'http://192.168.1.10:3000/api';
```
⚠️ Ganti `192.168.1.10` dengan IP komputer Anda

### 3. Cara Cek IP Komputer

**Windows:**
```powershell
ipconfig | Select-String "IPv4"
```

**Mac/Linux:**
```bash
ifconfig | grep "inet "
```

### 4. Test Backend dari Browser

Buka browser dan akses:
- `http://localhost:3000/api/auth/login` (dari komputer)
- `http://192.168.1.10:3000/api/auth/login` (dari device, ganti IP sesuai)

### 5. Test Koneksi dari Terminal

**PowerShell:**
```powershell
$body = @{nim='202210370311';password='password123'} | ConvertTo-Json
Invoke-RestMethod -Uri "http://localhost:3000/api/auth/login" -Method POST -ContentType "application/json" -Body $body
```

Harus mengembalikan:
```
success : True
message : Login berhasil
data    : @{user=; token=...}
```

### 6. Pastikan Firewall Tidak Memblokir

**Windows:**
1. Windows Security → Firewall & network protection
2. Allow an app through firewall
3. Pastikan Node.js diizinkan

**Mac:**
1. System Preferences → Security & Privacy → Firewall
2. Firewall Options
3. Allow Node.js

### 7. Kredensial Test

Gunakan kredensial yang sudah di-seed:
- **NIM:** 202210370311
- **Password:** password123

### 8. Cek Console Log

Setelah run `flutter run`, perhatikan console output:
```
=== LOGIN ATTEMPT ===
NIM: 202210370311
API URL: http://10.0.2.2:3000/api/auth/login
Testing backend connection...
Backend connection OK
POST request to: http://10.0.2.2:3000/api/auth/login
...
```

### 9. Common Issues

**Error: "address already in use"**
- Backend sudah running di terminal lain
- Kill process: `Get-Process node | Stop-Process -Force`

**Error: "ECONNREFUSED"**
- Backend tidak running
- Start: `cd backend && npm start`

**Error: "Timeout"**
- URL salah (gunakan 10.0.2.2 untuk emulator, bukan localhost)
- Firewall memblokir koneksi
- Backend terlalu lambat (sudah ditingkatkan timeout ke 60s)

### 10. Quick Fix

1. Stop semua node processes:
```powershell
Get-Process node -ErrorAction SilentlyContinue | Stop-Process -Force
```

2. Restart backend:
```powershell
cd backend
npm start
```

3. Edit `lib/config/api_config.dart` sesuai device Anda

4. Restart Flutter app:
```powershell
flutter run
```

### Fitur Baru yang Ditambahkan

✅ **Timeout ditingkatkan** dari 30s → 60s
✅ **Auto-retry** hingga 2x jika timeout
✅ **Connection checker** sebelum login
✅ **Detailed error messages** dengan solusi
✅ **Debug logging** untuk tracking request
✅ **Troubleshooting info** di login screen

### Kontak Support

Jika masih error, share:
1. Screenshot error message
2. Console log output
3. Device type (emulator/real device)
4. Backend status (running/not running)
