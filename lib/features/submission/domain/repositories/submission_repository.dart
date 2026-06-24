import 'package:sortirin/features/submission/domain/entities/submission_entity.dart';

/// Abstract repository for submissions.
/// Implementation lives in the data layer.
abstract class SubmissionRepository {
  /// Create a new submission record in the remote DB.
  Future<int> createSubmission(SubmissionEntity submission);

  /// Upload a video file to storage.
  Future<String> uploadVideo({
    required String userId,
    required String filePath,
    required String storagePath,
  });

  /// Update submission status after upload completes.
  Future<void> updateSubmissionStatus({
    required int submissionId,
    required String status,
    String? videoUrl,
  });

  /// Get paginated submission history for the current user.
  Future<List<SubmissionEntity>> getHistory({
    int page = 1,
    int limit = 20,
  });

  /// Check if a video hash already exists (anti-replay).
  Future<bool> isVideoHashExists(String hash);

  /// Delete a failed/draft submission.
  Future<void> deleteSubmission(int submissionId);
}
