class TodoModel {
  String id; // ID Unik dari Firebase
  String title;
  String matkul;
  String deadline;
  bool isCompleted;

  TodoModel({
    required this.id,
    required this.title,
    required this.matkul,
    required this.deadline,
    required this.isCompleted,
  });

  // Dari Firebase (JSON) ke Dart
  factory TodoModel.fromJson(String id, Map<String, dynamic> json) {
    return TodoModel(
      id: id,
      title: json['title'] ?? 'Tugas Baru',
      matkul: json['matkul'] ?? '-',
      deadline: json['deadline'] ?? '-',
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  // Dari Dart ke Firebase (JSON)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'matkul': matkul,
      'deadline': deadline,
      'isCompleted': isCompleted,
    };
  }
}