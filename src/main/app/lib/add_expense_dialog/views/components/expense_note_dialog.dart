import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:spend_spent_spent/add_expense_dialog/state/expense_note_dialog.dart';
import 'package:spend_spent_spent/add_expense_dialog/views/components/note_suggestion_pill.dart';

class ExpenseNoteDialog extends StatelessWidget {
  final Function(String note) onChanged;
  final String initialNote;

  const ExpenseNoteDialog({
    super.key,
    required this.onChanged,
    required this.initialNote,
  });

  static Future<String?> show(BuildContext context, String startingNote) async {
    String note = startingNote;
    return showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Expense Note'),
          content: ExpenseNoteDialog(
            initialNote: note,
            onChanged: (newNote) => setState(() {
              note = newNote;
            }),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(note),
              child: Text("Ok"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ExpenseNoteDialogCubit(ExpenseNoteDialogState(note: initialNote)),
      child: BlocConsumer<ExpenseNoteDialogCubit, ExpenseNoteDialogState>(
        listenWhen: (previous, current) => previous.note != current.note,
        listener: (context, state) => onChanged(state.note),
        builder: (context, state) {
          final cubit = context.read<ExpenseNoteDialogCubit>();
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: cubit.controller),
              Gap(10),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...state.suggestions.map(
                      (e) => NoteSuggestionPill(
                        current: e == state.note,
                        text: e,
                        tapSuggestion: cubit.selectSuggestion,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
