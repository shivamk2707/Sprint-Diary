class GoalModel {
  final String? id;
  final String userId;
  final String title;
  final String? description;
  final String? target;
  final DateTime? targetDate;
  final bool completed;
  final double progress;

  GoalModel({
    this.id,
    required this.userId,
    required this.title,
    this.description,
    this.target,
    this.targetDate,
    this.completed = false,
    this.progress = 0.0,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      target: json['target'],
      targetDate: json['target_date'] != null
          ? DateTime.parse(json['target_date'])
          : null,
      completed: json['completed'] ?? false,
      progress: json['progress']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'target': target,
      'target_date': targetDate?.toIso8601String().split('T')[0],
      'completed': completed,
      'progress': progress,
    };
  }

  GoalModel copyWith({
    String? title,
    String? description,
    String? target,
    DateTime? targetDate,
    bool? completed,
    double? progress,
  }) {
    return GoalModel(
      id: id,
      userId: userId,
      title: title ?? this.title,
      description: description ?? this.description,
      target: target ?? this.target,
      targetDate: targetDate ?? this.targetDate,
      completed: completed ?? this.completed,
      progress: progress ?? this.progress,
    );
  }
}
