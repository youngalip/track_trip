import 'package:cloud_firestore/cloud_firestore.dart';

enum BudgetType { daily, weekly, monthly }

class Budget {
  final String id;
  final String userId; // Tambahkan userId
  final String title;
  final double amount;
  final BudgetType type;
  final String category;
  final DateTime startDate;
  final DateTime? endDate;
  // Tambahan untuk Firestore
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Budget({
    required this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  // Konversi dari dokumen Firestore (DocumentSnapshot)
  factory Budget.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    BudgetType getTypeFromString(String? typeStr) {
      if (typeStr == 'daily') return BudgetType.daily;
      if (typeStr == 'weekly') return BudgetType.weekly;
      if (typeStr == 'monthly') return BudgetType.monthly;
      return BudgetType.monthly; // default
    }

    return Budget(
      id: doc.id,
      userId: data['userId'] ?? 'anonymous',
      title: data['title'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      type: getTypeFromString(data['type']),
      category: data['category'] ?? '',
      startDate: (data['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (data['endDate'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Konversi dari Map (misal untuk local storage)
  factory Budget.fromMap(Map<String, dynamic> map) {
    BudgetType getTypeFromString(String? typeStr) {
      if (typeStr == 'daily') return BudgetType.daily;
      if (typeStr == 'weekly') return BudgetType.weekly;
      if (typeStr == 'monthly') return BudgetType.monthly;
      return BudgetType.monthly;
    }

    return Budget(
      id: map['id'],
      userId: map['userId'] ?? 'anonymous',
      title: map['title'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      type: getTypeFromString(map['type']),
      category: map['category'] ?? '',
      startDate: DateTime.parse(map['startDate']),
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // Konversi ke Map untuk Firestore / local storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'amount': amount,
      'type': type.toString().split('.').last,
      'category': category,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : FieldValue.serverTimestamp(),
    };
  }

  // Buat salinan dengan perubahan
  Budget copyWith({
    String? id,
    String? userId,
    String? title,
    double? amount,
    BudgetType? type,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Budget(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
