/// Points calculation engine with multipliers and bonuses.
class PointsCalculator {
  /// Calculate gross points for sorted items.
  static int calculateItemPoints({
    required int basePoints,
    required int quantity,
  }) {
    return basePoints * quantity;
  }

  /// Apply streak bonus multiplier.
  /// - 0-2 streak: 1x
  /// - 3-6 streak: 1.5x (round down)
  /// - 7-13 streak: 2x
  /// - 14+ streak: 3x
  static double streakMultiplier(int streak) {
    if (streak >= 14) return 3.0;
    if (streak >= 7) return 2.0;
    if (streak >= 3) return 1.5;
    return 1.0;
  }

  /// Apply waste-type bonus (e.g., B3 waste gets bonus).
  static int categoryBonus({
    required String category,
    required int basePoints,
  }) {
    switch (category.toLowerCase()) {
      case 'b3':
        return basePoints ~/ 2; // +50%
      case 'logam':
        return (basePoints * 2) ~/ 10; // +20%
      default:
        return 0;
    }
  }

  /// Final points after all bonuses.
  static int calculateFinalPoints({
    required int itemPoints,
    required int streak,
    String category = '',
  }) {
    final multiplier = streakMultiplier(streak);
    final bonus = categoryBonus(category: category, basePoints: itemPoints);
    final total = (itemPoints * multiplier).round() + bonus;
    return total;
  }

  /// Calculate level from total points.
  static int levelFromPoints(int totalPoints) {
    return (totalPoints ~/ 100) + 1;
  }

  /// Points needed to reach next level.
  static int pointsUntilNextLevel(int totalPoints) {
    final next = (levelFromPoints(totalPoints) + 1) * 100;
    return next - totalPoints;
  }
}
