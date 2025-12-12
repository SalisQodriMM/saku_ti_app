class TimelineModel {
  String name;
  bool isCompleted;

  TimelineModel({
    required this.name, 
    this.isCompleted = false
  });

  // Dari Map (Firebase) ke Object Dart
  factory TimelineModel.fromMap(Map<String, dynamic> map) {
    return TimelineModel(
      name: map['name'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  // Dari Object Dart ke Map (Firebase)
  Map<String, dynamic> toMap() => {
    'name': name,
    'isCompleted': isCompleted,
  };
}