import 'dart:math';

import 'package:auto_route/annotations.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/categories/state/category_settings.dart';
import 'package:spend_spent_spent/components/categorySettings/categoryEntry.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/utils/views/components/error_listener.dart';

@RoutePage()
class CategorySettingsScreen extends StatelessWidget {
  onListReorder(int oldListIndex, int newListIndex) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Category Settings'),
        ),
        body: BlocProvider(
          create: (BuildContext context) => CategorySettingsCubit(
              CategorySettingsState(), context.read<CategoriesCubit>()),
          child: ErrorHandler<CategorySettingsCubit, CategorySettingsState>(
            child: BlocBuilder<CategorySettingsCubit, CategorySettingsState>(
                builder: (context, state) {
              final cubit = context.read<CategorySettingsCubit>();

              return state.categories.isEmpty
                  ? SizedBox.shrink()
                  : Container(
                      alignment: Alignment.center,
                      child: AnimatedContainer(
                        duration: panelTransition,
                        curve: Curves.easeInOutQuart,
                        width: min(MediaQuery.of(context).size.width, TABLET),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: PlatformText(
                                'Drag and drop the categoryies to change its order in the grid, all changes (edit, delete, reorder) are only applied when the save button is pressed.',
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                            Expanded(
                              child: DragAndDropLists(
                                itemDragHandle: DragHandle(
                                  onLeft: true,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Icon(
                                      Icons.menu,
                                      color: Colors.blueGrey,
                                      size: 15,
                                    ),
                                  ),
                                ),
                                children: [
                                  DragAndDropList(
                                      children: state.categories.map((e) {
                                    return DragAndDropItem(
                                        child: CategoryEntry(
                                      setIcon: cubit.updateCategoryIcon,
                                      delete: cubit.addToDelete,
                                      category: e,
                                    ));
                                  }).toList())
                                ],
                                onItemReorder: cubit.onItemReorder,
                                onListReorder: onListReorder,
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
                                      child: Text(
                                        'Save',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: state.toDelete.length > 0,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8, bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FaIcon(
                                        FontAwesomeIcons.exclamationTriangle,
                                        color: Colors.red,
                                        size: 15,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        PlatformText(
                                            '${state.toDelete.length.toString()} categor${(state.toDelete.length == 1 ? 'y' : 'ies')} to delete.'),
                                        PlatformText(
                                            '${state.expensesToDelete} expense${(state.expensesToDelete > 1 ? 's' : '')} to delete.'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
            }),
          ),
        ));
  }
}
