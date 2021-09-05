import 'package:after_layout/after_layout.dart';
import 'package:app/components/masterDetail.dart';
import 'package:app/globals.dart';
import 'package:app/views/settings/changePassword.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends StatefulWidget {
  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> with AfterLayoutMixin {
  MasterDetail? masterDetail;

  logOut(BuildContext context) async {
    await service.logout();
    Navigator.pop(context);
  }

  showPasswordChange(BuildContext context) {
    if (masterDetail != null) {
      masterDetail!.setDetails(ChangePassword(), 'Change password', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(title: PlatformText('Settings')),
      body: Visibility(visible: masterDetail != null, child: masterDetail ?? Container()),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      masterDetail = MasterDetail(
        master: SettingsList(
          sections: [
            SettingsSection(
              title: 'Account',
              tiles: [
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
            )
          ],
        ),
      );
    });
  }
}
