class Category {
  int id;
  String title;

  Category({
    required this.id,
    required this.title,
  });

  @override
  String toString() => 'Category(id: $id, title: $title)';

  /// Convert Category to a CSV row format
  List<dynamic> toCsvRow() {
    return [title, id];
  }

  /// Create a Category object from a CSV row
  factory Category.fromCsvRow(List<dynamic> row) {
    return Category(
      id: int.parse(row[1].toString()),
      title: row[0].toString(),
    );
  }
}
