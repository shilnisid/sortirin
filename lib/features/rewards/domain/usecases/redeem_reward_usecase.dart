import 'package:sortirin/features/rewards/domain/entities/redemption_entity.dart';
import 'package:sortirin/features/rewards/domain/repositories/reward_repository.dart';

class RedeemRewardUseCase {
  final RewardRepository _repo;
  RedeemRewardUseCase(this._repo);

  Future<RedemptionEntity> call({
    required String userId, required int rewardId, required int pointsCost,
  }) => _repo.redeemReward(userId: userId, rewardId: rewardId, pointsCost: pointsCost);
}
