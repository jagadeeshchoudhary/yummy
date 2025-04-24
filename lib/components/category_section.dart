import 'package:flutter/material.dart';

import 'package:yummy/components/components.dart';
import 'package:yummy/models/models.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({
    super.key,
    required this.categories,
  });

  final List<FoodCategory> categories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(
            height: 275,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) => SizedBox(
                width: 200,
                child: CategoryCard(
                  category: categories[index],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
