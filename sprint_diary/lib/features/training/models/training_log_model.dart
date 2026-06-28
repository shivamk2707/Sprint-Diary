class TrainingLogModel {
  final String? id;
  final String userId;
  final DateTime date;
  final String trainingType;
  final double? distance;
  final int? sets;
  final int? reps;
  final String?
      duration; // Stored as interval in PG, map to String HH:mm:ss for simplicity here
  final int? intensity;
  final String? notes;

  TrainingLogModel({
    this.id,
    required this.userId,
    required this.date,
    required this.trainingType,
    this.distance,
    this.sets,
    this.reps,
    this.duration,
    this.intensity,
    this.notes,
  });

  factory TrainingLogModel.fromJson(Map<String, dynamic> json) {
    return TrainingLogModel(
      id: json['id'],
      userId: json['user_id'],
      date: DateTime.parse(json['date']),
      trainingType: json['training_type'],
      distance: json['distance']?.toDouble(),
      sets: json['sets'],
      reps: json['reps'],
      duration: json['duration'],
      intensity: json['intensity'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'date': date.toIso8601String().split('T')[0],
      'training_type': trainingType,
      'distance': distance,
      'sets': sets,
      'reps': reps,
      'duration': duration,
      'intensity': intensity,
      'notes': notes,
    };
  }
}
