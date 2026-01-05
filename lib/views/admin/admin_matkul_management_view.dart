import 'package:flutter/material.dart';
import '../../models/matkul_model.dart';
import '../../services/api_service.dart';
import 'admin_matkul_form_view.dart';

class AdminMatkulManagementView extends StatefulWidget {
  const AdminMatkulManagementView({super.key});

  @override
  State<AdminMatkulManagementView> createState() =>
      _AdminMatkulManagementViewState();
}

class _AdminMatkulManagementViewState extends State<AdminMatkulManagementView> {
  List<MataKuliah> listMatkul = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMataKuliah();
  }

  Future<void> _loadMataKuliah() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Fetch mata kuliah from backend
      final response = await ApiService.get('/mata-kuliah', requiresAuth: true);

      if (response['success'] == true) {
        final List<dynamic> matkulData = response['data'] ?? [];
        setState(() {
          listMatkul = matkulData
              .map((json) => MataKuliah.fromJson(json))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = response['error'] ?? 'Gagal memuat data mata kuliah';
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

  void _navigateToAddMatkulForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminMatkulFormView()),
    );

    if (result != null && result is MataKuliah) {
      _showSnack("Mata kuliah berhasil ditambahkan");
      _loadMataKuliah(); // Reload data
    }
  }

  void _navigateToEditMatkulForm(MataKuliah matkul) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminMatkulFormView(matkulEdit: matkul),
      ),
    );

    if (result != null && result is MataKuliah) {
      _showSnack("Data mata kuliah berhasil diperbarui");
      _loadMataKuliah(); // Reload data
    }
  }

  Future<void> _deleteMatkul(MataKuliah matkul) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Mata Kuliah?"),
        content: Text(
          "Yakin ingin menghapus ${matkul.nama}? Data akan hilang permanen.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm == true && matkul.id != null) {
      try {
        final response = await ApiService.delete(
          '/mata-kuliah/${matkul.id}',
          requiresAuth: true,
        );

        if (response['success'] == true) {
          _showSnack("Mata kuliah berhasil dihapus");
          _loadMataKuliah(); // Reload data
        } else {
          _showSnack("Gagal menghapus mata kuliah: ${response['error']}");
        }
      } catch (e) {
        _showSnack("Error: ${e.toString()}");
      }
    }
  }

  void _showSnack(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EBE3),
      body: RefreshIndicator(
        onRefresh: _loadMataKuliah,
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
                      onPressed: _loadMataKuliah,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Coba Lagi"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006A4E),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            else if (listMatkul.isEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.folder_off, size: 80, color: Colors.grey),
                    SizedBox(height: 10),
                    Text("Belum ada Mata Kuliah yang diinput"),
                  ],
                ),
              )
            else
              ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: listMatkul.length,
                itemBuilder: (context, index) {
                  final matkul = listMatkul[index];
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
                          "${matkul.sks}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      title: Text(
                        matkul.nama,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text("Kode: ${matkul.kode}"),
                          Text("SKS: ${matkul.sks}"),
                          if (matkul.semester != null)
                            Text("Semester: ${matkul.semester}"),
                          if (matkul.prodi != null && matkul.prodi!.isNotEmpty)
                            Text("Prodi: ${matkul.prodi}"),
                          if (matkul.description != null &&
                              matkul.description!.isNotEmpty)
                            Text(
                              matkul.description!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () =>
                                  _navigateToEditMatkulForm(matkul),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteMatkul(matkul),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton.extended(
                onPressed: _navigateToAddMatkulForm,
                backgroundColor: const Color(0xFF006A4E),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Tambah Matkul",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
