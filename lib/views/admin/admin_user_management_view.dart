import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';
import 'admin_user_form_view.dart';

class AdminUserManagementView extends StatefulWidget {
  const AdminUserManagementView({super.key});

  @override
  State<AdminUserManagementView> createState() =>
      _AdminUserManagementViewState();
}

class _AdminUserManagementViewState extends State<AdminUserManagementView> {
  List<User> listUser = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Fetch users from backend
      final response = await ApiService.get('/user/users', requiresAuth: true);

      if (response['success'] == true) {
        final List<dynamic> usersData = response['data'] ?? [];
        setState(() {
          listUser = usersData.map((json) => User.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = response['error'] ?? 'Gagal memuat data user';
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

  void _navigateToAddUserForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminUserFormView()),
    );

    if (result != null && result is User) {
      _showSnack("User berhasil ditambahkan");
      _loadUsers(); // Reload data
    }
  }

  void _navigateToEditUserForm(User user) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminUserFormView(userEdit: user),
      ),
    );

    if (result != null && result is User) {
      _showSnack("Data user berhasil diperbarui");
      _loadUsers(); // Reload data
    }
  }

  Future<void> _deleteUser(User user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus User?"),
        content: Text(
          "Yakin ingin menghapus user ${user.nama}? Data akan hilang permanen.",
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

    if (confirm == true && user.id != null) {
      try {
        final response = await ApiService.delete(
          '/user/users/${user.id}',
          requiresAuth: true,
        );

        if (response['success'] == true) {
          _showSnack("User berhasil dihapus");
          _loadUsers(); // Reload data
        } else {
          _showSnack("Gagal menghapus user: ${response['error']}");
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
        onRefresh: _loadUsers,
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
                      onPressed: _loadUsers,
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
            else if (listUser.isEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.person_off, size: 80, color: Colors.grey),
                    SizedBox(height: 10),
                    Text("Belum ada user yang didaftarkan"),
                  ],
                ),
              )
            else
              ListView.builder(
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
                        backgroundColor: user.isAdmin
                            ? Colors.orange
                            : const Color(0xFF006A4E),
                        child: user.photoUrl != null
                            ? ClipOval(
                                child: Image.network(
                                  user.photoUrl!,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Text(
                                    user.nama[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              )
                            : Text(
                                user.nama[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              user.nama,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (user.isAdmin)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'ADMIN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text("NIM: ${user.nim}"),
                          Text("Email: ${user.email}"),
                          if (user.noHp != null && user.noHp!.isNotEmpty)
                            Text("No. HP: ${user.noHp}"),
                          if (user.prodi != null && user.prodi!.isNotEmpty)
                            Text("Prodi: ${user.prodi}"),
                          if (user.semester != null)
                            Text("Semester: ${user.semester}"),
                          if (user.isActive != null)
                            Row(
                              children: [
                                Icon(
                                  user.isActive!
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  size: 14,
                                  color: user.isActive!
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  user.isActive! ? 'Aktif' : 'Nonaktif',
                                  style: TextStyle(
                                    color: user.isActive!
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
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
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _navigateToEditUserForm(user),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteUser(user),
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
      ),
    );
  }
}
