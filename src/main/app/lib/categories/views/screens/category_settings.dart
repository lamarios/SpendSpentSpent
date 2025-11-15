import 'dart:math';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/categories/state/category_settings.dart';
import 'package:spend_spent_spent/categories/views/components/category_entry.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/utils/views/components/error_listener.dart';

@RoutePage()
class CategorySettingsScreen extends StatelessWidget {
  const CategorySettingsScreen({super.key});

  onListReorder(int oldListIndex, int newListIndex) {}

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Category Settings')),
      body: BlocProvider(
        create: (BuildContext context) =>
            CategorySettingsCubit(const CategorySettingsState(), context.read<CategoriesCubit>()),
        child: ErrorHandler<CategorySettingsCubit, CategorySettingsState>(
          child: BlocBuilder<CategorySettingsCubit, CategorySettingsState>(
            builder: (context, state) {
              final cubit = context.read<CategorySettingsCubit>();

              return Container(
                alignment: Alignment.center,
                child: AnimatedContainer(
                  duration: panelTransition,
                  curve: Curves.easeInOutQuart,
                  width: min(MediaQuery.of(context).size.width, TABLET),
                  child: Column(
                    children: [
                      if (state.categories.isNotEmpty)
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Drag and drop the categoryies to change its order in the grid, all changes (edit, delete, reorder) are only applied when the save button is pressed.',
                            style: TextStyle(fontSize: 10),
                          ),
                        )
                      else
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.sentiment_neutral, size: 100),
                              Gap(24),
                              Text(
                                'No expense categories to manage',
                                textAlign: TextAlign.center,
                                style: textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ),
                      if (state.categories.isNotEmpty)
                        Expanded(
                          child: ReorderableListView.builder(
                            buildDefaultDragHandles: false,
                            onReorder: cubit.onItemReorder,
                            itemCount: state.categories.length,
                            itemBuilder: (context, index) {
                              final e = state.categories[index];
                              return CategoryEntry(
                                key: ValueKey(e.id),
                                setIcon: cubit.updateCategoryIcon,
                                delete: cubit.addToDelete,
                                category: e,
                                index: index,
                              );
                            },
                          ),
                        ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FilledButton.tonal(
                                onPressed: () async {
                                  await cubit.saveCategories();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Save'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: state.toDelete.isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.warning_amber, color: Colors.red, size: 15),
                              ),
                              Column(
                                children: [
                                  Text(
                                    '${state.toDelete.length.toString()} categor${(state.toDelete.length == 1 ? 'y' : 'ies')} to delete.',
                                  ),
                                  Text(
                                    '${state.expensesToDelete} expense${(state.expensesToDelete > 1 ? 's' : '')} to delete.',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
