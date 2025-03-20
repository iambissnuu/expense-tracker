import 'package:expense_tracker/expense_tracker.dart';
import 'package:expense_tracker/category.dart';
import 'package:expense_tracker/transaction.dart';
import 'package:test/test.dart';
import 'dart:io';
import 'package:csv/csv.dart';

void main() {
    late ExpenseTracker tracker;
    late File testTransactionsFile;

    setUp(() { // Fixed function name
        // Setup a temporary transactions CSV file for testing
        testTransactionsFile = File('lib/test_transactions.csv'); // Added semicolon
        tracker = ExpenseTracker(transactionsFile: 'lib/test_transactions.csv'); // Fixed initialization
    });

    tearDown(() {
        // Clean up after each test
        if (testTransactionsFile.existsSync()) {
            testTransactionsFile.deleteSync();
        }
    });

    test('Add and Retrieve Expense', () {
        tracker.addExpenseTest('Lunch', 15.0, 2);
        var expenses = tracker.getExpenses();
        expect(expenses.isNotEmpty, true);
        expect(expenses.last.title, 'Lunch');
        expect(expenses.last.amount, 15.0);
    });

    test('Filter Expenses by Category', () {
        tracker.addExpenseTest('Movie', 20.0, 8);
        tracker.addExpenseTest('Dinner', 30.0, 2);
        var filtered = tracker.filterExpensesByCategoryTest(2);
        expect(filtered.length, 1);
        expect(filtered.first.title, 'Dinner');
    });

    test('Save and Load Transactions from CSV', () {
        tracker.addExpenseTest('Groceries', 50.0, 1);
        tracker.saveTransactions();
        tracker.loadTransactions();
        var expenses = tracker.getExpenses();
        expect(expenses.isNotEmpty, true);
        expect(expenses.first.title, 'Groceries');
    });
}