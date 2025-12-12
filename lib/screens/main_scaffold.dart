import 'package:flutter/material.dart';

// Import halaman-halaman
import 'home_screen.dart';
import 'materi/materi_screen.dart';
import 'catatan/catatan_screen.dart';
import 'project/project_screen.dart';
import 'todo/todo_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(onNavigate: _onItemTapped), // 0: Home
      const MateriScreen(), // 1: Materi
      const CatatanScreen(), // 2: Catatan
      const ProjectScreen(), // 3: Project
      const TodoScreen(), // 4: Tugas
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Agar body meluas ke belakang bottom bar (opsional, biar terlihat seamless)
      extendBody: true,

      body: IndexedStack(index: _selectedIndex, children: _pages),
      // Bungkus dengan SafeArea agar tidak tertutup tombol sistem HP
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 72, // Tinggi Bar
          // Margin agar bar "melayang" dan tidak nempel pinggir/bawah
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF2F6BFF),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  0.3,
                ),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_filled, 0),
              _buildNavItem(Icons.book, 1),
              _buildNavItem(Icons.edit_square, 2),
              _buildNavItem(Icons.folder, 3),
              _buildNavItem(Icons.check_circle, 4),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Item Navigasi (Icon Only & Besar)
  Widget _buildNavItem(IconData icon, int index) {
    final bool isActive = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isActive
              ? const Color(0xFF2F6BFF)
              : Colors.white.withOpacity(0.8),
          size: 24,
        ),
      ),
    );
  }
}
