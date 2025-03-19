import 'dart:convert';

class Transaction {
  int id;
  double amount;
  int categoryId;
  String title;
  DateTime transactionDt;
  Transaction({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.title,
    required this.transactionDt,
  });

  @override
  String toString() {
    return 'Transaction(id: $id, amount: $amount, categoryId: $categoryId, title: $title, transactionDt: $transactionDt)';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'categoryId': categoryId,
      'title': title,
      'transactionDt': transactionDt.millisecondsSinceEpoch,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id']?.toInt() ?? 0,
      amount: map['amount']?.toDouble() ?? 0.0,
      categoryId: map['categoryId']?.toInt() ?? 0,
      title: map['title'] ?? '',
      transactionDt: DateTime.fromMillisecondsSinceEpoch(map['transactionDt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source));
}
