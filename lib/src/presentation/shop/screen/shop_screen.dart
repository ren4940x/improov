// lib/src/presentation/shop/screens/shop_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:improov/src/presentation/shop/widgets/binders/shop_binder_painter.dart';


class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  static const kBgColor = Color(0xFFFAF5E8);
  static const kBorderColor = Color(0xFF2E2B27);
  static const kHabitPill = Color(0xFFFDECEB);

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  // Default to Tab 6 (Cream body active as shown in mockup)
  int _activeTabIndex = 6;

  static const double _kTabHeight = 28.0;
  static const int _kTotalTabs = 7;

  // Exact 7-folder color tokens from mockup
  static const List<Color> _tabFills = [
    Color(0xFFF7E4DC), // 0: Pale Peach
    Color(0xFFE8BAC6), // 1: Dusty Rose
    Color(0xFFA6D6B6), // 2: Mint Green
    Color(0xFFB8B3F4), // 3: Soft Periwinkle
    Color(0xFFB8D5EE), // 4: Baby Blue
    Color(0xFFE4A9DD), // 5: Lilac Orchid
    Color(0xFFFAF5E6), // 6: Warm Cream (Active in mockup)
  ];

  static const List<Color> _tabBorders = [
    Color(0xFFDEBAAC),
    Color(0xFFC994A3),
    Color(0xFF83B594),
    Color(0xFF9089CF),
    Color(0xFF8BAEC8),
    Color(0xFFBF7EB7),
    Color(0xFFD8C7A4),
  ];

  void _switchTab(int index) {
    if (_activeTabIndex == index) return;
    HapticFeedback.lightImpact();
    setState(() => _activeTabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    // Inactive tabs render 0 -> 6 so left tabs tuck neatly behind right tabs
    final inactiveIndices = List.generate(_kTotalTabs, (i) => i)
        .where((i) => i != _activeTabIndex);

    return Scaffold(
      backgroundColor: ShopScreen.kBgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: Column(
            children: [
              // ==========================================================
              // 1. TOP DIORAMA FRAME (Matching rough wireframe screen)
              // ==========================================================
              Expanded(
                flex: 40,
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
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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

              const SizedBox(height: 10),

              // ==========================================================
              // 2. MIDDLE 7-TAB BINDER STACK
              // ==========================================================
              Expanded(
                flex: 48,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final tabWidth = constraints.maxWidth / _kTotalTabs;

                    return Stack(
                      children: [
                        // A. Inactive Binders (Underneath)
                        for (final index in inactiveIndices)
                          Positioned.fill(
                            child: CustomPaint(
                              painter: ShopBinderPainter(
                                tabIndex: index,
                                totalTabs: _kTotalTabs,
                                fillColor: _tabFills[index],
                                borderColor: _tabBorders[index],
                                hasShadow: false,
                                tabHeight: _kTabHeight,
                              ),
                            ),
                          ),

                        // B. Active Binder (Top of Z-Index)
                        Positioned.fill(
                          child: CustomPaint(
                            painter: ShopBinderPainter(
                              tabIndex: _activeTabIndex,
                              totalTabs: _kTotalTabs,
                              fillColor: _tabFills[_activeTabIndex],
                              borderColor: _tabBorders[_activeTabIndex],
                              hasShadow: true,
                              tabHeight: _kTabHeight,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: _kTabHeight + 12.0,
                                left: 16.0,
                                right: 16.0,
                                bottom: 12.0,
                              ),
                              child: _buildItemsGrid(),
                            ),
                          ),
                        ),

                        // C. Touch Hit-Targets (Pinned along top tab strip)
                        ...List.generate(_kTotalTabs, (index) {
                          return Positioned(
                            left: index * tabWidth,
                            top: 0,
                            width: tabWidth,
                            height: _kTabHeight + 8.0,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => _switchTab(index),
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // 2x3 Items Catalog Grid inside the Active Binder
  Widget _buildItemsGrid() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildShopItemCard(isCurrent: true, label: "now"),
            _buildShopItemCard(label: "\$200"),
            _buildShopItemCard(label: "\$200"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildShopItemCard(label: "\$200"),
            _buildShopItemCard(label: "\$200"),
            _buildShopItemCard(label: "\$200"),
          ],
        ),
      ],
    );
  }

  Widget _buildShopItemCard({bool isCurrent = false, required String label}) {
    final cardContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: const Color(0xFFB57473),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: ShopScreen.kBorderColor,
          ),
        ),
      ],
    );

    if (isCurrent) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFEADBBE).withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFC7B18E), width: 1.5),
        ),
        child: cardContent,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: cardContent,
    );
  }
}