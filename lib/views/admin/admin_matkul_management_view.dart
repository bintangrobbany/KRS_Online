import 'package:flutter/material.dart';
import '../../models/matkul_model.dart';
import 'admin_matkul_form_view.dart';

class AdminMatkulManagementView extends StatefulWidget {
  const AdminMatkulManagementView({super.key});

  @override
  State<AdminMatkulManagementView> createState() =>
      _AdminMatkulManagementViewState();
}

class _AdminMatkulManagementViewState extends State<AdminMatkulManagementView> {
  // Data dummy mata kuliah
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

  void _navigateToAddMatkulForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminMatkulFormView()),
    );

    if (result != null && result is MataKuliah) {
      setState(() {
        listMatkul.add(result);
      });
      _showSnack("Mata kuliah berhasil ditambahkan");
    }
  }

  void _navigateToEditMatkulForm(int index, MataKuliah matkul) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminMatkulFormView(matkulEdit: matkul),
      ),
    );

    if (result != null && result is MataKuliah) {
      setState(() {
        listMatkul[index] = result;
      });
      _showSnack("Data mata kuliah berhasil diperbarui");
    }
  }

  void _deleteMatkul(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Mata Kuliah?"),
        content: const Text("Data mata kuliah ini akan hilang permanen."),
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
              _showSnack("Mata kuliah dihapus");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EBE3),
      body: Stack(
        children: [
          listMatkul.isEmpty
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
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(matkul.jadwal),
                              ],
                            ),
                          ],
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () =>
                                    _navigateToEditMatkulForm(index, matkul),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _deleteMatkul(index),
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
    );
  }
}
