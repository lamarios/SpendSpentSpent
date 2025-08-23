import 'package:flutter/material.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';

class Categories extends StatelessWidget {
  final String label, selected;
  final List<String>? categories;
  final Function(String selected) onSelect;

  const Categories({
    super.key,
    required this.label,
    this.categories,
    required this.onSelect,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Visibility(
      visible: categories != null,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: colors.onSurface)),
            Wrap(
              spacing: 8.0,
              runSpacing: 4,
              children:
                  categories
                      ?.map(
                        (e) => GestureDetector(
                          onTap: () => onSelect(e),
                          child: AnimatedContainer(
                            decoration: BoxDecoration(
                              borderRadius: defaultBorder,
                              color: selected == e
                                  ? colors.primaryContainer
                                  : Colors.transparent,
                            ),
                            duration: panelTransition,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: getIcon(
                                e,
                                size: 30,
                                color: selected == e
                                    ? colors.onPrimaryContainer
                                    : colors.primary,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList() ??
                  [],
            ),
          ],
        ),
      ),
    );
  }
}
