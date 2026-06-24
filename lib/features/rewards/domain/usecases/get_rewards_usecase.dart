import 'package:sortirin/features/rewards/domain/entities/reward_entity.dart';
import 'package:sortirin/features/rewards/domain/repositories/reward_repository.dart';

class GetRewardsUseCase {
  final RewardRepository _repo;
  GetRewardsUseCase(this._repo);

  Future<List<RewardEntity>> call({String? category}) => _repo.getRewards(category: category);
}
