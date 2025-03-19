class Category {
  int id;
  String title;
  String Description;
  Category({
    required this.id,
    required this.title,
    required this.Description,
  });

  @override
  String toString() =>
      'Category(id: $id, title: $title, Description: $Description)';
}
