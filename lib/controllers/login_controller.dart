import 'package:flutter/material.dart';
import '../models/login_model.dart';

class LoginController with ChangeNotifier {
  final LoginModel _model = LoginModel();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  bool get isPasswordObscured => _model.isPasswordObscured;


  void togglePasswordVisibility() {
    _model.isPasswordObscured = !_model.isPasswordObscured;
    notifyListeners(); 
  }

  // Method untuk menangani logika login
  void login(BuildContext context) {
    final String username = usernameController.text;
    final String password = passwordController.text;
    print("Attempting login with Username: $username and Password: $password");

    if (username.isNotEmpty && password.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Berhasil (Placeholder)")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username dan Password tidak boleh kosong")),
      );
    }
  }

  
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}