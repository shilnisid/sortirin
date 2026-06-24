import 'package:sortirin/features/gamification/domain/entities/badge_entity.dart';

class BadgeModel {
  final int id;
  final String name;
  final String description;
  final String? iconUrl;
  final String category;
  final String requirementType;
  final int requirementValue;
  final int pointsReward;

  const BadgeModel({
    required this.id,
    required this.name,
    required this.description,
    this.iconUrl,
    required this.category,
    required this.requirementType,
    required this.requirementValue,
    this.pointsReward = 0,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      iconUrl: json['icon_url'] as String?,
      category: json['category'] as String? ?? 'general',
      requirementType: json['requirement_type'] as String? ?? 'submission_count',
      requirementValue: json['requirement_value'] as int? ?? 1,
      pointsReward: json['points_reward'] as int? ?? 0,
    );
  }

  BadgeEntity toEntity() => BadgeEntity(
    id: id,
    name: name,
    description: description,
    iconUrl: iconUrl,
    category: category,
    requirementType: requirementType,
    requirementValue: requirementValue,
    pointsReward: pointsReward,
  );
}
