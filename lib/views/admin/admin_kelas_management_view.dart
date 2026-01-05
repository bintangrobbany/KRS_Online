import 'package:flutter/material.dart';
import '../../models/krs_model.dart';
import '../../services/api_service.dart';
import '../../config/api_config.dart';
import 'admin_kelas_form_view.dart';

class AdminKelasManagementView extends StatefulWidget {
  const AdminKelasManagementView({super.key});

  @override
  State<AdminKelasManagementView> createState() =>
      _AdminKelasManagementViewState();
}

class _AdminKelasManagementViewState extends State<AdminKelasManagementView> {
  List<KelasMataKuliah> listKelas = [];
  bool isLoading = true;
  String? errorMessage;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _loadKelas();
  }

  Future<void> _loadKelas() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await ApiService.get(
        '${ApiConfig.jadwal}?format=kelas',
        requiresAuth: true,
      );

      if (response['success'] == true) {
        final List<dynamic> kelasData = response['data'] ?? [];
        setState(() {
          listKelas = kelasData
              .map((json) => KelasMataKuliah.fromJson(json))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = response['error'] ?? 'Gagal memuat data kelas';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _navigateToAddKelasForm() async {
    if (_isNavigating) return;
    if (!mounted) return;

    debugPrint('AdminKelas: Tap Add button');
    setState(() {
      _isNavigating = true;
    });

    try {
      _showSnack('Membuka form tambah...');
      // Longer delay to ensure UI updates before navigation
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;

      debugPrint('AdminKelas: Pushing Add route');
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminKelasFormView()),
      );
      debugPrint('AdminKelas: Add route returned: $result');
      if (result == true) {
        _showSnack('Kelas berhasil ditambahkan');
        _loadKelas();
      }
    } catch (e) {
      debugPrint('AdminKelas: Error in Add: $e');
      _showSnack('Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isNavigating = false;
        });
      }
    }
  }

  Future<void> _navigateToEditKelasForm(String jadwalId) async {
    if (_isNavigating) return;
    if (!mounted) return;

    debugPrint('AdminKelas: Tap Edit button for jadwalId=$jadwalId');
    setState(() {
      _isNavigating = true;
    });

    try {
      _showSnack('Membuka form edit...');

      // Longer delay to ensure UI updates before navigation
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;

      debugPrint('AdminKelas: Pushing Edit route');
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdminKelasFormView(jadwalId: jadwalId),
        ),
      );
      debugPrint('AdminKelas: Edit route returned: $result');
      if (result == true) {
        _showSnack('Kelas berhasil diperbarui');
        _loadKelas();
      }
    } catch (e) {
      debugPrint('AdminKelas: Error in Edit: $e');
      _showSnack('Error saat membuka edit: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isNavigating = false;
        });
      }
    }
  }

  Future<void> _deleteKelas(KelasMataKuliah kelas) async {
    if (_isNavigating) return;
    if (!mounted) return;

    debugPrint('AdminKelas: Tap Delete button for ${kelas.id}');

    setState(() {
      _isNavigating = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 10));
      if (!mounted) return;

      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Hapus Kelas?'),
          content: Text(
            'Yakin ingin menghapus kelas ${kelas.namaMataKuliah}?\n\nKelas akan dinonaktifkan agar aman untuk data KRS yang sudah ada.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus'),
            ),
          ],
        ),
      );

      if (confirm != true) return;
      if (kelas.id.isEmpty) {
        _showSnack('Jadwal ID tidak ditemukan');
        return;
      }

      debugPrint('AdminKelas: Deleting jadwal ${kelas.id}');
      final response = await ApiService.delete(
        '${ApiConfig.jadwal}/${kelas.id}',
        requiresAuth: true,
      );
      if (response is Map && response['success'] == true) {
        _showSnack('Kelas berhasil dihapus');
        _loadKelas();
      } else {
        _showSnack('Gagal menghapus kelas');
      }
    } catch (e) {
      debugPrint('AdminKelas: Error in Delete: $e');
      _showSnack('Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isNavigating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EBE3),
      body: RefreshIndicator(
        onRefresh: _loadKelas,
        child: Stack(
          children: [
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (errorMessage != null)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 80,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 10),
                    Text(errorMessage!, textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _loadKelas,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006A4E),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            else if (listKelas.isEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.folder_off, size: 80, color: Colors.grey),
                    SizedBox(height: 10),
                    Text('Belum ada kelas/jadwal yang aktif'),
                  ],
                ),
              )
            else
              ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: listKelas.length,
                itemBuilder: (context, index) {
                  final kelas = listKelas[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF006A4E),
                        child: Text(
                          '${kelas.sks}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      title: Text(
                        kelas.namaMataKuliah,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text('Kode: ${kelas.kodeMataKuliah}'),
                          Text('Jadwal: ${kelas.jadwal}'),
                          if (kelas.dosen.isNotEmpty)
                            Text('Dosen: ${kelas.dosen}'),
                          if (kelas.ruangan.isNotEmpty)
                            Text('Ruangan: ${kelas.ruangan}'),
                          Text(
                            'Kuota: ${kelas.pendaftarSaat}/${kelas.kapasitas}',
                          ),
                          if (kelas.prodi != null && kelas.prodi!.isNotEmpty)
                            Text('Prodi: ${kelas.prodi}'),
                          if (kelas.semester != null)
                            Text('Semester: ${kelas.semester}'),
                        ],
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: _isNavigating
                                  ? null
                                  : () => _navigateToEditKelasForm(kelas.id),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: _isNavigating
                                  ? null
                                  : () => _deleteKelas(kelas),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            if (_isNavigating)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    color: Colors.black26,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton.extended(
                onPressed: _isNavigating ? null : _navigateToAddKelasForm,
                icon: const Icon(Icons.add),
                label: const Text('Tambah Kelas'),
                backgroundColor: const Color(0xFF006A4E),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
