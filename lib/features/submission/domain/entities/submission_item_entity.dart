/// A single waste item within a submission.
class SubmissionItemEntity {
  final int? wasteTypeId;
  final String? wasteTypeName; // display label
  final int quantity;
  final int basePoints;

  const SubmissionItemEntity({
    this.wasteTypeId,
    this.wasteTypeName,
    required this.quantity,
    this.basePoints = 0,
  });
}
