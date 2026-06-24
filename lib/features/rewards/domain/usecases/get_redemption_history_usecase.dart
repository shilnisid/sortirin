import 'package:sortirin/features/rewards/domain/entities/redemption_entity.dart';
import 'package:sortirin/features/rewards/domain/repositories/reward_repository.dart';

class GetRedemptionHistoryUseCase {
  final RewardRepository _repo;
  GetRedemptionHistoryUseCase(this._repo);

  Future<List<RedemptionEntity>> call(String userId) => _repo.getRedemptionHistory(userId);
}
