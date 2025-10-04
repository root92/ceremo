import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';

class Formatters {
  /// Format a date to a readable string
  /// Handles various date formats (String, DateTime, etc.)
  static String formatDate(dynamic date, {BuildContext? context}) {
    if (date == null) {
      return context != null 
          ? AppLocalizations.of(context)!.notAvailable 
          : 'Not Available';
    }
    
    try {
      // Handle different date formats
      DateTime dateTime;
      if (date is String) {
        dateTime = DateTime.parse(date);
      } else if (date is DateTime) {
        dateTime = date;
      } else {
        return date.toString();
      }
      
      return DateFormat('MMM dd, yyyy').format(dateTime);
    } catch (e) {
      return date.toString();
    }
  }

  /// Format an amount with proper currency
  /// Handles various amount formats (String, double, int)
  static String formatAmount(
    dynamic amount, {
    String? currency,
    String? projectCurrency,
    String? organizationCurrency,
    int decimalPlaces = 0,
  }) {
    if (amount == null) return '0';
    
    try {
      double value;
      if (amount is String) {
        value = double.parse(amount);
      } else if (amount is double) {
        value = amount;
      } else if (amount is int) {
        value = amount.toDouble();
      } else {
        return amount.toString();
      }
      
      // Determine currency to use (priority: currency param > project > organization > USD)
      String finalCurrency = currency ?? 
                            projectCurrency ?? 
                            organizationCurrency ?? 
                            'USD';
      
      // Format the amount with specified decimal places
      String formattedAmount = value.toStringAsFixed(decimalPlaces);
      
      // Add thousand separators for better readability
      if (decimalPlaces == 0) {
        formattedAmount = NumberFormat('#,###').format(value);
      } else {
        formattedAmount = NumberFormat('#,##0.${'0' * decimalPlaces}').format(value);
      }
      
      return '$formattedAmount $finalCurrency';
    } catch (e) {
      return amount.toString();
    }
  }

  /// Format amount with currency symbol instead of code
  static String formatAmountWithSymbol(
    dynamic amount, {
    String? currency,
    String? projectCurrency,
    String? organizationCurrency,
    int decimalPlaces = 0,
  }) {
    if (amount == null) return '0';
    
    try {
      double value;
      if (amount is String) {
        value = double.parse(amount);
      } else if (amount is double) {
        value = amount;
      } else if (amount is int) {
        value = amount.toDouble();
      } else {
        return amount.toString();
      }
      
      // Determine currency to use
      String finalCurrency = currency ?? 
                            projectCurrency ?? 
                            organizationCurrency ?? 
                            'USD';
      
      // Get currency symbol
      String symbol = _getCurrencySymbol(finalCurrency);
      
      // Format the amount
      String formattedAmount;
      if (decimalPlaces == 0) {
        formattedAmount = NumberFormat('#,###').format(value);
      } else {
        formattedAmount = NumberFormat('#,##0.${'0' * decimalPlaces}').format(value);
      }
      
      return '$symbol$formattedAmount';
    } catch (e) {
      return amount.toString();
    }
  }

  /// Get currency symbol for common currencies
  static String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'CAD':
        return 'C\$';
      case 'AUD':
        return 'A\$';
      case 'CHF':
        return 'CHF';
      case 'CNY':
        return '¥';
      case 'INR':
        return '₹';
      case 'NGN':
        return '₦';
      case 'GHS':
        return '₵';
      case 'KES':
        return 'KSh';
      case 'ZAR':
        return 'R';
      default:
        return '$currency '; // Fallback to currency code with space
    }
  }

  /// Format percentage
  static String formatPercentage(dynamic value, {int decimalPlaces = 1}) {
    if (value == null) return '0%';
    
    try {
      double percentage;
      if (value is String) {
        percentage = double.parse(value);
      } else if (value is double) {
        percentage = value;
      } else if (value is int) {
        percentage = value.toDouble();
      } else {
        return '${value}%';
      }
      
      return '${percentage.toStringAsFixed(decimalPlaces)}%';
    } catch (e) {
      return '${value}%';
    }
  }

  /// Format large numbers with K, M, B suffixes
  static String formatCompactNumber(dynamic value) {
    if (value == null) return '0';
    
    try {
      double numValue;
      if (value is String) {
        numValue = double.parse(value);
      } else if (value is double) {
        numValue = value;
      } else if (value is int) {
        numValue = value.toDouble();
      } else {
        return value.toString();
      }
      
      if (numValue >= 1000000000) {
        return '${(numValue / 1000000000).toStringAsFixed(1)}B';
      } else if (numValue >= 1000000) {
        return '${(numValue / 1000000).toStringAsFixed(1)}M';
      } else if (numValue >= 1000) {
        return '${(numValue / 1000).toStringAsFixed(1)}K';
      } else {
        return numValue.toStringAsFixed(0);
      }
    } catch (e) {
      return value.toString();
    }
  }

  /// Format relative time (e.g., "2 hours ago", "3 days ago")
  static String formatRelativeTime(dynamic date) {
    if (date == null) return 'Unknown';
    
    try {
      DateTime dateTime;
      if (date is String) {
        dateTime = DateTime.parse(date);
      } else if (date is DateTime) {
        dateTime = date;
      } else {
        return date.toString();
      }
      
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '$years year${years == 1 ? '' : 's'} ago';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return '$months month${months == 1 ? '' : 's'} ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return date.toString();
    }
  }
}
