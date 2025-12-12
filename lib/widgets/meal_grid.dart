import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealGrid extends StatelessWidget {
  final List<Meal> meals;
  final void Function(Meal meal) onTap;
  final Set<String> favoriteIds;
  final Future<void> Function(String id) onToggleFavorite;

  const MealGrid({
    super.key,
    required this.meals,
    required this.onTap,
    required this.favoriteIds,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: meals.length,
      itemBuilder: (_, i) {
        final meal = meals[i];
        final isFav = favoriteIds.contains(meal.id);

        return InkWell(
          onTap: () => onTap(meal),
          borderRadius: BorderRadius.circular(14),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(meal.thumb, fit: BoxFit.cover),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.05),
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Material(
                    color: Colors.black.withOpacity(0.35),
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: Icon(
                        isFav ? Icons.star : Icons.star_border,
                        color: Colors.white,
                      ),
                      onPressed: () => onToggleFavorite(meal.id),
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: Text(
                    meal.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
