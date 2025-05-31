import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:track_trip/models/budget.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Tambahkan ini

class BudgetProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'budgets';

  List<Budget> _budgets = [];

  List<Budget> get budgets => _budgets;

  BudgetProvider() {
    _listenToBudgets();
  }

  // Mendengarkan perubahan realtime di Firestore
void _listenToBudgets() {
  final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous'; // deklarasi userId

  _firestore
    .collection(_collection)
    .where('userId', isEqualTo: userId)
    .orderBy('startDate', descending: true)
    .snapshots()
    .listen((snapshot) {
      _budgets = snapshot.docs.map((doc) => Budget.fromFirestore(doc)).toList();
      notifyListeners();
    });
}

  // Tambah anggaran baru ke Firestore
  Future<void> addBudget(
    String title,
    double amount,
    BudgetType type,
    String category,
    DateTime startDate,
    DateTime? endDate,
  ) async {
    final id = const Uuid().v4();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

    try {
      // Jika Anda ingin menambahkan userID untuk keamanan
      // String? userId = FirebaseAuth.instance.currentUser?.uid;
      
      await _firestore.collection(_collection).doc(id).set({
        'id': id, // Tambahkan ID ke dokumen untuk konsistensi
        'userId': userId,
        'title': title,
        'amount': amount,
        'type': type.toString().split('.').last,
        'category': category,
        'startDate': Timestamp.fromDate(startDate),
        'endDate': endDate != null ? Timestamp.fromDate(endDate) : null,
        // 'userId': userId, // Uncomment jika menggunakan autentikasi
        'createdAt': FieldValue.serverTimestamp(), // Tambahkan timestamp pembuatan
      });
      
      if (kDebugMode) {
        print('Budget added successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to add budget: $e');
      }
      rethrow;
    }
  }

  // Update anggaran di Firestore
  Future<void> updateBudget(Budget budget) async {
    try {
      final Map<String, dynamic> data = budget.toMap();
      data['updatedAt'] = FieldValue.serverTimestamp(); // Tambahkan timestamp update
      
      await _firestore.collection(_collection).doc(budget.id).update(data);
      
      if (kDebugMode) {
        print('Budget updated successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to update budget: $e');
      }
      rethrow;
    }
  }

  // Hapus anggaran dari Firestore
  Future<void> deleteBudget(String id) async {
  try {
    // Hapus dari Firestore
    await _firestore.collection(_collection).doc(id).delete();
    
    // Hapus dari daftar lokal
    _budgets.removeWhere((budget) => budget.id == id);
    
    // Beritahu listener
    notifyListeners();
      
      if (kDebugMode) {
        print('Budget deleted successfully: $id');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to delete budget: $e');
      }
      rethrow;
    }
  }

  // Hitung total anggaran
  double getTotalBudget() {
    return _budgets.fold(0, (sum, budget) => sum + budget.amount);
  }

  // Hitung total anggaran berdasarkan kategori
  double getTotalBudgetByCategory(String category) {
    return _budgets
        .where((budget) => budget.category == category)
        .fold(0, (sum, budget) => sum + budget.amount);
  }

  // Dapatkan anggaran berdasarkan ID
  Budget? getBudgetById(String id) {
    try {
      return _budgets.firstWhere((budget) => budget.id == id);
    } catch (e) {
      return null;
    }
  }

  // Dapatkan anggaran yang aktif saat ini
  List<Budget> getActiveBudgets() {
    final now = DateTime.now();
    return _budgets.where((budget) {
      final isStarted = budget.startDate.isBefore(now) || budget.startDate.isAtSameMomentAs(now);
      final isEnded = budget.endDate != null && budget.endDate!.isBefore(now);
      return isStarted && !isEnded;
    }).toList();
  }
  
  // Dapatkan anggaran berdasarkan tipe
  List<Budget> getBudgetsByType(BudgetType type) {
    return _budgets.where((budget) => budget.type == type).toList();
  }
}
