import 'package:flutter/material.dart';
import '../views/home_view.dart';
import '../views/admin/admin_dashboard_view.dart';
import '../services/api_service.dart';
import '../helpers/auth_helper.dart';
import '../config/api_config.dart';

class LoginController extends ChangeNotifier {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordObscured = true;
  bool _isLoading = false;

  bool get isPasswordObscured => _isPasswordObscured;
  bool get isLoading => _isLoading;

  void togglePasswordVisibility() {
    _isPasswordObscured = !_isPasswordObscured;
    notifyListeners();
  }

  Future<void> login(BuildContext context, VoidCallback onSuccess) async {
    final String rawUsername = usernameController.text;
    final String password = passwordController.text;

    final normalizedUsername = rawUsername.trim().toUpperCase();
    final isAdminLogin = normalizedUsername.startsWith('ADMIN');

    // Mahasiswa: pastikan NIM bersih dari spasi/karakter lain
    final String nim = isAdminLogin
        ? rawUsername.trim()
        : rawUsername.replaceAll(RegExp(r'\D'), '');

    // Validasi input
    if (nim.isEmpty || password.isEmpty) {
      _showError(context, "NIM dan Password tidak boleh kosong");
      return;
    }

    // Validasi NIM: mahasiswa wajib 15 digit numerik, admin dikecualikan
    if (!isAdminLogin) {
      final isNumeric15 = RegExp(r'^\d{15}$').hasMatch(nim);
      if (!isNumeric15) {
        _showError(
          context,
          "NIM harus 15 digit (angka)\nKecuali login admin (contoh: ADMIN001)",
        );
        return;
      }
    }

    _isLoading = true;
    notifyListeners();

    try {
      print('=== LOGIN ATTEMPT ===');
      print('NIM: $nim');
      print('API URL: ${ApiConfig.baseUrl}${ApiConfig.login}');

      // Test connection first (warning only, not blocking)
      // print('Testing backend connection...');
      // final canConnect = await ConnectionChecker.checkBackendConnection();
      // if (!canConnect) {
      //   print('⚠️ Warning: Health check failed, but will try login anyway...');
      // } else {
      //   print('✓ Backend connection OK');
      // }

      // Call API login (try regardless of health check)
      final response = await ApiService.post(ApiConfig.login, {
        'nim': nim,
        'password': password,
      }, requiresAuth: false);

      print('Login response: $response');

      if (response['success'] == true) {
        final userData = response['data']['user'];
        final token = response['data']['token'];

        // Simpan data login
        await AuthHelper.saveLoginData(
          token: (token ?? '').toString(),
          userId: (userData['id'] ?? '').toString(),
          nim: (userData['nim'] ?? '').toString(),
          name: (userData['name'] ?? '').toString(),
          email: (userData['email'] ?? '').toString(),
          prodi: userData['prodi']?.toString(),
          semester: userData['semester'] ?? 0,
          role: userData['role'],
        );

        // Panggil onSuccess callback untuk menampilkan dialog success
        if (context.mounted) {
          onSuccess();
        }

        // Tunggu dialog success dan berikan waktu untuk complete operations
        await Future.delayed(const Duration(milliseconds: 2500));

        // Navigate based on role
        if (context.mounted) {
          final userRole = userData['role'] ?? 'mahasiswa';

          // Use pushAndRemoveUntil to clear navigation stack
          if (userRole == 'admin') {
            // Navigate to admin dashboard
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminDashboardView(),
              ),
              (route) => false,
            );
          } else {
            // Navigate to student home
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeView()),
              (route) => false,
            );
          }
        }
      } else {
        if (context.mounted) {
          _showError(context, response['error'] ?? 'Login gagal');
        }
      }
    } catch (e) {
      print('Login error: $e');
      if (context.mounted) {
        _showError(context, 'Error: ${e.toString()}');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
