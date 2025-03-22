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
    return [id, amount, title, transactionDt.toString(), categoryId];
  }

  /// Create a Transaction object from a CSV row
  factory Transaction.fromCsvRow(List<dynamic> row) {
    print(row[4]);
    return Transaction(
      id: int.parse(row[0].toString()),
      amount: double.parse(row[1].toString()),
      title: row[2].toString(),
      transactionDt: DateTime.parse(row[3].trim()),
      categoryId: int.parse(row[4].toString()),
    );
  }
}
