import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yummy/components/components.dart';
import 'package:yummy/constants/constants.dart';
import 'package:yummy/models/models.dart';
import 'package:yummy/pages/pages.dart';
import 'package:yummy/providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
    required this.auth,
    required this.tab,
    required this.changeTheme,
    required this.changeColor,
    required this.colorSelected,
    required this.cartManager,
    required this.orderManager,
  });

  final void Function(bool useLightMode) changeTheme;
  final void Function(int value) changeColor;
  final ColorSelection colorSelected;
  final CartManager cartManager;
  final OrderManager orderManager;
  final YummyAuth auth;
  final int tab;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    final userDao = ref.watch(userDaoProvider);
    final pages = [
      // Center(
      //   child: ConstrainedBox(
      //     constraints: const BoxConstraints(maxWidth: 300),
      //     child: CategoryCard(category: categories[0]),
      //   ),
      // ),
      ExplorePage(
        cartManager: widget.cartManager,
        orderManager: widget.orderManager,
      ),
      MyordersPage(orderManager: widget.orderManager),

      userDao.isLoggedIn() ? ChatPage() : const Login(),

      AccountPage(
        user: const User(
            firstName: 'Stef',
            lastName: 'P',
            role: 'Flutteristas',
            profileImageUrl: 'assets/profile_pics/person_stef.jpeg',
            points: 100,
            darkMode: true),
        onLogOut: (logout) async {
          await widget.auth.signOut();
          if (!context.mounted) return;
          context.go('/login');
        },
      )
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Yummy'),
        actions: [
          ThemeButton(changeThemeMode: widget.changeTheme),
          ColorButton(
            changeColor: widget.changeColor,
            colorSelected: widget.colorSelected,
          ),
          IconButton(
            onPressed: () => userDao.logout(),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.tab,
        onDestinationSelected: (index) => context.go('/$index'),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_outlined),
            selectedIcon: Icon(Icons.list),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_outlined),
            selectedIcon: Icon(Icons.chat),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: widget.tab,
          children: pages,
        ),
      ),
    );
  }
}
