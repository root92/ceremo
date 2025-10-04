import 'package:flutter/material.dart';

/// Color constants matching the web app's orange theme
class AppColors {
  // Primary orange colors (matching web app #f97316)
  static const Color primary = Color(0xFFF97316); // #f97316 - main orange
  static const Color primaryDark = Color(0xFFEA580C); // #ea580c - darker orange
  static const Color primaryLight = Color(0xFFFB923C); // #fb923c - lighter orange
  
  // Orange color palette
  static const Color orange50 = Color(0xFFFFF7ED);
  static const Color orange100 = Color(0xFFFFEDD5);
  static const Color orange200 = Color(0xFFFED7AA);
  static const Color orange300 = Color(0xFFFDBA74);
  static const Color orange400 = Color(0xFFFB923C);
  static const Color orange500 = Color(0xFFF97316);
  static const Color orange600 = Color(0xFFEA580C);
  static const Color orange700 = Color(0xFFC2410C);
  static const Color orange800 = Color(0xFF9A3412);
  static const Color orange900 = Color(0xFF7C2D12);
  
  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);
  
  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // Background colors
  static const Color background = gray50;
  static const Color surface = white;
  static const Color surfaceVariant = gray100;
  
  // Dark theme colors
  static const Color darkBackground = gray900;
  static const Color darkSurface = gray800;
  static const Color darkSurfaceVariant = gray700;
  
  // Text colors
  static const Color textPrimary = gray900;
  static const Color textSecondary = gray600;
  static const Color textTertiary = gray400;
  static const Color textInverse = white;
  
  // Dark theme text colors
  static const Color darkTextPrimary = white;
  static const Color darkTextSecondary = gray300;
  static const Color darkTextTertiary = gray500;
  static const Color darkTextInverse = gray900;
  
  // Border colors
  static const Color border = gray300;
  static const Color borderLight = gray200;
  static const Color borderDark = gray400;
  
  // Shadow colors
  static const Color shadow = Color(0x1A000000); // 10% opacity black
  static const Color shadowLight = Color(0x0D000000); // 5% opacity black
  static const Color shadowDark = Color(0x33000000); // 20% opacity black
}
