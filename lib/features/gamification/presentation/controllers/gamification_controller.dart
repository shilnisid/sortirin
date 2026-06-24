import 'package:get/get.dart';
import 'package:sortirin/core/network/supabase_client.dart';
import 'package:sortirin/features/gamification/domain/entities/user_badge_entity.dart';
import 'package:sortirin/features/gamification/domain/repositories/gamification_repository.dart';
import 'package:sortirin/features/gamification/domain/usecases/check_streak_and_badges_usecase.dart';
import 'package:sortirin/features/gamification/domain/usecases/get_points_summary_usecase.dart';

/// Unified controller for gamification display (dashboard, profile).
class GamificationController extends GetxController {
  final GetPointsSummaryUseCase _getSummary;
  final CheckStreakAndBadgesUseCase _checkStreakBadges;
  final GamificationRepository _repo;

  GamificationController({
    required GetPointsSummaryUseCase getSummary,
    required CheckStreakAndBadgesUseCase checkStreakBadges,
    required GamificationRepository repo,
  })  : _getSummary = getSummary,
        _checkStreakBadges = checkStreakBadges,
        _repo = repo,
        super();

  // ── Reactive State ──
  final totalPoints = 0.obs;
  final level = 1.obs;
  final pointsUntilNextLevel = 0.obs;
  final currentStreak = 0.obs;
  final longestStreak = 0.obs;
  final lastSubmissionDate = Rx<DateTime?>(null);
  final badgeCount = 0.obs;
  final newBadges = <UserBadgeEntity>[].obs;
  final isLoading = true.obs;
  final streakMultiplier = 1.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadSummary();
  }

  Future<void> loadSummary() async {
    isLoading.value = true;
    try {
      // Get current user ID from Supabase auth
      final userId = SupabaseClientService.client.auth.currentUser?.id;
      if (userId == null) return;

      final summary = await _getSummary.call(userId);
      totalPoints.value = summary.totalPoints;
      level.value = summary.level;
      pointsUntilNextLevel.value = summary.pointsUntilNextLevel;
      currentStreak.value = summary.streak;
      badgeCount.value = summary.recentBadgesCount;

      // Calculate streak multiplier
      if (summary.streak >= 14) {
        streakMultiplier.value = 3.0;
      } else if (summary.streak >= 7) {
        streakMultiplier.value = 2.0;
      } else if (summary.streak >= 3) {
        streakMultiplier.value = 1.5;
      } else {
        streakMultiplier.value = 1.0;
      }

      // Get full streak info
      final streakInfo = await _repo.getStreak(userId);
      longestStreak.value = streakInfo.longestStreak;
      lastSubmissionDate.value = streakInfo.lastSubmissionDate;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkAfterSubmission() async {
    final userId = SupabaseClientService.client.auth.currentUser?.id;
    if (userId == null) return;

    final (streak, badges) = await _checkStreakBadges.call(userId);
    currentStreak.value = streak.currentStreak;
    longestStreak.value = streak.longestStreak;
    lastSubmissionDate.value = streak.lastSubmissionDate;

    if (badges.isNotEmpty) {
      newBadges.addAll(badges);
      badgeCount.value += badges.length;
    }

    // Reload summary
    await loadSummary();
  }

  String get streakLabel {
    if (currentStreak.value == 0) return 'Mulai streak hari ini!';
    if (currentStreak.value == 1) return '1 hari berturut-turut';
    return '${currentStreak.value} hari berturut-turut';
  }
}

