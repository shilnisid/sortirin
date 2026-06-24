import 'package:get/get.dart';
import 'package:sortirin/core/network/supabase_client.dart';
import 'package:sortirin/features/rewards/data/datasources/reward_remote_datasource.dart';
import 'package:sortirin/features/rewards/data/repositories/reward_repository_impl.dart';
import 'package:sortirin/features/rewards/domain/repositories/reward_repository.dart';
import 'package:sortirin/features/rewards/domain/usecases/get_rewards_usecase.dart';
import 'package:sortirin/features/rewards/domain/usecases/redeem_reward_usecase.dart';
import 'package:sortirin/features/rewards/domain/usecases/get_redemption_history_usecase.dart';
import 'package:sortirin/features/rewards/presentation/controllers/reward_controller.dart';

class RewardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RewardRemoteDataSource>(
      () => RewardRemoteDataSource(SupabaseClientService.client),
    );
    Get.lazyPut<RewardRepository>(
      () => RewardRepositoryImpl(Get.find<RewardRemoteDataSource>()),
    );
    Get.lazyPut(() => GetRewardsUseCase(Get.find<RewardRepository>()));
    Get.lazyPut(() => RedeemRewardUseCase(Get.find<RewardRepository>()));
    Get.lazyPut(() => GetRedemptionHistoryUseCase(Get.find<RewardRepository>()));
    Get.lazyPut<RewardController>(() => RewardController(
      getRewards: Get.find<GetRewardsUseCase>(),
      redeem: Get.find<RedeemRewardUseCase>(),
      getHistory: Get.find<GetRedemptionHistoryUseCase>(),
    ));
  }
}
