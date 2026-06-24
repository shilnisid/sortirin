import 'package:get/get.dart';
import 'package:sortirin/features/rewards/presentation/controllers/reward_controller.dart';

class RewardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RewardController>(() => RewardController());
  }
}
