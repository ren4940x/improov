import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:improov/src/core/routing/desk_shell.dart';
import 'package:improov/src/presentation/diary/screen/diary_screen.dart';

import 'package:improov/src/presentation/home/screens/rough_wireframe_screen.dart';
import 'package:improov/src/presentation/shop/screen/shop_screen.dart';
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // 1. Persistent Desk Shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return DeskShell(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => const RoughWireframeScreen(),
              ),
            ],
          ),

          // Branch 1: Diary
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/diary',
                name: 'diary',
                builder: (context, state) => const DiaryScreen(),
              ),
            ],
          ),

          // Branch 2: Shop
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/shop',
                name: 'shop',
                builder: (context, state) => const ShopScreen(),
              ),
            ],
          ),
        ],
      ),

      // 2. Fullscreen Desk / Focus Mode
      GoRoute(
        path: '/desk-mode',
        name: 'desk_mode',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const Scaffold(
          backgroundColor: Color(0xFFFAF5E8),
          body: Center(child: Text("Desk / Focus Mode")),
        ),
      ),
    ],
  );
});