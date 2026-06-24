/// A badge definition from badges table.
class BadgeEntity {
  final int id;
  final String name;
  final String description;
  final String? iconUrl;
  final String category;
  final String requirementType;
  final int requirementValue;
  final int pointsReward;

  const BadgeEntity({
    required this.id,
    required this.name,
    required this.description,
    this.iconUrl,
    required this.category,
    required this.requirementType,
    required this.requirementValue,
    this.pointsReward = 0,
  });
}
