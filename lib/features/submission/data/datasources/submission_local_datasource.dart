import 'dart:convert';
import 'package:sortirin/core/services/local_storage_service.dart';

/// Local data source for offline queue.
/// Stores pending submissions in Hive when user is offline.
class SubmissionLocalDataSource {
  static const _queueKey = 'offline_submission_queue';

  /// Save a submission draft locally for later upload.
  Future<void> enqueue(Map<String, dynamic> data) async {
    final queue = await _getQueue();
    queue.add(data);
    LocalStorageService.put(_queueKey, jsonEncode(queue));
  }

  /// Get the list of queued submissions.
  Future<List<Map<String, dynamic>>> getQueue() async {
    return _getQueue();
  }

  /// Remove a queued submission after successful upload.
  Future<void> dequeue(int index) async {
    final queue = await _getQueue();
    if (index < queue.length) {
      queue.removeAt(index);
      LocalStorageService.put(_queueKey, jsonEncode(queue));
    }
  }

  /// Clear the entire queue.
  Future<void> clearQueue() async {
    LocalStorageService.put(_queueKey, jsonEncode([]));
  }

  Future<List<Map<String, dynamic>>> _getQueue() async {
    final raw = LocalStorageService.getString(_queueKey);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }
}
