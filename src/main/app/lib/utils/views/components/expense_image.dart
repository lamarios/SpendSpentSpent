import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:spend_spent_spent/expenses/models/ai_processing_status.dart';
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
                      progressIndicatorBuilder: (context, url, progress) {
                        double side = min(width, height) / 10;
                        return Center(
                          child: SizedBox(
                            width: side,
                            height: side,
                            child: LoadingIndicator(),
                          ),
                        );
                      },
                    ),
                  ),
                  if (showStatus &&
                      file.status != AiProcessingStatus.NO_PROCESSING)
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
                          child: switch (file.status) {
                            AiProcessingStatus.NO_PROCESSING =>
                              SizedBox.shrink(),
                            AiProcessingStatus.DONE => Icon(
                              Icons.auto_awesome,
                              size: 15,
                            ),
                            AiProcessingStatus.ERROR => Icon(
                              Icons.error,
                              size: 15,
                            ),
                            _ => SizedBox(
                              width: 15,
                              height: 15,
                              child: LoadingIndicator(),
                            ),
                          },
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
