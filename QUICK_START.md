# KRS Online - Quick Start Guide 🚀

## Prerequisites
- Node.js (v14+)
- Flutter SDK (v3.10+)
- Firebase Project dengan Firestore
- Android Emulator atau iOS Simulator atau Real Device

---

## 📦 **Setup dalam 5 Langkah**

### **1️⃣ Setup Backend**

```bash
# Navigate ke folder backend
cd backend

# Install dependencies
npm install

# Setup Firebase
# - Download serviceAccountKey.json dari Firebase Console
# - Place file di folder backend/

# Seed database dengan test data
npm run seed

# Start server
npm run dev
```

Server akan running di `http://localhost:3000`

**Test Credentials:**
- NIM: `202210370311`
- Password: `password123`

---

### **2️⃣ Configure Frontend**

Edit `lib/config/api_config.dart`:

```dart
// Pilih sesuai environment Anda:

// Android Emulator
static const String baseUrl = 'http://10.0.2.2:3000/api';

// iOS Simulator
// static const String baseUrl = 'http://localhost:3000/api';

// Real Device (ganti dengan IP komputer Anda)
// static const String baseUrl = 'http://192.168.1.5:3000/api';
```

**Cara cek IP Address:**
```bash
# Windows
ipconfig

# Mac/Linux
ifconfig
```

---

### **3️⃣ Install Flutter Dependencies**

```bash
# Di root folder project
flutter pub get
```

---

### **4️⃣ Run Flutter App**

```bash
# Check devices
flutter devices

# Run di device/emulator
flutter run

# Atau run di specific device
flutter run -d chrome        # Web
flutter run -d android       # Android
flutter run -d ios           # iOS
```

---

### **5️⃣ Login & Test**

1. **Login dengan credentials:**
   - NIM: `202210370311`
   - Password: `password123`

2. **Explore fitur:**
   - ✅ View Profile
   - ✅ Lihat KRS saya
   - ✅ Daftar Kelas
   - ✅ Tambah KRS
   - ✅ Grid Jadwal

---

## 🎯 **Struktur Project**

```
KRS_Online/
├── backend/                    # Express.js Backend
│   ├── src/
│   │   ├── config/            # Configuration
│   │   ├── controllers/       # API Controllers
│   │   ├── services/          # Business Logic
│   │   ├── routes/            # API Routes
│   │   └── middlewares/       # Middlewares
│   ├── scripts/seed.js        # Database seeding
│   ├── package.json
│   └── README.md
│
├── lib/                        # Flutter Frontend
│   ├── config/                # API Configuration
│   ├── services/              # API Services
│   ├── helpers/               # Helper functions
│   ├── models/                # Data Models
│   ├── controllers/           # Business Logic
│   ├── views/                 # UI Screens
│   └── main.dart
│
└── FRONTEND_BACKEND_INTEGRATION.md  # Integration docs
```

---

## 📚 **Dokumentasi**

- **Backend API:** `backend/API_DOCUMENTATION.md`
- **Firebase Setup:** `backend/FIREBASE_SETUP.md`
- **Backend README:** `backend/README.md`
- **Integration Guide:** `FRONTEND_BACKEND_INTEGRATION.md`

---

## 🔧 **Troubleshooting Cepat**

### **Backend tidak bisa diakses dari Android Emulator**
```dart
// Gunakan 10.0.2.2 bukan localhost
static const String baseUrl = 'http://10.0.2.2:3000/api';
```

### **Real Device tidak bisa connect**
```dart
// Gunakan IP Address komputer
static const String baseUrl = 'http://192.168.1.5:3000/api';

// Pastikan:
// 1. Komputer dan device di network yang sama
// 2. Firewall tidak block port 3000
```

### **Token expired atau 401 error**
```dart
// Logout dan login ulang
// Token disimpan di SharedPreferences
```

### **Data tidak muncul**
```bash
# Seed database lagi
cd backend
npm run seed
```

---

## 🧪 **Test Data**

Setelah running `npm run seed`, tersedia:

**Users:**
| NIM | Password | Nama | Prodi |
|-----|----------|------|-------|
| 202210370311 | password123 | Budi Santoso | Teknik Informatika |
| 202210370322 | password123 | Siti Rahmawati | Teknik Informatika |
| 202210370345 | password123 | Ahmad Fauzi | Teknik Informatika |

**Mata Kuliah:** 6 mata kuliah (TIF701-TIF706)

**Jadwal:** 8 jadwal kelas dengan berbagai waktu

**KRS:** Sample KRS untuk user pertama

---

## 🎨 **Tech Stack**

### **Backend**
- Node.js + Express.js
- Firebase Firestore
- JWT Authentication
- bcrypt untuk password hashing

### **Frontend**
- Flutter (Dart)
- HTTP package untuk API calls
- SharedPreferences untuk token storage
- Provider pattern untuk state management

---

## 🚀 **Quick Commands**

```bash
# Backend
cd backend
npm run dev          # Development mode
npm run seed         # Seed database
npm start            # Production mode

# Frontend
flutter pub get      # Install dependencies
flutter run          # Run app
flutter clean        # Clean build
flutter doctor       # Check setup

# Development
flutter run --hot    # Hot reload mode
flutter run -v       # Verbose output
```

---

## ✅ **Checklist Setup**

- [ ] Node.js installed
- [ ] Flutter SDK installed
- [ ] Firebase project created
- [ ] serviceAccountKey.json downloaded
- [ ] Backend dependencies installed
- [ ] Database seeded
- [ ] Backend server running
- [ ] Frontend base URL configured
- [ ] Flutter dependencies installed
- [ ] App running on device/emulator
- [ ] Successful login with test credentials

---

## 📞 **Support**

Jika ada masalah, check:
1. Backend logs di terminal
2. Flutter logs di terminal
3. `FRONTEND_BACKEND_INTEGRATION.md` untuk troubleshooting detail
4. `backend/API_DOCUMENTATION.md` untuk API reference

---

## 🎉 **Happy Coding!**

Project sudah ready untuk development. Semua fitur utama sudah terintegrasi dengan backend dan database.

**Next Steps:**
- Customize UI sesuai kebutuhan
- Tambah fitur baru
- Deploy ke production
- Add more features!

---

Made with ❤️ for KRS Online
