import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:sortirin/core/utils/device_fingerprint_util.dart';
import 'package:sortirin/core/utils/gps_util.dart';
import 'package:sortirin/core/utils/hash_util.dart';
import 'package:sortirin/core/network/supabase_client.dart';

/// Unifies all anti-cheat checks and stores audit trail.
class AntiCheatService {
  /// Collect all anti-cheat metadata for a submission.
  static Future<Map<String, dynamic>> collectMetadata({
    required String userId,
    required String videoPath,
  }) async {
    final deviceInfo = await DeviceFingerprintUtil.getFingerprint();
    final position = await GpsUtil.getCurrentPosition();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // Read video file bytes for hash
    final videoFile = File(videoPath);
    Uint8List? videoBytes;
    if (await videoFile.exists()) {
      videoBytes = await videoFile.readAsBytes();
    }

    final videoHash = HashUtil.computeVideoFingerprint(
      videoBytes: videoBytes ?? Uint8List(0),
      timestamp: timestamp,
      userId: userId,
    );

    return {
      'user_id': userId,
      'device_fingerprint': deviceInfo,
      'gps_lat': position?.latitude,
      'gps_lng': position?.longitude,
      'gps_accuracy': position?.accuracy,
      'video_hash': videoHash,
      'timestamp': timestamp,
      'platform': Platform.operatingSystem,
    };
  }

  /// Record audit entry in Supabase uploads_audit table.
  static Future<void> recordAudit(Map<String, dynamic> metadata) async {
    await SupabaseClientService.client
        .from('uploads_audit')
        .insert({
          'user_id': metadata['user_id'],
          'device_fingerprint': jsonEncode(metadata['device_fingerprint']),
          'gps_lat': metadata['gps_lat'],
          'gps_lng': metadata['gps_lng'],
          'video_hash': metadata['video_hash'],
          'metadata': jsonEncode({
            'platform': metadata['platform'],
            'timestamp': metadata['timestamp'],
            'gps_accuracy': metadata['gps_accuracy'],
          }),
        });
  }

  /// Validate submission integrity.
  static bool validateIntegrity(Map<String, dynamic> metadata) {
    if (metadata['video_hash'] == null || (metadata['video_hash'] as String).isEmpty) {
      return false;
    }
    if (metadata['device_fingerprint'] == null) {
      return false;
    }
    return true;
  }
}
