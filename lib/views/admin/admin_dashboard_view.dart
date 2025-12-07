import 'package:flutter/material.dart';
import '../../../models/matkul_model.dart'; // Pastikan model sudah dibuat
import '../login_view.dart'; // Untuk navigasi logout
import '../form_matkul_view.dart'; // Untuk pindah ke halaman form

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  // --- Data Dummy (Simulasi Database Lokal) ---
  // Nanti data ini diganti dengan data dari API/Firebase
  List<MataKuliah> listMatkul = [
    MataKuliah(
      kode: "TI001",
      nama: "Algoritma Pemrograman",
      sks: 3,
      jadwal: "Senin, 08:00",
    ),
    MataKuliah(
      kode: "TI002",
      nama: "Basis Data",
      sks: 4,
      jadwal: "Selasa, 10:00",
    ),
    MataKuliah(
      kode: "TI003",
      nama: "Pemrograman Mobile",
      sks: 3,
      jadwal: "Rabu, 13:00",
    ),
  ];

  // Fungsi untuk Menambah Data (Menerima data dari Form)
  void _navigateToAddForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormMatkulView()),
    );

    if (result != null && result is MataKuliah) {
      setState(() {
        listMatkul.add(result);
      });
      _showSnack("Mata kuliah berhasil ditambahkan");
    }
  }

  // Fungsi untuk Edit Data
  void _navigateToEditForm(int index, MataKuliah matkul) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormMatkulView(matkulEdit: matkul),
      ),
    );

    if (result != null && result is MataKuliah) {
      setState(() {
        listMatkul[index] = result;
      });
      _showSnack("Data berhasil diperbarui");
    }
  }

  // Fungsi Hapus Data
  void _deleteMatkul(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Data?"),
        content: const Text("Data ini akan hilang permanen."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                listMatkul.removeAt(index);
              });
              Navigator.pop(context);
              _showSnack("Data dihapus");
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // Fungsi Logout
  void _handleLogout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola KRS (Admin)"),
        backgroundColor: const Color(
          0xFF006A4E,
        ), // Warna hijau sesuai tema loginmu
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: "Logout",
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF0EBE3),

      // TAMPILAN LIST
      body: listMatkul.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.folder_off, size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("Belum ada Mata Kuliah yang diinput"),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: listMatkul.length,
              itemBuilder: (context, index) {
                final item = listMatkul[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF006A4E),
                      child: Text(
                        "${item.sks}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      item.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("Kode: ${item.kode}"),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(item.jadwal),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Tombol Edit
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _navigateToEditForm(index, item),
                        ),
                        // Tombol Hapus
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteMatkul(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      // TOMBOL TAMBAH (Floating Action Button)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddForm,
        backgroundColor: const Color(0xFF006A4E),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Tambah Matkul",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
