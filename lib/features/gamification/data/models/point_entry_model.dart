import 'package:sortirin/features/gamification/domain/entities/point_entry_entity.dart';

class PointEntryModel {
  final int id;
  final int pointsBefore;
  final int pointsEarned;
  final int pointsAfter;
  final String reason;
  final DateTime createdAt;

  const PointEntryModel({
    required this.id,
    required this.pointsBefore,
    required this.pointsEarned,
    required this.pointsAfter,
    required this.reason,
    required this.createdAt,
  });

  factory PointEntryModel.fromJson(Map<String, dynamic> json) {
    return PointEntryModel(
      id: json['id'] as int,
      pointsBefore: json['points_before'] as int? ?? 0,
      pointsEarned: json['points_earned'] as int? ?? 0,
      pointsAfter: json['points_after'] as int? ?? 0,
      reason: json['reason'] as String? ?? '',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'points_before': pointsBefore,
    'points_earned': pointsEarned,
    'points_after': pointsAfter,
    'reason': reason,
  };

  PointEntryEntity toEntity() => PointEntryEntity(
    id: id,
    pointsBefore: pointsBefore,
    pointsEarned: pointsEarned,
    pointsAfter: pointsAfter,
    reason: reason,
    createdAt: createdAt,
  );
}
