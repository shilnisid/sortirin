import 'package:sortirin/features/gamification/data/models/badge_model.dart';
import 'package:sortirin/features/gamification/domain/entities/user_badge_entity.dart';

class UserBadgeModel {
  final int id;
  final BadgeModel badge;
  final DateTime earnedAt;
  final bool isDisplayed;

  const UserBadgeModel({
    required this.id,
    required this.badge,
    required this.earnedAt,
    this.isDisplayed = true,
  });

  factory UserBadgeModel.fromJson(Map<String, dynamic> json) {
    final badgeJson = json['badges'] as Map<String, dynamic>? ?? json;
    return UserBadgeModel(
      id: json['id'] as int,
      badge: BadgeModel.fromJson(badgeJson),
      earnedAt: DateTime.tryParse(json['earned_at'] as String? ?? '') ?? DateTime.now(),
      isDisplayed: json['is_displayed'] as bool? ?? true,
    );
  }

  UserBadgeEntity toEntity() => UserBadgeEntity(
    id: id,
    badge: badge.toEntity(),
    earnedAt: earnedAt,
    isDisplayed: isDisplayed,
  );
}
