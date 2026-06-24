import 'package:sortirin/features/submission/domain/entities/submission_entity.dart';
import 'package:sortirin/features/submission/domain/repositories/submission_repository.dart';

/// Get paginated submission history.
class GetSubmissionHistoryUseCase {
  final SubmissionRepository _repository;

  GetSubmissionHistoryUseCase(this._repository);

  Future<List<SubmissionEntity>> call({int page = 1, int limit = 20}) {
    return _repository.getHistory(page: page, limit: limit);
  }
}
