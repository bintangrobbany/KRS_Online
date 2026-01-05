# 📖 Panduan Setup KRS Online untuk Rekan Kerja

Dokumentasi lengkap untuk setup dan menjalankan aplikasi KRS Online di environment lokal.

---

## 📋 Prerequisites (Yang Harus Diinstall)

### 1. Flutter SDK
- Download: https://flutter.dev/docs/get-started/install
- Versi minimal: 3.0.0
- Cek instalasi: `flutter --version`
- Run: `flutter doctor` untuk cek konfigurasi

### 2. Node.js & npm
- Download: https://nodejs.org/ (LTS version)
- Versi minimal: Node.js 16.x, npm 8.x
- Cek instalasi: `node --version` dan `npm --version`

### 3. Firebase CLI (Optional, untuk deployment)
- Install: `npm install -g firebase-tools`
- Login: `firebase login`

### 4. Android Studio / Xcode
- **Android**: Install Android Studio + Android SDK
- **iOS**: Install Xcode (Mac only)

### 5. Git
- Download: https://git-scm.com/downloads
- Cek instalasi: `git --version`

---

## 🚀 Langkah Setup Project

### Step 1: Clone Repository

```bash
git clone <URL_REPOSITORY_GITHUB>
cd KRS_Online
```

### Step 2: Setup Backend (Node.js + Firebase)

#### 2.1. Install Dependencies Backend
```bash
cd backend
npm install
```

#### 2.2. Setup Firebase Service Account Key

**PENTING:** File `serviceAccountKey.json` adalah credential sensitif dan tidak di-push ke GitHub!

1. **Dapatkan Firebase Service Account Key:**
   - Buka Firebase Console: https://console.firebase.google.com/
   - Pilih project: `krs-online-d1e1e`
   - Klik ⚙️ Settings → Project settings
   - Tab **Service accounts**
   - Klik **Generate new private key**
   - Download file JSON

2. **Copy file ke backend folder:**
   ```bash
   # Copy file yang di-download ke folder backend
   # Rename menjadi serviceAccountKey.json
   cp ~/Downloads/krs-online-xxxxx.json ./serviceAccountKey.json
   ```

3. **Pastikan struktur file sesuai template:**
   ```json
   {
     "type": "service_account",
     "project_id": "krs-online-d1e1e",
     "private_key_id": "...",
     "private_key": "-----BEGIN PRIVATE KEY-----\n...",
     "client_email": "firebase-adminsdk-xxxxx@krs-online-d1e1e.iam.gserviceaccount.com",
     ...
   }
   ```

#### 2.3. Jalankan Backend Server
```bash
# Dari folder backend
node src/server.js

# Atau gunakan npm script (jika tersedia)
npm start
```

✅ **Backend berjalan di:** `http://localhost:3000`

---

### Step 3: Setup Flutter App

#### 3.1. Install Dependencies Flutter
```bash
# Dari root folder KRS_Online
flutter pub get
```

#### 3.2. Konfigurasi API Base URL

Edit file `lib/config/api_config.dart`:

```dart
class ApiConfig {
  // Pilih salah satu sesuai device:
  
  // 🟢 ANDROID EMULATOR (ganti IP jika tidak work)
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  
  // 🟢 REAL DEVICE - SAME WI-FI (ganti dengan IP laptop/PC Anda)
  // Cek IP: ipconfig (Windows) atau ifconfig (Mac/Linux)
  // static const String baseUrl = 'http://192.168.x.x:3000/api';
  
  // 🟢 IOS SIMULATOR
  // static const String baseUrl = 'http://localhost:3000/api';
  
  ...
}
```

**Cara cek IP komputer:**
- **Windows:** `ipconfig` → lihat "IPv4 Address" di Wi-Fi
- **Mac/Linux:** `ifconfig` → lihat "inet" di en0

#### 3.3. Run Flutter App

**Option A: Android Emulator**
```bash
# Buka Android Studio → AVD Manager → Start emulator
flutter run
```

**Option B: Real Device**
```bash
# 1. Enable USB Debugging di HP Android
# 2. Sambungkan HP ke laptop
# 3. Cek device: flutter devices
# 4. Run:
flutter run -d <device-id>
```

**Option C: iOS Simulator (Mac only)**
```bash
open -a Simulator
flutter run
```

---

## 🔧 Troubleshooting

### ❌ Backend: "Error: Cannot find module"
```bash
cd backend
rm -rf node_modules package-lock.json
npm install
```

### ❌ Flutter: "Connection refused"
**Penyebab:** Backend tidak berjalan atau IP salah

