import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:auto_route/annotations.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:fbroadcast_nullsafety/fbroadcast_nullsafety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spend_spent_spent/components/categorySettings/categoryEntry.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/models/category.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

@RoutePage()
class CategorySettingsScreen extends StatefulWidget {
  @override
  CategorySettingsScreenState createState() => CategorySettingsScreenState();
}

class CategorySettingsScreenState extends State<CategorySettingsScreen> with AfterLayoutMixin {
  List<Category> categories = [];
  List<Category> toDelete = [];
  int expensesToDelete = 0;

  getCategories() {
    service.getCategories().then((value) {
      if (this.mounted) {
        setState(() {
          this.categories = value;
        });
      }
    });
  }

  onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = categories.removeAt(oldItemIndex);
      categories.insert(newItemIndex, movedItem);
      for (int i = 0; i < categories.length; i++) {
        categories[i].categoryOrder = i;
      }
    });
  }

  updateCategoryIcon(Category category, String newIcon) {
    setState(() {
      categories.forEach((element) {
        if (element.id == category.id) {
          element.icon = newIcon;
        }
      });
    });
  }

  addToDelete(Category category) async {
    int expenses = await service.countCategoryExpenses(category.id!);

    setState(() {
      toDelete.add(category);
      int index = categories.indexWhere((element) => element.id == category.id);
      categories.removeAt(index);
      expensesToDelete += expenses;
    });
  }

  onListReorder(int oldListIndex, int newListIndex) {}

  saveCategories(BuildContext context) async {
    await service.saveAllCategories(categories);

    toDelete.forEach((element) async {
      await service.deleteCategory(element.id!);
    });

    FBroadcast.instance()?.broadcast(BROADCAST_REFRESH_CATEGORIES);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    AppColors colors = get(context);
    return PlatformScaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: PlatformAppBar(
          title: PlatformText('Category Settings'),
          trailingActions: [],
        ),
        body: Container(
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
                          children: categories.map((e) {
                        return DragAndDropItem(
                            child: CategoryEntry(
                          setIcon: updateCategoryIcon,
                          delete: addToDelete,
                          category: e,
                        ));
                      }).toList())
                    ],
                    onItemReorder: onItemReorder,
                    onListReorder: onListReorder,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PlatformElevatedButton(
                          color: colors.main,
                          onPressed: () => saveCategories(context),
                          child: Text(
                            'Save',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: toDelete.length > 0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
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
                            PlatformText('${toDelete.length.toString()} categor${(toDelete.length == 1 ? 'y' : 'ies')} to delete.'),
                            PlatformText('$expensesToDelete expense${(expensesToDelete > 1 ? 's' : '')} to delete.'),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getCategories();
  }
}
