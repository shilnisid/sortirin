import 'dart:io';
import 'package:sortirin/core/network/supabase_client.dart';
import 'package:storage_client/storage_client.dart' show FileOptions;

/// Remote data source for submissions — Supabase DB + Storage.
class SubmissionRemoteDataSource {
  /// Create a new submission row, return the generated ID.
  Future<int> createSubmission(Map<String, dynamic> data) async {
    final supabase = SupabaseClientService.client;
    final response = await supabase
        .from('submissions')
        .insert(data)
        .select('id')
        .single();
    return response['id'] as int;
  }

  /// Insert submission items in bulk.
  Future<void> insertItems(List<Map<String, dynamic>> items) async {
    final supabase = SupabaseClientService.client;
    await supabase.from('submission_items').insert(items);
  }

  /// Upload a file to Supabase Storage.
  Future<String> uploadFile({
    required String bucket,
    required String path,
    required String filePath,
  }) async {
    final supabase = SupabaseClientService.client;
    final file = File(filePath);
    await supabase.storage.from(bucket).upload(
          path,
          file,
          fileOptions: const FileOptions(upsert: false),
        );
    final publicUrl = supabase.storage.from(bucket).getPublicUrl(path);
    return publicUrl;
  }

  /// Update submission after upload completes.
  Future<void> updateStatus({
    required int submissionId,
    required String status,
    String? videoUrl,
    String? thumbnailUrl,
    DateTime? submittedAt,
  }) async {
    final supabase = SupabaseClientService.client;
    final data = <String, dynamic>{'status': status};
    if (videoUrl != null) data['video_url'] = videoUrl;
    if (thumbnailUrl != null) data['thumbnail_url'] = thumbnailUrl;
    if (submittedAt != null) data['submitted_at'] = submittedAt.toIso8601String();

    await supabase.from('submissions').update(data).eq('id', submissionId);
  }

  /// Check if a video hash already exists (anti-replay).
  Future<bool> isVideoHashExists(String hash) async {
    final supabase = SupabaseClientService.client;
    final response = await supabase
        .from('submissions')
        .select('id')
        .eq('video_hash', hash)
        .maybeSingle();
    return response != null;
  }

  /// Get paginated history for current user.
  Future<List<Map<String, dynamic>>> getHistory({
    required String userId,
    int page = 1,
    int limit = 20,
  }) async {
    final supabase = SupabaseClientService.client;
    final from = (page - 1) * limit;
    final to = from + limit - 1;
    final response = await supabase
        .from('submissions')
        .select('*')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .range(from, to);
    return (response as List<dynamic>).cast<Map<String, dynamic>>();
  }

  /// Delete a submission (draft or failed).
  Future<void> deleteSubmission(int submissionId) async {
    final supabase = SupabaseClientService.client;
    await supabase.from('submissions').delete().eq('id', submissionId);
  }
}
