import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Pastikan import ini ada
import 'package:uuid/uuid.dart';
import 'package:track_trip/models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'expenses';

  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  ExpenseProvider() {
    _listenToExpenses();
  }

  // Listen perubahan realtime dari Firestore
  void _listenToExpenses() {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

    _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
      _expenses = snapshot.docs.map((doc) => Expense.fromFirestore(doc)).toList();
      notifyListeners();
    }, onError: (error) {
      if (kDebugMode) {
        print('Error listening to expenses: $error');
      }
    });
  }

  // Tambah pengeluaran baru ke Firestore dengan try-catch
  Future<void> addExpense(
    String title,
    double amount,
    DateTime date,
    String category,
    String? note,
  ) async {
    final id = const Uuid().v4();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

    try {
      await _firestore.collection(_collection).doc(id).set({
        'id': id,
        'userId': userId,
        'title': title,
        'amount': amount,
        'date': Timestamp.fromDate(date),
        'category': category,
        'note': note,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print('Expense added successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to add expense: $e');
      }
      rethrow;
    }
  }

  // Update pengeluaran di Firestore dengan try-catch
  Future<void> updateExpense(Expense expense) async {
    try {
      final Map<String, dynamic> data = expense.toMap();
      data['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore.collection(_collection).doc(expense.id).update(data);

      if (kDebugMode) {
        print('Expense updated successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to update expense: $e');
      }
      rethrow;
    }
  }

  // Hapus pengeluaran dari Firestore dengan try-catch
  Future<void> deleteExpense(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();

      if (kDebugMode) {
        print('Expense deleted successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to delete expense: $e');
      }
      rethrow;
    }
  }

  // Total pengeluaran hari tertentu
  double getTotalExpensesByDay(DateTime date) {
    return _expenses
        .where((expense) =>
            expense.date.year == date.year &&
            expense.date.month == date.month &&
            expense.date.day == date.day)
        .fold(0, (sum, expense) => sum + expense.amount);
  }

  // Total pengeluaran kategori tertentu
  double getTotalExpensesByCategory(String category) {
    return _expenses
        .where((expense) => expense.category == category)
        .fold(0, (sum, expense) => sum + expense.amount);
  }

  // Total seluruh pengeluaran
  double getTotalExpenses() {
    return _expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  // Dapatkan pengeluaran berdasarkan rentang tanggal
  List<Expense> getExpensesByDateRange(DateTime start, DateTime end) {
    return _expenses.where((expense) {
      return (expense.date.isAfter(start) || expense.date.isAtSameMomentAs(start)) &&
          (expense.date.isBefore(end) || expense.date.isAtSameMomentAs(end));
    }).toList();
  }
}
