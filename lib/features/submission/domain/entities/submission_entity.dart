import 'package:sortirin/features/submission/domain/entities/submission_item_entity.dart';

/// A video submission of waste sorting for validation.
class SubmissionEntity {
  final int? id;
  final String? videoUrl;
  final String? thumbnailUrl;
  final String videoHash;
  final double? gpsLat;
  final double? gpsLng;
  final String status; // draft, compressing, uploading, pending_review, approved, rejected, failed
  final int totalPoints;
  final String? rejectionReason;
  final List<SubmissionItemEntity> items;
  final DateTime? submittedAt;
  final DateTime? createdAt;

  const SubmissionEntity({
    this.id,
    this.videoUrl,
    this.thumbnailUrl,
    required this.videoHash,
    this.gpsLat,
    this.gpsLng,
    required this.status,
    this.totalPoints = 0,
    this.rejectionReason,
    required this.items,
    this.submittedAt,
    this.createdAt,
  });
}
