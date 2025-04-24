import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:yummy/constants/constants.dart';
import 'package:yummy/firebase_options.dart';
import 'package:yummy/models/models.dart';
import 'package:yummy/pages/pages.dart';

void main() async {
  WidgetsFlutterBinding();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: Yummy(),
    ),
  );
}

class Yummy extends StatefulWidget {
  const Yummy({super.key});

  @override
  State<Yummy> createState() => _YummyState();
}

class _YummyState extends State<Yummy> {
  ThemeMode themeMode = ThemeMode.system;
  ColorSelection colorSelected = ColorSelection.values.first;
  final _cartManager = CartManager();
  final _orderManager = OrderManager();
  final YummyAuth _auth = YummyAuth();
  Future<String?> _appRedirect(
      BuildContext context, GoRouterState state) async {
    final loggedIn = await _auth.loggedIn;
    final isOnLoginPage = state.matchedLocation == '/login';

    if (!loggedIn) {
      return '/login';
    } else if (loggedIn && isOnLoginPage) {
      return '/${YummyTab.home.value}';
    } else {
      return null;
    }
  }

  late final _router = GoRouter(
    initialLocation: '/login',
    redirect: _appRedirect,
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(
          onLogIn: (Credentials credentials) async {
            await _auth.signIn(credentials.username, credentials.password);
            if (!context.mounted) return;
            context.go('/${YummyTab.home.value}');
          },
        ),
      ),
      GoRoute(
        path: '/:tab',
        builder: (context, state) {
          return HomePage(
            auth: _auth,
            changeTheme: changeThemeMode,
            changeColor: changeColor,
            colorSelected: colorSelected,
            cartManager: _cartManager,
            orderManager: _orderManager,
            tab: int.tryParse(state.pathParameters['tab'] ?? '') ?? 0,
          );
        },
        routes: [
          GoRoute(
              path: 'restaurant/:id',
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                final restaurant = restaurants[id];
                return RestaurantPage(
                  restaurant: restaurant,
                  cartManager: _cartManager,
                  orderManager: _orderManager,
                );
              }),
        ],
      ),
    ],
    errorPageBuilder: (context, state) {
      return MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          body: Center(
            child: Text(
              state.error.toString(),
            ),
          ),
        ),
      );
    },
  );

  void changeThemeMode(bool useLightMode) {
    setState(() {
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void changeColor(int value) {
    setState(() {
      colorSelected = ColorSelection.values[value];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Yummy',
      routerConfig: _router,
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: colorSelected.color,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: colorSelected.color,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: themeMode,
    );
  }
}
