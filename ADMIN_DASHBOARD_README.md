# Admin Dashboard Documentation

## Deskripsi
Admin Dashboard adalah modul admin untuk mengelola user dan mata kuliah dalam aplikasi KRS Online dengan interface yang profesional menggunakan sidebar navigation.

## Struktur File

### File Utama
- **admin_dashboard_view.dart** - Halaman utama admin dengan sidebar navigation

### Manajemen User
- **admin_user_management_view.dart** - Halaman list user dengan CRUD
- **admin_user_form_view.dart** - Form untuk menambah/edit user

### Manajemen Mata Kuliah
- **admin_matkul_management_view.dart** - Halaman list mata kuliah dengan CRUD
- **admin_matkul_form_view.dart** - Form untuk menambah/edit mata kuliah

## Design & Layout

### Header
- **Logo KRS Online** - Ditampilkan di bagian kiri header dalam white box
- **Title** - "KRS Online - Admin Dashboard"
- **Color Scheme** - Primary Green (#006A4E)

### Sidebar Navigation
- **Sidebar Color** - Dark Green (#054F40)
- **Width** - 280px (desktop)
- **Menu Items:**
  - Kelola User (dengan icon person)
  - Kelola Mata Kuliah (dengan icon book)
- **Responsive** - Berubah menjadi drawer di mobile
- **Active State** - Highlight dengan background semi-transparent white dan left border

### Main Content Area
- **Page Title Header** - Menampilkan nama page yang sedang aktif
- **Content** - List data dengan card format
- **FAB (Floating Action Button)** - Tombol tambah data di bottom-right

### Color Palette
| Element | Color | Hex |
|---------|-------|-----|
| Primary (Sidebar) | Dark Green | #054F40 |
| Secondary (Header) | Green | #006A4E |
| Background | Cream | #F0EBE3 |
| Text Primary | Dark Green | #054F40 |
| Accent (User Avatar) | Green | #006A4E |

## Fitur User Management

### Create (Tambah User)
- Form input untuk data user baru
- Field yang diperlukan:
  - **NIM** (15 digit) - Primary key, disabled saat edit
  - **Password**
  - **Nama Mahasiswa**
  - **Email**
  - **No. HP**

### Read (Tampilkan User)
- List semua user dalam card format
- Menampilkan: Nama, NIM, Email, No. HP
- Avatar dengan inisial nama

### Update (Edit User)
- Edit data user (kecuali NIM)
- Validasi data sebelum update

### Delete (Hapus User)
- Konfirmasi dialog sebelum menghapus
- Pesan notifikasi hasil operasi

## Fitur Mata Kuliah Management

### Create (Tambah Matkul)
- Form untuk tambah mata kuliah baru
- Field yang diperlukan:
  - **Kode Mata Kuliah** - Identitas unik
  - **Nama Mata Kuliah**
  - **SKS** (1-4)
  - **Jadwal** - Hari dan jam

### Read (Tampilkan Matkul)
- List semua mata kuliah dalam card
- Menampilkan: Nama, Kode, SKS, Jadwal
- Avatar dengan jumlah SKS

### Update (Edit Matkul)
- Edit semua informasi matkul
- Validasi SKS 1-4

### Delete (Hapus Matkul)
- Konfirmasi sebelum menghapus
- Notifikasi hasil operasi

## Alur Navigasi

1. **Login** (sebagai Admin)
   - Username: `admin@krs.com`
   - Password: `12345678`

2. **Admin Dashboard** dibuka
   - Default menampilkan halaman "Kelola User"
   - Sidebar tersedia untuk switch halaman

3. **Kelola User**
   - Klik menu "Kelola User" di sidebar
   - Tampil list semua user
   - FAB untuk tambah user baru

4. **Kelola Mata Kuliah**
   - Klik menu "Kelola Mata Kuliah" di sidebar
   - Tampil list semua mata kuliah
   - FAB untuk tambah matkul baru

5. **Logout**
   - Klik tombol "Logout" di sidebar (desktop) atau menu drawer (mobile)
   - Kembali ke halaman Login

## Responsive Design

### Desktop (width > 600px)
- Sidebar fixed di kiri
- Content area expanded dengan header page
- Drawer tidak ditampilkan

### Mobile (width ≤ 600px)
- Sidebar berubah menjadi drawer
- Hamburger menu di AppBar
- Full-width content area
- Logout button di header

## Model Data

### User Model
```dart
class User {
  String nim;         // 15 digit
  String password;
  String nama;
  String email;
  String noHp;
}
```

### MataKuliah Model
```dart
class MataKuliah {
  String kode;
  String nama;
  int sks;           // 1-4
  String jadwal;
}
```

## Validasi

### User
- Semua field wajib diisi
- NIM harus 15 digit
- Format email yang valid (opsional)

### Mata Kuliah
- Semua field wajib diisi
- SKS numeric 1-4
- Kode dan nama tidak boleh kosong

## Data Persistence

Saat ini menggunakan local state management (List). Untuk production, implementasikan:
- API Backend untuk CRUD
- Database (Firebase/SQL)
- Local caching dengan hive/sqflite

## Fitur Tambahan yang Bisa Ditambahkan
- [ ] Search/Filter data user dan matkul
- [ ] Export data ke CSV/PDF
- [ ] Import data dari file
- [ ] Dashboard analytics/statistics
- [ ] User activity logs
- [ ] Bulk operations
- [ ] Advanced sorting/filtering
- [ ] Data pagination

## Screenshot Flow
```
Login Page (admin@krs.com)
    ↓
Admin Dashboard
├── Header (KRS Online Logo + Title)
├── Sidebar Navigation
│   ├── Kelola User (default)
│   └── Kelola Mata Kuliah
└── Content Area
    ├── Page Header (title)
    ├── Data List
    └── FAB (Tambah)
```

## Installation & Run
```bash
flutter pub get
flutter run
```

Akses Admin dengan:
- Email: `admin@krs.com`
- Password: `12345678`

