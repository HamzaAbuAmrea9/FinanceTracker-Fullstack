
class Transaction {
  final int id;
  final String description;
  final double amount;
  final DateTime transactionDate;
  final bool isExpense;
  final int categoryId;
  final Category category;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.transactionDate,
    required this.isExpense,
    required this.categoryId,
    required this.category,
  });

  // A factory constructor to create a Transaction from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      description: json['description'],
      amount: (json['amount'] as num).toDouble(),
      transactionDate: DateTime.parse(json['transactionDate']),
      isExpense: json['isExpense'],
      categoryId: json['categoryId'],
      category: Category.fromJson(json['category']),
    );
  }
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}