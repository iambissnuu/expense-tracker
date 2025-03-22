import 'dart:io';
import 'dart:math';
import 'package:csv/csv.dart';
import 'package:expense_tracker/date_check_extension.dart';
import 'package:intl/intl.dart';
import 'category.dart';
import 'transaction.dart';

void main(List<String> arguments) {
  ExpenseTracker tracker = ExpenseTracker();
  tracker.start(arguments);
}

class ExpenseTracker {
  Map<int, Category> _categories = {};
  List<Transaction> _transactions = [];
  final String transactionsFile;
  final String categoriesFile;

  ExpenseTracker(
      {this.transactionsFile = './lib/transactions.csv',
      this.categoriesFile = './lib/categories.csv'}) {
    File file = File(transactionsFile);
    Random random = Random();
    for (int i = 0; i < 10; i++) {
      final t = Transaction(
        id: i + 1,
        amount: (random.nextDouble() * 1000).roundToDouble(),
        categoryId: random.nextInt(8) + 1,
        title: 'Random buy',
        transactionDt: DateTime(2025, 3, random.nextInt(31) + 1),
      );
      // _transactions.add(t);
      // file.writeAsStringSync(t.toCsvRow().join(','), mode: FileMode.append);
      // file.writeAsStringSync(',\n', mode: FileMode.append);
    }
    // saveTransactions();
    // List<List<dynamic>> rows = [
    //   Category(id: 1, title: 'Grocery'),
    //   Category(id: 2, title: 'Entertainment'),
    //   Category(id: 3, title: 'Food & Dining'),
    //   Category(id: 4, title: 'Fuel'),
    //   Category(id: 5, title: 'Automotive'),
    //   Category(id: 6, title: 'Bills & Utilities'),
    //   Category(id: 7, title: 'Travel & Vacation'),
    //   Category(id: 8, title: 'Donations'),
    // ].map((t) => t.toCsvRow()).toList();
    // File(categoriesFile)
    //     .writeAsStringSync(const ListToCsvConverter().convert(rows));
    loadCategories();
    loadTransactions();
  }

  void start(List<String> arguments) {
    while (true) {
      print('\n===== Expense Tracker Menu =====');
      print('1.  Add Expense');
      print('2.  View All Expenses');
      print('3.  Filter Expenses');
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
          _filterExpenses();
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

  void loadCategories() {
    File file = File(categoriesFile);
    if (file.existsSync()) {
      try {
        List<List<dynamic>> rows =
            const CsvToListConverter().convert(file.readAsStringSync());
        for (var row in rows) {
          if (row.length >= 2) {
            final id = int.parse(row[1].toString());
            final title = row[0].toString();
            _categories[id] = Category(id: id, title: title);
          }
        }
        print('Loaded ${_categories.length} categories');
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
        print('Loaded ${rows.length} transactions');
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

  void _filterExpenses() {
    stdout.write(
        '\nEnter Category ID to filter expenses (Don\'t enter if none):');
    int? categoryId = int.tryParse(stdin.readLineSync() ?? '');

    if (categoryId != null && !_categories.containsKey(categoryId)) {
      print('Invalid category ID.');
      return;
    }

    stdout.write('Enter the from date for date specific filtering, '
        'don\'t enter if no from date (MM-DD-YYYY) :');
    String? fromDate = stdin.readLineSync();

    stdout.write('Enter the to date for date specific filtering, '
        'don\'t enter if no to date (MM-DD-YYYY) :');
    String? toDate = stdin.readLineSync();

    DateTime? fromDt;
    DateTime? toDt;
    if ((fromDate != null && fromDate.isNotEmpty) ||
        (toDate != null && toDate.isNotEmpty)) {
      fromDt = (fromDate != null && fromDate.isNotEmpty)
          ? DateFormat('MM-dd-yyyy').parse(fromDate.trim())
          : null;
      toDt = (toDate != null && toDate.isNotEmpty)
          ? DateFormat('MM-dd-yyyy').parse(toDate.trim())
          : null;
    }
    bool filteringFromTransactionsMap(Transaction exp) {
      return categoryId != null
          ? exp.categoryId == categoryId
          : true &&
              (fromDt != null
                  ? exp.transactionDt.isSameDateAs(fromDt) ||
                      exp.transactionDt.isAfter(fromDt)
                  : true) &&
              (toDt != null
                  ? exp.transactionDt.isSameDateAs(toDt) ||
                      exp.transactionDt.isBefore(toDt)
                  : true);
    }

    var filtered = _transactions.where(filteringFromTransactionsMap).toList();
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
