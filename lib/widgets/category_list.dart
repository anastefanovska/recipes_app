import 'package:flutter/material.dart';
import '../models/category.dart';
import 'category_card.dart';

class CategoryList extends StatelessWidget {
  final List<Category> categories;
  final void Function(Category) onTap;

  const CategoryList({
    super.key,
    required this.categories,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, i) {
        final c = categories[i];
        return CategoryCard(category: c, onTap: () => onTap(c));
      },
    );
  }
}
