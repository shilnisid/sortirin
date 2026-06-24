import 'package:sortirin/features/rewards/domain/entities/redemption_entity.dart';

class RedemptionModel {
  final int id; final int rewardId; final String rewardName;
  final int pointsSpent; final String status;
  final DateTime createdAt; final String? rejectionReason;

  const RedemptionModel({
    required this.id, required this.rewardId, required this.rewardName,
    required this.pointsSpent, this.status = 'pending',
    required this.createdAt, this.rejectionReason,
  });

  factory RedemptionModel.fromJson(Map<String, dynamic> json) {
    final reward = json['rewards'] as Map<String, dynamic>?;
    return RedemptionModel(
      id: json['id'] as int,
      rewardId: json['reward_id'] as int? ?? 0,
      rewardName: reward?['name'] as String? ?? json['reward_name'] as String? ?? '',
      pointsSpent: json['points_spent'] as int? ?? 0,
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      rejectionReason: json['rejection_reason'] as String?,
    );
  }

  RedemptionEntity toEntity() => RedemptionEntity(
    id: id, rewardId: rewardId, rewardName: rewardName,
    pointsSpent: pointsSpent, status: status,
    createdAt: createdAt, rejectionReason: rejectionReason,
  );
}
