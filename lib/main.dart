import 'package:flutter/material.dart';
import 'screens/categories_screen.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

void main() {
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Recipe App",
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const CategoriesScreen(),
      navigatorObservers: [routeObserver],
    );
  }
}
