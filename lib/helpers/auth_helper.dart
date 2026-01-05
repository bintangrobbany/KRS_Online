import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userNimKey = 'user_nim';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userProdiKey = 'user_prodi';
  static const String _userSemesterKey = 'user_semester';
  static const String _userRoleKey = 'user_role';

  // Save login data
  static Future<void> saveLoginData({
    required String token,
    required String userId,
    required String nim,
    required String name,
    required String email,
    String? prodi,
    required int semester,
    String? role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_userNimKey, nim);
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userProdiKey, (prodi ?? '').trim());
    await prefs.setInt(_userSemesterKey, semester);
    await prefs.setString(_userRoleKey, role ?? 'mahasiswa');
  }

  // Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Get user ID
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // Get user NIM
  static Future<String?> getUserNim() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNimKey);
  }

  // Get user name
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  // Get user email
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  // Get user prodi
  static Future<String?> getUserProdi() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userProdiKey);
  }

  // Get user semester
  static Future<int?> getUserSemester() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userSemesterKey);
  }

  // Get user role
  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }

  // Check if user is admin
  static Future<bool> isAdmin() async {
    final role = await getUserRole();
    return role == 'admin';
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Get all user data
  static Future<Map<String, dynamic>> getUserData() async {
    return {
      'userId': await getUserId(),
      'nim': await getUserNim(),
      'name': await getUserName(),
      'email': await getUserEmail(),
      'prodi': await getUserProdi(),
      'semester': await getUserSemester(),
      'role': await getUserRole(),
    };
  }
}
