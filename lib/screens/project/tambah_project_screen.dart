import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../services/auth_service.dart';
import '../../models/project_model.dart';
import '../../models/timeline_model.dart';
// import '../../widgets/loading_widget.dart';

class TambahProjectScreen extends StatefulWidget {
  const TambahProjectScreen({super.key});

  @override
  State<TambahProjectScreen> createState() => _TambahProjectScreenState();
}

class _TambahProjectScreenState extends State<TambahProjectScreen> {
  final _titleController = TextEditingController();
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  
  // List Controller untuk Timeline (Dinamis)
  final List<TextEditingController> _timelineControllers = [TextEditingController()];
  
  bool _isLoading = false;

  void _addTimelineField() {
    setState(() {
      _timelineControllers.add(TextEditingController());
    });
  }

  void _pickDate(TextEditingController controller) async {
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

  void _saveProject() async {
    final user = AuthService().currentUser;
    if (user == null || _titleController.text.isEmpty) return;

    setState(() => _isLoading = true);

    // Konversi Controller -> List<TimelineModel>
    List<TimelineModel> timelines = [];
    for (var ctrl in _timelineControllers) {
      if (ctrl.text.isNotEmpty) {
        timelines.add(TimelineModel(name: ctrl.text, isCompleted: false));
      }
    }

    final newProject = ProjectModel(
      id: '',
      title: _titleController.text,
      startDate: _startController.text,
      endDate: _endController.text,
      timelines: timelines,
    );

    await DatabaseService().addProject(user.uid, newProject);
    
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF536DFE), // Background Biru Penuh
      appBar: AppBar(
        title: const Text("Tambah Projek", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.white))
        : Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white, // Container Putih di dalam
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Judul Project"),
                  _buildInput(_titleController, ""),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel("Mulai"),
                          _buildDateInput(_startController),
                        ],
                      )),
                      const SizedBox(width: 16),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel("Selesai"),
                          _buildDateInput(_endController),
                        ],
                      )),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  const Center(child: Text("Timeline atau Tugas", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  
                  // Label Header Timeline (Biru background)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    color: const Color(0xFF536DFE),
                    child: const Center(child: Text("Timeline atau Tugas", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  ),
                  const SizedBox(height: 16),

                  // LIST INPUT TIMELINE
                  ..._timelineControllers.asMap().entries.map((entry) {
                    int idx = entry.key;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TextField(
                        controller: _timelineControllers[idx],
                        decoration: InputDecoration(
                          hintText: "Timeline/Tugas ${idx + 1}",
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        ),
                      ),
                    );
                  }).toList(),

                  // Tombol Tambah Timeline (+)
                  Center(
                    child: InkWell(
                      onTap: _addTimelineField,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey)),
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveProject,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3F51B5), // Biru Gelap
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildInput(TextEditingController ctrl, String hint) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        hintText: hint,
        filled: true, fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildDateInput(TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      readOnly: true,
      onTap: () => _pickDate(ctrl),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.calendar_today, size: 18),
        filled: true, fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }
}