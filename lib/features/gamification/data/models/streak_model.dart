import 'package:sortirin/features/gamification/domain/entities/streak_info_entity.dart';

class StreakModel {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastSubmissionDate;
  final DateTime? streakFreezeExpires;

  const StreakModel({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastSubmissionDate,
    this.streakFreezeExpires,
  });

  factory StreakModel.fromJson(Map<String, dynamic> json) {
    return StreakModel(
      currentStreak: json['current_streak'] as int? ?? 0,
      longestStreak: json['longest_streak'] as int? ?? 0,
      lastSubmissionDate: json['last_submission_date'] != null
          ? DateTime.tryParse(json['last_submission_date'] as String)
          : null,
      streakFreezeExpires: json['streak_freeze_expires'] != null
          ? DateTime.tryParse(json['streak_freeze_expires'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'current_streak': currentStreak,
    'longest_streak': longestStreak,
    'last_submission_date': lastSubmissionDate?.toIso8601String(),
    'streak_freeze_expires': streakFreezeExpires?.toIso8601String(),
  };

  StreakInfoEntity toEntity() => StreakInfoEntity(
    currentStreak: currentStreak,
    longestStreak: longestStreak,
    lastSubmissionDate: lastSubmissionDate,
    hasFreezeActive: streakFreezeExpires != null && streakFreezeExpires!.isAfter(DateTime.now()),
  );
}
