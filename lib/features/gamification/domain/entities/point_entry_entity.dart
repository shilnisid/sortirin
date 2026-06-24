/// A single points ledger entry (immutable record).
class PointEntryEntity {
  final int id;
  final int pointsBefore;
  final int pointsEarned;
  final int pointsAfter;
  final String reason;
  final DateTime createdAt;

  const PointEntryEntity({
    required this.id,
    required this.pointsBefore,
    required this.pointsEarned,
    required this.pointsAfter,
    required this.reason,
    required this.createdAt,
  });
}
