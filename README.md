# 🎓 KRS Online - Proyek Flutter

<p align="center">
  <img src="assets/images/welcome_logo.svg" alt="KRS Online Logo" width="200"/>
</p>

<p align="center">
  <strong>Aplikasi mobile untuk mempermudah proses pengisian Kartu Rencana Studi (KRS) mahasiswa.</strong>
</p>

---

## 🎯 Tentang Proyek

**KRS Online** adalah aplikasi mobile cross-platform (Android & iOS) yang dibangun menggunakan **Flutter**. Aplikasi ini bertujuan untuk menyederhanakan proses pengisian KRS bagi mahasiswa. Dengan aplikasi ini, mahasiswa dapat melihat daftar mata kuliah, memfilternya, memilih kelas, dan secara otomatis mendapatkan visualisasi jadwal kuliah mingguan.

## ✨ Fitur Utama

-   📱 **Antarmuka Modern**: Tampilan yang bersih dan intuitif untuk kemudahan penggunaan.
-   📖 **Daftar Kelas Interaktif**: Menampilkan semua mata kuliah yang tersedia dalam format *card* yang informatif.
-   🔍 **Filter SKS Cerdas**: Fitur untuk mencari kelas berdasarkan beban SKS (Satuan Kredit Semester).
-   👥 **Sistem Antrean (Waiting List)**: Jika kelas penuh, mahasiswa dapat mendaftar pada daftar antrean.
-   📝 **Keranjang KRS Fleksibel**: Mahasiswa dapat menambah atau menghapus mata kuliah dari rencana studi mereka dengan mudah.
-   📅 **Jadwal Kuliah Visual**: Jadwal yang sudah dipilih akan otomatis tersusun dalam tabel mingguan yang rapi.

---

## 🏛️ Arsitektur & Teknologi

Aplikasi ini dirancang dengan arsitektur dan teknologi yang terstruktur untuk memastikan kode yang bersih dan mudah dikelola.

-   **Arsitektur**: Aplikasi ini dibangun menggunakan pola arsitektur **MVC (Model-View-Controller)**.
    -   **Model**: Mengelola data dan logika (misalnya, data kelas, data mahasiswa).
    -   **View**: Bertanggung jawab untuk menampilkan data kepada pengguna (UI/UX).
    -   **Controller**: Menjembatani antara Model dan View, menangani input dari pengguna.

-   **Framework**: **Flutter 3.x**
-   **Bahasa Pemrograman**: **Dart**
-   **Backend as a Service (BaaS)**: **Firebase**
    -   **Authentication**: Untuk mengelola login dan registrasi pengguna.
    -   **Cloud Firestore**: Sebagai database NoSQL untuk menyimpan data kelas, mahasiswa, dan KRS.
    -   **Cloud Storage** (Opsional): Untuk menyimpan aset jika diperlukan.

-   **Paket Kunci**:
    -   `firebase_core`: Untuk inisialisasi koneksi ke Firebase.
    -   `firebase_auth`: Untuk layanan otentikasi.
    -   `cloud_firestore`: Untuk interaksi dengan database Firestore.

---

## 🔧 Konfigurasi & Instalasi

Ikuti langkah-langkah di bawah ini untuk menjalankan proyek ini di lingkungan lokal Anda.

1.  **Prasyarat**
    Pastikan Anda sudah menginstal [Flutter SDK](https://flutter.dev/docs/get-started/install) (versi 3.x atau lebih tinggi).

2.  **Clone Repository**
    ```bash
    git clone https://github.com/bintangrobbany/KRS_Online
    ```

3.  **Masuk ke Direktori Proyek**
    ```bash
    cd krs_online
    ```

4.  **Konfigurasi Firebase**
    Proyek ini memerlukan koneksi ke Firebase.
    -   Buka [Firebase Console](https://console.firebase.google.com/) dan buat proyek baru.
    -   Daftarkan aplikasi Android dan/atau iOS Anda.
    -   Unduh file konfigurasi:
        -   Untuk **Android**: `google-services.json` dan letakkan di dalam direktori `android/app/`.
        -   Untuk **iOS**: `GoogleService-Info.plist` dan letakkan di dalam direktori `ios/Runner/` melalui Xcode.
    -   Pastikan untuk mengaktifkan **Authentication** dan **Cloud Firestore** di Firebase Console.

5.  **Install Dependencies**
    Jalankan perintah ini untuk mengunduh semua paket yang dibutuhkan.
    ```bash
    flutter pub get
    ```

6.  **Jalankan Aplikasi**
    Hubungkan perangkat atau jalankan emulator, lalu eksekusi perintah:
    ```bash
    flutter run
    ```

---

## 📄 Lisensi

Proyek ini dilisensikan di bawah [Lisensi MIT](LICENSE.md).

---

<p align="center">
  Dibuat dengan ❤️ oleh <strong>Bintang, Edra, Igo, Weldan</strong>
</p>