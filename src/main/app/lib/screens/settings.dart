import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:spend_spent_spent/components/masterDetail.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/user.dart';
import 'package:spend_spent_spent/views/settings/changePassword.dart';
import 'package:spend_spent_spent/views/settings/editProfile.dart';
import 'package:spend_spent_spent/views/settings/manageUsers.dart';

class SettingsScreen extends StatefulWidget {
  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> with AfterLayoutMixin {
  MasterDetail? masterDetail;
  User? currentUser;
  GlobalKey<MasterDetailState> masterDetailKey = GlobalKey<MasterDetailState>();
  PackageInfo? packageInfo;

  logOut(BuildContext context) async {
    await service.logout();
    Navigator.pop(context);
  }

  refreshProfile() async {
    User user = await service.getCurrentUser();
    setState(() {
      currentUser = user;
    });
  }

  showPasswordChange(BuildContext context) {
    masterDetailKey.currentState!.changeDetails(context, 'Change password', ChangePassword());
  }

  showManageUsers(BuildContext context){
    masterDetailKey.currentState!.changeDetails(context, 'Manage users', ManageUsers());
  }

  @override
  initState() {
    super.initState();
  }

  showEditProfile(BuildContext context) {
    masterDetailKey.currentState!.changeDetails(
        context,
        'Edit profile',
        EditProfile(
          onProfileSaved: refreshProfile,
        ));
  }

  setSetting(String label, dynamic value) {}

  @override
  Widget build(BuildContext context) {
    List<SettingsSection> sections = [
      SettingsSection(
        title: '${currentUser?.firstName ?? ""} ${currentUser?.lastName ?? ""}',
        tiles: [
          SettingsTile(
            title: 'Edit profile',
            leading: FaIcon(FontAwesomeIcons.userAlt),
            onPressed: showEditProfile,
          ),
          SettingsTile(
            title: 'Change password',
            leading: FaIcon(FontAwesomeIcons.key),
            onPressed: showPasswordChange,
          ),
          SettingsTile(
            title: 'Logout',
            leading: FaIcon(FontAwesomeIcons.signOutAlt),
            onPressed: logOut,
          )
        ],
      ),
    ];

    if (currentUser?.isAdmin ?? false) {
      sections.add(SettingsSection(
        title: 'Admin',
        tiles: [
          SettingsTile(
            title: 'Manage users',
            leading: FaIcon(FontAwesomeIcons.users),
            onPressed: showManageUsers,
          ),
          SettingsTile(
            title: 'Currency Converter API key',
            subtitle: 'Optional currency converter api key',
            leading: FaIcon(FontAwesomeIcons.dollarSign),
            // onPressed: showEditProfile,
          ),
          SettingsTile(
            title: 'Set login screen message',
            subtitle: 'Message displayed on the login screen',
            leading: FaIcon(FontAwesomeIcons.comment),
            // onPressed: showEditProfile,
          ),
          SettingsTile.switchTile(
            title: 'Allow registration',
            leading: FaIcon(FontAwesomeIcons.pencilAlt),
            switchValue: true,
            onToggle: (bool value) {},
            // onPressed: showEditProfile,
          ),
          SettingsTile.switchTile(
            title: 'Demo mode',
            subtitle: 'Non-admin accounts cannot edit their profiles or change their passwords',
            leading: FaIcon(FontAwesomeIcons.pencilAlt),
            switchValue: true,
            onToggle: (bool value) {},
            // onPressed: showEditProfile,
          ),
        ],
      ));
    }

    if (packageInfo != null) {
      sections.add(SettingsSection(
        title: 'App info',
        tiles: [
          SettingsTile(
            title: 'Version: ${packageInfo?.version ?? 'n/a'}',
            subtitle: 'Build: ${packageInfo?.buildNumber ?? 'n/a'}',
            leading: FaIcon(FontAwesomeIcons.comment),
            // onPressed: showEditProfile,
          ),
        ],
      ));
    }

    return PlatformScaffold(
      appBar: PlatformAppBar(title: PlatformText('Settings')),
      // body: Visibility(visible: masterDetail != null, child: masterDetail ?? Container()),
      body: MasterDetail(
        key: masterDetailKey,
        master: SettingsList(
          sections: sections,
        ),
      ),
    );
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    User user = await service.getCurrentUser();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      this.packageInfo = packageInfo;
      this.currentUser = user;
    });
  }
}
