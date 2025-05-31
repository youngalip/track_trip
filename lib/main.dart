import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:track_trip/providers/budget_provider.dart';
import 'package:track_trip/providers/expense_provider.dart';
import 'package:track_trip/providers/schedule_provider.dart';
import 'package:track_trip/providers/theme_provider.dart';
import 'package:track_trip/screens/home_screen.dart';
import 'package:track_trip/constants/app_colors.dart';
import 'package:track_trip/constants/app_styles.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Buat MaterialColor dari warna #4E71FF
    const primaryColor = Color(0xFF4E71FF);
    const MaterialColor primarySwatch = MaterialColor(
      0xFF4E71FF,
      <int, Color>{
        50: Color(0xFFE8EDFF),
        100: Color(0xFFC7D1FF),
        200: Color(0xFFA2B3FF),
        300: Color(0xFF7D94FF),
        400: Color(0xFF617DFF),
        500: Color(0xFF4E71FF), // Warna utama
        600: Color(0xFF4769FF),
        700: Color(0xFF3D5EFF),
        800: Color(0xFF3554FF),
        900: Color(0xFF2542FF),
      },
    );

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
              primarySwatch: primarySwatch, // Menggunakan warna #4E71FF
              primaryColor: primaryColor,
              scaffoldBackgroundColor: const Color(0xFFF5F5F5),
              fontFamily: 'Poppins',
              appBarTheme: const AppBarTheme(
                backgroundColor: primaryColor, // Menggunakan warna #4E71FF
                elevation: 0,
                centerTitle: true,
                iconTheme: IconThemeData(color: Colors.white),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: AppStyles.primaryButtonStyle.copyWith(
                  backgroundColor: MaterialStateProperty.all(primaryColor),
                ),
              ),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: AppStyles.secondaryButtonStyle.copyWith(
                  foregroundColor: MaterialStateProperty.all(primaryColor),
                  side: MaterialStateProperty.all(
                    const BorderSide(color: primaryColor),
                  ),
                ),
              ),
              cardTheme: CardTheme(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: primaryColor, width: 2),
                ),
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              primaryColor: primaryColor,
              scaffoldBackgroundColor: AppColors.backgroundColorDark,
              appBarTheme: const AppBarTheme(
                backgroundColor: primaryColor,
                elevation: 0,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                ),
              ),
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


