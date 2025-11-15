import 'package:flutter/material.dart';
import 'package:spend_spent_spent/expenses/models/sss_file.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/utils/views/components/conditional_wrapper.dart';

import '../../all_scroll_behavior.dart' show AllScrollBehavior;
import 'expense_image.dart';

class ImageCarousel extends StatelessWidget {
  final Function(int value)? onTap;
  final CarouselController? controller;
  final List<SssFile> files;
  final Widget Function(BuildContext context, ExpenseImage imageWidget)? builder;

  const ImageCarousel({super.key, required this.files, this.onTap, this.controller, this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ScrollConfiguration(
          behavior: AllScrollBehavior(),
          child: CarouselView(
            controller: controller,
            onTap: onTap,
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.only(right: 0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(bigItemBorderRadius)),
            itemExtent: files.length == 1 ? constraints.maxWidth : constraints.maxWidth * 0.75,
            itemSnapping: true,
            enableSplash: onTap != null,
            children: [
              ...files.indexed.map(
                (e) => Padding(
                  padding: EdgeInsets.only(right: e.$1 == files.length - 1 ? 0 : 16),
                  child: ConditionalWrapper(
                    wrapIf: builder != null,
                    wrapper: (child) => builder!(context, child as ExpenseImage),
                    child: ExpenseImage(
                      file: e.$2,
                      width: files.length == 1 ? constraints.maxWidth : constraints.maxWidth * 0.75,
                      height: constraints.maxHeight,
                      showStatus: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
