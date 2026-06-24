import 'package:sortirin/features/submission/domain/entities/submission_entity.dart';
import 'package:sortirin/features/submission/domain/entities/submission_item_entity.dart';
import 'package:sortirin/features/submission/domain/repositories/submission_repository.dart';

/// Create a submission record and return the new ID.
class CreateSubmissionUseCase {
  final SubmissionRepository _repository;

  CreateSubmissionUseCase(this._repository);

  Future<int> call({
    required List<SubmissionItemEntity> items,
    required String videoHash,
    double? gpsLat,
    double? gpsLng,
  }) {
    final submission = SubmissionEntity(
      videoHash: videoHash,
      status: 'draft',
      items: items,
      gpsLat: gpsLat,
      gpsLng: gpsLng,
    );
    return _repository.createSubmission(submission);
  }
}
