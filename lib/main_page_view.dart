import 'package:flutter/material.dart';

// Import semua Halaman utama dari folder views/
import 'views/home_view.dart';
import 'views/notifikasi_view.dart';
import 'views/saved_classes_view.dart';
import 'views/profile_view.dart';
import 'views/settings_view.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({super.key});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  // Index halaman yang sedang aktif: 0 (Notifikasi) sampai 4 (Settings)
  int _selectedIndex = 2; // Default ke Home

  // Daftar halaman (Views) yang diakses melalui NavBar
  final List<Widget> _pages = [
    const NotifikasiView(),
    const SavedClassesView(),
    const HomeView(),
    const ProfileView(),
    const SettingsView(),
  ];

  // Palet Warna
  final Color bgCanvas = const Color(0xFFE8DFCD);
  final Color primaryGreen = const Color(0xFF054F40);

  // Fungsi untuk berpindah halaman
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Helper Widget untuk setiap item di Bottom Navigation Bar
  Widget _buildNavItem(int index, IconData unselectedIcon, String label) {
    final bool isSelected = index == _selectedIndex;

    // Logika untuk Tombol HOME yang menonjol (index 2)
    if (index == 2) {
      return IconButton(
        padding: EdgeInsets.zero,
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: bgCanvas, shape: BoxShape.circle),
          child: Icon(Icons.home_outlined, color: primaryGreen, size: 28),
        ),
        onPressed: () => _onItemTapped(index), // HOME kembali ke index 2
        tooltip: label,
      );
    }

    // Logika untuk tombol lainnya
    return IconButton(
      icon: Icon(unselectedIcon, color: isSelected ? bgCanvas : Colors.white),
      onPressed: () => _onItemTapped(index),
      tooltip: label,
      iconSize: 24,
      color: isSelected ? primaryGreen : Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCanvas,
      // Body akan menampilkan halaman yang sesuai dengan index. IndexedStack menjaga state.
      body: IndexedStack(index: _selectedIndex, children: _pages),

      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(color: primaryGreen),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, Icons.chat_bubble_outline, 'Notifikasi'),
            _buildNavItem(1, Icons.bookmark_border, 'Saved Classes'),
            _buildNavItem(2, Icons.home_outlined, 'Home'), // Tombol Home
            _buildNavItem(3, Icons.person_outline, 'Profile'),
            _buildNavItem(4, Icons.settings_outlined, 'Settings'),
          ],
        ),
      ),
    );
  }
}
