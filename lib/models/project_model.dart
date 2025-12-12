import 'timeline_model.dart';

class ProjectModel {
  String id;
  String title;
  String startDate;
  String endDate;
  List<TimelineModel> timelines;

  ProjectModel({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.timelines, 
  });

  // Menghitung jumlah tugas secara otomatis dari List timelines
  // kita tidak perlu menginput angka manual lagi
  int get completedTasks => timelines.where((t) => t.isCompleted).length;
  int get totalTasks => timelines.length;

  factory ProjectModel.fromJson(String id, Map<String, dynamic> json) {
    // Parsing List Timeline dari JSON
    var timelineList = (json['timelines'] as List<dynamic>?)
        ?.map((x) => TimelineModel.fromMap(x))
        .toList() ?? [];

    return ProjectModel(
      id: id,
      title: json['title'] ?? 'Project Baru',
      startDate: json['startDate'] ?? '-',
      endDate: json['endDate'] ?? '-',
      timelines: timelineList,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'startDate': startDate,
    'endDate': endDate,
    // Kita simpan List-nya, bukan angkanya
    'timelines': timelines.map((x) => x.toMap()).toList(),
  };
}