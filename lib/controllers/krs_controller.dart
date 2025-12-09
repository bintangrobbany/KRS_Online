import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/krs_model.dart';

class KRSController {
  static final KRSController _instance = KRSController._internal();
  static SharedPreferences? _prefsInstance;

  factory KRSController() {
    return _instance;
  }

  KRSController._internal();

  SharedPreferences? _prefs;
  bool _initialized = false;

  // In-memory storage for current session
  List<KelasMataKuliah> _availableClasses = [];
  List<DaftarKelasMahasiswa> _enrolledClasses = [];
  List<DaftarKelasMahasiswa> _queuedClasses = [];
  String? _currentMahasiswaUid;

  // Callbacks for UI updates
  List<Function()> _listeners = [];

  Future<void> _ensureInitialized() async {
    if (_initialized && _prefs != null) return;

    if (_prefsInstance != null) {
      _prefs = _prefsInstance;
    } else {
      _prefs = await SharedPreferences.getInstance();
      _prefsInstance = _prefs;
    }

    if (!_initialized) {
      _currentMahasiswaUid =
          _prefs?.getString('userUID') ??
          _prefs?.getString('username') ??
          'default_user';
      await _loadEnrollmentData();
      _initialized = true;
    }
  }

  Future<void> initialize(SharedPreferences prefs) async {
    _prefs = prefs;
    _prefsInstance = prefs;
    _currentMahasiswaUid =
        _prefs!.getString('userUID') ??
        _prefs!.getString('username') ??
        'default_user';
    await _loadEnrollmentData();
    _initialized = true;
  }

  Future<void> _loadEnrollmentData() async {
    final enrolledJson =
        _prefs?.getString('enrolled_classes_$_currentMahasiswaUid') ?? '[]';
    final queuedJson =
        _prefs?.getString('queued_classes_$_currentMahasiswaUid') ?? '[]';

    try {
      _enrolledClasses = (jsonDecode(enrolledJson) as List)
          .map((e) => DaftarKelasMahasiswa.fromJson(e))
          .toList();
      _queuedClasses = (jsonDecode(queuedJson) as List)
          .map((e) => DaftarKelasMahasiswa.fromJson(e))
          .toList();
    } catch (e) {
      print('Error loading enrollment data: $e');
      _enrolledClasses = [];
      _queuedClasses = [];
    }
  }

  void setAvailableClasses(List<KelasMataKuliah> classes) {
    _availableClasses = classes;
    notifyListeners();
  }

  List<KelasMataKuliah> getAvailableClasses() => _availableClasses;

  List<DaftarKelasMahasiswa> getEnrolledClasses() => _enrolledClasses;

  List<DaftarKelasMahasiswa> getQueuedClasses() => _queuedClasses;

  // Get all classes combined with enrollment status
  List<(KelasMataKuliah, DaftarKelasMahasiswa?)> getClassesWithStatus() {
    List<(KelasMataKuliah, DaftarKelasMahasiswa?)> result = [];

    for (var kelas in _availableClasses) {
      // Check if enrolled
      DaftarKelasMahasiswa? enrollment;
      try {
        enrollment = _enrolledClasses.firstWhere((e) => e.kelasId == kelas.id);
      } catch (e) {
        enrollment = null;
      }

      // Check if queued
      DaftarKelasMahasiswa? queue;
      try {
        queue = _queuedClasses.firstWhere((e) => e.kelasId == kelas.id);
      } catch (e) {
        queue = null;
      }

      result.add((kelas, enrollment ?? queue));
    }

    return result;
  }

