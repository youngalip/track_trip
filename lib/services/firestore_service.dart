import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track_trip/models/expense.dart';
import 'package:track_trip/models/budget.dart';
import 'package:track_trip/models/schedule.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection references
  final CollectionReference _expensesCollection = 
      FirebaseFirestore.instance.collection('expenses');
  final CollectionReference _budgetsCollection = 
      FirebaseFirestore.instance.collection('budgets');
  final CollectionReference _schedulesCollection = 
      FirebaseFirestore.instance.collection('schedules');

  // EXPENSE CRUD OPERATIONS
  
  // Create expense
  Future<void> addExpense(Expense expense) async {
    return await _expensesCollection.doc(expense.id).set(expense.toMap());
  }
  
  // Read expenses
  Stream<List<Expense>> getExpenses() {
    return _expensesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Expense.fromFirestore(doc);
      }).toList();
    });
  }
  
  // Update expense
  Future<void> updateExpense(Expense expense) async {
    return await _expensesCollection.doc(expense.id).update(expense.toMap());
  }
  
  // Delete expense
  Future<void> deleteExpense(String id) async {
    return await _expensesCollection.doc(id).delete();
  }
  
  // BUDGET CRUD OPERATIONS
  
  // Create budget
  Future<void> addBudget(Budget budget) async {
    return await _budgetsCollection.doc(budget.id).set(budget.toMap());
  }
  
  // Read budgets
  Stream<List<Budget>> getBudgets() {
    return _budgetsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Budget.fromFirestore(doc);
      }).toList();
    });
  }
  
  // Update budget
  Future<void> updateBudget(Budget budget) async {
    return await _budgetsCollection.doc(budget.id).update(budget.toMap());
  }
  
  // Delete budget
  Future<void> deleteBudget(String id) async {
    return await _budgetsCollection.doc(id).delete();
  }
  
  // SCHEDULE CRUD OPERATIONS
  
  // Create schedule
  Future<void> addSchedule(Schedule schedule) async {
    return await _schedulesCollection.doc(schedule.id).set(schedule.toMap());
  }
  
  // Read schedules
  Stream<List<Schedule>> getSchedules() {
    return _schedulesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Schedule.fromFirestore(doc);
      }).toList();
    });
  }
  
  // Update schedule
  Future<void> updateSchedule(Schedule schedule) async {
    return await _schedulesCollection.doc(schedule.id).update(schedule.toMap());
  }
  
  // Delete schedule
  Future<void> deleteSchedule(String id) async {
    return await _schedulesCollection.doc(id).delete();
  }
}
