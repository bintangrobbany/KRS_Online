# Frontend-Backend Integration Guide

## ✅ Status: Terintegrasi Penuh

Frontend Flutter telah berhasil dihubungkan dengan Backend Express.js + Firebase.

---

## 📁 **File-file yang Dibuat/Dimodifikasi**

### **1. Configuration & Services**
- ✅ `lib/config/api_config.dart` - Konfigurasi base URL dan endpoints
- ✅ `lib/services/api_service.dart` - HTTP client untuk API calls
- ✅ `lib/helpers/auth_helper.dart` - Helper untuk JWT token storage

### **2. Models (dengan JSON Serialization)**
- ✅ `lib/models/user_model.dart` - User model
- ✅ `lib/models/matkul_model.dart` - Mata Kuliah model
- ✅ `lib/models/krs_model.dart` - KRS dan KelasMataKuliah models

### **3. Controllers (Terintegrasi dengan API)**
- ✅ `lib/controllers/login_controller.dart` - Login authentication
- ✅ `lib/controllers/home_controller.dart` - User profile & KRS
- ✅ `lib/controllers/krs_controller_new.dart` - KRS management
- ✅ `lib/controllers/grid_jadwal_controller.dart` - Jadwal management

### **4. Dependencies**
- ✅ `pubspec.yaml` - Added `http` dan `intl` packages

---

## 🔧 **Cara Menggunakan**

### **1. Setup Backend**
```bash
cd backend
npm install
npm run seed  # Seed test data
npm run dev   # Start server di port 3000
```

### **2. Configure Frontend Base URL**

Edit `lib/config/api_config.dart`:

```dart
// Untuk Android Emulator
static const String baseUrl = 'http://10.0.2.2:3000/api';

// Untuk iOS Simulator
// static const String baseUrl = 'http://localhost:3000/api';

// Untuk Real Device (ganti dengan IP komputer Anda)
// static const String baseUrl = 'http://192.168.1.100:3000/api';
```

**Cara mendapatkan IP Address Komputer:**

**Windows:**
```cmd
ipconfig
# Cari "IPv4 Address" pada adapter yang active
```

**Mac/Linux:**
```bash
ifconfig
# Atau
ip addr show
```

### **3. Run Flutter App**
```bash
flutter pub get
flutter run
```

---

## 🔑 **Test Credentials**

Setelah backend seeding, gunakan credentials berikut:

| NIM | Password | Nama |
|-----|----------|------|
| 202210370311 | password123 | Budi Santoso |
| 202210370322 | password123 | Siti Rahmawati |
| 202210370345 | password123 | Ahmad Fauzi |

---

## 🎯 **Fitur yang Terintegrasi**

### **✅ Authentication**
- Login dengan NIM dan password
- JWT token storage menggunakan SharedPreferences
- Auto-login jika token masih valid
- Logout dengan clear token

### **✅ User Profile**
- Load profile dari backend
- Display data: nama, NIM, prodi, semester, IPK
- Update profile (nama, telepon, foto)

### **✅ KRS Management**
- Load daftar KRS mahasiswa
- Tambah KRS baru
- Hapus KRS
- Filter KRS by semester & tahun ajaran
- Status KRS (pending/approved/rejected)

### **✅ Jadwal/Kelas**
- Load available classes dengan filter
- Display info kelas: dosen, ruangan, waktu, kuota
- Check kuota tersedia
- Add to KRS
- Grid jadwal visualization

---

## 📱 **API Endpoints yang Digunakan Frontend**

### **Authentication**
```
POST /api/auth/login
GET  /api/auth/profile
```

### **Mata Kuliah**
```
GET /api/mata-kuliah?prodi=...&semester=...
```

### **Jadwal**
```
GET /api/jadwal?format=kelas&prodi=...&semester=...&hari=...
```

### **KRS**
```
GET    /api/krs?semester=...&tahunAjaran=...
POST   /api/krs
DELETE /api/krs/:id
```

### **User**
```
PUT /api/user/profile
GET /api/user/saved-classes
POST /api/user/saved-classes
DELETE /api/user/saved-classes/:jadwalId
```

---

## 🔄 **Flow Aplikasi**

### **1. Login Flow**
```
User Input NIM & Password
    ↓
LoginController.login()
    ↓
ApiService.post('/auth/login')
    ↓
Save Token & User Data (AuthHelper)
    ↓
Navigate to HomeView
```

