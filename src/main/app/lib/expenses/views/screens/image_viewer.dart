import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:spend_spent_spent/expenses/models/sss_file.dart';
import 'package:spend_spent_spent/utils/views/components/expense_image.dart';

@RoutePage()
class ImageViewerScreen extends StatelessWidget {
  final List<SssFile> images;
  final int initiallySelected;

  const ImageViewerScreen({
    super.key,
    required this.images,
    this.initiallySelected = 0,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return PageView.builder(
              itemCount: images.length,
              scrollDirection: Axis.horizontal,
              controller: PageController(
                viewportFraction: 1,
                initialPage: initiallySelected,
              ),
              itemBuilder: (context, index) {
                var image = images[index];
                return Stack(
                  children: [
                    Positioned.fill(
                      child: InteractiveViewer(
                        maxScale: 1000,
                        key: ValueKey(index),
                        child: ExpenseImage(
                          file: image,
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          showStatus: false,
                          borderRadius: 0,
                          boxFit: BoxFit.contain,
                        ),
                      ),
                    ),
                    if (image.aiTags.isNotEmpty)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(24),
                          color: Colors.black.withValues(alpha: 0.75),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            spacing: 16,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.local_offer, color: Colors.white),
                              Expanded(
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  spacing: 24,
                                  runSpacing: 4,
                                  children: image.aiTags
                                      .map(
                                        (e) => Text(
                                          e,
                                          style: textTheme.bodySmall?.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
