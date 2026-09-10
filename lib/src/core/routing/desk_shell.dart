// lib/src/presentation/home/widgets/desk_shell.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:improov/src/core/routing/ui/desk_nav.dart';

class DeskShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const DeskShell({super.key, required this.navigationShell});

  static const kBgColor = Color(0xFFFAF5E8);
  static const kBorderColor = Color(0xFF2E2B27);
  static const kFabOrange = Color(0xFFE58B58);
  static const kSumiInk = Color(0xFF382E2B);

  void _handleTabSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      backgroundColor: kBgColor,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Row(
            children: [
              // ----------------------------------------------------
              // CASE A: DIARY TAB (Show < CLOSE button on the left)
              // ----------------------------------------------------
              if (currentIndex == 1) ...[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _handleTabSelected(0), // return to Home
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chevron_left_rounded, size: 28, color: kSumiInk),
                        SizedBox(width: 4),
                        Text(
                          "CLOSE",
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                            color: kSumiInk,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ]

              // ----------------------------------------------------
              // CASE B: HOME & SHOP TABS (Show 3-button cluster)
              // ----------------------------------------------------
              else ...[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      DeskNav(
                        selectedIndex: currentIndex,
                        onItemSelected: _handleTabSelected,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // HOME: Stamp FAB (+)
                if (currentIndex == 0)
                  GestureDetector(
                    onTap: () {
                      // Open habit/memo creation bottom sheet
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: kFabOrange,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color.fromARGB(99, 46, 43, 39),
                          width: 2.5,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(55, 46, 43, 39),
                            offset: Offset(0, 3),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.add, size: 32, color: kBorderColor),
                      ),
                    ),
                  ),

                // SHOP: Tactile BUY Button
                if (currentIndex == 2)
                  GestureDetector(
                    onTap: () {
                      // Process shop purchase
                    },
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: kFabOrange,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color.fromARGB(99, 46, 43, 39),
                          width: 2.5,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(55, 46, 43, 39),
                            offset: Offset(0, 3),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "BUY",
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            letterSpacing: 1.2,
                            color: kBorderColor,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}