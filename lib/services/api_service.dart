import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const base = "https://www.themealdb.com/api/json/v1/1";

  static Future<List<dynamic>> fetchCategories() async {
    final res = await http.get(Uri.parse("$base/categories.php"));
    return jsonDecode(res.body)["categories"];
  }

  static Future<List<dynamic>> fetchMeals(String category) async {
    final res = await http.get(Uri.parse("$base/filter.php?c=$category"));
    return jsonDecode(res.body)["meals"];
  }

  static Future<List<dynamic>> searchMeals(String query) async {
    final res = await http.get(Uri.parse("$base/search.php?s=$query"));
    return jsonDecode(res.body)["meals"] ?? [];
  }

  static Future<Map<String, dynamic>> fetchMealDetail(String id) async {
    final res = await http.get(Uri.parse("$base/lookup.php?i=$id"));
    return jsonDecode(res.body)["meals"][0];
  }

  static Future<Map<String, dynamic>> randomMeal() async {
    final res = await http.get(Uri.parse("$base/random.php"));
    return jsonDecode(res.body)["meals"][0];
  }
}
