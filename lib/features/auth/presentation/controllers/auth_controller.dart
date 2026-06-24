import 'package:get/get.dart';
import 'package:sortirin/app/routes/app_routes.dart';
import 'package:sortirin/core/errors/failures.dart';
import 'package:sortirin/features/auth/domain/entities/profile_entity.dart';
import 'package:sortirin/features/auth/domain/usecases/sign_in_google_usecase.dart';
import 'package:sortirin/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:sortirin/features/auth/domain/usecases/update_profile_usecase.dart';

/// Authentication controller using GetX.
class AuthController extends GetxController {
  final SignInGoogleUseCase _signInGoogle;
  final SignOutUseCase _signOut;
  final UpdateProfileUseCase _updateProfile;

  AuthController({
    required SignInGoogleUseCase signInGoogle,
    required SignOutUseCase signOut,
    required UpdateProfileUseCase updateProfile,
  })  : _signInGoogle = signInGoogle,
        _signOut = signOut,
        _updateProfile = updateProfile;

  // ── Reactive State ──
  final profile = Rx<ProfileEntity?>(null);
  final isLoading = false.obs;
  final errorMessage = RxString('');

  // ── Computed ──
  bool get isLoggedIn => profile.value != null;
  bool get needsProfileCompletion =>
      profile.value != null && !profile.value!.isProfileComplete;

  // ── Methods ──

  /// Sign in with Google.
  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _signInGoogle();
      profile.value = result.profile;

      if (result.isNewUser || !result.profile.isProfileComplete) {
        Get.offNamed(AppRoutes.completeProfile);
      } else {
        Get.offNamed(AppRoutes.home);
      }
    } on AuthFailure catch (e) {
      errorMessage.value = e.message;
    } on ServerFailure catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan. Silakan coba lagi.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Complete profile (phone, city, district).
  Future<void> completeProfile({
    required String phone,
    String? city,
    String? district,
  }) async {
    if (profile.value == null) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final updated = await _updateProfile(
        userId: profile.value!.id,
        phone: phone,
        city: city,
        district: district,
      );
      profile.value = updated;
      Get.offAllNamed(AppRoutes.mainShell);
    } on ServerFailure catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Gagal menyimpan profil. Silakan coba lagi.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign out.
  Future<void> signOut() async {
    try {
      await _signOut();
      profile.value = null;
      Get.offAllNamed(AppRoutes.onboarding);
    } catch (e) {
      errorMessage.value = 'Gagal keluar. Silakan coba lagi.';
    }
  }

  /// Check session on app start.
  Future<void> checkSession() async {
    // This will be called from InitialBinding or splash screen.
    // For now, just redirect to onboarding.
  }
}