**Solusi:**
1. Cek backend running: `netstat -ano | findstr :3000` (Windows)
2. Cek IP di `api_config.dart` sesuai dengan IP komputer
3. Pastikan device dan laptop di Wi-Fi yang sama (untuk real device)

### ❌ Flutter: Packages error
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

### ❌ Firebase: "Permission denied"
**Penyebab:** `serviceAccountKey.json` tidak valid atau salah

**Solusi:**
1. Download ulang key dari Firebase Console
2. Pastikan file ada di folder `backend/`
3. Cek struktur JSON sesuai template

### ❌ Android: "Gradle build failed"
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

---

## 🧪 Testing Login

### Login sebagai Admin:
- **Username:** `admin@krs.com`
- **Password:** `12345678`

### Login sebagai Mahasiswa:
- **NIM:** `202210370311250` (15 digit)
- **Password:** `password123`

---

## 📱 Development Workflow

### 1. Start Backend (Terminal 1)
```bash
cd backend
node src/server.js
```

### 2. Start Flutter (Terminal 2)
```bash
flutter run
```

### 3. Hot Reload (saat development)
- Press `r` di terminal Flutter untuk reload
- Press `R` untuk hot restart
- Press `q` untuk quit

### 4. Debug Mode
```bash
# Verbose logging
flutter run -v

# Debug console
flutter logs
```

---

## 📦 Build untuk Production

### Android APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (untuk Google Play)
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS (Mac only)
```bash
flutter build ios --release
# Buka Xcode untuk archive & upload ke App Store
```

---

## 🌐 Network Configuration

### Untuk Real Device di Wi-Fi yang Sama:

1. **Cek IP laptop:**
   ```bash
   # Windows
   ipconfig
   
   # Mac/Linux
   ifconfig
   ```

2. **Update `api_config.dart`:**
   ```dart
   static const String baseUrl = 'http://192.168.x.x:3000/api';
   ```

3. **Pastikan Windows Firewall allow port 3000:**
   ```bash
   # Windows PowerShell (as Admin)
   New-NetFirewallRule -DisplayName "Node.js Port 3000" -Direction Inbound -Protocol TCP -LocalPort 3000 -Action Allow
   ```

### Untuk Mobile Hotspot (Laptop jadi Hotspot):

1. **Aktifkan Mobile Hotspot di laptop**
2. **Connect HP ke hotspot laptop**
3. **Update `api_config.dart`:**
   ```dart
   static const String baseUrl = 'http://192.168.137.1:3000/api';
   ```

---

## 📁 Struktur Project

```
KRS_Online/
├── android/               # Android native code
├── ios/                   # iOS native code
├── lib/                   # Flutter source code
│   ├── main.dart         # Entry point
│   ├── config/           # API config
│   ├── controllers/      # Business logic
│   ├── models/           # Data models
│   ├── views/            # UI screens
│   ├── services/         # API services
│   └── helpers/          # Utility functions
├── backend/              # Node.js backend
│   ├── src/
│   │   ├── server.js     # Entry point
│   │   ├── config/       # Backend config
│   │   ├── controllers/  # API handlers
│   │   ├── routes/       # API routes
│   │   ├── services/     # Business logic
│   │   └── middlewares/  # Auth, validation
│   ├── package.json      # Dependencies
│   └── serviceAccountKey.json  # Firebase key (TIDAK DI-PUSH!)
└── README.md             # Project overview
```

---

## 🔒 Keamanan

### File yang TIDAK BOLEH di-push ke GitHub:
- ❌ `backend/serviceAccountKey.json` (Firebase credential)
- ❌ `backend/.env` (environment variables)
- ❌ `android/app/google-services.json` (jika ada)
- ❌ `ios/Runner/GoogleService-Info.plist` (jika ada)

### File yang sudah di-gitignore:
✅ Sudah diatur di `backend/.gitignore`:
```
serviceAccountKey.json
firebase-key.json
*-firebase-adminsdk-*.json
.env
```

---

## 💬 Support & Contact

Jika ada masalah saat setup:
1. Check troubleshooting section di atas
2. Lihat console logs untuk error detail
3. Contact team lead atau project maintainer

---

## 🎯 Quick Start Summary

```bash
# 1. Clone repo
git clone <URL_REPO>

# 2. Setup backend
cd backend
npm install
# Copy serviceAccountKey.json dari Firebase Console
node src/server.js

# 3. Setup Flutter (terminal baru)
cd ..
flutter pub get
flutter run

# 4. Login dengan credentials di atas
```

---

Selamat coding! 🚀
