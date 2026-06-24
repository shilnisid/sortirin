import 'package:camera/camera.dart';

/// Singleton camera service — manages camera lifecycle.
/// Ensures gallery access is blocked (in-app camera only).
class CameraService {
  CameraService._();

  static List<CameraDescription>? _cameras;

  static Future<void> init() async {
    _cameras = await availableCameras();
  }

  /// Get the back camera (preferred) or fallback to any available.
  static CameraDescription? get backCamera {
    if (_cameras == null) return null;
    try {
      return _cameras!.firstWhere((c) => c.lensDirection == CameraLensDirection.back);
    } catch (_) {
      return _cameras!.isNotEmpty ? _cameras!.first : null;
    }
  }

  /// Get the front camera.
  static CameraDescription? get frontCamera {
    if (_cameras == null) return null;
    try {
      return _cameras!.firstWhere((c) => c.lensDirection == CameraLensDirection.front);
    } catch (_) {
      return null;
    }
  }

  static bool get hasCamera => _cameras != null && _cameras!.isNotEmpty;

  /// Cleanup.
  static void dispose() {
    _cameras = null;
  }
}
