import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/project_model.dart';
import '../models/todo_model.dart';
import '../widgets/loading_widget.dart';
import '../widgets/realtime_clock.dart'; // Pastikan widget jam sudah ada

class HomeScreen extends StatefulWidget {
  final Function(int) onNavigate;
  const HomeScreen({super.key, required this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = AuthService().currentUser;
    AuthService().authStateChanges.listen((user) {
      if (mounted) setState(() => _currentUser = user);
    });
  }

  // --- FUNGSI REFRESH ---
  Future<void> _refreshData() async {
    // Kita cukup panggil setState.
    // Ini akan memicu ulang build(), sehingga FutureBuilder akan
    // memanggil DatabaseService lagi untuk mengambil data terbaru.
    setState(() {});

    // Sedikit delay agar animasi loading terlihat natural
    await Future.delayed(const Duration(milliseconds: 1500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 1. BUNGKUS DENGAN REFRESH INDICATOR
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: const Color(0xFF2F6BFF), // Warna loading biru
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          // 2. WAJIB ADA PHYSICS INI
          // Agar layar bisa ditarik (bounce) meskipun kontennya pendek
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSectionHeader("Project Saya"),
              _buildProjectSummary(),
              const SizedBox(height: 20),
              _buildSectionHeader("List Tugas"),
              _buildTodoSummary(),
              const SizedBox(height: 160),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
      decoration: const BoxDecoration(
        color: Color(0xFF2F6BFF),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/logo.png', width: 35),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/settings');
                },
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white,
                  backgroundImage: _currentUser?.photoURL != null
                      ? NetworkImage(_currentUser!.photoURL!)
                      : null,
                  child: _currentUser?.photoURL == null
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Halo,",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Text(
            _currentUser?.displayName?.split(" ").first.toUpperCase() ?? "TAMU",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Selamat dan semangat belajar hari ini!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),

          const SizedBox(height: 30),

          // Widget Jam Realtime
          const RealtimeClock(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildProjectSummary() {
    if (_currentUser == null) return _buildLoginMessage();

    return FutureBuilder<List<ProjectModel>>(
      future: DatabaseService().getProjects(_currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyMessage("Belum ada project.");
        }

        final projects = snapshot.data!.take(2).toList();

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final p = projects[index];
            bool isFinished =
                p.totalTasks > 0 && p.completedTasks == p.totalTasks;

            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                // onTap: () => widget.onNavigate(3),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                title: Text(
                  p.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "${p.startDate} - ${p.endDate}",
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isFinished
                        ? const Color(0xFF00C48C)
                        : const Color(0xFFFFD54F),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${p.completedTasks}/${p.totalTasks}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: isFinished ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTodoSummary() {
    if (_currentUser == null) return _buildLoginMessage();

    return FutureBuilder<List<TodoModel>>(
      future: DatabaseService().getTodos(_currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyMessage("Belum ada tugas.");
        }

        final todos = snapshot.data!.take(2).toList();

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final t = todos[index];
            Color bgColor = t.isCompleted
                ? const Color(0xFF00C48C)
                : const Color(0xFFFFD54F);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    t.isCompleted
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: t.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        Text(t.deadline, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLoginMessage() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        "Silakan login di menu Akun untuk melihat data.",
        style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget _buildEmptyMessage(String msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(msg, style: const TextStyle(color: Colors.grey)),
    );
  }
}
