import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:yummy/models/models.dart';
import 'cart_control.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({
    super.key,
    required this.item,
    required this.cartManager,
    required this.quantityUpdated,
  });

  final Item item;
  final CartManager cartManager;
  final void Function() quantityUpdated;

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.item.name,
                style: textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              _mostLikedBadge(colorScheme),
              const SizedBox(height: 16),
              Text(widget.item.description),
              const SizedBox(height: 16),
              _itemImage(widget.item.imageUrl),
              const SizedBox(height: 16),
              _addToCartControl(widget.item),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mostLikedBadge(ColorScheme colorScheme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(4),
        color: colorScheme.onPrimary,
        child: const Text('#1 Most Liked'),
      ),
    );
  }

  Widget _itemImage(String imageUrl) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _addToCartControl(Item item) {
    return CartControl(addToCard: (number) {
      const uuid = Uuid();
      final uniqueId = uuid.v4();
      final cartItem = CartItem(
        id: uniqueId,
        name: widget.item.name,
        price: widget.item.price,
        quantity: number,
      );
      setState(() {
        widget.cartManager.addItem(cartItem);
        widget.quantityUpdated();
      });
      Navigator.pop(context);
    });
  }
}
