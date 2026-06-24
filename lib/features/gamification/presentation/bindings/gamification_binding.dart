import 'package:get/get.dart';
import 'package:sortirin/core/network/supabase_client.dart';
import 'package:sortirin/features/gamification/data/datasources/gamification_remote_datasource.dart';
import 'package:sortirin/features/gamification/data/repositories/gamification_repository_impl.dart';
import 'package:sortirin/features/gamification/domain/repositories/gamification_repository.dart';
import 'package:sortirin/features/gamification/domain/usecases/check_streak_and_badges_usecase.dart';
import 'package:sortirin/features/gamification/domain/usecases/get_points_summary_usecase.dart';
import 'package:sortirin/features/gamification/presentation/controllers/gamification_controller.dart';

class GamificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GamificationRemoteDataSource>(
      () => GamificationRemoteDataSource(SupabaseClientService.client),
    );
    Get.lazyPut<GamificationRepository>(
      () => GamificationRepositoryImpl(Get.find<GamificationRemoteDataSource>()),
    );
    Get.lazyPut(() => GetPointsSummaryUseCase(Get.find<GamificationRepository>()));
    Get.lazyPut(() => CheckStreakAndBadgesUseCase(Get.find<GamificationRepository>()));
    Get.lazyPut<GamificationController>(() => GamificationController(
      getSummary: Get.find<GetPointsSummaryUseCase>(),
      checkStreakBadges: Get.find<CheckStreakAndBadgesUseCase>(),
      repo: Get.find<GamificationRepository>(),
    ));
  }
}
