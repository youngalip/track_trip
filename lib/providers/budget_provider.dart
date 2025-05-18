import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:track_trip/models/budget.dart';
import 'package:track_trip/services/mock_data_service.dart';

class BudgetProvider with ChangeNotifier {
  List<Budget> _budgets = [];
  final MockDataService _mockDataService = MockDataService();
  
  BudgetProvider() {
    _loadBudgets();
  }

  List<Budget> get budgets => _budgets;

  Future<void> _loadBudgets() async {
    // Simulasi loading data dari backend
    _budgets = await _mockDataService.getMockBudgets();
    notifyListeners();
  }

  Future<void> addBudget(
    String title,
    double amount,
    BudgetType type,
    String category,
    DateTime startDate,
    DateTime? endDate,
  ) async {
    final budget = Budget(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      type: type,
      category: category,
      startDate: startDate,
      endDate: endDate,
    );

    _budgets.add(budget);
    notifyListeners();
    
    // Simulasi penyimpanan ke backend
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> updateBudget(Budget budget) async {
    final index = _budgets.indexWhere((b) => b.id == budget.id);
    if (index >= 0) {
      _budgets[index] = budget;
      notifyListeners();
      
      // Simulasi update ke backend
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  Future<void> deleteBudget(String id) async {
    _budgets.removeWhere((budget) => budget.id == id);
    notifyListeners();
    
    // Simulasi delete dari backend
    await Future.delayed(const Duration(milliseconds: 300));
  }

  double getTotalBudget() {
    return _budgets.fold(0, (sum, budget) => sum + budget.amount);
  }

  double getTotalBudgetByCategory(String category) {
    return _budgets
        .where((budget) => budget.category == category)
        .fold(0, (sum, budget) => sum + budget.amount);
  }

  Budget? getBudgetById(String id) {
    try {
      return _budgets.firstWhere((budget) => budget.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Budget> getActiveBudgets() {
    final now = DateTime.now();
    return _budgets.where((budget) {
      final isStarted = budget.startDate.isBefore(now) || budget.startDate.isAtSameMomentAs(now);
      final isEnded = budget.endDate != null && budget.endDate!.isBefore(now);
      return isStarted && !isEnded;
    }).toList();
  }
}
