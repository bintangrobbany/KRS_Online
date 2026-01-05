import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';
import '../models/krs_model.dart';

class SavedClassesController extends ChangeNotifier {
  List<KelasMataKuliah> _savedClasses = [];
  Set<String> _savedJadwalIds = {}; // For quick lookup
  bool _isLoading = false;
  String? _error;

  List<KelasMataKuliah> get savedClasses => _savedClasses;
  Set<String> get savedJadwalIds => _savedJadwalIds;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool isSaved(String jadwalId) => _savedJadwalIds.contains(jadwalId);

  Future<void> loadSavedClasses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.get(
        '${ApiConfig.user}/saved-classes',
        requiresAuth: true,
      );

      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        print('DEBUG: Saved classes data count: ${data.length}');

        _savedClasses = data
            .map((json) {
              // Map backend response to KelasMataKuliah
              final jadwal = json['jadwal'];
              print('DEBUG: jadwal data: $jadwal');

              if (jadwal != null) {
                return KelasMataKuliah.fromJson(jadwal);
              }
              return null;
            })
            .whereType<KelasMataKuliah>()
            .toList();

        print('DEBUG: Parsed saved classes count: ${_savedClasses.length}');
        _savedJadwalIds = _savedClasses.map((k) => k.id).toSet();
      }
    } catch (e) {
      _error = e.toString();
      _savedClasses = [];
      _savedJadwalIds = {};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> toggleSaveClass(String jadwalId) async {
    try {
      if (isSaved(jadwalId)) {
        // Unsave
        await ApiService.delete(
          '${ApiConfig.user}/saved-classes/$jadwalId',
          requiresAuth: true,
        );
        _savedJadwalIds.remove(jadwalId);
        _savedClasses.removeWhere((k) => k.id == jadwalId);
      } else {
        // Save
        await ApiService.post('${ApiConfig.user}/saved-classes', {
          'jadwalId': jadwalId,
        }, requiresAuth: true);
        _savedJadwalIds.add(jadwalId);
        // Don't add to _savedClasses yet, will be loaded on next refresh
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
