class ProfileModel {
  final String id;
  final String email;
  final String? fullName;
  final int? age;
  final DateTime? birthday;
  final String? gender;
  final double? height;
  final double? weight;
  final String? club;
  final String? emergencyContact;
  final String? preferredEvent;
  final String? avatarUrl;

  ProfileModel({
    required this.id,
    required this.email,
    this.fullName,
    this.age,
    this.birthday,
    this.gender,
    this.height,
    this.weight,
    this.club,
    this.emergencyContact,
    this.preferredEvent,
    this.avatarUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      age: json['age'],
      birthday:
          json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
      gender: json['gender'],
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
      club: json['club'],
      emergencyContact: json['emergency_contact'],
      preferredEvent: json['preferred_event'],
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'age': age,
      'birthday': birthday?.toIso8601String().split('T')[0],
      'gender': gender,
      'height': height,
      'weight': weight,
      'club': club,
      'emergency_contact': emergencyContact,
      'preferred_event': preferredEvent,
      'avatar_url': avatarUrl,
    };
  }

  ProfileModel copyWith({
    String? fullName,
    int? age,
    DateTime? birthday,
    String? gender,
    double? height,
    double? weight,
    String? club,
    String? emergencyContact,
    String? preferredEvent,
    String? avatarUrl,
  }) {
    return ProfileModel(
      id: id,
      email: email,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      club: club ?? this.club,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      preferredEvent: preferredEvent ?? this.preferredEvent,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
