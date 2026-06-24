/// Pure function point calculator — no dependencies on Flutter/Supabase.
/// All calculations are deterministic and testable.
class PointCalculator {
  PointCalculator._();

  // ── Base points per waste type ──
  static const Map<String, int> basePoints = {
    'organik': 5,
    'kertas': 8,
    'plastik_lunak': 10,
    'plastik_keras': 12,
    'kaca': 12,
    'logam': 15,
    'tekstil': 10,
    'b3_ringan': 25,
    'b3_berat': 40,
    'residu': 3,
  };

  // ── Quantity multiplier ──
  static double quantityMultiplier(int totalItems) {
    if (totalItems >= 31) return 2.0;
    if (totalItems >= 16) return 1.75;
    if (totalItems >= 8) return 1.5;
    if (totalItems >= 4) return 1.2;
    return 1.0;
  }

  // ── Variety bonus ──
  static int varietyBonus(int uniqueTypes) {
    if (uniqueTypes >= 5) return 70;
    if (uniqueTypes == 4) return 45;
    if (uniqueTypes == 3) return 25;
    if (uniqueTypes == 2) return 10;
    return 0;
  }

  // ── Streak multiplier ──
  static double streakMultiplier(int streakDays) {
    if (streakDays >= 90) return 2.0;
    if (streakDays >= 30) return 1.75;
    if (streakDays >= 14) return 1.5;
    if (streakDays >= 7) return 1.25;
    return 1.0;
  }

  // ── AI confidence multiplier ──
  static double confidenceMultiplier(double confidence) {
    // confidence 0.0–1.0
    if (confidence >= 0.95) return 1.1;
    if (confidence >= 0.80) return 1.0;
    if (confidence >= 0.65) return 0.9;
    return 0.8;
  }

  /// Calculate total points for a submission.
  ///
  /// [itemsByType] — map of waste type key -> item count.
  /// [streakDays] — current active streak.
  /// [aiConfidence] — AI validation confidence (0.0–1.0).
  /// [discoveryTypes] — set of waste types discovered for the first time.
  /// [isWeekend] — whether today is Saturday/Sunday.
  /// Returns total points (capped at daily soft cap externally).
  static int calculate({
    required Map<String, int> itemsByType,
    required int streakDays,
    required double aiConfidence,
    required Set<String> discoveryTypes,
    bool isWeekend = false,
  }) {
    // Σ Base_Poin × Q_Multiplier
    int totalItems = itemsByType.values.fold(0, (a, b) => a + b);
    double baseSum = 0;
    for (final entry in itemsByType.entries) {
      final base = basePoints[entry.key] ?? 5;
      baseSum += base * entry.value;
    }

    double qMultiplier = quantityMultiplier(totalItems);
    double baseTotal = baseSum * qMultiplier;

    // Variety_Bonus
    int varietyB = varietyBonus(itemsByType.length);

    // Discovery_Bonus
    int discoveryB = discoveryTypes.length * 20;

    // Streak × AI Confidence multipliers
    double sMultiplier = streakMultiplier(streakDays);
    double cMultiplier = confidenceMultiplier(aiConfidence);

    double total = (baseTotal + varietyB + discoveryB) * sMultiplier * cMultiplier;

    // Weekend bonus
    if (isWeekend) {
      total += 8; // flat per-submission
    }

    return total.round();
  }
}
