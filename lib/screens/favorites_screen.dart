import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService favoritesService = FavoritesService();

  bool loading = true;
  List<Meal> meals = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() {
      loading = true;
    });

    final ids = await favoritesService.loadFavorites();

    final list = <Meal>[];
    for (final id in ids) {
      final detail = await ApiService.fetchMealDetail(id);
      list.add(
        Meal(
          id: detail["idMeal"],
          name: detail["strMeal"],
          thumb: detail["strMealThumb"],
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      meals = list;
      loading = false;
    });
  }

  void openMeal(Meal meal) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MealDetailScreen(id: meal.id)),
    ).then((_) => load());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : meals.isEmpty
          ? const Center(child: Text("No favorites yet"))
          : ListView.separated(
              itemCount: meals.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final m = meals[i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      m.thumb,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(m.name),
                  onTap: () => openMeal(m),
                );
              },
            ),
    );
  }
}
