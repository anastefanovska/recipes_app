class Category {
  final String name;
  final String thumb;
  final String description;

  Category({
    required this.name,
    required this.thumb,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json["strCategory"],
      thumb: json["strCategoryThumb"],
      description: json["strCategoryDescription"],
    );
  }
}
