import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_spent_spent/expenses/models/sss_file.dart';
import 'package:spend_spent_spent/expenses/state/expense_images.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/router.dart';
import 'package:spend_spent_spent/sss_files/views/components/sss_file_listener.dart';
import 'package:spend_spent_spent/utils/all_scroll_behavior.dart';
import 'package:spend_spent_spent/utils/views/components/expense_image.dart';
import 'package:spend_spent_spent/utils/views/components/image_carousell.dart';

class ExpenseImages extends StatelessWidget {
  final List<SssFile> files;

  const ExpenseImages({super.key, required this.files});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => ExpenseImagesCubit(ExpenseImagesState(files: files)),
      child: BlocBuilder<ExpenseImagesCubit, ExpenseImagesState>(
        builder: (context, state) {
          final cubit = context.read<ExpenseImagesCubit>();
          return SssFileListener(
            onFile: (SssFile file) {
              if (state.files.any((element) => element.id == file.id)) {
                cubit.updateImage(file);
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              spacing: 8,
              children: [
                Expanded(
                  child: ImageCarousel(
                    files: files,
                    onTap: (value) {
                      AutoRouter.of(context).push(
                        ImageViewerRoute(
                          images: files,
                          initiallySelected: value,
                        ),
                      );
                    },
                  ),
                ),

                if (state.possibleTags.isNotEmpty)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Icon(Icons.local_offer, color: colors.secondary),
                      Expanded(
                        child: SizedBox(
                          height: 30,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: state.possibleTags
                                .map(
                                  (e) => Center(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 4),
                                      key: ValueKey(e),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colors.primaryContainer,
                                        borderRadius: BorderRadius.circular(30),
                                      ),

                                      child: Text(
                                        e,
                                        style: textTheme.bodySmall?.copyWith(
                                          color: colors.onPrimaryContainer,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
