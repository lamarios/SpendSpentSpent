import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_spent_spent/add_expense_dialog/state/add_expense_dialog.dart';
import 'package:spend_spent_spent/add_expense_dialog/views/components/expense_file_management.dart';
import 'package:spend_spent_spent/expenses/models/sss_file.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/utils/views/components/expense_image.dart';

class UploadImageButton extends StatelessWidget {
  final List<SssFile> files;

  const UploadImageButton({super.key, required this.files});

  Future<void> showFileManagement(BuildContext context) async {
    var cubit = context.read<AddExpenseDialogCubit>();
    await ExpenseFileManagement.show(
      context,
      files: files,
      onFilesChanged: (files) => cubit.setImages(files),
      onAmountTapped: (amount) {
        cubit.setAmount(formatCurrency(amount));
      },
      onTagTapped: cubit.setNote,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return files.isEmpty
        ? IconButton(onPressed: () => showFileManagement(context), icon: Icon(Icons.image_rounded))
        : GestureDetector(
            onTap: () => showFileManagement(context),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ExpenseImage(file: files.first, width: 35, height: 35, showStatus: false),
                Positioned(
                  top: -10,
                  right: -10,
                  child: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle, color: colors.primaryContainer),
                    child: Center(
                      child: Padding(padding: const EdgeInsets.all(8.0), child: Text(files.length.toString())),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
