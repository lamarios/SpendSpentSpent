import 'package:app/globals.dart';
import 'package:app/icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class Categories extends StatelessWidget {
  String label, selected;
  List<String>? categories;
  Function onSelect;

  Categories({required this.label,
    this.categories,
    required this.onSelect,
    required this.selected});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: categories != null,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PlatformText(
              label,
              style: TextStyle(color: Colors.white),
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 4,
              children: categories
                  ?.map((e) =>
                  GestureDetector(
                    onTap: () => onSelect(e),
                    child: AnimatedContainer(
                      decoration: BoxDecoration(
                        borderRadius: defaultBorder,
                        color: selected == e
                            ? Colors.white
                            : Theme
                            .of(context)
                            .primaryColor,
                      ),
                      duration: panelTransition,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: getIcon(e,
                            size: 30,
                            color: selected == e
                                ? Theme
                                .of(context)
                                .primaryColor
                                : Colors.white),
                      ),
                    ),
                  ))
                  .toList() ??
                  [],
            )
          ],
        ),
      ),
    );
  }
}
