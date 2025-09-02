import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:spend_spent_spent/add_expense_dialog/state/expense_file_management.dart';
import 'package:spend_spent_spent/expenses/models/sss_file.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/sss_files/views/components/sss_file_listener.dart';
import 'package:spend_spent_spent/utils/all_scroll_behavior.dart';
import 'package:spend_spent_spent/utils/views/components/expense_image.dart';
import 'package:spend_spent_spent/utils/views/components/image_carousell.dart';

class ExpenseFileManagement extends StatelessWidget {
  final List<SssFile> files;
  final Function(List<SssFile> file) onFilesChanged;
  final Function(String tag) onTagTapped;
  final Function(double amount) onAmountTapped;

  const ExpenseFileManagement({
    super.key,
    required this.files,
    required this.onFilesChanged,
    required this.onTagTapped,
    required this.onAmountTapped,
  });

  static Future<List<SssFile>?> show(
    BuildContext context, {
    required List<SssFile> files,
    required Function(List<SssFile>) onFilesChanged,
    required Function(String tag) onTagTapped,
    required Function(double amount) onAmountTapped,
  }) async {
    return showModalBottomSheet<List<SssFile>>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        bottom: true,
        child: Wrap(
          children: [
            ExpenseFileManagement(
              files: files,
              onFilesChanged: onFilesChanged,
              onAmountTapped: onAmountTapped,
              onTagTapped: onTagTapped,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadFile(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null && context.mounted) {
      context.read<ExpenseFileManagementCubit>().uploadImage(image);
    }
  }

  Future<void> takePicture(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);

    if (image != null && context.mounted) {
      context.read<ExpenseFileManagementCubit>().uploadImage(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) =>
          ExpenseFileManagementCubit(ExpenseFileManagementState(files: files)),
      child:
          BlocConsumer<ExpenseFileManagementCubit, ExpenseFileManagementState>(
            listenWhen: (previous, current) => previous.files != current.files,
            listener: (context, state) => onFilesChanged(state.files),
            builder: (context, state) {
              final cubit = context.read<ExpenseFileManagementCubit>();
              return SssFileListener(
                onFile: cubit.onFileUpdated,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 300,
                        child: AnimatedSwitcher(
                          duration: animationDuration,
                          child: !state.loading && state.files.isEmpty
                              ? Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 100,
                                    color: colors.secondary,
                                  ),
                                )
                              : ImageCarousel(
                                  files: state.files,
                                  controller: cubit.carouselController,
                                  builder: (context, imageWidget) => Stack(
                                    children: [
                                      Positioned.fill(child: imageWidget),
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: IconButton.filledTonal(
                                          onPressed: () => cubit.removeFile(
                                            imageWidget.file,
                                          ),
                                          icon: Icon(Icons.close),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                      Gap(24),
                      if (state.possibleTags.isNotEmpty) ...[
                        Row(
                          spacing: 4,
                          children: [
                            Icon(Icons.local_offer, size: 16),
                            Text('Found tags', style: textTheme.labelMedium),
                          ],
                        ),
                        Gap(8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: state.possibleTags
                              .map(
                                (e) => InkWell(
                                  onTap: () {
                                    onTagTapped(e);
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colors.primaryContainer,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(e),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                      Gap(24),
                      if (state.possiblePrices.isNotEmpty) ...[
                        Row(
                          spacing: 4,
                          children: [
                            Icon(Icons.attach_money, size: 16),
                            Text('Found amounts', style: textTheme.labelMedium),
                          ],
                        ),
                        Gap(8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: state.possiblePrices
                              .map(
                                (e) => InkWell(
                                  onTap: () {
                                    onAmountTapped(e);
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colors.primaryContainer,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(formatCurrency(e)),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                      Gap(24),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        spacing: 16,
                        children: [
                          if (kIsWeb)
                            Expanded(
                              child: FilledButton.tonalIcon(
                                onPressed: state.loading
                                    ? null
                                    : () => uploadFile(context),
                                label: Text('Upload'),
                                icon: Icon(Icons.upload),
                              ),
                            )
                          else ...[
                            Expanded(
                              child: FilledButton.tonalIcon(
                                onPressed: state.loading
                                    ? null
                                    : () => takePicture(context),
                                label: Text('Take picture'),
                                icon: Icon(Icons.camera_alt),
                              ),
                            ),
                            Expanded(
                              child: FilledButton.tonalIcon(
                                onPressed: state.loading
                                    ? null
                                    : () => uploadFile(context),
                                label: Text('Pick from gallery'),
                                icon: Icon(Icons.upload),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (kIsWeb) Gap(16),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}
