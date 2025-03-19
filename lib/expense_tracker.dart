import 'dart:io';

import 'package:csv/csv.dart';
import 'package:expense_tracker/category.dart';

void start(List<String> arguments) {
  readCategories();
  while (true) {
    print('Welcome to Expense Tracker in Dart 🎯');
    stdout.write('Please choose one of the options below');
    final input = stdin.readLineSync();
  }
}

void readCategories() {
  File file = File('./lib/categories.csv');
  Map<int, Category> categoriesMap = {};
  if (file.existsSync()) {
    List<List<dynamic>> rowsAsListOfValues =
        const CsvToListConverter().convert(file.readAsStringSync());
    print(rowsAsListOfValues.length);

    for (var row in rowsAsListOfValues) {
      for (int i = 0; i < row.length - 1; i = i + 2) {
        final id = row[i];
        final title = row[i + 1];
        categoriesMap[id] = Category(id: id, title: title);
      }
    }
    print(categoriesMap);
  } else {
    throw Exception('could not find categories CSV');
  }
}
