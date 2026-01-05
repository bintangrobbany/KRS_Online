import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';
import '../models/krs_model.dart';

class KRSController extends ChangeNotifier {
  List<KelasMataKuliah> _availableClasses = [];
  List<DaftarKelasMahasiswa> _myKrsList = [];
  bool _isLoading = false;
  String? _error;

  List<KelasMataKuliah> get availableClasses => _availableClasses;
  List<DaftarKelasMahasiswa> get myKrsList => _myKrsList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get enrolled classes (approved + pending)
  List<DaftarKelasMahasiswa> get enrolledClasses {
    return _myKrsList
        .where((krs) => krs.status == 'approved' || krs.status == 'pending')
        .toList();
  }

  // Get queued/pending classes
  List<DaftarKelasMahasiswa> get queuedClasses {
    return _myKrsList.where((krs) => krs.status == 'pending').toList();
  }

  // Load available classes (jadwal) dari backend
  Future<void> loadAvailableClasses({
    String? prodi,
    int? semester,
    String? hari,
    String? search,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      String endpoint = '${ApiConfig.jadwal}?format=kelas';
      if (prodi != null) endpoint += '&prodi=$prodi';
      if (semester != null) endpoint += '&semester=$semester';
      if (hari != null) endpoint += '&hari=$hari';
      if (search != null) endpoint += '&search=$search';

      final response = await ApiService.get(endpoint);

      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        _availableClasses = data
            .map((json) => KelasMataKuliah.fromJson(json))
            .toList();
      }
    } catch (e) {
      _error = e.toString();
      _availableClasses = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load my KRS
  Future<void> loadMyKrs({String? semester, String? tahunAjaran}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      String endpoint = ApiConfig.krs;
      List<String> params = [];
      if (semester != null) params.add('semester=$semester');
      if (tahunAjaran != null) params.add('tahunAjaran=$tahunAjaran');
      if (params.isNotEmpty) {
        endpoint += '?${params.join('&')}';
      }

      final response = await ApiService.get(endpoint);

      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        _myKrsList = data
            .map((json) => DaftarKelasMahasiswa.fromJson(json))
            .toList();
      }
    } catch (e) {
      _error = e.toString();
      _myKrsList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add class to KRS
  Future<bool> addKRS({
    required String jadwalId,
    required String semester,
    required String tahunAjaran,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await ApiService.post(ApiConfig.krs, {
        'jadwalId': jadwalId,
        'semester': semester,
        'tahunAjaran': tahunAjaran,
      });

      if (response['success'] == true) {
        // Reload KRS list
        await loadMyKrs(semester: semester, tahunAjaran: tahunAjaran);
        return true;
      }

      _error = response['error'] ?? 'Gagal menambahkan KRS';
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete KRS
  Future<bool> deleteKRS(String krsId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await ApiService.delete('${ApiConfig.krs}/$krsId');

      if (response['success'] == true) {
        // Remove from local list
        _myKrsList.removeWhere((krs) => krs.id == krsId);
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _error = response['error'] ?? 'Gagal menghapus KRS';
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Check if class is already enrolled
  bool isClassEnrolled(String jadwalId) {
    return _myKrsList.any((krs) => krs.jadwalId == jadwalId);
  }

  // Get classes with enrollment status
  List<(KelasMataKuliah, bool)> getClassesWithStatus() {
    return _availableClasses.map((kelas) {
      final isEnrolled = isClassEnrolled(kelas.id);
      return (kelas, isEnrolled);
    }).toList();
  }

  // Calculate total SKS
  int getTotalSks() {
    return _myKrsList
        .where((krs) => krs.status == 'approved' || krs.status == 'pending')
        .fold(0, (sum, krs) => sum + (krs.kelasDetail?.sks ?? 0));
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Refresh all data
  Future<void> refresh({
    String? semester,
    String? tahunAjaran,
    String? prodi,
  }) async {
    await Future.wait([
      loadAvailableClasses(
        prodi: prodi,
        semester: semester != null ? int.tryParse(semester) : null,
      ),
      loadMyKrs(semester: semester, tahunAjaran: tahunAjaran),
    ]);
  }
}
