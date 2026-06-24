import 'package:sortirin/features/auth/domain/entities/profile_entity.dart';

/// Profile model with JSON serialization for Supabase.
class ProfileModel {
  final String id;
  final String? email;
  final String? name;
  final String? photoUrl;
  final String? phone;
  final String? city;
  final String? district;
  final bool isProfileComplete;
  final int totalPoints;
  final int streakDays;
  final DateTime createdAt;

  const ProfileModel({
    required this.id,
    this.email,
    this.name,
    this.photoUrl,
    this.phone,
    this.city,
    this.district,
    this.isProfileComplete = false,
    this.totalPoints = 0,
    this.streakDays = 0,
    required this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      email: json['email'] as String?,
      name: json['name'] as String?,
      photoUrl: json['photo_url'] as String?,
      phone: json['phone'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
      isProfileComplete: (json['is_profile_complete'] as bool?) ?? false,
      totalPoints: (json['total_points'] as int?) ?? 0,
      streakDays: (json['streak_days'] as int?) ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photo_url': photoUrl,
      'phone': phone,
      'city': city,
      'district': district,
      'is_profile_complete': isProfileComplete,
      'total_points': totalPoints,
      'streak_days': streakDays,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      email: email,
      name: name,
      photoUrl: photoUrl,
      phone: phone,
      city: city,
      district: district,
      isProfileComplete: isProfileComplete,
      totalPoints: totalPoints,
      streakDays: streakDays,
      createdAt: createdAt,
    );
  }

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      photoUrl: entity.photoUrl,
      phone: entity.phone,
      city: entity.city,
      district: entity.district,
      isProfileComplete: entity.isProfileComplete,
      totalPoints: entity.totalPoints,
      streakDays: entity.streakDays,
      createdAt: entity.createdAt,
    );
  }
}
