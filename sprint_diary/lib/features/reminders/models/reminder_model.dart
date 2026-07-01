class ReminderModel {
  final String? id;
  final String userId;
  final String title;
  final DateTime date;
  final String time;
  final String? category;
  final bool notificationEnabled;

  ReminderModel({
    this.id,
    required this.userId,
    required this.title,
    required this.date,
    required this.time,
    this.category,
    this.notificationEnabled = true,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      category: json['category'],
      notificationEnabled: json['notification_enabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'title': title,
      'date': date.toIso8601String().split('T')[0],
      'time': time,
      'category': category,
      'notification_enabled': notificationEnabled,
    };
  }
}
