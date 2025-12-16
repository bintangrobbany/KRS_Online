# KRS Online Backend with Firebase

Backend API untuk aplikasi KRS Online menggunakan Node.js, Express, dan Firebase Firestore.

## 🚀 Teknologi

- **Node.js** - Runtime environment
- **Express.js** - Web framework
- **Firebase Firestore** - NoSQL Cloud Database
- **Firebase Admin SDK** - Server-side Firebase operations
- **JWT** - Authentication
- **bcryptjs** - Password hashing

## 🛠️ Setup & Installation

### 1. Install Dependencies

```bash
cd backend
npm install
```

### 2. Setup Firebase Project

#### A. Buat Project Firebase
1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Klik **"Add project"**
3. Masukkan nama project: `krs-online`
4. Disable Google Analytics (optional)
5. Klik **"Create project"**

#### B. Aktifkan Firestore Database
1. Pilih **"Firestore Database"**
2. Klik **"Create database"**
3. Pilih **"Start in test mode"**
4. Pilih location: **asia-southeast1**
5. Klik **"Enable"**

#### C. Generate Service Account Key
1. Klik ⚙️ **Settings** > **"Project settings"**
2. Tab **"Service accounts"**
3. Klik **"Generate new private key"**
4. Simpan file JSON

### 3. Configure .env

Copy `.env.example` ke `.env` dan isi dengan data dari JSON:

```env
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@....iam.gserviceaccount.com
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"
JWT_SECRET=your-secret-key
```

### 4. Start Server

```bash
npm run dev
```

Server di `http://localhost:3000`

## 📡 API Endpoints

### Auth
- `POST /api/auth/register` - Register
- `POST /api/auth/login` - Login
- `GET /api/auth/profile` - Get profile (auth required)

### KRS
- `GET /api/krs` - Get KRS
- `POST /api/krs` - Add KRS
- `DELETE /api/krs/:id` - Delete KRS

### Jadwal
- `GET /api/jadwal` - Get all jadwal
- `GET /api/jadwal/:id` - Get jadwal by ID

### User
- `PUT /api/user/profile` - Update profile
- `GET /api/user/saved-classes` - Get saved classes
- `POST /api/user/saved-classes` - Save class
- `DELETE /api/user/saved-classes/:jadwalId` - Unsave class
- `GET /api/user/notifications` - Get notifications

## 🗄️ Firestore Collections

- `users` - User data
- `mata_kuliah` - Mata kuliah data
- `jadwal` - Jadwal kelas
- `krs` - KRS records
- `saved_classes` - Saved classes
- `notifications` - User notifications
- `otp_codes` - OTP for password reset

## 📝 License

MIT
