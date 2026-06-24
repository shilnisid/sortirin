/// A reward redemption record.
class RedemptionEntity {
  final int id;
  final int rewardId;
  final String rewardName;
  final int pointsSpent;
  final String status;
  final DateTime createdAt;
  final String? rejectionReason;

  const RedemptionEntity({
    required this.id,
    required this.rewardId,
    required this.rewardName,
    required this.pointsSpent,
    this.status = 'pending',
    required this.createdAt,
    this.rejectionReason,
  });
}