  Future<bool> enrollClass(
    KelasMataKuliah kelas, {
    bool isQueue = false,
  }) async {
    print(
      'DEBUG KRSController.enrollClass: Starting for ${kelas.namaMataKuliah}',
    );
    print('DEBUG: _initialized = $_initialized, _prefs = $_prefs');

    // Don't await _ensureInitialized to avoid blocking main thread
    // Just ensure it's running in background
    _ensureInitialized();

    // Give a moment for initialization to start
    await Future.delayed(const Duration(milliseconds: 10));

    print('DEBUG: After delay, _initialized = $_initialized');

    // Check if already enrolled or queued
    DaftarKelasMahasiswa? existingEnrollment;
    try {
      existingEnrollment = _enrolledClasses.firstWhere(
        (e) => e.kelasId == kelas.id,
      );
    } catch (e) {
      existingEnrollment = null;
    }

    DaftarKelasMahasiswa? existingQueue;
    try {
      existingQueue = _queuedClasses.firstWhere((e) => e.kelasId == kelas.id);
    } catch (e) {
      existingQueue = null;
    }

    if (existingEnrollment != null || existingQueue != null) {
      print('DEBUG: Already enrolled or queued, returning false');
      return false; // Already enrolled or queued
    }

    final enrollment = DaftarKelasMahasiswa(
      id: _generateId(),
      mahasiswaUid: _currentMahasiswaUid ?? '',
      kelasId: kelas.id,
      namaMataKuliah: kelas.namaMataKuliah,
      sks: kelas.sks,
      jadwal: kelas.jadwal,
      ruangan: kelas.ruangan,
      tglDaftar: DateTime.now(),
      status: isQueue ? 'antrian' : 'terdaftar',
    );

    if (isQueue) {
      _queuedClasses.add(enrollment);
    } else {
      _enrolledClasses.add(enrollment);
      print(
        'DEBUG: Added to _enrolledClasses, count = ${_enrolledClasses.length}',
      );
    }

    print('DEBUG: Before _saveEnrollmentData');
    // Save data in background WITHOUT awaiting to avoid blocking
    _saveEnrollmentData()
        .then((_) {
          print('DEBUG: Background save completed');
        })
        .catchError((e) {
          print('DEBUG: Background save error: $e');
        });

    print('DEBUG: After _saveEnrollmentData trigger (not awaited)');

    notifyListeners();
    print('DEBUG: enrollClass completed successfully');
    return true;
  }

  Future<bool> removeEnrollment(String kelasId, {bool isQueued = false}) async {
    // Don't await _ensureInitialized to avoid blocking
    _ensureInitialized();
    await Future.delayed(const Duration(milliseconds: 10));

    if (isQueued) {
      _queuedClasses.removeWhere((e) => e.kelasId == kelasId);
    } else {
      _enrolledClasses.removeWhere((e) => e.kelasId == kelasId);
    }

    // Save data in background WITHOUT awaiting
    _saveEnrollmentData().catchError((e) {
      print('DEBUG: Background save error in removeEnrollment: $e');
    });

    notifyListeners();
    return true;
  }

  Future<bool> moveFromQueueToEnrolled(String kelasId) async {
    // Don't await _ensureInitialized to avoid blocking
    _ensureInitialized();
    await Future.delayed(const Duration(milliseconds: 10));

    final queueIndex = _queuedClasses.indexWhere((e) => e.kelasId == kelasId);
    if (queueIndex == -1) return false;

    final queuedEnrollment = _queuedClasses[queueIndex];
    _queuedClasses.removeAt(queueIndex);
    _enrolledClasses.add(
      queuedEnrollment.copyWith(status: 'terdaftar', tglDaftar: DateTime.now()),
    );

    // Save data in background WITHOUT awaiting
    _saveEnrollmentData().catchError((e) {
      print('DEBUG: Background save error in moveFromQueueToEnrolled: $e');
    });

    notifyListeners();
    return true;
  }

  Future<void> _saveEnrollmentData() async {
    if (_currentMahasiswaUid == null || _prefs == null) return;

    final enrolledJson = jsonEncode(
      _enrolledClasses.map((e) => e.toJson()).toList(),
    );
    final queuedJson = jsonEncode(
      _queuedClasses.map((e) => e.toJson()).toList(),
    );

    await _prefs!.setString(
      'enrolled_classes_$_currentMahasiswaUid',
      enrolledJson,
    );
    await _prefs!.setString('queued_classes_$_currentMahasiswaUid', queuedJson);
  }

  void addListener(Function() callback) {
    _listeners.add(callback);
  }

  void removeListener(Function() callback) {
    _listeners.remove(callback);
  }

  void notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<void> clearAllEnrollments() async {
    _enrolledClasses.clear();
    _queuedClasses.clear();
    await _saveEnrollmentData();
    notifyListeners();
  }
}
