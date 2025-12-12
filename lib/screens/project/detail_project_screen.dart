import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../services/auth_service.dart';
import '../../models/project_model.dart';
import 'edit_project_screen.dart';

class DetailProjectScreen extends StatefulWidget {
  final ProjectModel project;
  const DetailProjectScreen({super.key, required this.project});

  @override
  State<DetailProjectScreen> createState() => _DetailProjectScreenState();
}

class _DetailProjectScreenState extends State<DetailProjectScreen> {
  late ProjectModel _project; // Local state untuk update checklist instan

  @override
  void initState() {
    super.initState();
    _project = widget.project;
  }

  void _updateProgress(int index, bool val) async {
    final user = AuthService().currentUser;
    if (user == null) return;

    setState(() {
      _project.timelines[index].isCompleted = val;
    });

    // Kirim update seluruh objek project ke Firebase (agar sync)
    await DatabaseService().updateProject(user.uid, _project);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF536DFE),
      appBar: AppBar(
        title: const Text(
          "Detail Projek",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nama Projek",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(_project.title, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Mulai: ${_project.startDate}"),
                Text("Selesai: ${_project.endDate}"),
              ],
            ),

            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: const Color(0xFF536DFE),
              child: const Center(
                child: Text(
                  "Timeline atau Tugas",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // LIST CHECKLIST TIMELINE
            Expanded(
              child: ListView.builder(
                itemCount: _project.timelines.length,
                itemBuilder: (context, index) {
                  final task = _project.timelines[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CheckboxListTile(
                      title: Text(task.name),
                      value: task.isCompleted,
                      activeColor: Colors.black,
                      onChanged: (val) => _updateProgress(index, val ?? false),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // TOMBOL EDIT & HAPUS
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Navigate to Edit
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditProjectScreen(project: _project),
                        ),
                      );
                      // Refresh parent (Project Screen) when back
                      // ignore: use_build_context_synchronously
                      if (mounted) Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    child: const Text(
                      "Edit",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // --- TOMBOL HAPUS DENGAN KONFIRMASI ---
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // 1. Tampilkan Dialog Konfirmasi
                      bool confirm = await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Hapus Projek"),
                          content: const Text("Yakin ingin menghapus projek ini?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false), // Batal
                              child: const Text("Batal"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true), // Ya, Hapus
                              child: const Text("Hapus", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ) ?? false; // Default false jika dialog ditutup paksa

                      // 2. Jika user pilih "Hapus", jalankan logika delete
                      if (confirm) {
                        final user = AuthService().currentUser;
                        if (user != null) {
                          await DatabaseService().deleteProject(
                            user.uid,
                            _project.id,
                          );
                          // ignore: use_build_context_synchronously
                          if (mounted) Navigator.pop(context); // Kembali ke list project
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      "Hapus",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}