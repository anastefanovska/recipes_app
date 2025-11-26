import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/category.dart';
import '../widgets/category_list.dart';
import 'meals_screen.dart';
import 'meal_detail_screen.dart';
import '../main.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> with RouteAware {
  late List<Category> _categories;
  List<Category> _filtered = [];
  bool _loading = true;

  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    FocusScope.of(context).unfocus();
    _controller.clear();
    _query = '';
    _filtered = _categories;
    setState(() {});
  }

  Future<void> load() async {
    final data = await ApiService.fetchCategories();
    _categories = data.map((e) => Category.fromJson(e)).toList();

    setState(() {
      _filtered = _categories;
      _loading = false;
    });
  }

  void filter(String text) {
    setState(() {
      _query = text;
      if (text.isEmpty) {
        _filtered = _categories;
      } else {
        _filtered = _categories
            .where((c) => c.name.toLowerCase().contains(text.toLowerCase()))
            .toList();
      }
    });
  }

  void openMeals(Category c) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MealsScreen(category: c.name)),
    );
  }

  void openRandom() async {
    final meal = await ApiService.randomMeal();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MealDetailScreen(id: meal["idMeal"]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
        actions: [
          IconButton(
            onPressed: openRandom,
            icon: const Icon(Icons.shuffle),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              onChanged: filter,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search categories...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _filtered.isEmpty && _query.isNotEmpty
                ? const Center(
              child: Text(
                "No results found",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
                : CategoryList(
              categories: _filtered,
              onTap: openMeals,
            ),
          ),
        ],
      ),
    );
  }
}
