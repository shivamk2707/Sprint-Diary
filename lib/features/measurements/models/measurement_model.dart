class MeasurementModel {
  final String? id;
  final String userId;
  final DateTime date;
  final double? weight;
  final double? height;
  final double? bodyFat;
  final int? heartRate;
  final String? notes;

  MeasurementModel({
    this.id,
    required this.userId,
    required this.date,
    this.weight,
    this.height,
    this.bodyFat,
    this.heartRate,
    this.notes,
  });

  factory MeasurementModel.fromJson(Map<String, dynamic> json) {
    return MeasurementModel(
      id: json['id'],
      userId: json['user_id'],
      date: DateTime.parse(json['date']),
      weight: json['weight']?.toDouble(),
      height: json['height']?.toDouble(),
      bodyFat: json['body_fat']?.toDouble(),
      heartRate: json['heart_rate'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'date': date.toIso8601String().split('T')[0],
      'weight': weight,
      'height': height,
      'body_fat': bodyFat,
      'heart_rate': heartRate,
      'notes': notes,
    };
  }
}
