import 'package:intl/intl.dart';

class Formatters {
  // Currency formatter
  static String formatCurrency(double amount, {String symbol = 'Rp ', int decimalDigits = 0}) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: symbol,
      decimalDigits: decimalDigits,
    ).format(amount);
  }

  // Date formatter
  static String formatDate(DateTime date, {String pattern = 'dd MMM yyyy'}) {
    return DateFormat(pattern).format(date);
  }

  // Time formatter
  static String formatTime(DateTime time, {String pattern = 'HH:mm'}) {
    return DateFormat(pattern).format(time);
  }

  // Date and time formatter
  static String formatDateTime(DateTime dateTime, {String pattern = 'dd MMM yyyy, HH:mm'}) {
    return DateFormat(pattern).format(dateTime);
  }

  // Format date range
  static String formatDateRange(DateTime startDate, DateTime endDate) {
    final isSameDay = startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        startDate.day == endDate.day;
    
    if (isSameDay) {
      return '${formatDate(startDate)} ${formatTime(startDate)} - ${formatTime(endDate)}';
    } else {
      return '${formatDate(startDate)} - ${formatDate(endDate)}';
    }
  }

  // Format budget type
  static String formatBudgetType(String type) {
    switch (type) {
      case 'daily':
        return 'Harian';
      case 'weekly':
        return 'Mingguan';
      case 'monthly':
        return 'Bulanan';
      default:
        return type;
    }
  }

  // Format percentage
  static String formatPercentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  // Format number with thousand separator
  static String formatNumber(int number) {
    return NumberFormat('#,###').format(number);
  }
}
