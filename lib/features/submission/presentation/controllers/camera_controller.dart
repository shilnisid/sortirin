import 'package:get/get.dart';

/// Controller for in-app camera — recording state, timer, block gallery.
class CameraController extends GetxController {
  // ── State ──
  final isRecording = false.obs;
  final isCameraReady = false.obs;
  final elapsedSeconds = 0.obs;
  final flashMode = false.obs;
  final cameraFacing = 0.obs; // 0 = back, 1 = front

  // ── Recording ──
  String? _recordedVideoPath;

  String? get recordedVideoPath => _recordedVideoPath;

  Future<void> startRecording() async {
    // Actual recording via camera package will be implemented in M2 integration
    isRecording.value = true;
    _recordedVideoPath = null;
  }

  Future<String?> stopRecording() async {
    isRecording.value = false;
    return _recordedVideoPath;
  }

  Future<void> toggleCamera() async {
    cameraFacing.value = cameraFacing.value == 0 ? 1 : 0;
  }

  Future<void> toggleFlash() async {
    flashMode.value = !flashMode.value;
  }

  @override
  void onClose() {
    // Cleanup camera resources
    super.onClose();
  }
}
