import 'package:sortirin/features/submission/domain/repositories/submission_repository.dart';

/// Upload a compressed video file to Supabase Storage.
class UploadVideoUseCase {
  final SubmissionRepository _repository;

  UploadVideoUseCase(this._repository);

  Future<String> call({
    required String userId,
    required String filePath,
    required String storagePath,
  }) {
    return _repository.uploadVideo(
      userId: userId,
      filePath: filePath,
      storagePath: storagePath,
    );
  }
}
