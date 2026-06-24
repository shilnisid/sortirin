/// Video compression service — client-side compression before upload.
/// Wraps the `video_compress` package.
class VideoCompressionService {
  VideoCompressionService._();

  /// Maximum video file size after compression (50 MB).
  static const int maxFileSizeBytes = 50 * 1024 * 1024;

  /// Compress a video file at [inputPath].
  ///
  /// Returns the path to the compressed output file, or the original path
  /// if compression fails or the file is already small enough.
  static Future<String> compress({
    required String inputPath,
    int quality = 70, // 0–100
  }) async {
    // TODO: Implement with video_compress package:
    // final info = await MediaInfo.file(inputPath);
    // if (info.filesize < maxFileSizeBytes) return inputPath;
    // final result = await Compress.compressVideo(
    //   inputPath,
    //   quality: quality,
    //   deleteOrigin: false,
    // );
    // return result?.path ?? inputPath;
    return inputPath;
  }
}
