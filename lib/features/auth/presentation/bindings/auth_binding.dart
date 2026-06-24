import 'package:get/get.dart';
import 'package:sortirin/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:sortirin/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:sortirin/features/auth/domain/repositories/auth_repository.dart';
import 'package:sortirin/features/auth/domain/usecases/sign_in_google_usecase.dart';
import 'package:sortirin/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:sortirin/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:sortirin/features/auth/presentation/controllers/auth_controller.dart';

/// Dependency injection for Auth feature.
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Data source
    Get.lazyPut<AuthRemoteDataSource>(() => AuthRemoteDataSource());

    // Repository
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(Get.find<AuthRemoteDataSource>()),
    );

    // Use cases
    Get.lazyPut<SignInGoogleUseCase>(
      () => SignInGoogleUseCase(Get.find<AuthRepository>()),
    );
    Get.lazyPut<SignOutUseCase>(
      () => SignOutUseCase(Get.find<AuthRepository>()),
    );
    Get.lazyPut<UpdateProfileUseCase>(
      () => UpdateProfileUseCase(Get.find<AuthRepository>()),
    );

    // Controller
    Get.lazyPut<AuthController>(() => AuthController(
          signInGoogle: Get.find<SignInGoogleUseCase>(),
          signOut: Get.find<SignOutUseCase>(),
          updateProfile: Get.find<UpdateProfileUseCase>(),
        ));
  }
}
