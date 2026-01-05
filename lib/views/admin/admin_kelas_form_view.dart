import 'package:flutter/material.dart';
import '../../config/api_config.dart';
import '../../services/api_service.dart';

class AdminKelasFormView extends StatefulWidget {
  final String? jadwalId;

  const AdminKelasFormView({super.key, this.jadwalId});

  @override
  State<AdminKelasFormView> createState() => _AdminKelasFormViewState();
}

class _AdminKelasFormViewState extends State<AdminKelasFormView> {
  final Color primaryColor = const Color(0xFF006A4E);
  final Color backgroundColor = const Color(0xFFF0EBE3);

  late final BorderRadius _fieldRadius = BorderRadius.circular(12);
  late final OutlineInputBorder _fieldBorder = OutlineInputBorder(
    borderRadius: _fieldRadius,
  );

  final TextEditingController _dosenController = TextEditingController();
  final TextEditingController _ruanganController = TextEditingController();
  final TextEditingController _kodeKelasController = TextEditingController();
  final TextEditingController _kuotaController = TextEditingController();
  final TextEditingController _jamMulaiController = TextEditingController();
  final TextEditingController _jamSelesaiController = TextEditingController();

  final List<String> _hariOptions = const [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  late final List<DropdownMenuItem<String>> _hariDropdownItems;
  List<DropdownMenuItem<String>> _mataKuliahDropdownItems = const [];

  bool _isLoadingInit = true; // Start as true so we show loading immediately
  bool _isSubmitting = false;
  bool _hasStartedLoading = false;
  String? _selectedHari;
  String? _selectedMataKuliahId;

  static const Duration _editLoadTimeout = Duration(seconds: 3);
  String _loadingLabel = 'Memuat...';

  bool get _isEdit => widget.jadwalId != null;

  void _normalizeSelectedValues() {
    final selectedMk = _selectedMataKuliahId;
    if (selectedMk != null && selectedMk.isNotEmpty) {
      final exists = _mataKuliahDropdownItems.any(
        (it) => it.value == selectedMk,
      );
      if (!exists) {
        _selectedMataKuliahId = null;
      }
    }

    final selectedHari = _selectedHari;
    if (selectedHari != null && selectedHari.isNotEmpty) {
      if (!_hariOptions.contains(selectedHari)) {
        _selectedHari = null;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // DO NOTHING - let the screen render first completely
    // Loading will be triggered from build() after first frame
  }

  @override
  void dispose() {
    _dosenController.dispose();
    _ruanganController.dispose();
    _kodeKelasController.dispose();
    _kuotaController.dispose();
    _jamMulaiController.dispose();
    _jamSelesaiController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    // CRITICAL: Prevent multiple simultaneous calls
    if (!mounted || !_isLoadingInit) return;

    try {
      final sw = Stopwatch()..start();

      if (mounted) {
        setState(() {
          _loadingLabel = 'Memuat mata kuliah...';
        });
      }

      await _loadMataKuliahOptions();
      debugPrint(
        'AdminKelasFormView: load mata-kuliah ${sw.elapsedMilliseconds}ms',
      );

      if (_isEdit) {
        if (mounted) {
          setState(() {
            _loadingLabel = 'Memuat detail jadwal...';
          });
        }
        await _loadJadwalById(widget.jadwalId!);
        debugPrint(
          'AdminKelasFormView: load jadwalById total ${sw.elapsedMilliseconds}ms',
        );
      }

      // Build dropdown items AFTER data loaded (not in initState)
      _hariDropdownItems = _hariOptions
          .map((h) => DropdownMenuItem<String>(value: h, child: Text(h)))
          .toList(growable: false);

      // Avoid DropdownButtonFormField assertion when selected value
      // is not present in the loaded items.
      _normalizeSelectedValues();
    } catch (e) {
      debugPrint('AdminKelasFormView: Error loading data: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingInit = false;
        });
      }
    }
  }

  Future<void> _loadMataKuliahOptions() async {
    final response = await ApiService.get(
      '${ApiConfig.mataKuliah}?format=dropdown',
      requiresAuth: true,
      timeout: _editLoadTimeout,
    );
    if (response is Map && response['success'] == true) {
      final List<dynamic> data = response['data'] ?? [];

      // Cache dropdown items once to avoid heavy rebuild work.
      _mataKuliahDropdownItems = data
          .whereType<Map>()
          .map((e) => e.cast<String, dynamic>())
          .where((mk) => (mk['id'] ?? '').toString().isNotEmpty)
          .map(
            (mk) => DropdownMenuItem<String>(
              value: mk['id'].toString(),
              child: Text(
                '${(mk['kodeMk'] ?? '').toString()} - ${(mk['namaMk'] ?? '').toString()}',
              ),
            ),
          )
          .toList(growable: false);
    }
  }

  Future<void> _loadJadwalById(String id) async {
    final response = await ApiService.get(
      '${ApiConfig.jadwal}/$id',
      requiresAuth: true,
      timeout: _editLoadTimeout,
    );
    if (response is Map && response['success'] == true) {
      final Map<String, dynamic> data = (response['data'] ?? {})
          .cast<String, dynamic>();

      _selectedMataKuliahId = data['mataKuliahId']?.toString();
      _dosenController.text = (data['dosen'] ?? '').toString();
      _ruanganController.text = (data['ruangan'] ?? '').toString();
      _kodeKelasController.text = (data['kodeKelas'] ?? '').toString();
      _kuotaController.text = (data['kuota'] ?? '').toString();
      _selectedHari = (data['hari'] ?? '').toString().isEmpty
          ? null
          : (data['hari'] ?? '').toString();
      _jamMulaiController.text = (data['jamMulai'] ?? '').toString();
      _jamSelesaiController.text = (data['jamSelesai'] ?? '').toString();
    }
  }

  Future<void> _save() async {
    if (_isSubmitting) return;

    if (_selectedMataKuliahId == null || _selectedMataKuliahId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mata kuliah harus dipilih')),
      );
      return;
    }

    if (_selectedHari == null || _selectedHari!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Hari harus dipilih')));
      return;
    }

    if (_jamMulaiController.text.trim().isEmpty ||
        _jamSelesaiController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jam mulai & selesai harus diisi')),
      );
      return;
    }

