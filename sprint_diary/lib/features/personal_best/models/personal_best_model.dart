class PersonalBestModel {
  final String? id;
  final String userId;
  final double distance;
  final double timing;
  final String? venue;
  final DateTime date;
  final String? notes;

  PersonalBestModel({
    this.id,
    required this.userId,
    required this.distance,
    required this.timing,
    this.venue,
    required this.date,
    this.notes,
  });

  factory PersonalBestModel.fromJson(Map<String, dynamic> json) {
    return PersonalBestModel(
      id: json['id'],
      userId: json['user_id'],
      distance: json['distance']?.toDouble() ?? 0.0,
      timing: json['timing']?.toDouble() ?? 0.0,
      venue: json['venue'],
      date: DateTime.parse(json['date']),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'distance': distance,
      'timing': timing,
      'venue': venue,
      'date': date.toIso8601String().split('T')[0],
      'notes': notes,
    };
  }
}
