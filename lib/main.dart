import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_trip/providers/budget_provider.dart';
import 'package:track_trip/providers/expense_provider.dart';
import 'package:track_trip/providers/schedule_provider.dart';
import 'package:track_trip/providers/theme_provider.dart';
import 'package:track_trip/screens/home_screen.dart';
import 'package:track_trip/constants/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'TrackTrip',
            theme: ThemeData(
              primarySwatch: AppColors.primaryColor,
              scaffoldBackgroundColor: AppColors.backgroundColor,
              fontFamily: 'Poppins',
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.primaryColor,
                elevation: 0,
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              primaryColor: AppColors.primaryColorDark,
              scaffoldBackgroundColor: AppColors.backgroundColorDark,
            ),
            themeMode: themeProvider.themeMode,
            home: const HomeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
