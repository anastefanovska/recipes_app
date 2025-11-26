class Meal {
  final String id;
  final String name;
  final String thumb;

  Meal({required this.id, required this.name, required this.thumb});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json["idMeal"],
      name: json["strMeal"],
      thumb: json["strMealThumb"],
    );
  }
}
