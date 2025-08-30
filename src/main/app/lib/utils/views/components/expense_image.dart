import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:spend_spent_spent/expenses/models/sss_file.dart';
import 'package:spend_spent_spent/globals.dart';

class ExpenseImage extends StatelessWidget {
  final SssFile file;
  final double width;
  final double height;
  final bool showStatus;

  const ExpenseImage({
    super.key,
    required this.file,
    required this.width,
    required this.height,
    required this.showStatus,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return FutureBuilder<String?>(
      builder: (context, data) {
        return data.hasData && data.data != null
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: '${service.url}/API/Files/${file.id}/download',
                      httpHeaders: {'Authorization': 'Bearer ${data.data}'},
                      imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
                      width: width,
                      height: height,
                      fit: BoxFit.cover,
                      fadeInDuration: animationDuration,
                      fadeOutDuration: animationDuration,
                    ),
                  ),
                  if (showStatus)
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: AnimatedSwitcher(
                          duration: animationDuration,
                          key: ValueKey(file.status),
                          child: Row(
                            spacing: 8,
                            children: [
                              if (file.status.getIcon() != null)
                                Icon(
                                  file.status.getIcon(),
                                  size: 15,
                                  color: colors.onPrimaryContainer,
                                ),
                              if (file.status.getLabel().isNotEmpty)
                                Text(
                                  file.status.getLabel(),
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colors.onPrimaryContainer,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              )
            : SizedBox(width: width, height: height);
      },
      future: service.token,
    );
  }
}
