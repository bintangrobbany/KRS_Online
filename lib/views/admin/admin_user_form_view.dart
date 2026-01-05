import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';

class AdminUserFormView extends StatefulWidget {
  final User? userEdit;

  const AdminUserFormView({super.key, this.userEdit});

  @override
  State<AdminUserFormView> createState() => _AdminUserFormViewState();
}

class _AdminUserFormViewState extends State<AdminUserFormView> {
  late TextEditingController _nimController;
  late TextEditingController _passwordController;
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _noHpController;
  late TextEditingController _prodiController;
  late TextEditingController _semesterController;

  bool _isSubmitting = false;

  final Color primaryColor = const Color(0xFF006A4E);
  final Color backgroundColor = const Color(0xFFF0EBE3);

  @override
  void initState() {
    super.initState();
    _nimController = TextEditingController(text: widget.userEdit?.nim ?? '');
    _passwordController = TextEditingController(
      text: widget.userEdit?.password ?? '',
    );
    _namaController = TextEditingController(text: widget.userEdit?.nama ?? '');
    _emailController = TextEditingController(
      text: widget.userEdit?.email ?? '',
    );
    _noHpController = TextEditingController(text: widget.userEdit?.noHp ?? '');
    _prodiController = TextEditingController(
      text: widget.userEdit?.prodi ?? '',
    );
    _semesterController = TextEditingController(
      text: widget.userEdit?.semester?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nimController.dispose();
    _passwordController.dispose();
    _namaController.dispose();
    _emailController.dispose();
    _noHpController.dispose();
    _prodiController.dispose();
    _semesterController.dispose();
    super.dispose();
  }

  Future<void> _saveUser() async {
    final nim = _nimController.text.replaceAll(RegExp(r'\s+'), '').trim();
    final password = _passwordController.text.trim();
    final nama = _namaController.text.trim();
    final email = _emailController.text.trim();
    final noHp = _noHpController.text.trim();
    final prodi = _prodiController.text.trim();
    final semesterText = _semesterController.text.trim();

    if (nim.isEmpty ||
        (widget.userEdit == null && password.isEmpty) ||
        nama.isEmpty ||
        email.isEmpty ||
        noHp.isEmpty ||
        prodi.isEmpty ||
        semesterText.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Semua field harus diisi")));
      return;
    }

    final semester = int.tryParse(semesterText);
    if (semester == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semester harus berupa angka")),
      );
      return;
    }

    // Rentang semester (aman): 1-14
    if (semester < 1 || semester > 14) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semester harus antara 1-14")),
      );
      return;
    }

    // Sesuai aturan login: mahasiswa wajib NIM 15 digit numeric
    if (!RegExp(r'^\d+$').hasMatch(nim)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("NIM harus berupa angka")));
      return;
    }

    if (nim.length != 15) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("NIM harus 15 digit")));
      return;
    }

    // Basic email validation (match backend requirement isEmail)
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Email tidak valid")));
      return;
    }

    // Backend requires min 6 chars for create; for edit only validate if provided
    if ((widget.userEdit == null && password.length < 6) ||
        (widget.userEdit != null &&
            password.isNotEmpty &&
            password.length < 6)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password minimal 6 karakter")),
      );
      return;
    }

    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final newUser = User(
        id: widget.userEdit?.id,
        nim: nim,
        password: password.isEmpty ? null : password,
        nama: nama,
        email: email,
        noHp: noHp,
        prodi: prodi,
        semester: semester,
      );

      final body = newUser.toJson();

      // Saat edit: kalau password kosong, jangan kirim password (biar tidak overwrite)
      if (widget.userEdit != null && _passwordController.text.isEmpty) {
        body.remove('password');
      }

      final dynamic response;
      if (widget.userEdit == null) {
        response = await ApiService.post(
          '/user/users',
          body,
          requiresAuth: true,
        );
      } else {
        if (widget.userEdit?.id == null) {
          throw ApiException('User ID tidak ditemukan untuk update');
        }
        response = await ApiService.put(
          '/user/users/${widget.userEdit!.id}',
          body,
          requiresAuth: true,
        );
      }

      if (response is Map && response['success'] == true) {
        final createdOrUpdated = User.fromJson(
          (response['data'] ?? {}) as Map<String, dynamic>,
        );
        if (mounted) {
          Navigator.pop(context, createdOrUpdated);
        }
      } else {
        final message = (response is Map)
            ? (response['error'] ??
                  response['message'] ??
                  'Gagal menyimpan user')
            : 'Gagal menyimpan user';
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message.toString())));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userEdit != null ? "Edit User" : "Tambah User"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // NIM Field
            TextField(
              controller: _nimController,
              keyboardType: TextInputType.number,
              enabled: widget.userEdit == null,
              decoration: InputDecoration(
                labelText: "NIM",
                hintText: "Masukkan NIM mahasiswa",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.badge),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Masukkan password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.lock),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Nama Field
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                labelText: "Nama Mahasiswa",
                hintText: "Masukkan nama lengkap",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.person),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Email Field
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Masukkan email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.email),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // No HP Field
            TextField(
              controller: _noHpController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "No. HP",
                hintText: "Masukkan nomor HP",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.phone),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Prodi / Jurusan Field
            TextField(
              controller: _prodiController,
              decoration: InputDecoration(
                labelText: "Jurusan / Prodi",
                hintText: "Contoh: Teknik Informatika",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.account_balance),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Semester Field
            TextField(
              controller: _semesterController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Semester",
                hintText: "Contoh: 4",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.school),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Simpan
            ElevatedButton(
              onPressed: _isSubmitting ? null : _saveUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      widget.userEdit != null ? "Perbarui User" : "Tambah User",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
            const SizedBox(height: 12),

            // Tombol Batal
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Batal",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
