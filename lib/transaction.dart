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
    return 'Transaction(id: $id, amount: \$${amount.toStringAsFixed(2)}, categoryId: $categoryId, title: $title, transactionDt: ${transactionDt.toLocal()})';
  }

  /// Convert Transaction to a CSV row format
  List<dynamic> toCsvRow() {
    return [id, amount, categoryId, title, transactionDt.toIso8601String()];
  }

  /// Create a Transaction object from a CSV row
  factory Transaction.fromCsvRow(List<dynamic> row) {
    return Transaction(
      id: int.parse(row[0].toString()),
      amount: double.parse(row[1].toString()),
      categoryId: int.parse(row[2].toString()),
      title: row[3].toString(),
      transactionDt: DateTime.parse(row[4].toString()),
    );
  }

  /// Convert Transaction to a JSON string
  String toJson() => json.encode(toMap());

  /// Create a Transaction object from JSON string
  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source));

  /// Convert Transaction to a Map (for serialization)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'categoryId': categoryId,
      'title': title,
      'transactionDt': transactionDt.toIso8601String(),
    };
  }

  /// Create a Transaction object from a Map
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: int.parse(map['id'].toString()),
      amount: double.parse(map['amount'].toString()),
      categoryId: int.parse(map['categoryId'].toString()),
      title: map['title'].toString(),
      transactionDt: DateTime.parse(map['transactionDt']),
    );
  }
}
