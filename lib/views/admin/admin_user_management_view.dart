import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'admin_user_form_view.dart';

class AdminUserManagementView extends StatefulWidget {
  const AdminUserManagementView({super.key});

  @override
  State<AdminUserManagementView> createState() =>
      _AdminUserManagementViewState();
}

class _AdminUserManagementViewState extends State<AdminUserManagementView> {
  // Data dummy pengguna
  List<User> listUser = [
    User(
      nim: '123456789012345',
      password: 'password123',
      nama: 'Ahmad Rizki',
      email: 'ahmad@example.com',
      noHp: '081234567890',
    ),
    User(
      nim: '123456789012346',
      password: 'password456',
      nama: 'Siti Nurhaliza',
      email: 'siti@example.com',
      noHp: '081234567891',
    ),
  ];

  void _navigateToAddUserForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminUserFormView()),
    );

    if (result != null && result is User) {
      setState(() {
        listUser.add(result);
      });
      _showSnack("User berhasil ditambahkan");
    }
  }

  void _navigateToEditUserForm(int index, User user) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminUserFormView(userEdit: user),
      ),
    );

    if (result != null && result is User) {
      setState(() {
        listUser[index] = result;
      });
      _showSnack("Data user berhasil diperbarui");
    }
  }

  void _deleteUser(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus User?"),
        content: const Text("Data user ini akan hilang permanen."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                listUser.removeAt(index);
              });
              Navigator.pop(context);
              _showSnack("User dihapus");
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
          listUser.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.person_off, size: 80, color: Colors.grey),
                      SizedBox(height: 10),
                      Text("Belum ada user yang didaftarkan"),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: listUser.length,
                  itemBuilder: (context, index) {
                    final user = listUser[index];
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
                            user.nama[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        title: Text(
                          user.nama,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6),
                            Text("NIM: ${user.nim}"),
                            Text("Email: ${user.email}"),
                            Text("No. HP: ${user.noHp}"),
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
                                    _navigateToEditUserForm(index, user),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _deleteUser(index),
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
              onPressed: _navigateToAddUserForm,
              backgroundColor: const Color(0xFF006A4E),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Tambah User",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
