import 'package:sortirin/core/errors/failures.dart';
import 'package:sortirin/features/gamification/data/datasources/gamification_remote_datasource.dart';
import 'package:sortirin/features/gamification/domain/entities/point_entry_entity.dart';
import 'package:sortirin/features/gamification/domain/entities/streak_info_entity.dart';
import 'package:sortirin/features/gamification/domain/entities/user_badge_entity.dart';
import 'package:sortirin/features/gamification/domain/repositories/gamification_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

class GamificationRepositoryImpl implements GamificationRepository {
  final GamificationRemoteDataSource _remote;

  GamificationRepositoryImpl(this._remote);

  @override
  Future<int> getTotalPoints(String userId) async {
    try {
      return await _remote.getTotalPoints(userId);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<int> getLevel(int totalPoints) async => (totalPoints ~/ 100) + 1;

  @override
  Future<List<PointEntryEntity>> getPointsHistory(String userId, {int limit = 50}) async {
    try {
      return (await _remote.getPointsHistory(userId, limit: limit)).map((m) => m.toEntity()).toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<PointEntryEntity> addPoints({required String userId, required int points, required String reason, int? submissionId, int? ruleId}) async {
    try {
      return (await _remote.addPoints(userId: userId, points: points, reason: reason, submissionId: submissionId)).toEntity();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<StreakInfoEntity> getStreak(String userId) async {
    try {
      return (await _remote.getStreak(userId)).toEntity();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<StreakInfoEntity> checkAndUpdateStreak(String userId) async {
    try {
      return (await _remote.checkAndUpdateStreak(userId)).toEntity();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<List<UserBadgeEntity>> getUserBadges(String userId) async {
    try {
      return (await _remote.getUserBadges(userId)).map((m) => m.toEntity()).toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<List<UserBadgeEntity>> checkNewBadges(String userId, int currentTotalPoints, int submissionCount, int currentStreak) async {
    try {
      return (await _remote.checkNewBadges(userId)).map((m) => m.toEntity()).toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
