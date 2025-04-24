import 'package:flutter/material.dart';

class CartControl extends StatefulWidget {
  const CartControl({
    super.key,
    required this.addToCard,
  });

  final void Function(int) addToCard;

  @override
  State<CartControl> createState() => _CartControlState();
}

class _CartControlState extends State<CartControl> {
  int _cartNumber = 1;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMinusButton(),
        _buildCartNumberContainer(colorScheme),
        _buildPlusButton(),
        const Spacer(),
        _buildAddCartButton(),
      ],
    );
  }

  Widget _buildMinusButton() {
    return IconButton(
      icon: const Icon(Icons.remove),
      onPressed: () => setState(() {
        if (_cartNumber > 1) {
          _cartNumber -= 1;
        }
      }),
      tooltip: 'Decrease Cart Count',
    );
  }

  Widget _buildCartNumberContainer(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.onPrimary,
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: Text(
        _cartNumber.toString(),
      ),
    );
  }

  Widget _buildPlusButton() {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () => setState(() {
        _cartNumber++;
      }),
      tooltip: 'Increase Cart Count',
    );
  }

  Widget _buildAddCartButton() {
    return FilledButton(
      onPressed: () => widget.addToCard(_cartNumber),
      child: const Text('Add to Cart'),
    );
  }
}
