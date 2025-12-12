import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/database_service.dart';
import '../../services/auth_service.dart';
import '../../models/note_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/loading_widget.dart';
import 'tambah_catatan_screen.dart';
import 'edit_catatan_screen.dart';

class CatatanScreen extends StatefulWidget {
  const CatatanScreen({super.key});

  @override
  State<CatatanScreen> createState() => _CatatanScreenState();
}

class _CatatanScreenState extends State<CatatanScreen> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = AuthService().currentUser;

    // 2. WAJIB ADA: Dengarkan jika user Login/Logout dari Home
    AuthService().authStateChanges.listen((user) {
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    });
  }

  // Fungsi Refresh Halaman (dipanggil setelah tambah/edit)
  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Cek Login
    if (_currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("Silakan Login di menu Home.")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Catatan",
        // Tombol Tambah di Kanan Atas
        actionButton: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.add, color: Colors.black, size: 20),
          ),
          onPressed: () async {
            // Navigasi ke Halaman Tambah
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TambahCatatanScreen(),
              ),
            );
            _refresh(); // Refresh list setelah kembali
          },
        ),
      ),
      body: FutureBuilder<List<NoteModel>>(
        future: DatabaseService().getNotes(_currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(message: "Memuat catatan...");
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Belum ada catatan. Buat baru yuk!"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final note = snapshot.data![index];
              return GestureDetector(
                onTap: () async {
                  // Navigasi ke Detail/Edit
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditCatatanScreen(note: note),
                    ),
                  );
                  _refresh();
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C48C), // Warna Hijau Sesuai Desain
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18, // Judul agak besar
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        note.content,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        maxLines: 3, // Preview 3 baris saja
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
