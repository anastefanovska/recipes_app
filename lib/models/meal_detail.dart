class MealDetail {
  final String name;
  final String thumb;
  final String instructions;
  final List<String> ingredients;
  final String? youtube;

  MealDetail({
    required this.name,
    required this.thumb,
    required this.instructions,
    required this.ingredients,
    required this.youtube,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    List<String> ing = [];
    for (int i = 1; i <= 20; i++) {
      final ingName = json["strIngredient$i"];
      final measure = json["strMeasure$i"];
      if (ingName != null && ingName.isNotEmpty) {
        ing.add("$ingName - $measure");
      }
    }

    return MealDetail(
      name: json["strMeal"],
      thumb: json["strMealThumb"],
      instructions: json["strInstructions"],
      ingredients: ing,
      youtube: json["strYoutube"],
    );
  }
}
