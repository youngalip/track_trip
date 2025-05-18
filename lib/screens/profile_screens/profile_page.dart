import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_trip/constants/app_colors.dart';
import 'package:track_trip/constants/app_strings.dart';
import 'package:track_trip/constants/app_styles.dart';
import 'package:track_trip/providers/expense_provider.dart';
import 'package:track_trip/providers/budget_provider.dart';
import 'package:track_trip/widgets/common/custom_button.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildStatistics(context),
            _buildSettings(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppColors.primaryColor,
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 60,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Pengguna TrackTrip',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'pengguna@example.com',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              // Edit profile functionality would go here
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Edit Profil'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(BuildContext context) {
    return Consumer2<ExpenseProvider, BudgetProvider>(
      builder: (context, expenseProvider, budgetProvider, _) {
        final totalExpense = expenseProvider.getTotalExpenses();
        final totalBudget = budgetProvider.getTotalBudget();
        
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Statistik Keuangan',
                style: AppStyles.headingSmall,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Pengeluaran',
                      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
                          .format(totalExpense),
                      Icons.arrow_downward,
                      Colors.red,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Total Anggaran',
                      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
                          .format(totalBudget),
                      Icons.account_balance_wallet,
                      AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
                            _buildStatCard(
                'Sisa Anggaran',
                NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
                    .format(totalBudget - totalExpense),
                Icons.savings,
                (totalBudget - totalExpense) >= 0 ? Colors.green : Colors.red,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
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
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pengaturan',
            style: AppStyles.headingSmall,
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            context,
            'Notifikasi',
            Icons.notifications,
            () {
              // Navigate to notification settings
            },
          ),
          _buildSettingItem(
            context,
            'Tema Aplikasi',
            Icons.color_lens,
            () {
              // Navigate to theme settings
            },
          ),
          _buildSettingItem(
            context,
            'Bahasa',
            Icons.language,
            () {
              // Navigate to language settings
            },
          ),
          _buildSettingItem(
            context,
            'Privasi & Keamanan',
            Icons.security,
            () {
              // Navigate to privacy settings
            },
          ),
          _buildSettingItem(
            context,
            'Bantuan & Dukungan',
            Icons.help,
            () {
              // Navigate to help & support
            },
          ),
          _buildSettingItem(
            context,
            'Tentang Aplikasi',
            Icons.info,
            () {
              // Navigate to about app
            },
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Keluar',
            onPressed: () {
              // Logout functionality
              _showLogoutConfirmation(context);
            },
            backgroundColor: Colors.red,
            icon: Icons.exit_to_app,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primaryColor,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: AppStyles.bodyLarge,
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              // Perform logout
              Navigator.of(ctx).pop();
              // Additional logout logic would go here
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
