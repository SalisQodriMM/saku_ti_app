import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../services/auth_service.dart';
import '../../models/todo_model.dart';
import '../../widgets/loading_widget.dart';

class TambahTodoScreen extends StatefulWidget {
  const TambahTodoScreen({super.key});

  @override
  State<TambahTodoScreen> createState() => _TambahTodoScreenState();
}

class _TambahTodoScreenState extends State<TambahTodoScreen> {
  final _titleController = TextEditingController();
  final _matkulController = TextEditingController();
  final _dateController = TextEditingController();
  bool _isLoading = false;

  // Fungsi Date Picker
  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      String formattedDate = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
      _dateController.text = formattedDate;
    }
  }

  void _saveTodo() async {
    final user = AuthService().currentUser;
    if (user == null || _titleController.text.isEmpty) return;

    setState(() => _isLoading = true);

    final newTodo = TodoModel(
      id: '',
      title: _titleController.text,
      matkul: _matkulController.text,
      deadline: _dateController.text,
      isCompleted: false,
    );

    await DatabaseService().addTodo(user.uid, newTodo);
    
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Tambah Tugas", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const LoadingWidget(message: "Menyimpan tugas...")
          : Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD54F),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildInput(_titleController, "Nama Tugas"),
                  const SizedBox(height: 16),
                  _buildInput(_matkulController, "Mata Kuliah"),
                  const SizedBox(height: 16),
                  // Input Date dengan Icon Calendar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: _pickDate,
                      decoration: const InputDecoration(
                        hintText: "Deadline (dd-mm-yyyy)",
                        border: InputBorder.none,
                        icon: Icon(Icons.calendar_today, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveTodo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8D6E63),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Simpan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInput(TextEditingController controller, String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: hint, border: InputBorder.none),
      ),
    );
  }
}