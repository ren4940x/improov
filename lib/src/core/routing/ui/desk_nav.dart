import 'package:flutter/material.dart';

class DeskNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final List<IconData>? icons;

  const DeskNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.icons,
  });

  // Tonal Stationery Tokens
  static const kNavYellow = Color(0xFFF8E5BA);
  static const kBorderMutedBrown = Color.fromARGB(255, 131, 114, 91);
  static const kShadowBrown = Color.fromARGB(55, 46, 43, 39);
  static const kInkColor = Color(0xFF2E2B27);

 // 1: Home, 2: Diary, 3: Shop
  static const List<IconData> _navIcons = [
    Icons.home_outlined,
    Icons.menu_book_outlined,
    Icons.storefront_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_navIcons.length, (index) {
        final isSelected = selectedIndex == index;

        return GestureDetector(
          onTap: () => onItemSelected(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            width: 50,
            height: 50,
            margin: EdgeInsets.only(right: index < _navIcons.length - 1 ? 10 : 0),
            transform: Matrix4.translationValues(0, isSelected ? 2.0 : 0.0, 0),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : kNavYellow,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? kInkColor : kBorderMutedBrown,
                width: isSelected ? 2.2 : 2.0,
              ),
              boxShadow: isSelected
                  ? null
                  : const [
                      BoxShadow(
                        color: kShadowBrown,
                        offset: Offset(0, 2),
                        blurRadius: 0,
                      ),
                    ],
            ),
            child: Icon(
              _navIcons[index],
              size: 22,
              color: isSelected ? kInkColor : kInkColor.withOpacity(0.45),
            ),
          ),
        );
      }),
    );
  }
}