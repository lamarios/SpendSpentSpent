import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_spent_spent/expenses/models/sss_file.dart';
import 'package:spend_spent_spent/expenses/state/expense_images.dart';
import 'package:spend_spent_spent/sss_files/views/components/sss_file_listener.dart';
import 'package:spend_spent_spent/utils/all_scroll_behavior.dart';
import 'package:spend_spent_spent/utils/views/components/expense_image.dart';

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
              spacing: 8,
              children: [
                SizedBox(
                  height: 300,
                  child: ScrollConfiguration(
                    behavior: AllScrollBehavior(),
                    child: CarouselView(
                      itemExtent: 300,
                      itemSnapping: true,
                      enableSplash: false,
                      children: [
                        ...files.map(
                          (e) => Stack(
                            children: [
                              ExpenseImage(
                                file: e,
                                width: 300,
                                height: 300,
                                showStatus: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (state.possibleTags.isNotEmpty)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 16,
                    children: [
                      Icon(Icons.local_offer, color: colors.secondary),
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: state.possibleTags
                              .map(
                                (e) => Container(
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
                              )
                              .toList(),
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
