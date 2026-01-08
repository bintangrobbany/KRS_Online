import 'package:flutter/foundation.dart';

class ApiConfig {
  // ========================================
  // PRODUCTION & DEVELOPMENT CONFIGURATION
  // ========================================

  // PRODUCTION URL (Backend hosted on Netlify)
  static const String _productionUrl =
      'https://backend-krs-online.netlify.app/api';

  // DEVELOPMENT URL (Local backend for testing)
  // Update IP sesuai komputer Anda: ipconfig (Windows) atau ifconfig (Mac/Linux)
  static const String _developmentUrl = 'http://192.168.1.10:3000/api';

  // Auto-detect: Release build = production, Debug build = development
  // Bisa juga manual override dengan set _useProduction = true
  static const bool _useProduction =
      true; // Set true untuk test production atau build APK

  static String get baseUrl {
    // Jika manual override diset
    if (_useProduction) return _productionUrl;

    // Auto detect berdasarkan build mode
    return kReleaseMode ? _productionUrl : _developmentUrl;
  }

  // ========================================
  // DEVELOPMENT URLS (untuk referensi)
  // ========================================
  // Android Emulator: 'http://10.0.2.2:3000/api'
  // Mobile Hotspot: 'http://192.168.137.1:3000/api'
  // iOS Simulator: 'http://localhost:3000/api'
  // Real Device (same Wi-Fi): 'http://192.168.x.x:3000/api'

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
