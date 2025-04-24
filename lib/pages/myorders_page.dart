import 'package:flutter/material.dart';

import 'package:yummy/models/models.dart';

class MyordersPage extends StatelessWidget {
  const MyordersPage({
    super.key,
    required this.orderManager,
  });

  final OrderManager orderManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'My Orders',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: ListView.builder(
        itemCount: orderManager.totalOrders,
        itemBuilder: (context, index) =>
            OrderTile(order: orderManager.orders[index]),
      ),
    );
  }
}

class OrderTile extends StatelessWidget {
  const OrderTile({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'assets/food/burger.webp',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scheduled',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(order.getFormattedOrderInfo()),
            Text('Items: ${order.items.length}'),
          ],
        ));
  }
}
