import 'package:after_layout/after_layout.dart';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:spend_spent_spent/components/paginationSwitcher.dart';
import 'package:spend_spent_spent/components/settings/addUserDialog.dart';
import 'package:spend_spent_spent/components/settings/changePasswordDialog.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/models/paginatedResults.dart';
import 'package:spend_spent_spent/models/user.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';

class ManageUsers extends StatefulWidget {
  @override
  ManageUserState createState() => ManageUserState();
}

class ManageUserState extends State<ManageUsers> with AfterLayoutMixin {
  final searchController = TextEditingController();
  int page = 0, pageSize = 20;
  PaginatedResults<User>? users;
  User? currentUser;

  @override
  initState() {
    super.initState();
    searchController.addListener(getUsers);
  }

  getUsers() async {
    print('getting users');
    PaginatedResults<User> users = await service.getUsers(searchController.text, page, pageSize);
    setState(() {
      this.users = users;
    });
  }

  toggleUserAdmin(User user, bool isAdmin) async {
    await service.setUserAdmin(user.id!, isAdmin);
    await getUsers();
  }

  changeUserPassword(User user) {
    showModal(
        context: context,
        builder: (context) => Card(
            margin: getInsetsForMaxSize(MediaQuery.of(context), maxWidth:350, maxHeight: 250),
            child: ChangePasswordDialog(
              userId: user.id!,
            )));
  }

  previous() {
    if (page > 0) {
      setState(() {
        page--;
        getUsers();
      });
    }
  }

  next() {
    print('getting next');
    if (page < users!.pagination.totalPages - 1) {
      setState(() async {
        page++;
        getUsers();
      });
    }
  }

  Future<void> saveUser(User user) async {
    await service.createUser(user);
    await getUsers();
  }

  addUser(BuildContext context) {
    showModal(
        context: context,
        builder: (context) => Card(
            margin: getInsetsForMaxSize(MediaQuery.of(context), maxWidth:350, maxHeight: 600),
            child: AddUserDialog(
              saveUser: saveUser,
            )));
  }

  showDeleteUserDialog(BuildContext context, String id) {
    AppColors colors = get(context);
    showPlatformDialog(
        context: context,
        builder: (_) => PlatformAlertDialog(
              title: Text('Delete user ?'),
              content: Text('This will delete the user and all its expenses, it is not recoverable.'),
              actions: <Widget>[
                PlatformDialogAction(
                  child: PlatformText(
                    'Cancel',
                    style: TextStyle(color: colors.text),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                PlatformDialogAction(
                  child: PlatformText(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    deleteUser(id);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  deleteUser(String id) async {
    await service.deleteUser(id);
    await getUsers();
  }

  Widget getUserWidget(BuildContext context) {
    AppColors colors = get(context);
    if (isTablet(MediaQuery.of(context))) {
      List<TableRow> rows = [
        TableRow(children: [
          TableCell(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Email',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )),
          TableCell(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
          )),
          TableCell(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Admin', style: TextStyle(fontWeight: FontWeight.bold)),
          )),
          TableCell(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
          )),
        ])
      ];

      rows.addAll((users?.data ?? []).map((e) {
        bool isCurrentUser = (currentUser?.id ?? -1) == e.id;
        return TableRow(children: [
          TableCell(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(e.email),
          )),
          TableCell(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${e.firstName} ${e.lastName}'),
          )),
          TableCell(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: PlatformSwitch(value: e.isAdmin, onChanged: !isCurrentUser ? (value) => toggleUserAdmin(e, value) : null),
          )),
          Visibility(
            visible: !isCurrentUser,
            child: TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: PlatformTextButton(
                        child: Text('Change password'),
                        onPressed: () => changeUserPassword(e),
                      ),
                    ),
                    PlatformTextButton(
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.red,
                      onPressed: () => showDeleteUserDialog(context, e.id!),
                    )
                  ],
                ),
              ),
            ),
          )
        ]);
      }).toList());

      return Table(
        border: TableBorder.all(),
        children: rows,
      );
    } else {
      return Expanded(
          child: ListView(
        children: (users?.data ?? []).map((e) {
          bool isCurrentUser = (currentUser?.id ?? -1) == e.id;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(color: colors.containerOnDialogBackground, borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  key: Key(e.id.toString()),
                  children: [
                    Text(
                      '${e.firstName} ${e.lastName}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(e.email),
                    Row(
                      children: [
                        Expanded(child: Text('Admin')),
                        PlatformSwitch(value: e.isAdmin, onChanged: !isCurrentUser ? (value) => toggleUserAdmin(e, value) : null),
                      ],
                    ),
                    Visibility(
                      visible: !isCurrentUser,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: PlatformTextButton(
                              child: Text('Change password'),
                              onPressed: () => changeUserPassword(e),
                            ),
                          ),
                          PlatformTextButton(
                            child: Text(
                              'Delete',
                            ),
                            color: Colors.red,
                            onPressed: () => showDeleteUserDialog(context, e.id!),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    AppColors colors = get(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          PlatformTextField(
            hintText: 'Search',
            controller: searchController,
          ),
          getUserWidget(context),
          Visibility(visible: users != null, child: users != null ? PaginationSwitcher(pagination: users!.pagination, previous: previous, next: next) : SizedBox.shrink()),
          Row(
            children: [
              PlatformTextButton(
                color: Theme.of(context).primaryColor,
                onPressed: () => addUser(context),
                child: Text(
                  'Add user',
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    User user = await service.getCurrentUser();
    setState(() {
      this.currentUser = user;
    });
    getUsers();
  }
}
