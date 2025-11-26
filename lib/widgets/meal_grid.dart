import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../widgets/meal_card.dart';

class MealGrid extends StatelessWidget {
  final List<Meal> meals;
  final void Function(Meal) onTap;

  const MealGrid({super.key, required this.meals, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: meals.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, i) {
        final meal = meals[i];
        return MealCard(meal: meal, onTap: () => onTap(meal));
      },
    );
  }
}
