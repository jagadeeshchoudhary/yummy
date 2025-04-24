import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:yummy/components/components.dart';
import 'package:yummy/constants/constants.dart';
import 'package:yummy/models/models.dart';

class RestaurantSection extends StatelessWidget {
  const RestaurantSection({
    super.key,
    required this.restaurants,
    required this.cartManager,
    required this.orderManager,
  });

  final List<Restaurant> restaurants;
  final CartManager cartManager;
  final OrderManager orderManager;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Food Near Me',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(
            height: 230,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: restaurants.length,
              itemBuilder: (context, index) => SizedBox(
                width: 300,
                child: RestaurantLandscapeCard(
                  restaurant: restaurants[index],
                  onTap: () => context.go(
                    '/${YummyTab.home.value}/restaurant/${restaurants[index].id}',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
