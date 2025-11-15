import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/categories/state/category_entry.dart';
import 'package:spend_spent_spent/categories/views/components/add_category.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';

class CategoryEntry extends StatelessWidget {
  final Category category;
  final int index;
  final Function(Category category, String newIcon) setIcon;
  final Function(Category category) delete;

  const CategoryEntry({
    super.key,
    required this.index,
    required this.setIcon,
    required this.category,
    required this.delete,
  });

  editIcon(BuildContext context) {
    showModal(
      context: context,
      builder: (context) => Card(
        margin: getInsetsForMaxSize(MediaQuery.of(context), maxWidth: 350, maxHeight: 600),
        child: AddCategory(onSelected: (newIcon) => setIcon(category, newIcon), buttonLabel: 'Choose new Icon'),
      ),
    );
  }

  deleteIcon(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete category'),
        content: const Text(
          'The category will only be deleted when you press the save button, this will delete all related expenses.',
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel', style: TextStyle(color: colors.secondary)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () {
              delete(category);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        color: colors.surfaceContainer,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              ReorderableDragStartListener(index: index, child: const Icon(Icons.drag_handle)),
              const Gap(20),
              getIcon(category.icon!, color: colors.primary, size: 20),
              const Gap(20),
              BlocProvider(
                create: (context) => CategoryEntryCubit(null, category),
                child: BlocBuilder<CategoryEntryCubit, int?>(
                  builder: (context, expenses) {
                    if (expenses != null) {
                      return expenses == -1
                          ? const Icon(Icons.warning)
                          : Text('$expenses expenses', style: textTheme.bodySmall);
                    } else {
                      return SizedBox(width: 10, height: 10, child: LoadingIndicator());
                    }
                  },
                ),
              ),
              const Spacer(),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => editIcon(context),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(Icons.edit, size: 15),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => deleteIcon(context),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(Icons.delete, size: 15, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
