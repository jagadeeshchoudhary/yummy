import 'package:flutter/material.dart';

import 'package:yummy/models/models.dart';

class RestaurantLandscapeCard extends StatefulWidget {
  const RestaurantLandscapeCard({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  final Restaurant restaurant;
  final Function() onTap;

  @override
  State<RestaurantLandscapeCard> createState() =>
      _RestaurantLandscapeCardState();
}

class _RestaurantLandscapeCardState extends State<RestaurantLandscapeCard> {
  bool _isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            child: AspectRatio(
              aspectRatio: 2,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    widget.restaurant.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: IconButton(
                      icon: Icon(
                        _isFavorite
                            ? Icons.favorite_border_outlined
                            : Icons.favorite_outlined,
                        color: Colors.red,
                      ),
                      onPressed: () => setState(() {
                        _isFavorite = !_isFavorite;
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text(widget.restaurant.name),
            subtitle: Text(widget.restaurant.attributes),
            onTap: widget.onTap,
          )
        ],
      ),
    );
  }
}
