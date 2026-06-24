import 'package:sortirin/features/gamification/domain/entities/streak_info_entity.dart';
import 'package:sortirin/features/gamification/domain/entities/user_badge_entity.dart';
import 'package:sortirin/features/gamification/domain/repositories/gamification_repository.dart';

/// Called after each submission — checks streak + awards new badges.
class CheckStreakAndBadgesUseCase {
  final GamificationRepository _repo;

  CheckStreakAndBadgesUseCase(this._repo);

  Future<(StreakInfoEntity, List<UserBadgeEntity>)> call(String userId) async {
    final streak = await _repo.checkAndUpdateStreak(userId);
    final totalPoints = await _repo.getTotalPoints(userId);
    final history = await _repo.getPointsHistory(userId, limit: 999);
    final submissionCount = history.length;
    final newBadges = await _repo.checkNewBadges(
      userId,
      totalPoints,
      submissionCount,
      streak.currentStreak,
    );
    return (streak, newBadges);
  }
}
