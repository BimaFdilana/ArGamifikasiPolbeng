// lib/main_page.dart

import 'package:flutter/material.dart';
import 'features/missions/presentation/pages/home_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0; // 0 = Misi, 1 = Profil

  final List<Widget> _pages = [
    const HomePage(),
    const ProfilePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onArButtonPressed() {
    // TODO: Buka halaman kamera AR (Unity)
    // Navigator.of(context).pushNamed('/ar_camera');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Halaman Kamera AR Belum Dibuat'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gunakan IndexedStack agar state halaman (cth: scroll position)
      // di HomePage dan ProfilePage tidak hilang saat berpindah tab
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      // Tombol AR (Tombol tengah yang besar)
      floatingActionButton: FloatingActionButton(
        onPressed: _onArButtonPressed,
        shape: const CircleBorder(),
        elevation: 2.0,
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12.0,
          unselectedFontSize: 12.0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Misi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
