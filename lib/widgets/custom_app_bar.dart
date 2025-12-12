import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? actionButton; // Tombol di kanan (bisa null)

  const CustomAppBar({super.key, required this.title, this.actionButton});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      automaticallyImplyLeading: false, // Hilangkan tombol back default
      toolbarHeight: 100,
      // 1. Logo & Judul di Kiri
      title: Row(
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 35, // Sesuaikan ukuran logo
            height: 35,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),

      // 2. Tombol Aksi di Kanan (Opsional)
      actions: [
        if (actionButton != null)
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: actionButton,
          ),
      ],
    );
  }

  // Wajib ada agar bisa masuk slot 'appBar' di Scaffold
  @override
  Size get preferredSize => const Size.fromHeight(100);
}
