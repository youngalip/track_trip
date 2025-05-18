import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:track_trip/models/expense.dart';
import 'package:track_trip/providers/expense_provider.dart';
import 'package:track_trip/screens/expense_screens/expense_form.dart';
import 'package:track_trip/constants/app_colors.dart';
import 'package:track_trip/constants/app_strings.dart';
import 'package:track_trip/constants/app_styles.dart';
import 'package:track_trip/widgets/common/custom_button.dart';

class ExpenseDetailScreen extends StatelessWidget {
  final Expense expense;

  const ExpenseDetailScreen({Key? key, required this.expense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengeluaran'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditExpense(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildExpenseHeader(),
            const SizedBox(height: 24),
            _buildExpenseDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            expense.title,
            style: AppStyles.headingLarge,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                _getCategoryIcon(expense.category),
                color: _getCategoryColor(expense.category),
              ),
              const SizedBox(width: 8),
              Text(
                expense.category,
                style: AppStyles.bodyMedium.copyWith(
                  color: _getCategoryColor(expense.category),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(expense.amount),
            style: AppStyles.headingLarge.copyWith(
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informasi Pengeluaran',
          style: AppStyles.headingSmall,
        ),
        const SizedBox(height: 16),
        _buildDetailItem('Tanggal', DateFormat('dd MMMM yyyy').format(expense.date)),
        _buildDetailItem('Waktu', DateFormat('HH:mm').format(expense.date)),
        if (expense.note != null && expense.note!.isNotEmpty)
          _buildDetailItem('Catatan', expense.note!),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Makanan':
        return Icons.restaurant;
      case 'Transportasi':
        return Icons.directions_car;
      case 'Hiburan':
        return Icons.movie;
      case 'Belanja':
        return Icons.shopping_bag;
      case 'Pendidikan':
        return Icons.school;
      case 'Kesehatan':
        return Icons.medical_services;
      default:
        return Icons.attach_money;
    }
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

  void _navigateToEditExpense(BuildContext context) {
    // Implementation for navigating to edit expense screen
    // This would be implemented when we have the edit expense form
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Pengeluaran'),
        content: const Text('Apakah Anda yakin ingin menghapus pengeluaran ini?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              _deleteExpense(context);
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _deleteExpense(BuildContext context) async {
    try {
      await Provider.of<ExpenseProvider>(context, listen: false)
          .deleteExpense(expense.id);
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (error) {
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menghapus pengeluaran. Silakan coba lagi.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
