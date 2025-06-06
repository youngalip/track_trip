import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_trip/constants/app_colors.dart';
import 'package:track_trip/constants/app_styles.dart';
import 'package:track_trip/providers/expense_provider.dart';
import 'package:track_trip/providers/budget_provider.dart';
import 'package:track_trip/providers/theme_provider.dart';
import 'package:track_trip/widgets/common/custom_button.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context),
            _buildStatistics(context),
            _buildSettings(context, themeProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppColors.primaryColor,
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 60, color: AppColors.primaryColor),
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
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              // TODO: Implement edit profile functionality
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
              Text(
                'Statistik Keuangan',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Pengeluaran',
                      NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: 'Rp ',
                        decimalDigits: 0,
                      ).format(totalExpense),
                      Icons.arrow_downward,
                      Colors.red,
                      context,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Total Anggaran',
                      NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: 'Rp ',
                        decimalDigits: 0,
                      ).format(totalBudget),
                      Icons.account_balance_wallet,
                      AppColors.primaryColor,
                      context,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                'Sisa Anggaran',
                NumberFormat.currency(
                  locale: 'id_ID',
                  symbol: 'Rp ',
                  decimalDigits: 0,
                ).format(totalBudget - totalExpense),
                Icons.savings,
                (totalBudget - totalExpense) >= 0 ? Colors.green : Colors.red,
                context,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.black54
                    : Colors.grey.withOpacity(0.1),
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
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings(BuildContext context, ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pengaturan', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          _buildSettingItem(context, 'Notifikasi', Icons.notifications, () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Pengaturan notifikasi belum tersedia'),
              ),
            );
          }),
          _buildSettingItemWithSwitch(
            context,
            'Tema Layar (Terang/Gelap)',
            Icons.color_lens,
            themeProvider.isDarkMode,
            (value) {
              themeProvider.toggleTheme();
            },
          ),
          _buildSettingItem(context, 'Bahasa', Icons.language, () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Pengaturan bahasa belum tersedia')),
            );
          }),
          _buildSettingItem(context, 'Privasi & Keamanan', Icons.security, () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Pengaturan privasi belum tersedia'),
              ),
            );
          }),
          _buildSettingItem(context, 'Bantuan & Dukungan', Icons.help, () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Bantuan belum tersedia')),
            );
          }),
          _buildSettingItem(context, 'Tentang Aplikasi', Icons.info, () {
            showAboutDialog(
              context: context,
              applicationName: 'TrackTrip',
              applicationVersion: '1.0.0',
              applicationIcon: const FlutterLogo(size: 48),
              children: const [
                Text(
                  'Aplikasi pengelolaan perjalanan dan keuangan untuk mahasiswa perantau.',
                ),
              ],
            );
          }),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Keluar',
            onPressed: () {
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
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primaryColor, size: 24),
              const SizedBox(width: 16),
              Text(title, style: Theme.of(context).textTheme.bodyLarge),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[500], size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItemWithSwitch(
    BuildContext context,
    String title,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: Theme.of(context).textTheme.bodyLarge),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Keluar'),
            content: const Text(
              'Apakah Anda yakin ingin keluar dari aplikasi?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  // TODO: Implement logout logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Anda telah keluar')),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Keluar'),
              ),
            ],
          ),
    );
  }
}
