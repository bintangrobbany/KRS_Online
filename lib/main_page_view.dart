import 'package:flutter/material.dart';

// Import semua Halaman utama dari folder views/
// Pastikan nama file sesuai dengan yang ada di project Anda
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
  // Index halaman yang sedang aktif. 
  // Default kita set ke 2 agar saat aplikasi dibuka langsung ke Home (Tengah).
  int _selectedIndex = 2; 

  // Daftar halaman (Views) harus urut sesuai dengan urutan tombol di bawah (0 sampai 4)
  final List<Widget> _pages = [
    const NotifikasiView(),   // Index 0: Halaman Notifikasi
    const SavedClassesView(), // Index 1: Halaman Saved Classes
    const HomeView(),         // Index 2: Halaman Home (Tengah)
    const ProfileView(),      // Index 3: Halaman Profile
    const SettingsView(),     // Index 4: Halaman Settings
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

  // Helper Widget untuk membuat item navigasi
  Widget _buildNavItem(int index, IconData unselectedIcon, String label) {
    final bool isSelected = index == _selectedIndex;

    // KHUSUS TOMBOL HOME (Index 2 - Tengah)
    // Dibuat berbeda agar terlihat menonjol
    if (index == 2) {
      return IconButton(
        padding: EdgeInsets.zero,
        icon: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: bgCanvas, // Warna lingkaran background icon
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.home_outlined, 
            color: primaryGreen, 
            size: 30
          ),
        ),
        onPressed: () => _onItemTapped(index),
        tooltip: label,
      );
    }

    // TOMBOL NAVIGASI LAINNYA (Kiri & Kanan)
    return IconButton(
      icon: Icon(
        unselectedIcon, 
        // Jika dipilih warnanya canvas (krem), jika tidak putih
        color: isSelected ? bgCanvas : Colors.white.withOpacity(0.7)
      ),
      onPressed: () => _onItemTapped(index),
      tooltip: label,
      iconSize: 26,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCanvas,
      
      // IndexedStack menjaga state halaman agar tidak reload saat pindah tab
      body: IndexedStack(
        index: _selectedIndex, 
        children: _pages
      ),

      bottomNavigationBar: Container(
        height: 80, // Sedikit diperbesar agar nyaman
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: primaryGreen,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Membagi jarak sama rata
          children: [
            // KIRI 1: Notifikasi
            _buildNavItem(0, Icons.chat_bubble_outline, 'Notifikasi'),
            
            // KIRI 2: Saved Classes
            _buildNavItem(1, Icons.bookmark_border, 'Saved Classes'),
            
            // TENGAH: Home
            _buildNavItem(2, Icons.home_outlined, 'Home'), 
            
            // KANAN 1: Profile
            _buildNavItem(3, Icons.person_outline, 'Profile'),
            
            // KANAN 2: Settings
            _buildNavItem(4, Icons.settings_outlined, 'Settings'),
          ],
        ),
      ),
    );
  }
}