class NoteModel {
  final String? id;
  final String userId;
  final DateTime date;
  final String title;
  final String description;

  NoteModel({
    this.id,
    required this.userId,
    required this.date,
    required this.title,
    required this.description,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      userId: json['user_id'],
      date: DateTime.parse(json['date']),
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'date': date.toIso8601String().split('T')[0],
      'title': title,
      'description': description,
    };
  }
}
