enum BudgetType { daily, weekly, monthly }

class Budget {
  final String id;
  final String title;
  final double amount;
  final BudgetType type;
  final String category;
  final DateTime startDate;
  final DateTime? endDate;

  Budget({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.startDate,
    this.endDate,
  });

  // Konversi dari dan ke Map untuk penyimpanan lokal
  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      type: BudgetType.values.byName(map['type']),
      category: map['category'],
      startDate: DateTime.parse(map['startDate']),
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.name,
      'category': category,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}
