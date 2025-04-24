import 'package:flutter/material.dart';

import 'package:yummy/models/models.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
  });

  final FoodCategory category;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.asset(category.imageUrl),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: Text(
                  'Yummy',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: RotatedBox(
                  quarterTurns: 1,
                  child: Text(
                    'Smoothies',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
              ),
            ],
          ),
          ListTile(
            title: Text(category.name),
            subtitle: Text('${category.numberOfRestaurants} places'),
          ),
        ],
      ),
    );
  }
}
