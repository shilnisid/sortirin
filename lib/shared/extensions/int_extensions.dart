/// Integer utility extensions.
extension IntExtensions on int {
  /// Format as points with thousand separator: "1.250"
  String formatPoints() {
    final str = toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  /// Format as currency "Rp 10.000"
  String toCurrency() {
    return 'Rp ${formatPoints()}';
  }

  /// Pluralize Indonesian-style: 1 "hari", 2 "hari" (no change needed).
  String withUnit(String unit) {
    return '$this $unit';
  }
}
