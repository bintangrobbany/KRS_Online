class ApiConfig {
  // Base URL - Ganti dengan IP komputer Anda atau gunakan emulator
  // IMPORTANT: Jika emulator tidak bisa connect ke 10.0.2.2, gunakan IP lokal komputer
  //
  // Cara cek IP komputer:
  // Windows: ipconfig | Select-String "IPv4"
  // Mac/Linux: ifconfig | grep "inet "
  //
  // Untuk Android Emulator: 10.0.2.2 (jika tidak work, gunakan IP lokal)
  // Untuk iOS Simulator: localhost atau 127.0.0.1
  // Untuk Real Device: IP Address komputer (contoh: 192.168.1.10)

  // GUNAKAN SALAH SATU (uncomment yang sesuai):

  // Option 1: Android Emulator (default)
  // static const String baseUrl = 'http://10.0.2.2:3000/api';

  // Option 2: Mobile Hotspot (laptop jadi hotspot, HP connect ke laptop)
  // static const String baseUrl = 'http://192.168.137.1:3000/api';

  // Option 3: IP Lokal untuk Real Device di Wi-Fi yang sama (Wi-Fi Cafe)
  static const String baseUrl = 'http://172.16.176.59:3000/api';

  // Option 4: iOS Simulator
  // static const String baseUrl = 'http://localhost:3000/api';

  // Timeout duration - keep reasonably short to avoid "feels like freeze"
  // when backend is unreachable (especially on real devices).
  static const Duration timeoutDuration = Duration(seconds: 15);
  static const int maxRetries = 1;

  // Endpoints
  static const String auth = '/auth';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String profile = '/auth/profile';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';

  static const String mataKuliah = '/mata-kuliah';
  static const String jadwal = '/jadwal';
  static const String krs = '/krs';

  static const String user = '/user';
  static const String userProfile = '/user/profile';
  static const String savedClasses = '/user/saved-classes';
  static const String notifications = '/user/notifications';
}
