/// String utility extensions.
extension StringExtensions on String {
  /// Capitalize the first letter.
  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Mask phone number: 0812*****123
  String maskPhone() {
    if (length < 8) return this;
    return '${substring(0, 4)}*****${substring(length - 3)}';
  }

  /// Check if string is a valid phone number (Indonesian format).
  bool isValidPhone() {
    final regex = RegExp(r'^(0|62|62\s?|0\s?)?8[1-9][0-9]{6,11}$');
    return regex.hasMatch(trim());
  }

  /// Remove all whitespace.
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Truncate to [maxLength] with ellipsis.
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}…';
  }
}