### **2. Home Screen Flow**
```
HomeView Loaded
    ↓
HomeController.loadUserData()
    ↓
ApiService.get('/auth/profile')
ApiService.get('/krs')
    ↓
Display Profile & KRS Summary
```

### **3. KRS Management Flow**
```
Open Daftar Kelas
    ↓
KRSController.loadAvailableClasses()
    ↓
ApiService.get('/jadwal?format=kelas')
    ↓
Display Available Classes
    ↓
User Click "Tambah"
    ↓
KRSController.addKRS()
    ↓
ApiService.post('/krs')
    ↓
Reload KRS List
```

---

## 🐛 **Troubleshooting**

### **1. "Tidak dapat terhubung ke server"**
**Penyebab:** Backend tidak running atau base URL salah

**Solusi:**
- Pastikan backend running di `http://localhost:3000`
- Check base URL di `api_config.dart`
- Untuk Android Emulator gunakan `10.0.2.2` bukan `localhost`
- Untuk Real Device gunakan IP Address komputer

### **2. "401 Unauthorized"**
**Penyebab:** Token expired atau tidak valid

**Solusi:**
- Logout dan login ulang
- Token disimpan di SharedPreferences
- Check token dengan: `await AuthHelper.getToken()`

### **3. "Timeout"**
**Penyebab:** Request terlalu lama

**Solusi:**
- Check koneksi internet
- Pastikan backend responsive
- Timeout duration di `ApiConfig.timeoutDuration` (default 30s)

### **4. "CORS Error" (jika run di web)**
**Penyebab:** CORS policy di backend

**Solusi:**
- Backend sudah include CORS middleware
- Pastikan `cors` package installed di backend

### **5. "Data tidak muncul"**
**Penyebab:** Backend belum di-seed atau database kosong

**Solusi:**
```bash
cd backend
npm run seed
```

---

## 📊 **Response Format**

Semua API response menggunakan format standar:

**Success:**
```json
{
  "success": true,
  "data": { ... }
}
```

**Error:**
```json
{
  "success": false,
  "error": "Error message here"
}
```

---

## 🎨 **Next Steps (Opsional)**

### **1. Error Handling UI**
Tambahkan UI yang lebih baik untuk display errors:
- SnackBar untuk error notification
- Loading indicators
- Retry buttons

### **2. Offline Support**
Implement caching untuk offline mode:
- Cache user profile
- Cache KRS list
- Sync when online

### **3. Real-time Updates**
Implementasi WebSocket untuk:
- Real-time kuota updates
- Push notifications
- Live KRS approval status

### **4. Image Upload**
Implementasi upload foto profil:
- Camera integration
- Image picker
- Upload to cloud storage

---

## 📝 **Code Examples**

### **Contoh: Login**
```dart
final controller = LoginController();
await controller.login(context, () {
  // Success callback
  showSuccessDialog();
});
```

### **Contoh: Load Profile**
```dart
final controller = HomeController();
// Otomatis load saat controller dibuat
// Atau manual refresh:
await controller.refreshData();
```

### **Contoh: Add KRS**
```dart
final controller = KRSController();
final success = await controller.addKRS(
  jadwalId: 'jadwal1',
  semester: 'Ganjil',
  tahunAjaran: '2024/2025',
);

if (success) {
  showSuccessMessage();
} else {
  showError(controller.error);
}
```

### **Contoh: Load Jadwal**
```dart
final controller = GridJadwalController();
await controller.loadAvailableCourses(
  prodi: 'Teknik Informatika',
  semester: 7,
  hari: 'Senin',
);

// Display data
for (var kelas in controller.availableCourses) {
  print('${kelas.namaMataKuliah} - ${kelas.jadwal}');
}
```

---

## ✨ **Features Implemented**

- ✅ JWT Authentication
- ✅ Token Storage & Auto-login
- ✅ Profile Management
- ✅ KRS CRUD Operations
- ✅ Jadwal Filtering & Search
- ✅ Kuota Checking
- ✅ Error Handling
- ✅ Loading States
- ✅ API Response Parsing
- ✅ Model Serialization

---

## 🎉 **Selesai!**

Frontend dan Backend sekarang sudah fully integrated. Semua fungsi utama KRS Online sudah terhubung dengan database Firebase melalui backend API.

**Test dengan:**
1. Start backend: `npm run dev`
2. Run Flutter app: `flutter run`
3. Login dengan NIM: `202210370311` Password: `password123`
4. Explore semua fitur!

Untuk dokumentasi API lengkap, lihat: `backend/API_DOCUMENTATION.md`
