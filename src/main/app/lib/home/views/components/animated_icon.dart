import 'package:flutter/material.dart';

class AnimatedMenuIcon extends StatelessWidget {
  final bool selected;
  final IconData iconData;

  const AnimatedMenuIcon({
    super.key,
    required this.selected,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final selectedColor = colors.primary;
    final iconColor = colors.primary;

    return TweenAnimationBuilder<Color?>(
      builder: (context, color, child) {
        return Icon(iconData, size: 36, color: color);
      },
      tween: ColorTween(
        begin: selected ? iconColor : selectedColor,
        end: selected ? selectedColor : iconColor,
      ),
      duration: Duration(milliseconds: 500),
    );
  }
}
