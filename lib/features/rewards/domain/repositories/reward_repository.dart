import 'package:sortirin/features/rewards/domain/entities/reward_entity.dart';
import 'package:sortirin/features/rewards/domain/entities/redemption_entity.dart';

abstract class RewardRepository {
  Future<List<RewardEntity>> getRewards({String? category});
  Future<RewardEntity> getRewardById(int id);
  Future<RedemptionEntity> redeemReward({
    required String userId,
    required int rewardId,
    required int pointsCost,
  });
  Future<List<RedemptionEntity>> getRedemptionHistory(String userId);
}
