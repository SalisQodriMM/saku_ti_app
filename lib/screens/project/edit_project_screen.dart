import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../services/auth_service.dart';
import '../../models/project_model.dart';
import '../../models/timeline_model.dart';
import '../../widgets/loading_widget.dart';

class EditProjectScreen extends StatefulWidget {
  final ProjectModel project;
  const EditProjectScreen({super.key, required this.project});

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  late TextEditingController _titleController;
  late TextEditingController _startController;
  late TextEditingController _endController;

  // List Controller + Status Selesai
  final List<Map<String, dynamic>> _timelinesData = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.project.title);
    _startController = TextEditingController(text: widget.project.startDate);
    _endController = TextEditingController(text: widget.project.endDate);

    // Isi timeline data dari project lama
    for (var t in widget.project.timelines) {
      _timelinesData.add({
        'controller': TextEditingController(text: t.name),
        'isCompleted': t.isCompleted,
      });
    }
  }

  void _addTimelineField() {
    setState(() {
      _timelinesData.add({
        'controller': TextEditingController(),
        'isCompleted': false,
      });
    });
  }

  void _removeTimelineField(int index) {
    setState(() {
      _timelinesData.removeAt(index);
    });
  }

  void _pickDate(TextEditingController controller) async {
    // ... (sama seperti tambah screen) ...
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      controller.text = "${picked.day}-${picked.month}-${picked.year}";
    }
  }

  void _updateProject() async {
    final user = AuthService().currentUser;
    if (user == null) return;
    setState(() => _isLoading = true);

    List<TimelineModel> updatedTimelines = [];
    for (var item in _timelinesData) {
      TextEditingController ctrl = item['controller'];
      if (ctrl.text.isNotEmpty) {
        updatedTimelines.add(
          TimelineModel(name: ctrl.text, isCompleted: item['isCompleted']),
        );
      }
    }

    final updatedProject = ProjectModel(
      id: widget.project.id, // ID Tetap
      title: _titleController.text,
      startDate: _startController.text,
      endDate: _endController.text,
      timelines: updatedTimelines,
    );

    await DatabaseService().updateProject(user.uid, updatedProject);
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF536DFE),
      appBar: AppBar(
        title: const Text("Edit Projek", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: _isLoading
          ? const LoadingWidget()
          : Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: "Judul Project",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _startController,
                      readOnly: true,
                      onTap: () => _pickDate(_startController),
                      decoration: const InputDecoration(labelText: "Mulai"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _endController,
                      readOnly: true,
                      onTap: () => _pickDate(_endController),
                      decoration: const InputDecoration(labelText: "Selesai"),
                    ),

                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      color: const Color(0xFF536DFE),
                      width: double.infinity,
                      child: const Center(
                        child: Text(
                          "Timeline",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // LIST TIMELINE EDITABLE
                    ..._timelinesData.asMap().entries.map((entry) {
                      int idx = entry.key;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: entry.value['controller'],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // TOMBOL MINUS (-)
                            InkWell(
                              onTap: () => _removeTimelineField(idx),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    IconButton(
                      icon: const Icon(Icons.add_circle, size: 40),
                      onPressed: _addTimelineField,
                    ),

                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _updateProject,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F51B5),
                        ),
                        child: const Text(
                          "Simpan",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
