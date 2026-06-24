/// Form validation helper mixin.
mixin FormValidationMixin {
  // ── Required field ──
  String? required(String? value, [String fieldName = 'Field ini']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName wajib diisi';
    }
    return null;
  }

  // ── Phone number ──
  String? validPhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Nomor HP wajib diisi';
    final regex = RegExp(r'^(0|62)?8[1-9][0-9]{6,11}$');
    if (!regex.hasMatch(value.trim().removeAllWhitespace)) {
      return 'Format nomor HP tidak valid';
    }
    return null;
  }

  // ── Email (fallback, though app uses Google Sign-In) ──
  String? validEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // ── Min length ──
  String? minLength(String? value, int min, [String fieldName = 'Field ini']) {
    if (value != null && value.trim().length < min) {
      return '$fieldName minimal $min karakter';
    }
    return null;
  }
}

/// Extension to remove whitespace (used in mixin above).
extension _StringRemoveWhitespace on String {
  String get removeAllWhitespace => replaceAll(RegExp(r'\s+'), '');
}
