import 'package:sortirin/features/gamification/domain/repositories/gamification_repository.dart';

class PointsSummary {
  final int totalPoints;
  final int level;
  final int streak;
  final int recentBadgesCount;
  final int pointsUntilNextLevel;

  const PointsSummary({
    required this.totalPoints,
    required this.level,
    required this.streak,
    required this.recentBadgesCount,
    required this.pointsUntilNextLevel,
  });
}

class GetPointsSummaryUseCase {
  final GamificationRepository _repo;

  GetPointsSummaryUseCase(this._repo);

  Future<PointsSummary> call(String userId) async {
    final totalPoints = await _repo.getTotalPoints(userId);
    final level = await _repo.getLevel(totalPoints);
    final streakInfo = await _repo.getStreak(userId);
    final badges = await _repo.getUserBadges(userId);

    final nextThreshold = (level + 1) * 100;
    final pointsUntilNextLevel = nextThreshold - totalPoints;

    return PointsSummary(
      totalPoints: totalPoints,
      level: level,
      streak: streakInfo.currentStreak,
      recentBadgesCount: badges.length,
      pointsUntilNextLevel: pointsUntilNextLevel > 0 ? pointsUntilNextLevel : 0,
    );
  }
}
