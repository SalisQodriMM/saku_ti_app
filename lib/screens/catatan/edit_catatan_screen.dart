import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../services/auth_service.dart';
import '../../models/note_model.dart';
import '../../widgets/loading_widget.dart';

class EditCatatanScreen extends StatefulWidget {
  final NoteModel note; // Data lama dikirim ke sini

  const EditCatatanScreen({super.key, required this.note});

  @override
  State<EditCatatanScreen> createState() => _EditCatatanScreenState();
}

class _EditCatatanScreenState extends State<EditCatatanScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Isi form dengan data lama
    _titleController.text = widget.note.title;
    _contentController.text = widget.note.content;
  }

  void _updateNote() async {
    final user = AuthService().currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    
    // Gunakan ID dari note lama, tapi isi dari controller baru
    final updatedNote = NoteModel(
      id: widget.note.id,
      title: _titleController.text,
      content: _contentController.text,
    );

    await DatabaseService().updateNote(user.uid, updatedNote);
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pop(context);
    }
  }

  void _deleteNote() async {
    final user = AuthService().currentUser;
    if (user == null) return;

    // Konfirmasi Hapus
    bool confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Catatan"),
        content: const Text("Yakin ingin menghapus catatan ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Batal")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Hapus", style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;

    if (confirm) {
      setState(() => _isLoading = true);
      await DatabaseService().deleteNote(user.uid, widget.note.id);
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Catatan", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading 
        ? const LoadingWidget(message: "Memproses...")
        : Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF00C48C), // Hijau
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Field Judul
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(hintText: "Judul", border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Field Isi
                  Container(
                    height: 300,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: _contentController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(hintText: "Isi...", border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Row Tombol: Hapus & Simpan
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _deleteNote,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text("Hapus", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _updateNote,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B5E20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text("Simpan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
    );
  }
}