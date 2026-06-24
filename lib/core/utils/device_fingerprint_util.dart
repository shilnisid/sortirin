import 'package:device_info_plus/device_info_plus.dart';

/// Device fingerprint utility for anti-cheat metadata.
class DeviceFingerprintUtil {
  DeviceFingerprintUtil._();

  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Gather device info as a Map for embedding in submission metadata.
  static Future<Map<String, dynamic>> getFingerprint() async {
    try {
      final androidInfo = await _deviceInfo.androidInfo;
      return {
        'device': androidInfo.model,
        'brand': androidInfo.brand,
        'sdk': androidInfo.version.sdkInt,
        'fingerprint': androidInfo.fingerprint,
        'id': androidInfo.id,
      };
    } catch (_) {
      try {
        final iosInfo = await _deviceInfo.iosInfo;
        return {
          'device': iosInfo.model,
          'system': iosInfo.systemName,
          'version': iosInfo.systemVersion,
          'identifier': iosInfo.identifierForVendor,
        };
      } catch (_) {
        return {'platform': 'unknown'};
      }
    }
  }
}
