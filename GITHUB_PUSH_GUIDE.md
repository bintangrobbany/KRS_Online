# 📤 Cara Push ke GitHub Repository

## Step 1: Initialize Git (Jika belum)

Cek apakah sudah ada git:
```bash
git status
```

Jika belum diinit:
```bash
git init
```

## Step 2: Pastikan .gitignore Sudah Benar

File `backend/.gitignore` sudah mengecualikan:
- ✅ `serviceAccountKey.json` (TIDAK akan di-push)
- ✅ `node_modules/`
- ✅ `.env`

## Step 3: Create GitHub Repository

1. Buka https://github.com
2. Klik tombol **New Repository** (+)
3. Isi:
   - **Repository name:** `KRS_Online` (atau nama lain)
   - **Description:** "Aplikasi mobile KRS Online - Flutter & Node.js"
   - **Visibility:** Private atau Public (pilih Private untuk keamanan)
4. **JANGAN** centang "Initialize with README" (karena sudah ada)
5. Klik **Create repository**

## Step 4: Add Remote & Push

Copy URL repository dari GitHub, lalu:

```bash
# Add remote (ganti <URL> dengan URL repo GitHub kamu)
git remote add origin <URL>

# Contoh:
# git remote add origin https://github.com/username/KRS_Online.git

# Cek remote
git remote -v

# Stage semua file (kecuali yang di .gitignore)
git add .

# Commit
git commit -m "Initial commit: KRS Online app with Flutter & Node.js backend"

# Push ke GitHub
git push -u origin main

# Atau jika branch utama adalah master:
# git push -u origin master
```

## Step 5: Verifikasi

Buka repository di GitHub dan pastikan:
- ✅ File `SETUP_GUIDE.md` ada
- ✅ File `backend/serviceAccountKey.example.json` ada (template)
- ❌ File `backend/serviceAccountKey.json` TIDAK ADA (aman!)
- ✅ Semua folder lib/, backend/, android/, ios/ terupload

## ⚠️ PENTING: Keamanan

### File yang TIDAK BOLEH ada di GitHub:
- ❌ `backend/serviceAccountKey.json` (credential Firebase)
- ❌ `backend/.env` (environment variables)

### Jika tidak sengaja ter-push:
```bash
# Hapus file dari git history (HATI-HATI!)
git rm --cached backend/serviceAccountKey.json
git commit -m "Remove sensitive file"
git push

# Regenerate Firebase key di Firebase Console
# (karena key yang lama sudah exposed)
```

## 📝 Commit Message Guidelines

Gunakan format yang jelas:
```bash
# Format: <type>: <description>

# Contoh:
git commit -m "feat: add save class feature"
git commit -m "fix: resolve ANR issue on second login"
git commit -m "docs: update setup guide"
git commit -m "refactor: convert HomeController to singleton"
```

Types:
- `feat`: Feature baru
- `fix`: Bug fix
- `docs`: Dokumentasi
- `refactor`: Refactor code
- `style`: Formatting
- `test`: Testing

## 🔄 Workflow untuk Rekan Kerja

Setelah di-push, rekan kerja bisa:

```bash
# 1. Clone repository
git clone <URL_REPOSITORY>
cd KRS_Online

# 2. Ikuti SETUP_GUIDE.md untuk:
#    - Install dependencies
#    - Setup Firebase key (download sendiri dari Firebase Console)
#    - Configure API base URL
#    - Run backend dan Flutter app

# 3. Development workflow
git checkout -b feature/nama-feature
# ... coding ...
git add .
git commit -m "feat: add new feature"
git push origin feature/nama-feature

# 4. Create Pull Request di GitHub
```

## 📦 Branch Strategy (Recommended)

```bash
main/master     # Production-ready code
  ↓
develop         # Integration branch
  ↓
feature/*       # Feature branches
```

Buat branch untuk feature baru:
```bash
git checkout -b feature/admin-dashboard
# ... develop ...
git push origin feature/admin-dashboard
```

## 🔍 Cek Status Sebelum Push

Selalu cek sebelum push:
```bash
# Cek file yang akan di-commit
git status

# Cek diff
git diff

# Pastikan tidak ada file sensitif
git ls-files | grep -i "key\|secret\|credential"
```

---

**Happy Coding! 🚀**
