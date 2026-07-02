class SprintTimingModel {
  final String? id;
  final String userId;
  final DateTime date;
  final double distance;
  final double timing;
  final String? location;
  final String? weather;
  final String? notes;
  final double? previousTime;
  final double? improvement;
  final bool isPersonalBest;

  SprintTimingModel({
    this.id,
    required this.userId,
    required this.date,
    required this.distance,
    required this.timing,
    this.location,
    this.weather,
    this.notes,
    this.previousTime,
    this.improvement,
    this.isPersonalBest = false,
  });

  factory SprintTimingModel.fromJson(Map<String, dynamic> json) {
    return SprintTimingModel(
      id: json['id'],
      userId: json['user_id'],
      date: DateTime.parse(json['date']),
      distance: json['distance']?.toDouble() ?? 0.0,
      timing: json['timing']?.toDouble() ?? 0.0,
      location: json['location'],
      weather: json['weather'],
      notes: json['notes'],
      previousTime: json['previous_time']?.toDouble(),
      improvement: json['improvement']?.toDouble(),
      isPersonalBest: json['is_personal_best'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'date': date.toIso8601String().split('T')[0],
      'distance': distance,
      'timing': timing,
      'location': location,
      'weather': weather,
      'notes': notes,
      'previous_time': previousTime,
      'improvement': improvement,
      'is_personal_best': isPersonalBest,
    };
  }
}
