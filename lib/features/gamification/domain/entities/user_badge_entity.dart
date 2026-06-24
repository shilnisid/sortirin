import 'package:sortirin/features/gamification/domain/entities/badge_entity.dart';

/// A badge earned by a user.
class UserBadgeEntity {
  final int id;
  final BadgeEntity badge;
  final DateTime earnedAt;
  final bool isDisplayed;

  const UserBadgeEntity({
    required this.id,
    required this.badge,
    required this.earnedAt,
    this.isDisplayed = true,
  });
}
