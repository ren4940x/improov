// lib/src/presentation/shop/widgets/shop_folder_stack.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:improov/src/presentation/shop/widgets/binders/floor_binder.dart';
import 'package:improov/src/presentation/shop/widgets/binders/items_binder.dart';
import 'package:improov/src/presentation/shop/widgets/binders/wall_binder.dart';

class ShopFolderStack extends StatefulWidget {
  final int? activeIndex; // 0: Wall, 1: Floor, 2: Items
  final ValueChanged<int>? onTabChanged;
  final Widget? wallContent;
  final Widget? floorContent;
  final Widget? itemsContent;
  final double tabHeight;
  final int totalSlots;

  const ShopFolderStack({
    super.key,
    this.activeIndex,
    this.onTabChanged,
    this.wallContent,
    this.floorContent,
    this.itemsContent,
    this.tabHeight = 40,
    this.totalSlots = 4, // 1/4-cut staggering
  });

  @override
  State<ShopFolderStack> createState() => _ShopFolderStackState();
}

class _ShopFolderStackState extends State<ShopFolderStack> {
  late int _internalIndex;

  @override
  void initState() {
    super.initState();
    // Default to Tab 2 (Items / Green) matching the mockup
    _internalIndex = widget.activeIndex ?? 2;
  }

  int get _currentIndex => widget.activeIndex ?? _internalIndex;

  void _handleTabTap(int index) {
    if (_currentIndex == index) return;
    HapticFeedback.lightImpact();

    if (widget.onTabChanged != null) {
      widget.onTabChanged!(index);
    } else {
      setState(() => _internalIndex = index);
    }
  }

  Widget _buildBinder({required int index, required bool isActive}) {
    switch (index) {
      case 0:
        return WallBinder(
          hasShadow: isActive,
          tabHeight: widget.tabHeight,
          totalSlots: widget.totalSlots,
          child: isActive ? widget.wallContent : null,
        );
      case 1:
        return FloorBinder(
          hasShadow: isActive,
          tabHeight: widget.tabHeight,
          totalSlots: widget.totalSlots,
          child: isActive ? widget.floorContent : null,
        );
      case 2:
        return ItemsBinder(
          hasShadow: isActive,
          tabHeight: widget.tabHeight,
          totalSlots: widget.totalSlots,
          child: isActive ? widget.itemsContent : null,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final inactiveIndices = [2,1,0].where((i) => i != _currentIndex);

    return LayoutBuilder(
      builder: (context, constraints) {
        final slotWidth = constraints.maxWidth / widget.totalSlots;

        return Stack(
          children: [
            // ==========================================================
            // 1. INACTIVE BINDERS (Rendered first underneath)
            // ==========================================================
            for (final index in inactiveIndices)
              Positioned.fill(
                child: _buildBinder(index: index, isActive: false),
              ),

            // ==========================================================
            // 2. ACTIVE BINDER (Paints LAST = Top of Z-index)
            // ==========================================================
            Positioned.fill(
              child: _buildBinder(index: _currentIndex, isActive: true),
            ),

            // ==========================================================
            // 3. TAB HIT TARGETS (Slots 0, 1, 2 along the top shelf)
            // ==========================================================
            ...List.generate(3, (index) {
              return Positioned(
                left: index * slotWidth,
                top: 0,
                width: slotWidth,
                height: widget.tabHeight + 8.0,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _handleTabTap(index),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}