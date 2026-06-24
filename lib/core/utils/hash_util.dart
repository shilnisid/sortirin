import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

/// SHA-256 hashing utilities for anti-cheat video fingerprinting.
class HashUtil {
  HashUtil._();

  /// Compute SHA-256 hash of raw bytes.
  static String hashBytes(Uint8List bytes) {
    return sha256.convert(bytes).toString();
  }

  /// Compute SHA-256 hash of a string.
  static String hashString(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  }

  /// Create a composite hash from [videoBytes] + [timestamp] + [userId].
  /// Used as the unique fingerprint stored in the database for anti-replay.
  static String computeVideoFingerprint({
    required Uint8List videoBytes,
    required int timestamp,
    required String userId,
  }) {
    final combined = Uint8List.fromList([
      ...videoBytes,
      ...utf8.encode(timestamp.toString()),
      ...utf8.encode(userId),
    ]);
    return sha256.convert(combined).toString();
  }
}
