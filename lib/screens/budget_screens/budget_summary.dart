import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:track_trip/models/budget.dart';
import 'package:track_trip/providers/budget_provider.dart';
import 'package:track_trip/providers/expense_provider.dart';
import 'package:track_trip/screens/budget_screens/budget_form.dart';
import 'package:track_trip/constants/app_colors.dart';
import 'package:track_trip/constants/app_strings.dart';
import 'package:track_trip/widgets/budget_widgets/budget_card.dart';
import 'package:track_trip/widgets/common/empty_state.dart';
import 'package:fl_chart/fl_chart.dart';

class BudgetSummaryScreen extends StatefulWidget {
  const BudgetSummaryScreen({Key? key}) : super(key: key);

  @override
  State<BudgetSummaryScreen> createState() => _BudgetSummaryScreenState();
}

class _BudgetSummaryScreenState extends State<BudgetSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.budgetSummary),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBudgetOverview(),
            _buildBudgetChart(),
            _buildBudgetList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetOverview() {
    return Consumer2<BudgetProvider, ExpenseProvider>(
      builder: (context, budgetProvider, expenseProvider, _) {
        final totalBudget = budgetProvider.getTotalBudget();
        final totalExpense = expenseProvider.getTotalExpenses();
        final remainingBudget = totalBudget - totalExpense;
        final percentUsed = totalBudget > 0 ? (totalExpense / totalBudget) * 100 : 0;
        
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ringkasan Bulan Ini',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildOverviewItem(
                    'Total Anggaran',
                    totalBudget,
                    AppColors.primaryColor,
                  ),
                  _buildOverviewItem(
                    'Total Pengeluaran',
                    totalExpense,
                    Colors.red,
                  ),
                  _buildOverviewItem(
                    'Sisa Anggaran',
                    remainingBudget,
                    remainingBudget >= 0 ? Colors.green : Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: percentUsed / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  percentUsed > 90 ? Colors.red : 
                  percentUsed > 70 ? Colors.orange : 
                  Colors.green,
                ),
                minHeight: 10,
                borderRadius: BorderRadius.circular(5),
              ),
              const SizedBox(height: 8),
              Text(
                '${percentUsed.toStringAsFixed(1)}% terpakai',
                style: TextStyle(
                  color: percentUsed > 90 ? Colors.red : 
                         percentUsed > 70 ? Colors.orange : 
                         Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverviewItem(String title, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetChart() {
    return Consumer<ExpenseProvider>(
      builder: (context, expenseProvider, _) {
        final categoryExpenses = {
          'Makanan': expenseProvider.getTotalExpensesByCategory('Makanan'),
          'Transportasi': expenseProvider.getTotalExpensesByCategory('Transportasi'),
          'Hiburan': expenseProvider.getTotalExpensesByCategory('Hiburan'),
          'Belanja': expenseProvider.getTotalExpensesByCategory('Belanja'),
          'Pendidikan': expenseProvider.getTotalExpensesByCategory('Pendidikan'),
          'Kesehatan': expenseProvider.getTotalExpensesByCategory('Kesehatan'),
          'Lainnya': expenseProvider.getTotalExpensesByCategory('Lainnya'),
        };
        
        // Filter kategori dengan nilai > 0
        final filteredCategories = categoryExpenses.entries
            .where((entry) => entry.value > 0)
            .toList();
        
        if (filteredCategories.isEmpty) {
          return const SizedBox.shrink();
        }
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pengeluaran per Kategori',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: _createPieChartSections(filteredCategories),
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: filteredCategories.map((entry) {
                  return _buildCategoryLegend(
                    entry.key,
                    entry.value,
                    _getCategoryColor(entry.key),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  List<PieChartSectionData> _createPieChartSections(List<MapEntry<String, double>> categories) {
    final total = categories.fold<double>(0, (sum, item) => sum + item.value);
    
    return categories.asMap().entries.map((entry) {
      final category = entry.value.key;
      final value = entry.value.value;
      final percent = total > 0 ? (value / total) * 100 : 0;
      
      return PieChartSectionData(
        color: _getCategoryColor(category),
        value: value,
        title: '${percent.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Makanan':
        return AppColors.foodColor;
      case 'Transportasi':
        return AppColors.transportColor;
      case 'Hiburan':
        return AppColors.entertainmentColor;
      case 'Belanja':
        return AppColors.shoppingColor;
      case 'Pendidikan':
        return AppColors.educationColor;
      case 'Kesehatan':
        return AppColors.healthColor;
      default:
        return AppColors.otherColor;
    }
  }

  Widget _buildCategoryLegend(String category, double amount, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          category,
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(width: 4),
        Text(
          NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetList() {
    return Consumer<BudgetProvider>(
      builder: (context, budgetProvider, _) {
        final budgets = budgetProvider.budgets;
        
        if (budgets.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: EmptyState(
              icon: Icons.account_balance_wallet,
              message: AppStrings.noBudgetsYet,
              actionText: 'Tambah Anggaran',
            ),
          );
        }
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Daftar Anggaran',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: budgets.length,
              itemBuilder: (context, index) {
                final budget = budgets[index];
                return BudgetCard(
                  budget: budget,
                  onTap: () {
                    // Navigasi ke detail anggaran
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
