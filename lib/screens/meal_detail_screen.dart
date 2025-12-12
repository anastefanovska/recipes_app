import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal_detail.dart';
import '../services/favorites_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MealDetailScreen extends StatefulWidget {
  final String id;

  const MealDetailScreen({super.key, required this.id});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  MealDetail? meal;
  bool isFavorite = false;

  final FavoritesService favoritesService = FavoritesService();

  @override
  void initState() {
    super.initState();
    load();
    loadFavorite();
  }

  Future<void> load() async {
    final data = await ApiService.fetchMealDetail(widget.id);
    if (!mounted) return;
    setState(() {
      meal = MealDetail.fromJson(data);
    });
  }

  Future<void> loadFavorite() async {
    final ids = await favoritesService.loadFavorites();
    if (!mounted) return;
    setState(() {
      isFavorite = ids.contains(widget.id);
    });
  }

  Future<void> toggleFavorite() async {
    await favoritesService.toggleFavorite(widget.id);
    await loadFavorite();
  }

  @override
  Widget build(BuildContext context) {
    if (meal == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(meal!.name),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.star : Icons.star_border),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(meal!.thumb),
            const SizedBox(height: 16),
            const Text(
              "Ingredients",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...meal!.ingredients.map((e) => Text("- $e")),
            const SizedBox(height: 16),
            const Text(
              "Instructions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(meal!.instructions),
            const SizedBox(height: 16),
            const Text(
              "Youtube video",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (meal!.youtube != null)
              InkWell(
                onTap: () => launchUrl(Uri.parse(meal!.youtube!)),
                child: Text(
                  meal!.youtube!,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
