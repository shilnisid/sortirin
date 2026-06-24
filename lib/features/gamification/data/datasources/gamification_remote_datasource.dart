import 'package:sortirin/features/gamification/data/models/point_entry_model.dart';
import 'package:sortirin/features/gamification/data/models/streak_model.dart';
import 'package:sortirin/features/gamification/data/models/user_badge_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GamificationRemoteDataSource {
  final SupabaseClient _client;

  GamificationRemoteDataSource(this._client);

  Future<int> getTotalPoints(String userId) async {
    final response = await _client
        .from('profiles')
        .select('total_points')
        .eq('id', userId)
        .single();
    return (response['total_points'] as num?)?.toInt() ?? 0;
  }

  Future<List<PointEntryModel>> getPointsHistory(String userId, {int limit = 50}) async {
    final data = await _client
        .from('points_ledger')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);
    return (data as List).map((e) => PointEntryModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<PointEntryModel> addPoints({
    required String userId,
    required int points,
    required String reason,
    int? submissionId,
  }) async {
    final profile = await _client
        .from('profiles')
        .select('total_points')
        .eq('id', userId)
        .single();
    final pointsBefore = (profile['total_points'] as num?)?.toInt() ?? 0;
    final pointsAfter = pointsBefore + points;

    final payload = <String, dynamic>{
      'user_id': userId,
      'points_before': pointsBefore,
      'points_earned': points,
      'points_after': pointsAfter,
      'reason': reason,
    };
    if (submissionId != null) payload['submission_id'] = submissionId;

    final inserted = await _client
        .from('points_ledger')
        .insert(payload)
        .select()
        .single();

    // Update profile
    await _client
        .from('profiles')
        .update({'total_points': pointsAfter})
        .eq('id', userId);

    return PointEntryModel.fromJson(inserted);
  }

  Future<StreakModel> getStreak(String userId) async {
    try {
      final data = await _client
          .from('streaks')
          .select()
          .eq('user_id', userId)
          .single();
      return StreakModel.fromJson(data);
    } on PostgrestException {
      return const StreakModel();
    }
  }

  Future<StreakModel> checkAndUpdateStreak(String userId) async {
    final current = await getStreak(userId);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (current.lastSubmissionDate == null) {
      final newStreak = StreakModel(
        currentStreak: 1,
        longestStreak: 1,
        lastSubmissionDate: today,
      );
      await _upsertStreak(userId, newStreak);
      return newStreak;
    }

    final lastDate = DateTime(
      current.lastSubmissionDate!.year,
      current.lastSubmissionDate!.month,
      current.lastSubmissionDate!.day,
    );
    final diff = today.difference(lastDate).inDays;

    int newCurrent = current.currentStreak;
    int newLongest = current.longestStreak;

    if (diff == 0) {
      return current;
    } else if (diff == 1) {
      newCurrent += 1;
      if (newCurrent > newLongest) newLongest = newCurrent;
    } else if (diff == 2 && current.streakFreezeExpires != null &&
        current.streakFreezeExpires!.isAfter(now)) {
      newCurrent += 1;
      if (newCurrent > newLongest) newLongest = newCurrent;
    } else {
      newCurrent = 1;
    }

    final updated = StreakModel(
      currentStreak: newCurrent,
      longestStreak: newLongest,
      lastSubmissionDate: today,
    );
    await _upsertStreak(userId, updated);
    return updated;
  }

  Future<void> _upsertStreak(String userId, StreakModel streak) async {
    await _client.from('streaks').upsert({
      'user_id': userId,
      'current_streak': streak.currentStreak,
      'longest_streak': streak.longestStreak,
      'last_submission_date': streak.lastSubmissionDate?.toIso8601String(),
    });
  }

  Future<List<UserBadgeModel>> getUserBadges(String userId) async {
    final data = await _client
        .from('user_badges')
        .select('*, badges(*)')
        .eq('user_id', userId);
    return (data as List).map((e) => UserBadgeModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<UserBadgeModel>> checkNewBadges(String userId) async {
    final allBadges = await _client.from('badges').select();
    final userBadgesData = await _client
        .from('user_badges')
        .select('badge_id')
        .eq('user_id', userId);
    final earnedIds = (userBadgesData as List).map((e) => e['badge_id'] as int).toSet();

    final profile = await _client
        .from('profiles')
        .select('total_points')
        .eq('id', userId)
        .single();
    final totalPoints = (profile['total_points'] as num?)?.toInt() ?? 0;

    final streakData = await getStreak(userId);
    final subData = await _client
        .from('submissions')
        .select('id')
        .eq('user_id', userId);
    final count = (subData as List).length;

    final newUserBadges = <UserBadgeModel>[];
    for (final badgeData in allBadges as List) {
      final badgeJson = badgeData as Map<String, dynamic>;
      final badgeId = badgeJson['id'] as int;
      if (earnedIds.contains(badgeId)) continue;

      final type = badgeJson['requirement_type'] as String? ?? '';
      final value = badgeJson['requirement_value'] as int? ?? 1;
      bool earned = false;

      switch (type) {
        case 'submission_count':
          earned = count >= value;
          break;
        case 'points_total':
          earned = totalPoints >= value;
          break;
        case 'streak':
          earned = streakData.currentStreak >= value;
          break;
      }

      if (earned) {
        final inserted = await _client
            .from('user_badges')
            .insert({'user_id': userId, 'badge_id': badgeId})
            .select('*, badges(*)')
            .single();
        newUserBadges.add(UserBadgeModel.fromJson(inserted));

        final badgePoints = badgeJson['points_reward'] as int? ?? 0;
        if (badgePoints > 0) {
          await addPoints(userId: userId, points: badgePoints, reason: 'Badge: ${badgeJson['name']}');
        }
      }
    }

    return newUserBadges;
  }
}
