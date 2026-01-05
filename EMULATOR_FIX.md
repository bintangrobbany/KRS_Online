# PENTING: Solusi Emulator Tidak Bisa Connect

## Masalah
Android Emulator tidak bisa connect ke `http://10.0.2.2:3000/api` (timeout).

## Penyebab
`10.0.2.2` adalah special alias untuk localhost di Android Emulator, tapi tidak selalu bekerja tergantung konfigurasi network emulator.

## ✅ SOLUSI (Sudah Diterapkan)

Sudah diubah ke menggunakan IP lokal komputer Anda: `http://192.168.1.10:3000/api`

### Langkah yang Sudah Dilakukan:

1. ✅ Updated `lib/config/api_config.dart` → gunakan IP `192.168.1.10`
2. ✅ Updated login view troubleshooting info
3. ✅ Backend confirmed bisa diakses via IP lokal

## Cara Test Sekarang:

1. **Hot Restart aplikasi**:
   - Tekan `R` di terminal Flutter
   - Atau stop & run ulang dengan `flutter run`

2. **Login dengan kredensial**:
   - NIM: `202210370311`
   - Password: `password123`

3. **Expected behavior**:
   ```
   === LOGIN ATTEMPT ===
   Testing backend connection...
   Testing connection to: http://192.168.1.10:3000/api
   ✓ Backend connection OK
   POST request to: http://192.168.1.10:3000/api/auth/login
   Response status: 200
   Login response: {success: true, ...}
   ```

## Jika IP Berubah

Jika IP komputer Anda berubah (setelah restart/ganti network):

1. Cek IP baru:
   ```powershell
   ipconfig | Select-String "IPv4"
   ```

2. Update `lib/config/api_config.dart`:
   ```dart
   static const String baseUrl = 'http://[IP_BARU]:3000/api';
   ```

3. Hot restart Flutter app

## Alternative: Gunakan Real Device

Jika masih ada masalah dengan emulator, gunakan real device:

1. Connect HP Android via USB
2. Enable USB Debugging
3. Pastikan HP dan PC di network WiFi yang sama
4. Gunakan IP yang sama: `192.168.1.10`
5. Run: `flutter run`

## Verifikasi Backend

Test backend dari browser/Postman:
- Health: http://192.168.1.10:3000/api/health
- Login: POST http://192.168.1.10:3000/api/auth/login
  ```json
  {
    "nim": "202210370311",
    "password": "password123"
  }
  ```

## Tips

- Pastikan backend tetap running (`npm start`)
- Pastikan PC dan emulator di network yang sama
- Jika pakai VPN, matikan dulu
- Check Windows Firewall tidak block port 3000

---

**Status: READY TO TEST** ✅
Silakan hot restart aplikasi dan coba login lagi!
