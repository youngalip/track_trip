import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:track_trip/models/expense.dart';
import 'package:track_trip/services/mock_data_service.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  final MockDataService _mockDataService = MockDataService();
  
  ExpenseProvider() {
    _loadExpenses();
  }

  List<Expense> get expenses => _expenses;

  Future<void> _loadExpenses() async {
    // Simulasi loading data dari backend
    _expenses = await _mockDataService.getMockExpenses();
    notifyListeners();
  }

  Future<void> addExpense(
    String title,
    double amount,
    DateTime date,
    String category,
    String? note,
  ) async {
    final expense = Expense(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      date: date,
      category: category,
      note: note,
    );

    _expenses.add(expense);
    notifyListeners();
    
    // Simulasi penyimpanan ke backend
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> updateExpense(Expense expense) async {
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index >= 0) {
      _expenses[index] = expense;
      notifyListeners();
      
      // Simulasi update ke backend
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  Future<void> deleteExpense(String id) async {
    _expenses.removeWhere((expense) => expense.id == id);
    notifyListeners();
    
    // Simulasi delete dari backend
    await Future.delayed(const Duration(milliseconds: 300));
  }

  double getTotalExpensesByDay(DateTime date) {
    return _expenses
        .where((expense) => 
            expense.date.year == date.year &&
            expense.date.month == date.month &&
            expense.date.day == date.day)
        .fold(0, (sum, expense) => sum + expense.amount);
  }

  double getTotalExpensesByCategory(String category) {
    return _expenses
        .where((expense) => expense.category == category)
        .fold(0, (sum, expense) => sum + expense.amount);
  }

  double getTotalExpenses() {
  return _expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

}
