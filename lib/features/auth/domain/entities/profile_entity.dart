/// User profile entity — pure Dart, no framework dependency.
class ProfileEntity {
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

  const ProfileEntity({
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

  ProfileEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    String? phone,
    String? city,
    String? district,
    bool? isProfileComplete,
    int? totalPoints,
    int? streakDays,
    DateTime? createdAt,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      district: district ?? this.district,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      totalPoints: totalPoints ?? this.totalPoints,
      streakDays: streakDays ?? this.streakDays,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
