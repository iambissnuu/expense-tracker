class Transaction {
  int id;
  double amount;
  int categoryId;
  String title;
  String description;
  DateTime transactionDt;
  Transaction({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.transactionDt,
  });

  @override
  String toString() {
    return 'Transaction(id: $id, amount: $amount, categoryId: $categoryId, title: $title, description: $description, transactionDt: $transactionDt)';
  }
}
