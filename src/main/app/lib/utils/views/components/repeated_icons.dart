import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:spend_spent_spent/icons.dart';

class RepeatedIconsBackground extends StatelessWidget {
  final String icon;
  final Color color;
  final double size;
  final Widget child;

  const RepeatedIconsBackground({
    super.key,
    required this.icon,
    required this.color,
    required this.size,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final startPoint = (-size / 4) * 5;
    final distance = size * 1.75;

    return LayoutBuilder(
      builder: (context, constraints) {
        List<Widget> patternWidgets = [];
        for (double y = startPoint; y < constraints.maxHeight; y += distance) {
          for (double x = startPoint; x < constraints.maxWidth; x += distance) {
            patternWidgets.add(
              Positioned(
                left: x,
                top: y,
                child: getIcon(icon, size: size, color: color)
                    .animate(onPlay: (controller) => controller.repeat())
                    .move(
                      duration: const Duration(seconds: 20),
                      end: Offset(distance, distance),
                    ),
              ),
            );
          }
        }

        return Stack(
          children: [
            ...patternWidgets,
            Center(child: child),
          ],
        );
      },
    );
  }
}
