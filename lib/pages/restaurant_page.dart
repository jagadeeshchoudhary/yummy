import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:yummy/components/components.dart';
import 'package:yummy/constants/constants.dart';
import 'package:yummy/models/models.dart';
import 'checkout_page.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({
    super.key,
    required this.restaurant,
    required this.cartManager,
    required this.orderManager,
  });

  final Restaurant restaurant;
  final CartManager cartManager;
  final OrderManager orderManager;

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  static const double desktopThreshold = 700;
  static const double largeScreenPercentage = 0.9;
  static const double maxWidth = 1000;
  static const double drawerWidth = 375;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int calculateColumnCount(double screenWidth) {
    return screenWidth >= desktopThreshold ? 2 : 1;
  }

  double calculateContrainedWidth(double screenWidth) {
    return (screenWidth > desktopThreshold
            ? screenWidth * largeScreenPercentage
            : screenWidth)
        .clamp(0, maxWidth);
  }

  void _showBottomSheet(Item item) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      constraints: const BoxConstraints(
        maxWidth: 480,
      ),
      builder: (context) => ItemDetails(
        item: item,
        cartManager: widget.cartManager,
        quantityUpdated: () => setState(() {}),
      ),
    );
  }

  void openDrawer() {
    scaffoldKey.currentState!.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final constrainedWidth =
        calculateContrainedWidth(MediaQuery.sizeOf(context).width);
    return Scaffold(
      key: scaffoldKey,
      endDrawer: _buildEndDrawer(),
      body: Center(
        child: SizedBox(
          width: constrainedWidth,
          child: _buildCustomScrollView(),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  CustomScrollView _buildCustomScrollView() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        _buildInfoSection(),
        _buildGridViewSection('Menu'),
      ],
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 300,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 64,
          ),
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(widget.restaurant.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Positioned(
                bottom: 0,
                left: 16,
                child: CircleAvatar(
                  radius: 30,
                  child: Icon(
                    Icons.store,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildInfoSection() {
    final textTheme = Theme.of(context).textTheme;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.restaurant.name, style: textTheme.headlineLarge),
            Text(
              widget.restaurant.address,
              style: textTheme.bodySmall,
            ),
            Text(
              widget.restaurant.getRatingAndDistance(),
              style: textTheme.bodySmall,
            ),
            Text(
              widget.restaurant.attributes,
              style: textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(int index) {
    final item = widget.restaurant.items[index];
    return InkWell(
      onTap: () => _showBottomSheet(item),
      child: RestaurantItem(item: item),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }

  GridView _buildGridView(int columns) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3 / 2,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.restaurant.items.length,
      itemBuilder: (context, index) => _buildGridItem(index),
    );
  }

  SliverToBoxAdapter _buildGridViewSection(String title) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final columns = calculateColumnCount(screenWidth);
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSectionTitle(title),
            _buildGridView(columns),
          ],
        ),
      ),
    );
  }

  Widget _buildEndDrawer() {
    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        child: CheckoutPage(
          cartManager: widget.cartManager,
          didUpdate: () => setState(() {}),
          onSubmit: (order) {
            widget.orderManager.addOrder(order);
            context.pop();
            context.go('/${YummyTab.orders.value}');
          },
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      icon: const Icon(Icons.shopping_cart),
      tooltip: 'Cart',
      label: Text('${widget.cartManager.items.length} Items in cart'),
      onPressed: openDrawer,
    );
  }
}
