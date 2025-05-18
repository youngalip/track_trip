import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:track_trip/models/budget.dart';
import 'package:track_trip/providers/expense_provider.dart';
import 'package:track_trip/constants/app_colors.dart';
import 'package:track_trip/utils/formatters.dart';

class BudgetCard extends StatelessWidget {
  final Budget budget;
  final VoidCallback onTap;

  const BudgetCard({
    Key? key,
    required this.budget,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      budget.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildBudgetTypeChip(),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Kategori: ${budget.category}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getDateRangeText(),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              Consumer<ExpenseProvider>(
                builder: (context, expenseProvider, _) {
                  final spent = _calculateSpent(expenseProvider);
                  final percentUsed = (spent / budget.amount) * 100;
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Anggaran: ${Formatters.formatCurrency(budget.amount)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Terpakai: ${Formatters.formatCurrency(spent)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _getColorForPercentage(percentUsed),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: percentUsed / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getColorForPercentage(percentUsed),
                        ),
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${percentUsed.toStringAsFixed(1)}% terpakai',
                        style: TextStyle(
                          fontSize: 12,
                          color: _getColorForPercentage(percentUsed),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetTypeChip() {
    Color chipColor;
    String typeText;
    
    switch (budget.type) {
      case BudgetType.daily:
        chipColor = Colors.blue;
        typeText = 'Harian';
        break;
      case BudgetType.weekly:
        chipColor = Colors.purple;
        typeText = 'Mingguan';
        break;
      case BudgetType.monthly:
        chipColor = Colors.green;
        typeText = 'Bulanan';
        break;
    }
    
    return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        typeText,
        style: TextStyle(
          color: chipColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getDateRangeText() {
    final startDateFormatted = DateFormat('dd MMM yyyy').format(budget.startDate);
    
    if (budget.endDate == null) {
      switch (budget.type) {
        case BudgetType.daily:
          return 'Mulai: $startDateFormatted (1 hari)';
        case BudgetType.weekly:
          return 'Mulai: $startDateFormatted (7 hari)';
        case BudgetType.monthly:
          return 'Mulai: $startDateFormatted (30 hari)';
      }
    } else {
      final endDateFormatted = DateFormat('dd MMM yyyy').format(budget.endDate!);
      return 'Periode: $startDateFormatted - $endDateFormatted';
    }
  }

  double _calculateSpent(ExpenseProvider expenseProvider) {
    final now = DateTime.now();
    
    // Determine date range based on budget type
    DateTime startDate = budget.startDate;
    DateTime endDate = budget.endDate ?? now;
    
    if (budget.endDate == null) {
      switch (budget.type) {
        case BudgetType.daily:
          endDate = DateTime(startDate.year, startDate.month, startDate.day, 23, 59, 59);
          break;
        case BudgetType.weekly:
          endDate = startDate.add(const Duration(days: 6));
          endDate = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
          break;
        case BudgetType.monthly:
          endDate = DateTime(startDate.year, startDate.month + 1, 0, 23, 59, 59);
          break;
      }
    }
    
    // Calculate total expenses for this budget's category within date range
    double totalSpent = 0;
    for (final expense in expenseProvider.expenses) {
      if (expense.category == budget.category &&
          expense.date.isAfter(startDate) &&
          expense.date.isBefore(endDate)) {
        totalSpent += expense.amount;
      }
    }
    
    return totalSpent;
  }

  Color _getColorForPercentage(double percentage) {
    if (percentage >= 90) {
      return Colors.red;
    } else if (percentage >= 70) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}
