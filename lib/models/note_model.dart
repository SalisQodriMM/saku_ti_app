class NoteModel {
  String id;
  String title;
  String content;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
  });

  factory NoteModel.fromJson(String id, Map<String, dynamic> json) {
    return NoteModel(
      id: id,
      title: json['title'] ?? 'Catatan',
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }
}