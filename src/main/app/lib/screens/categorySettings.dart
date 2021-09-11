import 'package:after_layout/after_layout.dart';
import 'package:spend_spent_spent/components/categorySettings/categoryEntry.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/category.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategorySettingsScreen extends StatefulWidget {
  @override
  CategorySettingsScreenState createState() => CategorySettingsScreenState();
}

class CategorySettingsScreenState extends State<CategorySettingsScreen> with AfterLayoutMixin {
  List<Category> categories = [];
  List<Category> toDelete = [];

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

  addToDelete(Category category) {
    setState(() {
      toDelete.add(category);
      int index = categories.indexWhere((element) => element.id == category.id);
      categories.removeAt(index);
    });
  }

  onListReorder(int oldListIndex, int newListIndex) {}

  saveCategories(BuildContext context) async {
    await service.saveAllCategories(categories);

    toDelete.forEach((element) async {
      await service.deleteCategory(element.id!);
    });

    FBroadcast.instance().broadcast(BROADCAST_REFRESH_CATEGORIES);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        appBar: PlatformAppBar(
          title: PlatformText('Category Settings'),
          trailingActions: [],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
              child: PlatformText(
                'Drag and drop the categoryies to change its order in the grid, all changes (edit, delete, reorder) are only applied when the save button is pressed.',
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
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
                    child: PlatformButton(
                      color: Theme.of(context).primaryColorDark,
                      onPressed: () => saveCategories(context),
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
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
                      FaIcon(
                        FontAwesomeIcons.exclamationTriangle,
                        color: Colors.red,
                        size: 15,
                      ),
                      PlatformText(' '+toDelete.length.toString()),
                      PlatformText(' categor${(toDelete.length == 1 ? 'y' : 'ies')} to delete.'),
                    ],
                  ),
                ))
          ],
        ));
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getCategories();
  }
}
