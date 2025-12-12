import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../services/auth_service.dart';
import '../../models/todo_model.dart';
import '../../widgets/loading_widget.dart';

class EditTodoScreen extends StatefulWidget {
  final TodoModel todo;
  const EditTodoScreen({super.key, required this.todo});

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final _titleController = TextEditingController();
  final _matkulController = TextEditingController();
  final _dateController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Isi data lama
    _titleController.text = widget.todo.title;
    _matkulController.text = widget.todo.matkul;
    _dateController.text = widget.todo.deadline;
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      _dateController.text = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
    }
  }

  void _updateTodo() async {
    final user = AuthService().currentUser;
    if (user == null) return;
    setState(() => _isLoading = true);

    // Gunakan ID lama, data baru dari controller
    final updatedTodo = TodoModel(
      id: widget.todo.id,
      title: _titleController.text,
      matkul: _matkulController.text,
      deadline: _dateController.text,
      isCompleted: widget.todo.isCompleted,
    );

    await DatabaseService().updateTodo(user.uid, updatedTodo);
    if (mounted) { setState(() => _isLoading = false); Navigator.pop(context); }
  }

  void _deleteTodo() async {
    final user = AuthService().currentUser;
    if (user == null) return;
    
    bool confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Tugas"),
        content: const Text("Yakin tugas ini dihapus?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Batal")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Hapus", style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;

    if (confirm) {
      setState(() => _isLoading = true);
      await DatabaseService().deleteTodo(user.uid, widget.todo.id);
      if (mounted) { setState(() => _isLoading = false); Navigator.pop(context); }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Tugas", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: _pickDate,
                      decoration: const InputDecoration(
                        hintText: "Deadline", border: InputBorder.none, icon: Icon(Icons.calendar_today, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _updateTodo,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8D6E63),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text("Simpan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _deleteTodo,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF5350),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text("Hapus", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
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