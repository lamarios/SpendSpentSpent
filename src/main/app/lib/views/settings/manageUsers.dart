import 'package:after_layout/after_layout.dart';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:spend_spent_spent/components/paginationSwitcher.dart';
import 'package:spend_spent_spent/components/settings/addUserDialog.dart';
import 'package:spend_spent_spent/components/settings/changePasswordDialog.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/paginatedResults.dart';
import 'package:spend_spent_spent/models/user.dart';
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
            margin: getInsetsForMaxSize(MediaQuery.of(context), 350, vertical: 60),
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
            margin: getInsetsForMaxSize(MediaQuery.of(context), 350, vertical: 60),
            child: AddUserDialog(
              saveUser: saveUser,
            )));
  }

  showDeleteUserDialog(BuildContext context, String id) {
    showPlatformDialog(
        context: context,
        builder: (_) => PlatformAlertDialog(
              title: Text('Delete user ?'),
              content: Text('This will delete the user and all its expenses, it is not recoverable.'),
              actions: <Widget>[
                PlatformDialogAction(
                  child: PlatformText(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[850]),
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
    if (isTablet(MediaQuery.of(context))) {
      return Text('yo');
    } else {
      return Expanded(
          child: ListView(
        children: (users?.data ?? []).map((e) {
          bool isCurrentUser = (currentUser?.id ?? -1) == e.id;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(5)),
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
                            child: PlatformButton(
                              child: Text('Change password'),
                              onPressed: () => changeUserPassword(e),
                            ),
                          ),
                          PlatformButton(
                            child: Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
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
              PlatformButton(
                color: Theme.of(context).primaryColor,
                onPressed: () => addUser(context),
                child: Text(
                  'Add user',
                  style: TextStyle(color: Colors.white),
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
