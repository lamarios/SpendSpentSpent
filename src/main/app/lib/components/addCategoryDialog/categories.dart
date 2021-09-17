import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

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
    AppColors colors = get(context);
    return Visibility(
      visible: categories != null,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PlatformText(
              label,
              style: TextStyle(color: colors.textOnMain),
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
                            ? colors.iconOnMain
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
                                : colors.iconOnMain),
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