    final kuota = int.tryParse(_kuotaController.text.trim());
    if (kuota == null || kuota < 1) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Kuota harus angka >= 1')));
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final payload = <String, dynamic>{
        'mataKuliahId': _selectedMataKuliahId,
        'dosen': _dosenController.text.trim(),
        'ruangan': _ruanganController.text.trim(),
        'hari': _selectedHari,
        'jamMulai': _jamMulaiController.text.trim(),
        'jamSelesai': _jamSelesaiController.text.trim(),
        'kuota': kuota,
        'kodeKelas': _kodeKelasController.text.trim(),
      };

      final dynamic response;
      if (_isEdit) {
        response = await ApiService.put(
          '${ApiConfig.jadwal}/${widget.jadwalId}',
          payload,
          requiresAuth: true,
        );
      } else {
        response = await ApiService.post(
          ApiConfig.jadwal,
          payload,
          requiresAuth: true,
        );
      }

      if (response is Map && response['success'] == true) {
        if (mounted) {
          Navigator.pop(context, true);
        }
        return;
      }

      final message = (response is Map)
          ? (response['error'] ??
                response['message'] ??
                'Gagal menyimpan kelas')
          : 'Gagal menyimpan kelas';
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message.toString())));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Don't build ANY form widgets until data is loaded (prevents ANR during navigation)
    if (_isLoadingInit) {
      // Trigger loading AFTER this loading screen is rendered
      if (!_hasStartedLoading) {
        _hasStartedLoading = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _loadInitialData();
        });
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(_isEdit ? 'Edit Kelas' : 'Tambah Kelas'),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
        backgroundColor: backgroundColor,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 12),
              Text(_loadingLabel, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Kelas' : 'Tambah Kelas'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              key: ValueKey('mata_kuliah_${_selectedMataKuliahId ?? "null"}'),
              initialValue: _selectedMataKuliahId,
              isExpanded: true,
              items: _mataKuliahDropdownItems,
              onChanged: (v) => setState(() => _selectedMataKuliahId = v),
              decoration: InputDecoration(
                labelText: 'Mata Kuliah',
                border: _fieldBorder,
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.book),
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              key: ValueKey('hari_${_selectedHari ?? "null"}'),
              initialValue: _selectedHari,
              isExpanded: true,
              items: _hariDropdownItems,
              onChanged: (v) => setState(() => _selectedHari = v),
              decoration: InputDecoration(
                labelText: 'Hari',
                border: _fieldBorder,
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.calendar_month),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _jamMulaiController,
                    decoration: InputDecoration(
                      labelText: 'Jam Mulai',
                      hintText: '08:00',
                      border: _fieldBorder,
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.schedule),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _jamSelesaiController,
                    decoration: InputDecoration(
                      labelText: 'Jam Selesai',
                      hintText: '10:00',
                      border: _fieldBorder,
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.schedule_outlined),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _dosenController,
              decoration: InputDecoration(
                labelText: 'Dosen',
                border: _fieldBorder,
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _ruanganController,
              decoration: InputDecoration(
                labelText: 'Ruangan',
                border: _fieldBorder,
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.meeting_room),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _kuotaController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Kuota',
                      border: _fieldBorder,
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.numbers),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _kodeKelasController,
                    decoration: InputDecoration(
                      labelText: 'Kode Kelas (opsional)',
                      border: _fieldBorder,
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.tag),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _save,
              icon: _isSubmitting
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_isSubmitting ? 'Menyimpan...' : 'Simpan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
