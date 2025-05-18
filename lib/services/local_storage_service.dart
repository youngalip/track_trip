import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_trip/models/expense.dart';
import 'package:track_trip/models/budget.dart';
import 'package:track_trip/models/schedule.dart';

class LocalStorageService {
  static const String _expensesKey = 'expenses';
  static const String _budgetsKey = 'budgets';
  static const String _schedulesKey = 'schedules';
  static const String _userPrefsKey = 'userPreferences';

  // Expense Storage Methods
  Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final expensesJson = expenses.map((expense) => jsonEncode(expense.toMap())).toList();
    await prefs.setStringList(_expensesKey, expensesJson);
  }

  Future<List<Expense>> getExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final expensesJson = prefs.getStringList(_expensesKey) ?? [];
    
    return expensesJson
        .map((json) => Expense.fromMap(jsonDecode(json)))
        .toList();
  }

  // Budget Storage Methods
  Future<void> saveBudgets(List<Budget> budgets) async {
    final prefs = await SharedPreferences.getInstance();
    final budgetsJson = budgets.map((budget) => jsonEncode(budget.toMap())).toList();
    await prefs.setStringList(_budgetsKey, budgetsJson);
  }

  Future<List<Budget>> getBudgets() async {
    final prefs = await SharedPreferences.getInstance();
    final budgetsJson = prefs.getStringList(_budgetsKey) ?? [];
    
    return budgetsJson
        .map((json) => Budget.fromMap(jsonDecode(json)))
        .toList();
  }

  // Schedule Storage Methods
  Future<void> saveSchedules(List<Schedule> schedules) async {
    final prefs = await SharedPreferences.getInstance();
    final schedulesJson = schedules.map((schedule) => jsonEncode(schedule.toMap())).toList();
    await prefs.setStringList(_schedulesKey, schedulesJson);
  }

  Future<List<Schedule>> getSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final schedulesJson = prefs.getStringList(_schedulesKey) ?? [];
    
    return schedulesJson
        .map((json) => Schedule.fromMap(jsonDecode(json)))
        .toList();
  }

  // User Preferences Methods
  Future<void> saveUserPreference(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    final userPrefs = prefs.getString(_userPrefsKey);
    Map<String, dynamic> prefsMap = {};
    
    if (userPrefs != null) {
      prefsMap = jsonDecode(userPrefs);
    }
    
    prefsMap[key] = value;
    await prefs.setString(_userPrefsKey, jsonEncode(prefsMap));
  }

  Future<dynamic> getUserPreference(String key, [dynamic defaultValue]) async {
    final prefs = await SharedPreferences.getInstance();
    final userPrefs = prefs.getString(_userPrefsKey);
    
    if (userPrefs == null) {
      return defaultValue;
    }
    
    final prefsMap = jsonDecode(userPrefs);
    return prefsMap[key] ?? defaultValue;
  }

  // Clear All Data
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
