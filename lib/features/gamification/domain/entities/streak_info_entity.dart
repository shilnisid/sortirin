/// User's streak information.
class StreakInfoEntity {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastSubmissionDate;
  final bool hasFreezeActive;

  const StreakInfoEntity({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastSubmissionDate,
    this.hasFreezeActive = false,
  });

  bool get isStreakActive => currentStreak > 0;

  int get daysSinceLastSubmission => lastSubmissionDate != null
      ? DateTime.now().difference(lastSubmissionDate!).inDays
      : 999;
}
