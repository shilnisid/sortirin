import 'package:get/get.dart';
import 'package:sortirin/features/submission/domain/usecases/create_submission_usecase.dart';
import 'package:sortirin/features/submission/domain/usecases/upload_video_usecase.dart';
import 'package:sortirin/features/submission/domain/usecases/get_submission_history_usecase.dart';
import 'package:sortirin/features/submission/domain/entities/submission_entity.dart';
import 'package:sortirin/features/submission/domain/entities/submission_item_entity.dart';

/// Controller for the full submission flow.
class SubmissionController extends GetxController {
  final CreateSubmissionUseCase _createUseCase;
  final UploadVideoUseCase _uploadUseCase;
  final GetSubmissionHistoryUseCase _historyUseCase;

  SubmissionController({
    required CreateSubmissionUseCase createUseCase,
    required UploadVideoUseCase uploadUseCase,
    required GetSubmissionHistoryUseCase historyUseCase,
  })  : _createUseCase = createUseCase,
        _uploadUseCase = uploadUseCase,
        _historyUseCase = historyUseCase;

  // ── Reactive state ──
  final status = RxString('idle'); // idle → compressing → uploading → pending_review
  final selectedWasteTypes = <Map<String, dynamic>>[].obs;
  final submissions = <SubmissionEntity>[].obs;
  final isHistoryLoading = false.obs;
  final uploadProgress = 0.0.obs;
  final currentSubmissionId = 0.obs;

  /// Update selected waste items. Each item: {wasteTypeId, name, basePoints, quantity}
  void updateSelectedItems(List<Map<String, dynamic>> items) {
    selectedWasteTypes.assignAll(items);
  }

  /// Calculate estimated points from selected items.
  int get estimatedPoints {
    int total = 0;
    for (final item in selectedWasteTypes) {
      final qty = item['quantity'] as int? ?? 1;
      final base = item['basePoints'] as int? ?? 0;
      total += base * qty;
    }
    return total;
  }

  /// Submit a recorded video for validation.
  Future<void> submitVideo({
    required String videoPath,
    required String videoHash,
    required String userId,
    double? lat,
    double? lng,
  }) async {
    try {
      status.value = 'compressing';

      // TODO: video compression via VideoCompressionService (M2 integration)

      status.value = 'uploading';

      // Create submission record first
      final items = selectedWasteTypes.map((w) {
        return SubmissionItemEntity(
          wasteTypeId: w['wasteTypeId'] as int?,
          wasteTypeName: w['name'] as String?,
          quantity: w['quantity'] as int? ?? 1,
          basePoints: w['basePoints'] as int? ?? 0,
        );
      }).toList();

      // 1. Create DB record
      final submissionId = await _createUseCase(
        items: items,
        videoHash: videoHash,
        gpsLat: lat,
        gpsLng: lng,
      );
      currentSubmissionId.value = submissionId;

      // 2. Upload video
      uploadProgress.value = 0.0;
      // ignore: unused_local_variable
      final videoUrl = await _uploadUseCase(
        userId: userId,
        filePath: videoPath,
        storagePath: 'submissions/$userId/$submissionId/video.mp4',
      );

      // 3. Mark as pending_review
      status.value = 'pending_review';

      // TODO: update submission status with video URL via repository
      // TODO: trigger thumbnail generation
    } catch (e) {
      status.value = 'failed';
    }
  }

  /// Load submission history.
  Future<void> loadHistory({int page = 1}) async {
    isHistoryLoading.value = true;
    try {
      final result = await _historyUseCase(page: page);
      if (page == 1) {
        submissions.assignAll(result);
      } else {
        submissions.addAll(result);
      }
    } finally {
      isHistoryLoading.value = false;
    }
  }

  /// Reset the submission flow.
  void reset() {
    status.value = 'idle';
    selectedWasteTypes.clear();
    uploadProgress.value = 0.0;
    currentSubmissionId.value = 0;
  }
}
