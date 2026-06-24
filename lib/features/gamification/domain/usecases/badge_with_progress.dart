/// A badge with progress info (used in dashboard/UI).
class BadgeWithProgress {
  final int id;
  final String name;
  final String description;
  final String? iconUrl;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int currentValue;
  final int requiredValue;

  const BadgeWithProgress({
    required this.id,
    required this.name,
    required this.description,
    this.iconUrl,
    required this.isUnlocked,
    this.unlockedAt,
    required this.currentValue,
    required this.requiredValue,
  });

  double get progressPercent => requiredValue > 0
      ? (currentValue / requiredValue).clamp(0.0, 1.0)
      : 0.0;
}
