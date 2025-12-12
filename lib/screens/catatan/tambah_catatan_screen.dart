import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../services/auth_service.dart';
import '../../models/note_model.dart';
import '../../widgets/loading_widget.dart';

class TambahCatatanScreen extends StatefulWidget {
  const TambahCatatanScreen({super.key});

  @override
  State<TambahCatatanScreen> createState() => _TambahCatatanScreenState();
}

class _TambahCatatanScreenState extends State<TambahCatatanScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isLoading = false;

  void _saveNote() async {
    final user = AuthService().currentUser;
    if (user == null || _titleController.text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final newNote = NoteModel(
        id: '', // ID diisi otomatis Firebase
        title: _titleController.text,
        content: _contentController.text,
      );

      await DatabaseService().addNote(user.uid, newNote);
      
      if (mounted) Navigator.pop(context); // Kembali ke list
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Tambah Catatan", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading 
        ? const LoadingWidget(message: "Menyimpan...")
        : Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            height: double.infinity, // Full screen container
            decoration: BoxDecoration(
              color: const Color(0xFF00C48C), 
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Input Judul
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: "Judul Catatan",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Input Isi (Area Besar)
                  Container(
                    height: 300, // Tinggi area tulis
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _contentController,
                      maxLines: null, // Unlimited lines
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: "Tulis Catatan ...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Tombol Simpan
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveNote,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20), // Hijau Tua
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Simpan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}