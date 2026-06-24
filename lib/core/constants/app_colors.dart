import 'package:flutter/material.dart';

/// Dark eco palette — Sortirin brand colors.
/// Inspired by waste-sorting themes: greens, earthy neutrals, high-contrast accents.
class AppColors {
  AppColors._();

  // ── Brand ──
  static const Color primary = Color(0xFF22C55E);      // Vibrant green
  static const Color primaryDark = Color(0xFF16A34A);
  static const Color primaryLight = Color(0xFF4ADE80);

  // ── Backgrounds ──
  static const Color background = Color(0xFF0A0F0D);    // Near-black eco
  static const Color surface = Color(0xFF141A17);
  static const Color surfaceLight = Color(0xFF1E2722);

  // ── Accents ──
  static const Color accent = Color(0xFFA3E635);        // Lime
  static const Color accentDark = Color(0xFF65A30D);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ── Text ──
  static const Color textPrimary = Color(0xFFF9FAFB);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFF6B7280);

  // ── Borders & Dividers ──
  static const Color border = Color(0xFF2D3A35);
  static const Color divider = Color(0xFF1F2937);

  // ── Waste-type chips ──
  static const Color wasteOrganik = Color(0xFF22C55E);
  static const Color wasteKertas = Color(0xFF60A5FA);
  static const Color wastePlastik = Color(0xFFFBBF24);
  static const Color wasteKaca = Color(0xFFA78BFA);
  static const Color wasteLogam = Color(0xFFFB923C);
  static const Color wasteTekstil = Color(0xFFF472B6);
  static const Color wasteB3 = Color(0xFFEF4444);
  static const Color wasteResidu = Color(0xFF6B7280);
}
