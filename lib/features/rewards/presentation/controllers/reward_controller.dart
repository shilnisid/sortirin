import 'package:get/get.dart';
import 'package:sortirin/core/network/supabase_client.dart';
import 'package:sortirin/features/rewards/domain/entities/redemption_entity.dart';
import 'package:sortirin/features/rewards/domain/entities/reward_entity.dart';
import 'package:sortirin/features/rewards/domain/usecases/get_redemption_history_usecase.dart';
import 'package:sortirin/features/rewards/domain/usecases/get_rewards_usecase.dart';
import 'package:sortirin/features/rewards/domain/usecases/redeem_reward_usecase.dart';

class RewardController extends GetxController {
  final GetRewardsUseCase _getRewards;
  final RedeemRewardUseCase _redeem;
  final GetRedemptionHistoryUseCase _getHistory;

  RewardController({
    required GetRewardsUseCase getRewards,
    required RedeemRewardUseCase redeem,
    required GetRedemptionHistoryUseCase getHistory,
  })  : _getRewards = getRewards,
        _redeem = redeem,
        _getHistory = getHistory;

  final rewards = <RewardEntity>[].obs;
  final history = <RedemptionEntity>[].obs;
  final isLoading = true.obs;
  final isRedeeming = false.obs;
  final errorMessage = RxString('');
  final selectedCategory = RxString('all');

  @override
  void onInit() {
    super.onInit();
    loadRewards();
  }

  Future<void> loadRewards() async {
    isLoading.value = true;
    try {
      rewards.value = await _getRewards();
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Gagal memuat katalog reward';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadHistory() async {
    final userId = SupabaseClientService.client.auth.currentUser?.id;
    if (userId == null) return;
    history.value = await _getHistory.call(userId);
  }

  Future<bool> redeem(int rewardId, int pointsCost) async {
    final userId = SupabaseClientService.client.auth.currentUser?.id;
    if (userId == null) return false;

    isRedeeming.value = true;
    try {
      // ignore: unused_local_variable
      final result = await _redeem(
        userId: userId,
        rewardId: rewardId,
        pointsCost: pointsCost,
      );
      // Refresh
      await loadRewards();
      await loadHistory();
      Get.snackbar('Berhasil!', 'Penukaran berhasil diproses.');
      return true;
    } catch (e) {
      Get.snackbar('Gagal', 'Tidak dapat menukarkan reward. Coba lagi.');
      return false;
    } finally {
      isRedeeming.value = false;
    }
  }

  List<RewardEntity> get filteredRewards {
    if (selectedCategory.value == 'all') return rewards;
    return rewards.where((r) => r.category == selectedCategory.value).toList();
  }

  List<String> get categories {
    final cats = rewards.map((r) => r.category).toSet().toList();
    return ['all', ...cats];
  }
}
