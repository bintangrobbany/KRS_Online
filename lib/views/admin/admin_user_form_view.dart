import 'package:flutter/material.dart';
import '../../models/user_model.dart';

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
  }

  @override
  void dispose() {
    _nimController.dispose();
    _passwordController.dispose();
    _namaController.dispose();
    _emailController.dispose();
    _noHpController.dispose();
    super.dispose();
  }

  void _saveUser() {
    if (_nimController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _namaController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _noHpController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Semua field harus diisi")));
      return;
    }

    if (_nimController.text.length != 15) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("NIM harus 15 digit")));
      return;
    }

    final newUser = User(
      nim: _nimController.text,
      password: _passwordController.text,
      nama: _namaController.text,
      email: _emailController.text,
      noHp: _noHpController.text,
    );

    Navigator.pop(context, newUser);
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
                labelText: "NIM (15 digit)",
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
            const SizedBox(height: 32),

            // Tombol Simpan
            ElevatedButton(
              onPressed: _saveUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
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
