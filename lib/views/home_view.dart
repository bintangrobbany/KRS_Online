import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import '../models/home_model.dart';

// --- IMPORT HALAMAN LAIN ---
import 'daftar_kelas_view.dart'; // Halaman War Slot / Antrean
import 'profile_view.dart'; // Halaman Profil
import 'settings_view.dart'; // Halaman Settings
import 'form_krs_view.dart'; // Halaman Form Manual
import 'review_kelas_view.dart'; // Halaman Status KRS Saya

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController _controller = HomeController();

  // --- PALET WARNA ---
  final Color bgCanvas = const Color(0xFFE8DFCD);
  final Color cardWhite = const Color(0xFFFFFFFF);
  final Color primaryGreen = const Color(0xFF054F40);
  final Color textDark = const Color(0xFF1A1A1A);
  final Color textGrey = const Color(0xFF888888);
  final Color warningYellow = const Color(0xFFF57F17); // Warna Waiting List

  // Fungsi refresh saat kembali ke home agar data terupdate
  void _refreshData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCanvas,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopHeader(),
              const SizedBox(height: 16),

              // 1. Profile Card
              _buildProfileCard(context),
              const SizedBox(height: 24),

              // 2. Action Buttons (Menu Tombol Geser)
              _buildActionButtons(context),
              const SizedBox(height: 24),

              // 3. Grid Jadwal Card
              _buildGridJadwalCard(),
              const SizedBox(height: 24),

              // 4. Card Daftar Kelas (List Bawah) - SEKARANG BISA DIKLIK
              _buildDaftarKelasCard(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildTopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Selamat Datang, ${_controller.model.studentName.split(' ')[0]}!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        Text('See more', style: TextStyle(color: textGrey, fontSize: 12)),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileView()),
        ).then((_) => _refreshData());
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardWhite,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.grey[300],
              backgroundImage: NetworkImage(_controller.model.profileImageUrl),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    _controller.model.studentName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NIM : ${_controller.model.nim}',
                    style: TextStyle(color: textGrey, fontSize: 12),
                  ),
                  Text(
                    'Program Studi :\n${_controller.model.programStudi}',
                    style: TextStyle(color: textGrey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Semester',
                  style: TextStyle(color: textGrey, fontSize: 12),
                ),
                Text(
                  '${_controller.model.semester}\n${_controller.model.year}',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    ButtonStyle getStyle(Color bgColor) {
      return ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // TOMBOL 1: Form KRS
          SizedBox(
            width: 120,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FormKrsView()),
                ).then((_) => _refreshData());
              },
              style: getStyle(primaryGreen),
              child: const Text(
                'Form KRS',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // TOMBOL 2: Daftar Kelas (Ke Halaman Status/KRS Saya)
          SizedBox(
            width: 120,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReviewKelasView(),
                  ),
                ).then((_) => _refreshData());
              },
              style: getStyle(cardWhite),
              child: Text(
                'Daftar Kelas',
                style: TextStyle(color: textDark, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // TOMBOL 3: Grid Jadwal
          SizedBox(
            width: 120,
            child: ElevatedButton(
              onPressed: _controller.onGridJadwalTapped,
              style: getStyle(cardWhite),
              child: Text(
                'Grid Jadwal',
                style: TextStyle(color: textDark, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // TOMBOL 4: Review Kelas (Ke Halaman War/Antrean)
          SizedBox(
            width: 120,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DaftarKelasView(),
                  ),
                ).then((_) => _refreshData());
              },
              style: getStyle(cardWhite),
              child: Text(
                'Review Kelas',
                style: TextStyle(color: textDark, fontSize: 13),
              ),
            ),
          ),

          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _buildGridJadwalCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Grid Jadwal Kelas',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text('See more', style: TextStyle(color: textGrey, fontSize: 12)),
            ],
          ),
          Text(
            'SKS yang diambil :',
            style: TextStyle(color: textGrey, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 20, color: textDark),
              const SizedBox(width: 8),
              Text(
                'Jadwal saya',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTimelineGrid(),
        ],
      ),
    );
  }

  Widget _buildTimelineGrid() {
    Widget dayHeader(String txt) => Expanded(
      child: Center(
        child: Text(
          txt,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
    Widget timeRow(String time) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Text(
                time,
                style: TextStyle(color: textGrey, fontSize: 11),
              ),
            ),
            Expanded(child: Container(height: 1, color: Colors.grey[400])),
          ],
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 40),
            dayHeader('Sen'),
            dayHeader('Sel'),
            dayHeader('Rab'),
            dayHeader('Kam'),
            dayHeader('Jum'),
          ],
        ),
        const SizedBox(height: 10),
        timeRow('07:00'),
        timeRow('08:00'),
        timeRow('09:00'),
        timeRow('10:00'),
        timeRow('11:00'),
      ],
    );
  }

  // --- CARD BAWAH: DAFTAR KELAS (BISA DIKLIK) ---
  Widget _buildDaftarKelasCard() {
    final myClasses = _controller.myKrsList;

    // BUNGKUS DENGAN GESTURE DETECTOR
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman ReviewKelasView (Sama seperti tombol Daftar Kelas di atas)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ReviewKelasView()),
        ).then((_) => _refreshData());
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardWhite,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daftar Kelas',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                // Tampilkan jumlah kelas atau icon panah kecil
                Row(
                  children: [
                    if (myClasses.isNotEmpty)
                      Text(
                        "${myClasses.length} Kelas",
                        style: TextStyle(fontSize: 12, color: textGrey),
                      ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: textGrey,
                    ), // Indikator bisa diklik
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (myClasses.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Belum ada kelas diambil.",
                  style: TextStyle(
                    color: textGrey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else
              Column(
                children: myClasses.map((data) {
                  return _buildReviewItem(
                    data['name'],
                    "${data['time']} / ${data['sks']} sks",
                    data['status'],
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(String title, String subtitle, String status) {
    bool isWaiting = status == "Waiting List";

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(color: textGrey, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isWaiting
                  ? const Color(0xFFFFF3E0)
                  : const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: isWaiting ? warningYellow : primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(color: primaryGreen),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.white),
            onPressed: () {},
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bgCanvas, shape: BoxShape.circle),
            child: Icon(Icons.home_outlined, color: primaryGreen, size: 28),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileView()),
              ).then((_) => _refreshData());
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsView()),
              );
            },
          ),
        ],
      ),
    );
  }
}
