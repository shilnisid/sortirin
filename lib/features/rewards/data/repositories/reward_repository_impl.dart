import 'package:sortirin/core/errors/failures.dart';
import 'package:sortirin/features/rewards/data/datasources/reward_remote_datasource.dart';
import 'package:sortirin/features/rewards/domain/entities/reward_entity.dart';
import 'package:sortirin/features/rewards/domain/entities/redemption_entity.dart';
import 'package:sortirin/features/rewards/domain/repositories/reward_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

class RewardRepositoryImpl implements RewardRepository {
  final RewardRemoteDataSource _remote;
  RewardRepositoryImpl(this._remote);

  @override
  Future<List<RewardEntity>> getRewards({String? category}) async {
    try {
      return (await _remote.getRewards(category: category)).map((m) => m.toEntity()).toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<RewardEntity> getRewardById(int id) async {
    try {
      return (await _remote.getRewardById(id)).toEntity();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<RedemptionEntity> redeemReward({
    required String userId, required int rewardId, required int pointsCost,
  }) async {
    try {
      return (await _remote.redeemReward(userId: userId, rewardId: rewardId, pointsCost: pointsCost)).toEntity();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<List<RedemptionEntity>> getRedemptionHistory(String userId) async {
    try {
      return (await _remote.getRedemptionHistory(userId)).map((m) => m.toEntity()).toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
