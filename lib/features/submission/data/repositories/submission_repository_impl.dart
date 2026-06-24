import 'package:sortirin/core/errors/exceptions.dart';
import 'package:sortirin/features/submission/data/datasources/submission_remote_datasource.dart';
import 'package:sortirin/features/submission/data/models/submission_model.dart';
import 'package:sortirin/features/submission/domain/entities/submission_entity.dart';
import 'package:sortirin/features/submission/domain/repositories/submission_repository.dart';

class SubmissionRepositoryImpl implements SubmissionRepository {
  final SubmissionRemoteDataSource _remote;

  SubmissionRepositoryImpl(this._remote);

  @override
  Future<int> createSubmission(SubmissionEntity submission) async {
    try {
      final model = SubmissionModel.fromEntity(submission);
      final id = await _remote.createSubmission(model.toJson());

      // Insert items with the submission ID
      if (model.items.isNotEmpty) {
        final itemJsons = model.items
            .map((e) => e.toJson()
              ..['submission_id'] = id)
            .toList();
        await _remote.insertItems(itemJsons);
      }

      return id;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw const ServerException('Gagal membuat submission');
    }
  }

  @override
  Future<String> uploadVideo({
    required String userId,
    required String filePath,
    required String storagePath,
  }) async {
    try {
      return await _remote.uploadFile(
        bucket: 'videos',
        path: storagePath,
        filePath: filePath,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw const ServerException('Gagal upload video');
    }
  }

  @override
  Future<void> updateSubmissionStatus({
    required int submissionId,
    required String status,
    String? videoUrl,
  }) async {
    try {
      await _remote.updateStatus(
        submissionId: submissionId,
        status: status,
        videoUrl: videoUrl,
        submittedAt: status == 'pending_review' ? DateTime.now() : null,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw const ServerException('Gagal update status submission');
    }
  }

  @override
  Future<List<SubmissionEntity>> getHistory({int page = 1, int limit = 20}) async {
    try {
      // Note: user ID is extracted from the auth state in the datasource
      // The datasource uses auth.uid() via RLS
      final models = await _remote.getHistory(
        userId: '', // will be handled by RLS
        page: page,
        limit: limit,
      );
      return models.map((m) {
        return SubmissionModel.fromJson(m).toEntity();
      }).toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw const ServerException('Gagal mengambil riwayat');
    }
  }

  @override
  Future<bool> isVideoHashExists(String hash) async {
    try {
      return await _remote.isVideoHashExists(hash);
    } catch (e) {
      return false; // fail open — better to let a dupe through than block legit users
    }
  }

  @override
  Future<void> deleteSubmission(int submissionId) async {
    try {
      await _remote.deleteSubmission(submissionId);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw const ServerException('Gagal menghapus submission');
    }
  }
}
