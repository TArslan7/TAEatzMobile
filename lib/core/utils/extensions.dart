import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// String Extensions
extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
  
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }
  
  String removeExtraSpaces() {
    return replaceAll(RegExp(r'\s+'), ' ').trim();
  }
  
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }
  
  bool get isEmail {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(this);
  }
  
  bool get isPhoneNumber {
    final cleanValue = replaceAll(RegExp(r'[^\d]'), '');
    return cleanValue.length >= 10;
  }
  
  bool get isPostalCode {
    final cleanValue = replaceAll(' ', '').toUpperCase();
    return RegExp(r'^[1-9][0-9]{3}[A-Z]{2}$').hasMatch(cleanValue);
  }
  
  String get initials {
    if (isEmpty) return '';
    final words = split(' ');
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }
  
  String formatPhoneNumber() {
    final cleanValue = replaceAll(RegExp(r'[^\d]'), '');
    if (cleanValue.length == 10) {
      return '${cleanValue.substring(0, 2)} ${cleanValue.substring(2, 6)} ${cleanValue.substring(6)}';
    }
    return this;
  }
  
  String formatPostalCode() {
    final cleanValue = replaceAll(' ', '').toUpperCase();
    if (cleanValue.length == 6) {
      return '${cleanValue.substring(0, 4)} ${cleanValue.substring(4)}';
    }
    return this;
  }
}

// DateTime Extensions
extension DateTimeExtensions on DateTime {
  String formatDate({String pattern = 'dd/MM/yyyy'}) {
    return DateFormat(pattern).format(this);
  }
  
  String formatTime({String pattern = 'HH:mm'}) {
    return DateFormat(pattern).format(this);
  }
  
  String formatDateTime({String pattern = 'dd/MM/yyyy HH:mm'}) {
    return DateFormat(pattern).format(this);
  }
  
  String formatRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(this);
    
    if (difference.inDays > 7) {
      return formatDate();
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
  
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
  
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }
  
  bool get isThisWeek {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    return isAfter(weekStart) && isBefore(weekEnd);
  }
  
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }
  
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }
  
  DateTime get startOfWeek {
    return subtract(Duration(days: weekday - 1));
  }
  
  DateTime get endOfWeek {
    return add(Duration(days: 7 - weekday));
  }
}

// Double Extensions
extension DoubleExtensions on double {
  String formatCurrency({String symbol = '€', int decimalPlaces = 2}) {
    return '$symbol${toStringAsFixed(decimalPlaces)}';
  }
  
  String formatPercentage({int decimalPlaces = 1}) {
    return '${toStringAsFixed(decimalPlaces)}%';
  }
  
  String formatDistance() {
    if (this < 1) {
      return '${(this * 1000).round()}m';
    } else {
      return '${toStringAsFixed(1)}km';
    }
  }
  
  String formatWeight() {
    if (this < 1) {
      return '${(this * 1000).round()}g';
    } else {
      return '${toStringAsFixed(1)}kg';
    }
  }
  
  double clampToRange(double min, double max) {
    return this < min ? min : (this > max ? max : this);
  }
  
  bool get isPositive => this > 0;
  bool get isNegative => this < 0;
  bool get isZero => this == 0;
}

// Int Extensions
extension IntExtensions on int {
  String formatNumber() {
    if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    } else {
      return toString();
    }
  }
  
  String get ordinal {
    if (this >= 11 && this <= 13) {
      return '${this}th';
    }
    switch (this % 10) {
      case 1:
        return '${this}st';
      case 2:
        return '${this}nd';
      case 3:
        return '${this}rd';
      default:
        return '${this}th';
    }
  }
  
  Duration get seconds => Duration(seconds: this);
  Duration get minutes => Duration(minutes: this);
  Duration get hours => Duration(hours: this);
  Duration get days => Duration(days: this);
}

// List Extensions
extension ListExtensions<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;
  
  List<T> get unique {
    return toSet().toList();
  }
  
  List<T> whereNotNull() {
    return where((element) => element != null).cast<T>().toList();
  }
  
  void addIfNotNull(T? item) {
    if (item != null) add(item);
  }
  
  List<T> addAllIfNotNull(List<T>? items) {
    if (items != null) addAll(items);
    return this;
  }
  
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }
  
  List<T> takeFirst(int count) {
    if (count >= length) return this;
    return sublist(0, count);
  }
  
  List<T> takeLast(int count) {
    if (count >= length) return this;
    return sublist(length - count);
  }
}

// BuildContext Extensions
extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  EdgeInsets get screenPadding => MediaQuery.of(this).padding;
  EdgeInsets get screenViewInsets => MediaQuery.of(this).viewInsets;
  
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;
  bool get isLandscape => MediaQuery.of(this).orientation == Orientation.landscape;
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;
  
  void showSnackBar(String message, {Color? backgroundColor, Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }
  
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }
  
  Future<T?> showAppDialog<T>(Widget child) {
    return showDialog<T>(
      context: this,
      builder: (context) => child,
    );
  }
  
  Future<T?> showAppBottomSheet<T>(Widget child, {bool isScrollControlled = true}) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: isScrollControlled,
      builder: (context) => child,
    );
  }
}

// Color Extensions
extension ColorExtensions on Color {
  Color withOpacity(double opacity) {
    return Color.fromRGBO(red, green, blue, opacity);
  }
  
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
  
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
  
  String get hexString {
    return '#${value.toRadixString(16).substring(2).toUpperCase()}';
  }
}
