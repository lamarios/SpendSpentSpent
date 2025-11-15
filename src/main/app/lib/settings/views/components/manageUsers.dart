import 'package:after_layout/after_layout.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:spend_spent_spent/utils/views/components/paginationSwitcher.dart';
import 'package:spend_spent_spent/settings/views/components/add_user_dialog.dart';
import 'package:spend_spent_spent/settings/views/components/change_password_dialog.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/utils/models/paginatedResults.dart';
import 'package:spend_spent_spent/settings/models/user.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

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
        margin: getInsetsForMaxSize(MediaQuery.of(context), maxWidth: 350, maxHeight: 250),
        child: ChangePasswordDialog(userId: user.id!),
      ),
    );
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
        margin: getInsetsForMaxSize(MediaQuery.of(context), maxWidth: 350, maxHeight: 600),
        child: AddUserDialog(saveUser: saveUser),
      ),
    );
  }

  showDeleteUserDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete user ?'),
        content: const Text('This will delete the user and all its expenses, it is not recoverable.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () {
              deleteUser(id);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  deleteUser(String id) async {
    await service.deleteUser(id);
    await getUsers();
  }

  Widget getUserWidget(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    if (isTablet(MediaQuery.of(context))) {
      List<TableRow> rows = [
        const TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Admin', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ];

      rows.addAll(
        (users?.data ?? []).map((e) {
          bool isCurrentUser = (currentUser?.id ?? -1) == e.id;
          return TableRow(
            children: [
              TableCell(
                child: Padding(padding: const EdgeInsets.all(8.0), child: Text(e.email)),
              ),
              TableCell(
                child: Padding(padding: const EdgeInsets.all(8.0), child: Text('${e.firstName} ${e.lastName}')),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Switch(
                    value: e.isAdmin,
                    onChanged: !isCurrentUser ? (value) => toggleUserAdmin(e, value) : null,
                  ),
                ),
              ),
              Visibility(
                visible: !isCurrentUser,
                child: TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: TextButton(
                            child: const Text('Change password'),
                            onPressed: () => changeUserPassword(e),
                          ),
                        ),
                        TextButton(
                          style: const ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.red)),
                          onPressed: () => showDeleteUserDialog(context, e.id!),
                          child: const Text('Delete', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      );

      return Table(border: TableBorder.all(), children: rows);
    } else {
      return Expanded(
        child: ListView(
          children: (users?.data ?? []).map((e) {
            bool isCurrentUser = (currentUser?.id ?? -1) == e.id;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(color: colors.surfaceContainer, borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    key: Key(e.id.toString()),
                    children: [
                      Text('${e.firstName} ${e.lastName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(e.email),
                      Row(
                        children: [
                          const Expanded(child: Text('Admin')),
                          Switch(
                            value: e.isAdmin,
                            onChanged: !isCurrentUser ? (value) => toggleUserAdmin(e, value) : null,
                          ),
                        ],
                      ),
                      Visibility(
                        visible: !isCurrentUser,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: TextButton(
                                child: const Text('Change password'),
                                onPressed: () => changeUserPassword(e),
                              ),
                            ),
                            TextButton(
                              style: const ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.red)),
                              onPressed: () => showDeleteUserDialog(context, e.id!),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(hintText: 'Search'),
            controller: searchController,
          ),
          getUserWidget(context),
          Visibility(
            visible: users != null,
            child: users != null
                ? PaginationSwitcher(pagination: users!.pagination, previous: previous, next: next)
                : const SizedBox.shrink(),
          ),
          Row(
            children: [FilledButton.tonal(onPressed: () => addUser(context), child: const Text('Add user'))],
          ),
        ],
      ),
    );
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    User user = await service.getCurrentUser();
    setState(() {
      currentUser = user;
    });
    getUsers();
  }
}
