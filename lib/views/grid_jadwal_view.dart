// lib/views/grid_jadwal_view.dart

import 'package:flutter/material.dart';
import '../controllers/grid_jadwal_controller.dart';

class GridJadwalView extends StatelessWidget {
  const GridJadwalView({super.key});

  @override
  Widget build(BuildContext context) {
    final GridJadwalController controller = GridJadwalController();

    // Palet Warna
    final Color bgColor = const Color(0xFFE8DFCD);
    final Color cardColor = const Color.fromARGB(255, 255, 255, 255);
    final Color textDark = const Color(0xFF1A1A1A);
    final Color textGrey = const Color(0xFF888888);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- KARTU JADWAL ---
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Form Rencana Studi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'SKS yang diambil : ${controller.totalSks}',
                    style: TextStyle(color: textGrey, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 22,
                        color: textDark,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Jadwal saya',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTimelineGrid(textGrey), // Helper widget untuk grid
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- SEKSI KELAS YANG DIAMBIL ---
            Text(
              'Kelas Yang di ambil (${controller.takenCourses.length})',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Belum ada kelas yang dipilih.',
                style: TextStyle(color: textGrey, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper untuk membangun grid jadwal
  Widget _buildTimelineGrid(Color textGrey) {
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
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Text(
                time,
                style: TextStyle(color: textGrey, fontSize: 11),
              ),
            ),
            Expanded(child: Container(height: 1, color: Colors.grey[300])),
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
        ...List.generate(11, (index) {
          int hour = 7 + index;
          return timeRow('${hour.toString().padLeft(2, '0')}:00');
        }),
      ],
    );
  }
}
