import 'package:get/get.dart';
import 'package:sortirin/app/routes/app_routes.dart';
import 'package:sortirin/features/auth/presentation/bindings/auth_binding.dart';
import 'package:sortirin/features/auth/presentation/views/login_view.dart';
import 'package:sortirin/features/auth/presentation/views/onboarding_view.dart';
import 'package:sortirin/features/auth/presentation/views/complete_profile_view.dart';
import 'package:sortirin/features/dashboard/presentation/bindings/dashboard_binding.dart';
import 'package:sortirin/features/dashboard/presentation/views/dashboard_view.dart';
import 'package:sortirin/features/dashboard/presentation/views/main_shell_view.dart';
import 'package:sortirin/features/leaderboard/presentation/bindings/leaderboard_binding.dart';
import 'package:sortirin/features/leaderboard/presentation/views/leaderboard_view.dart';
import 'package:sortirin/features/profile/presentation/views/profile_view.dart';
import 'package:sortirin/features/rewards/presentation/bindings/reward_binding.dart';
import 'package:sortirin/features/rewards/presentation/views/reward_catalog_view.dart';
import 'package:sortirin/features/rewards/presentation/views/redemption_history_view.dart';
import 'package:sortirin/features/submission/presentation/bindings/submission_binding.dart';
import 'package:sortirin/features/submission/presentation/views/waste_selector_view.dart';
import 'package:sortirin/features/submission/presentation/views/camera_view.dart';
import 'package:sortirin/features/submission/presentation/views/submission_result_view.dart';

/// All routes and their bindings.
class AppPages {
  AppPages._();

  static const initial = AppRoutes.onboarding;

  static final routes = [
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.completeProfile,
      page: () => const CompleteProfileView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const DashboardView(),
      bindings: [
        DashboardBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      bindings: [
        DashboardBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.mainShell,
      page: () => const MainShellView(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
    ),
    GetPage(
      name: AppRoutes.leaderboard,
      page: () => const LeaderboardView(),
      binding: LeaderboardBinding(),
    ),
    GetPage(
      name: AppRoutes.rewardCatalog,
      page: () => const RewardCatalogView(),
      binding: RewardBinding(),
    ),
    GetPage(
      name: AppRoutes.redemptionHistory,
      page: () => const RedemptionHistoryView(),
      binding: RewardBinding(),
    ),

    // ── Submission (F02) ──
    GetPage(
      name: AppRoutes.submissionSelect,
      page: () => const WasteSelectorView(),
      binding: SubmissionBinding(),
    ),
    GetPage(
      name: AppRoutes.submissionCamera,
      page: () => const CameraView(),
      binding: SubmissionBinding(),
    ),
    GetPage(
      name: AppRoutes.submissionResult,
      page: () => const SubmissionResultView(),
      binding: SubmissionBinding(),
    ),
  ];
}
