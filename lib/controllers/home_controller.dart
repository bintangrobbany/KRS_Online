// lib/controllers/home_controller.dart

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../helpers/auth_helper.dart';
import '../config/api_config.dart';
import '../models/user_model.dart';
import '../models/krs_model.dart';

class HomeController extends ChangeNotifier {
  // Singleton pattern with lazy initialization
  static final HomeController _instance = HomeController._internal();
  factory HomeController() => _instance;

  HomeController._internal(); // Don't load data in constructor!

  User? _currentUser;
  List<DaftarKelasMahasiswa> _myKrsList = [];
  bool _isLoading = false;
  String? _error;
  bool _hasLoadedOnce = false; // Track if data was loaded

  User? get currentUser => _currentUser;
  List<DaftarKelasMahasiswa> get myKrsList => _myKrsList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Getter untuk backward compatibility dengan UI lama
  User? get model => _currentUser;

  // Getter untuk data profile
  String get studentName => _currentUser?.nama ?? '';
  String get nim => _currentUser?.nim ?? '';
  String get programStudi => _currentUser?.prodi ?? '';
  int get semester => _currentUser?.semester ?? 0;
  String get email => _currentUser?.email ?? '';
  String? get phoneNumber => _currentUser?.noHp;
  String? get profileImageUrl => _currentUser?.photoUrl;
  double get ipk => _currentUser?.ipk ?? 0.0;
  int get maxSks => _currentUser?.maxSks ?? 24;

  // Getter untuk KRS yang approved (untuk backward compatibility dengan UI yang ada)
  List<Map<String, dynamic>> get approvedCoursesForSchedule {
    return _myKrsList.where((krs) => krs.status == 'approved').map((krs) {
      final detail = krs.kelasDetail;
      return {
        'name': detail?.namaMataKuliah ?? '',
        'time': detail?.jadwal ?? '',
        'sks': detail?.sks ?? 0,
        'status': 'Aktif',
        'day': detail?.hari ?? '',
      };
    }).toList();
  }

  // Getter untuk total SKS
  int get totalSksTaken {
    if (_myKrsList.isEmpty) return 0;
    return _myKrsList
        .where((krs) => krs.status == 'approved')
        .fold(0, (sum, krs) => sum + (krs.kelasDetail?.sks ?? 0));
  }

  // Load user profile dan KRS dari backend
  Future<void> loadUserData() async {
    // Prevent multiple concurrent loads
    if (_isLoading) {
      print('HomeController: Already loading, skipping...');
      return;
    }

    print('HomeController: Starting loadUserData...');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Load user profile
      await loadProfile();
      print('HomeController: Profile loaded - ${_currentUser?.nama}');

      // Load user's KRS
      await loadMyKrs();
      print('HomeController: KRS loaded - ${_myKrsList.length} items');

      _hasLoadedOnce = true;
    } catch (e) {
      print('HomeController: Error in loadUserData - $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
      print('HomeController: loadUserData completed');
    }
  }

  // Load user profile dari API
  Future<void> loadProfile() async {
    try {
      final response = await ApiService.get(ApiConfig.profile);

      if (response['success'] == true) {
        _currentUser = User.fromJson(response['data']);
        notifyListeners();
      }
    } catch (e) {
      print('Error loading profile: $e');
      // Try to load from local storage
      final userData = await AuthHelper.getUserData();
      if (userData['name'] != null) {
        _currentUser = User(
          id: userData['userId'],
          nim: userData['nim'] ?? '',
          nama: userData['name'] ?? '',
          email: userData['email'] ?? '',
          prodi: userData['prodi'],
          semester: userData['semester'],
        );
        notifyListeners();
      }
    }
  }

  // Load KRS mahasiswa dari API
  Future<void> loadMyKrs() async {
    try {
      final response = await ApiService.get(ApiConfig.krs);

      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        _myKrsList = data
            .map((json) => DaftarKelasMahasiswa.fromJson(json))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading KRS: $e');
      _myKrsList = [];
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    await loadUserData();
  }

  // Update profile
  Future<bool> updateProfile({
    String? name,
    String? phoneNumber,
    String? photoUrl,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (phoneNumber != null) body['phoneNumber'] = phoneNumber;
      if (photoUrl != null) body['photoUrl'] = photoUrl;

      final response = await ApiService.put(ApiConfig.userProfile, body);

      if (response['success'] == true) {
        _currentUser = User.fromJson(response['data']);
        _isLoading = false;
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await AuthHelper.logout();
    _currentUser = null;
    _myKrsList = [];
    notifyListeners();
  }

  // Legacy methods untuk backward compatibility
  void removeKrsItem(int index) {
    if (index >= 0 && index < _myKrsList.length) {
      // Akan dihandle di KRS controller
    }
  }
}
