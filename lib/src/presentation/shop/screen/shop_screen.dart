// lib/src/presentation/shop/screens/shop_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:improov/src/presentation/shop/widgets/shop_folder_stack.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  static const kBgColor = Color(0xFFFAF5E8);
  static const kBorderColor = Color(0xFF2E2B27);
  static const kHabitPill = Color(0xFFFDECEB);

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  // 0: Wall (Peach), 1: Floor (Rose), 2: Items (Green)
  int _activeTabIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ShopScreen.kBgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18.0, 8.0, 18.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================================
              // 1. TOP DIORAMA FRAME
              // ==========================================================
              Expanded(
                flex: 44,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: ShopScreen.kBorderColor, width: 2.5),
                    boxShadow: const [
                      BoxShadow(
                        color: ShopScreen.kBorderColor,
                        offset: Offset(0, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Center Isometric Room Asset Placeholder
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset(
                            'assets/images/room_preview.jpg',
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.none,
                          ),
                        ),
                      ),

                      // Top-Left: Close Navigation
                      Positioned(
                        top: 14,
                        left: 14,
                        child: GestureDetector(
                          onTap: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/');
                            }
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: ShopScreen.kHabitPill,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: ShopScreen.kBorderColor, width: 2),
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              size: 22,
                              color: ShopScreen.kBorderColor,
                            ),
                          ),
                        ),
                      ),

                      // Top-Right: Sparks Currency Badge
                      Positioned(
                        top: 14,
                        right: 14,
                        child: Container(
                          height: 38,
                          width: 96,
                          decoration: BoxDecoration(
                            color: ShopScreen.kHabitPill,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: ShopScreen.kBorderColor, width: 2),
                          ),
                        ),
                      ),

                      // Bottom-Right: Desk / Room Tool
                      Positioned(
                        bottom: 14,
                        right: 14,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6ACB2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: ShopScreen.kBorderColor, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const SizedBox(height: 6),

              // ==========================================================
              // 3. EMPTY BINDER STACK (Wall, Floor, Items)
              // ==========================================================
              Expanded(
                flex: 46,
                child: ShopFolderStack(
                  activeIndex: _activeTabIndex,
                  onTabChanged: (index) => setState(() => _activeTabIndex = index),
                  wallContent: null,
                  floorContent: null,
                  itemsContent: null,
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

}