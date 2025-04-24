import 'package:flutter/material.dart';

import 'package:yummy/api/mock_yummy_service.dart';
import 'package:yummy/components/components.dart';
import 'package:yummy/models/models.dart';

class ExplorePage extends StatelessWidget {
  ExplorePage({
    super.key,
    required this.cartManager,
    required this.orderManager,
  });

  final mockService = MockYummyService();
  final CartManager cartManager;
  final OrderManager orderManager;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: mockService.getExploreData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final restaurants = snapshot.data?.restaurants ?? [];
          final posts = snapshot.data?.friendPosts ?? [];
          final categories = snapshot.data?.categories ?? [];
          return ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              RestaurantSection(restaurants: restaurants, 
              cartManager: cartManager,
              orderManager: orderManager,
              ),
              CategorySection(categories: categories),
              PostSection(posts: posts)
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }
}
