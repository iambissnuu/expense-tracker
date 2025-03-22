import 'dart:io';
import 'package:csv/csv.dart';
import 'category.dart';
import 'transaction.dart';

class ExpenseTracker {
  Map<int, Category> _categories = {};
  List<Transaction> _transactions = [];
  final String transactionsFile;
  final String categoriesFile;

  ExpenseTracker(
      {this.transactionsFile = './lib/transactions.csv',
      this.categoriesFile = './lib/categories.csv'}) {
    readCategories();
    loadTransactions();
  }

  void start(List<String> arguments) {
    while (true) {
      print('\n===== Expense Tracker Menu =====');
      print('1.  Add Expense');
      print('2.  View All Expenses');
      print('3.  Filter Expenses by Category');
      print('4.  View Categories');
      print('5.  Exit');
      print('==============================');
      stdout.write('Choose an option: ');
      final input = stdin.readLineSync();

      switch (input) {
        case '1':
          _addExpense();
          break;
        case '2':
          _viewExpenses();
          break;
        case '3':
          _filterExpensesByCategory();
          break;
        case '4':
          _viewCategories();
          break;
        case '5':
          print('Thank you for using our program!');
          saveTransactions();
          return;
        default:
          print('Please provide a valid choice');
      }
    }
  }

  void readCategories() {
    File file = File(categoriesFile);
    if (file.existsSync()) {
      try {
        List<List<dynamic>> rows =
            const CsvToListConverter().convert(file.readAsStringSync());
        for (var row in rows) {
          if (row.length >= 2) {
            final id = int.parse(row[0].toString());
            final title = row[1].toString();
            _categories[id] = Category(id: id, title: title);
          }
        }
      } catch (e) {
        print('Error reading categories CSV file: $e');
      }
    } else {
      print('Could not find categories CSV file.');
    }
  }

  void loadTransactions() {
    File file = File(transactionsFile);
    if (file.existsSync()) {
      try {
        List<List<dynamic>> rows =
            const CsvToListConverter().convert(file.readAsStringSync());
        for (var row in rows) {
          _transactions.add(Transaction.fromCsvRow(row));
        }
      } catch (e) {
        print('Error reading transactions CSV file: $e');
      }
    } else {
      print('No previous transactions matched. Start fresh.');
    }
  }

  void saveTransactions() {
    List<List<dynamic>> rows = _transactions.map((t) => t.toCsvRow()).toList();
    File(transactionsFile)
        .writeAsStringSync(const ListToCsvConverter().convert(rows));
  }

  void _addExpense() {
    print('\nEnter Expense Details:');
    stdout.write('Title: ');
    String title = stdin.readLineSync() ?? '';
    stdout.write('Amount: ');
    double? amount = double.tryParse(stdin.readLineSync() ?? '');
    stdout.write('Category ID: ');
    int? categoryId = int.tryParse(stdin.readLineSync() ?? '');

    if (amount == null ||
        categoryId == null ||
        !_categories.containsKey(categoryId)) {
      print(' Invalid input. Please enter a valid amount and category ID.');
      return;
    }

    Transaction transaction = Transaction(
      id: _transactions.length + 1,
      amount: amount,
      categoryId: categoryId,
      title: title,
      transactionDt: DateTime.now(),
    );

    _transactions.add(transaction);
    saveTransactions();
    print('Expense added successfully!');
  }

  void _viewExpenses() {
    if (_transactions.isEmpty) {
      print('No expenses recorded.');
      return;
    }
    print('\n All Expenses:');
    for (var exp in _transactions) {
      print(exp);
    }
  }

  void _filterExpensesByCategory() {
    print('\nEnter Category ID to filter expenses:');
    int? categoryId = int.tryParse(stdin.readLineSync() ?? '');

    if (categoryId == null || !_categories.containsKey(categoryId)) {
      print('Invalid category ID.');
      return;
    }

    var filtered =
        _transactions.where((exp) => exp.categoryId == categoryId).toList();
    if (filtered.isEmpty) {
      print(' No expenses for this category.');
      return;
    }

    print('\nExpenses in Category ID: $categoryId');
    for (var exp in filtered) {
      print(exp);
    }
  }

  void _viewCategories() {
    if (_categories.isEmpty) {
      print('No categories available.');
      return;
    }
    print('\n Available Categories:');
    _categories.forEach((id, category) {
      print('${category.id}: ${category.title}');
    });
  }

  List<Transaction> getExpenses() => _transactions;

  // Public methods for testing
  void addExpenseTest(String title, double amount, int categoryId) {
    Transaction transaction = Transaction(
      id: _transactions.length + 1,
      amount: amount,
      categoryId: categoryId,
      title: title,
      transactionDt: DateTime.now(),
    );
    _transactions.add(transaction);
  }

  List<Transaction> filterExpensesByCategoryTest(int categoryId) {
    return _transactions.where((exp) => exp.categoryId == categoryId).toList();
  }
}
