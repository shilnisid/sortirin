import 'package:sortirin/features/submission/data/models/submission_item_model.dart';
import 'package:sortirin/features/submission/domain/entities/submission_entity.dart';

/// JSON-serializable model for a submission.
class SubmissionModel {
  final int? id;
  final String? userId;
  final String? videoUrl;
  final String? thumbnailUrl;
  final String? videoHash;
  final double? gpsLat;
  final double? gpsLng;
  final String status;
  final int totalPoints;
  final String? rejectionReason;
  final List<SubmissionItemModel> items;
  final DateTime? submittedAt;
  final DateTime? createdAt;

  const SubmissionModel({
    this.id,
    this.userId,
    this.videoUrl,
    this.thumbnailUrl,
    this.videoHash,
    this.gpsLat,
    this.gpsLng,
    required this.status,
    this.totalPoints = 0,
    this.rejectionReason,
    this.items = const [],
    this.submittedAt,
    this.createdAt,
  });

  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    return SubmissionModel(
      id: json['id'] as int?,
      userId: json['user_id'] as String?,
      videoUrl: json['video_url'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      videoHash: json['video_hash'] as String?,
      gpsLat: (json['gps_lat'] as num?)?.toDouble(),
      gpsLng: (json['gps_lng'] as num?)?.toDouble(),
      status: json['status'] as String? ?? 'draft',
      totalPoints: json['total_points'] as int? ?? 0,
      rejectionReason: json['rejection_reason'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => SubmissionItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      submittedAt: json['submitted_at'] != null
          ? DateTime.parse(json['submitted_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (userId != null) 'user_id': userId,
        if (videoUrl != null) 'video_url': videoUrl,
        if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
        if (videoHash != null) 'video_hash': videoHash,
        if (gpsLat != null) 'gps_lat': gpsLat,
        if (gpsLng != null) 'gps_lng': gpsLng,
        'status': status,
        if (totalPoints > 0) 'total_points': totalPoints,
        if (rejectionReason != null) 'rejection_reason': rejectionReason,
        if (submittedAt != null) 'submitted_at': submittedAt!.toIso8601String(),
      };

  SubmissionEntity toEntity() => SubmissionEntity(
        id: id,
        videoUrl: videoUrl,
        thumbnailUrl: thumbnailUrl,
        videoHash: videoHash ?? '',
        gpsLat: gpsLat,
        gpsLng: gpsLng,
        status: status,
        totalPoints: totalPoints,
        rejectionReason: rejectionReason,
        items: items.map((e) => e.toEntity()).toList(),
        submittedAt: submittedAt,
        createdAt: createdAt,
      );

  factory SubmissionModel.fromEntity(SubmissionEntity entity) {
    return SubmissionModel(
      videoHash: entity.videoHash,
      gpsLat: entity.gpsLat,
      gpsLng: entity.gpsLng,
      status: entity.status,
      totalPoints: entity.totalPoints,
      items: entity.items
          .map((e) => SubmissionItemModel.fromEntity(e))
          .toList(),
    );
  }
}
