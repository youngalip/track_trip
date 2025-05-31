import 'package:flutter/material.dart';
import 'package:track_trip/screens/expense_screens/expense_form.dart';
import 'package:track_trip/screens/expense_screens/expense_list.dart';
import 'package:track_trip/screens/budget_screens/budget_form.dart';
import 'package:track_trip/screens/budget_screens/budget_summary.dart';
import 'package:track_trip/screens/schedule_screens/schedule_calendar.dart';
import 'package:track_trip/screens/schedule_screens/schedule_form.dart';
import 'package:track_trip/screens/profile_screens/profile_page.dart';
import 'package:track_trip/constants/app_colors.dart';
import 'package:track_trip/constants/app_strings.dart';

// ... sisa kode home_screen.dart ...


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const ExpenseListScreen(),
    const BudgetSummaryScreen(),
    const ScheduleCalendarScreen(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: AppStrings.expenses,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: AppStrings.budget,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: AppStrings.schedule,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: AppStrings.profile,
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget? _buildFloatingActionButton() {
    // Tampilkan FAB yang berbeda tergantung pada tab yang dipilih
    switch (_selectedIndex) {
      case 0: // Expenses
        return FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExpenseFormScreen()),
            );
          },
          backgroundColor: AppColors.accentColor,
          child: const Icon(Icons.add),
        );
      case 1: // Budget
        return FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BudgetFormScreen()),
            );
          },
          backgroundColor: AppColors.accentColor,
          child: const Icon(Icons.add),
        );
      case 2: // Schedule
        return FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ScheduleFormScreen()),
            );
          },
          backgroundColor: AppColors.accentColor,
          child: const Icon(Icons.add),
        );
      default:
        return null;
    }
  }
}
