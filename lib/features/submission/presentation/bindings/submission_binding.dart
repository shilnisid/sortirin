import 'package:get/get.dart';
import 'package:sortirin/features/submission/data/datasources/submission_remote_datasource.dart';
import 'package:sortirin/features/submission/data/datasources/submission_local_datasource.dart';
import 'package:sortirin/features/submission/data/repositories/submission_repository_impl.dart';
import 'package:sortirin/features/submission/domain/repositories/submission_repository.dart';
import 'package:sortirin/features/submission/domain/usecases/create_submission_usecase.dart';
import 'package:sortirin/features/submission/domain/usecases/upload_video_usecase.dart';
import 'package:sortirin/features/submission/domain/usecases/get_submission_history_usecase.dart';
import 'package:sortirin/features/submission/presentation/controllers/submission_controller.dart';
import 'package:sortirin/features/submission/presentation/controllers/camera_controller.dart';

class SubmissionBinding extends Bindings {
  @override
  void dependencies() {
    // Data sources
    Get.lazyPut<SubmissionRemoteDataSource>(() => SubmissionRemoteDataSource());
    Get.lazyPut<SubmissionLocalDataSource>(() => SubmissionLocalDataSource());

    // Repository
    Get.lazyPut<SubmissionRepository>(
      () => SubmissionRepositoryImpl(Get.find<SubmissionRemoteDataSource>()),
    );

    // Use cases
    Get.lazyPut<CreateSubmissionUseCase>(
      () => CreateSubmissionUseCase(Get.find<SubmissionRepository>()),
    );
    Get.lazyPut<UploadVideoUseCase>(
      () => UploadVideoUseCase(Get.find<SubmissionRepository>()),
    );
    Get.lazyPut<GetSubmissionHistoryUseCase>(
      () => GetSubmissionHistoryUseCase(Get.find<SubmissionRepository>()),
    );

    // Controllers
    Get.lazyPut<CameraController>(() => CameraController());
    Get.lazyPut<SubmissionController>(
      () => SubmissionController(
        createUseCase: Get.find<CreateSubmissionUseCase>(),
        uploadUseCase: Get.find<UploadVideoUseCase>(),
        historyUseCase: Get.find<GetSubmissionHistoryUseCase>(),
      ),
    );
  }
}
