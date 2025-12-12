import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/database_service.dart';
import '../../services/auth_service.dart';
import '../../models/todo_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/loading_widget.dart';
import 'tambah_todo_screen.dart';
import 'edit_todo_screen.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = AuthService().currentUser;

    AuthService().authStateChanges.listen((user) {
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    });
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("Silakan Login di menu Home.")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "List Tugas",
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
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TambahTodoScreen()),
            );
            _refresh();
          },
        ),
      ),
      body: FutureBuilder<List<TodoModel>>(
        future: DatabaseService().getTodos(_currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(message: "Memuat tugas...");
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tugas aman! Tidak ada deadline."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final todo = snapshot.data![index];

              // Jika Selesai (isCompleted) -> Hijau
              // Jika Belum -> Kuning
              Color cardColor = todo.isCompleted
                  ? const Color(0xFF00C48C) // Hijau (Selesai)
                  : const Color(0xFFFFD54F); // Kuning (Belum)

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    // 1. CHECKBOX
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          value: todo.isCompleted,
                          activeColor: Colors.black,
                          checkColor: Colors.white,
                          side: const BorderSide(
                            color: Colors.black,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: (val) async {
                            // Update Status Langsung ke Firebase
                            // Saat status berubah, warna kartu akan otomatis berubah karena setState
                            await DatabaseService().updateTodoStatus(
                              _currentUser!.uid,
                              todo.id,
                              val ?? false,
                            );
                            _refresh();
                          },
                        ),
                      ),
                    ),

                    // 2. TEXT INFO
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              todo.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                decoration: todo.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              todo.matkul,
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              todo.deadline,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 3. TOMBOL EDIT (Kotak Biru di Kanan)
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTodoScreen(todo: todo),
                          ),
                        );
                        _refresh();
                      },
                      child: Container(
                        width: 60,
                        height: 90,
                        decoration: const BoxDecoration(
                          color: Color(0xFF536DFE), // Biru
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: const Icon(Icons.edit, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
