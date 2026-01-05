import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ConnectionChecker {
  /// Test if backend server is reachable
  static Future<bool> checkBackendConnection() async {
    try {
      print('Testing connection to: ${ApiConfig.baseUrl}');

      // Use health check endpoint instead of login
      final url = Uri.parse('${ApiConfig.baseUrl}/health');
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      print('Connection test - Status code: ${response.statusCode}');
      print('Connection test - Response: ${response.body}');

      // Accept any 2xx or 404 status as "server is reachable"
      return response.statusCode >= 200 && response.statusCode < 500;
    } on SocketException catch (e) {
      print('SocketException: $e');
      print('Backend tidak dapat dijangkau. Pastikan:');
      print('1. Backend berjalan di port 3000');
      print('2. Gunakan IP yang benar:');
      print('   - Emulator Android: http://10.0.2.2:3000/api');
      print('   - Real Device: http://[IP_KOMPUTER]:3000/api');
      return false;
    } on TimeoutException catch (e) {
      print('TimeoutException: $e');
      print(
        'Backend timeout - mungkin terlalu lambat atau tidak dapat dijangkau',
      );
      return false;
    } catch (e) {
      print('Connection test error: $e');
      // If we get other errors, maybe the server is there but endpoint is wrong
      // Let's still try to proceed
      return true;
    }
  }

  /// Get local machine IP address
  static Future<String?> getLocalIpAddress() async {
    try {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
            return addr.address;
          }
        }
      }
    } catch (e) {
      print('Error getting IP: $e');
    }
    return null;
  }
}
