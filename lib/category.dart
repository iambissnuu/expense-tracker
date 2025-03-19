class Category {
  int id;
  String title;
  Category({
    required this.id,
    required this.title,
  });

  @override
  String toString() => 'Category(id: $id, title: $title)';

  factory Category.fromValue(String id, String title) {
    return Category(id: int.parse(id), title: title);
  }
}
