import 'package:sortirin/features/gamification/domain/entities/point_entry_entity.dart';
import 'package:sortirin/features/gamification/domain/entities/streak_info_entity.dart';
import 'package:sortirin/features/gamification/domain/entities/user_badge_entity.dart';

/// Unified repository for points, streak, badge data.
abstract class GamificationRepository {
  Future<int> getTotalPoints(String userId);
  Future<int> getLevel(int totalPoints);
  Future<List<PointEntryEntity>> getPointsHistory(String userId, {int limit = 50});
  Future<PointEntryEntity> addPoints({
    required String userId,
    required int points,
    required String reason,
    int? submissionId,
    int? ruleId,
  });
  Future<StreakInfoEntity> getStreak(String userId);
  Future<StreakInfoEntity> checkAndUpdateStreak(String userId);
  Future<List<UserBadgeEntity>> getUserBadges(String userId);
  Future<List<UserBadgeEntity>> checkNewBadges(
    String userId,
    int currentTotalPoints,
    int submissionCount,
    int currentStreak,
  );
}
