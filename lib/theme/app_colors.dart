import 'package:flutter/material.dart';

/// Modern banking app color palette - clean and sophisticated
class AppColors {
  // Primary colors — Tailwind Orange
  // 500 = #F97316, 600 = #EA580C, 100 = #FFEDD5
  static const Color primary = Color(0xFFF97316);       // Orange 500
  static const Color primaryDark = Color(0xFFEA580C);   // Orange 600
  static const Color primaryLight = Color(0xFFFFEDD5);  // Orange 100

  // Secondary colors — Purple accent (Tailwind Violet)
  // 600 = #7C3AED, 700 = #6D28D9, 100 = #EDE9FE
  static const Color secondary = Color(0xFF7C3AED);       // Violet 600
  static const Color secondaryDark = Color(0xFF6D28D9);   // Violet 700
  static const Color secondaryLight = Color(0xFFEDE9FE);  // Violet 100

  // Accent colors — Green for success (Tailwind Emerald-ish)
  static const Color accent = Color(0xFF059669);
  static const Color accentDark = Color(0xFF047857);
  static const Color accentLight = Color(0xFFD1FAE5);

  // Neutrals — Slate/Gray mix
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0xFFF8FAFC);
  static const Color gray100 = Color(0xFFF1F5F9);
  static const Color gray200 = Color(0xFFE2E8F0);
  static const Color gray300 = Color(0xFFCBD5E1);
  static const Color gray400 = Color(0xFF94A3B8);
  static const Color gray500 = Color(0xFF64748B);
  static const Color gray600 = Color(0xFF475569);
  static const Color gray700 = Color(0xFF334155);
  static const Color gray800 = Color(0xFF1E293B);
  static const Color gray900 = Color(0xFF0F172A);

  // Status colors
  static const Color success = Color(0xFF059669);
  static const Color warning = Color(0xFFD97706);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB); // Blue 600

  // Backgrounds
  static const Color background = gray50;
  static const Color surface = white;
  static const Color surfaceVariant = gray100;

  // Dark theme surfaces
  static const Color darkBackground = gray900;
  static const Color darkSurface = gray800;
  static const Color darkSurfaceVariant = gray700;

  // Text colors
  static const Color textPrimary = gray900;
  static const Color textSecondary = gray600;
  static const Color textTertiary = gray400;
  static const Color textInverse = white;

  // Dark text colors
  static const Color darkTextPrimary = white;
  static const Color darkTextSecondary = gray300;
  static const Color darkTextTertiary = gray500;
  static const Color darkTextInverse = gray900;

  // Borders
  static const Color border = gray200;
  static const Color borderLight = gray100;
  static const Color borderDark = gray300;

  // Shadows (ARGB with low opacity)
  static const Color shadow = Color(0x0A000000);      // ~4% opacity
  static const Color shadowLight = Color(0x05000000); // ~2% opacity
  static const Color shadowDark = Color(0x15000000);  // ~8% opacity

  // Cards
  static const Color cardBackground = white;
  static const Color cardBorder = gray200;

  // Interactive
  static const Color interactive = primary;
  static const Color interactiveHover = primaryDark;
  static const Color interactivePressed = Color(0xFF1E40AF); // Blue 800

  // Project type colors
  static const Color wedding = Color(0xFFEC4899);   // Pink 500
  static const Color birthday = Color(0xFF3B82F6);  // Blue 500
  static const Color corporate = Color(0xFF059669); // Green 600
  static const Color religious = Color(0xFF7C3AED); // Purple 600
}