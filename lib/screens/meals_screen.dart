import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal.dart';
import '../widgets/meal_grid.dart';
import 'meal_detail_screen.dart';
import '../main.dart';

class MealsScreen extends StatefulWidget {
  final String category;

  const MealsScreen({super.key, required this.category});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> with RouteAware {
  late List<Meal> _meals;
  List<Meal> _filtered = [];
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
    _filtered = _meals;
    setState(() {});
  }

  Future<void> load() async {
    final data = await ApiService.fetchMeals(widget.category);
    _meals = data.map((e) => Meal.fromJson(e)).toList();

    setState(() {
      _filtered = _meals;
      _loading = false;
    });
  }

  void filter(String text) async {
    setState(() => _query = text);

    if (text.isEmpty) {
      _filtered = _meals;
      setState(() {});
      return;
    }

    final results = await ApiService.searchMeals(text);
    _filtered = results.map((e) => Meal.fromJson(e)).toList();
    setState(() {});
  }

  void openMeal(Meal meal) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MealDetailScreen(id: meal.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
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
                hintText: "Search meals...",
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
                : MealGrid(
              meals: _filtered,
              onTap: openMeal,
            ),
          ),
        ],
      ),
    );
  }
}
