import 'package:after_layout/after_layout.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:spend_spent_spent/components/masterDetail.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/config.dart';
import 'package:spend_spent_spent/models/settings.dart';
import 'package:spend_spent_spent/models/user.dart';
import 'package:spend_spent_spent/router.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';
import 'package:spend_spent_spent/views/settings/changePassword.dart';
import 'package:spend_spent_spent/views/settings/editProfile.dart';
import 'package:spend_spent_spent/views/settings/manageUsers.dart';

const ALLOW_SIGNUP = "allowSignUp",
    DEMO_MODE = "demoMode",
    MOTD = "motd",
    CURRENCY_API_KEY = "currencyApiKey";

settingsTheme(ColorScheme colorScheme) => SettingsThemeData(
    settingsSectionBackground: colorScheme.surface,
    settingsListBackground: colorScheme.surface,
    titleTextColor: colorScheme.primary,
    dividerColor: colorScheme.onSurface,
    tileDescriptionTextColor: colorScheme.secondary,
    leadingIconsColor: colorScheme.secondary,
    tileHighlightColor: colorScheme.secondaryContainer);

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> with AfterLayoutMixin {
  MasterDetail? masterDetail;
  User? currentUser;
  GlobalKey<MasterDetailState> masterDetailKey = GlobalKey<MasterDetailState>();
  PackageInfo? packageInfo;
  TextEditingController motdController = TextEditingController(),
      currencyapiKey = TextEditingController();
  bool demoMode = false;
  bool allowSignUp = false;
  bool showChangePassword = false;
  Config? config;

  logOut(BuildContext context) async {
    await service.logout();
    AutoRouter.of(context).replaceAll([const LoginRoute()]);
  }

  refreshProfile() async {
    User user = await service.getCurrentUser();
    setState(() {
      currentUser = user;
    });
  }

  showPasswordChange(BuildContext context) {
    masterDetailKey.currentState!
        .changeDetails(context, 'Change password', ChangePassword());
  }

  showManageUsers(BuildContext context) {
    masterDetailKey.currentState!
        .changeDetails(context, 'Manage users', ManageUsers());
  }

  setMotd() {
    showPromptDialog(context, 'Login screen message', "", motdController, () {
      setSetting(MOTD, motdController.text.trim(), false);
    }, maxLines: 5);
  }

  setCurrencyApiKey() {
    showPromptDialog(context, 'currencyapi.com api key', "", currencyapiKey,
        () {
      setSetting(CURRENCY_API_KEY, currencyapiKey.text.trim(), true);
    });
  }

  showEditProfile(BuildContext context) {
    masterDetailKey.currentState!.changeDetails(
        context,
        'Edit profile',
        EditProfile(
          onProfileSaved: refreshProfile,
        ));
  }

  Future<void> refreshSettings() async {
    List<Settings> settings = await service.getAllSettings();

    setState(() {
      for (var element in settings) {
        switch (element.name) {
          case MOTD:
            motdController.text = element.value;
            break;
          case ALLOW_SIGNUP:
            allowSignUp = element.value == "1";
            break;
          case DEMO_MODE:
            demoMode = element.value == "1";
            break;
        }
      }
    });
  }

  setSetting(String label, String value, bool secret) async {
    Settings settings = Settings(name: label, value: value, secret: secret);
    await service.setSettings(settings);
    await refreshSettings();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    SettingsThemeData theme = settingsTheme(colors);

    const iconSize = 15.0;

    var tiles = [
      SettingsTile(
        title: const Text('Logout'),
        leading: const FaIcon(
          FontAwesomeIcons.rightFromBracket,
          size: iconSize,
        ),
        onPressed: logOut,
      )
    ];

    if (showChangePassword) {
      tiles.insert(
          0,
          SettingsTile(
            title: const Text('Edit profile'),
            leading: const FaIcon(
              FontAwesomeIcons.userLarge,
              size: iconSize,
            ),
            onPressed: showEditProfile,
          ));
      tiles.insert(
          1,
          SettingsTile(
            title: const Text('Change password'),
            leading: const FaIcon(
              FontAwesomeIcons.key,
              size: iconSize,
            ),
            onPressed: showPasswordChange,
          ));
    }

    List<SettingsSection> sections = [
      SettingsSection(
        title: Text(
          '${currentUser?.firstName ?? ""} ${currentUser?.lastName ?? ""}',
          style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold),
        ),
        tiles: tiles,
      ),
    ];

    if (currentUser?.isAdmin ?? false) {
      sections.add(SettingsSection(
        title: Text('Admin',
            style:
                TextStyle(color: colors.primary, fontWeight: FontWeight.bold)),
        tiles: [
          SettingsTile(
            title: const Text('Manage users'),
            leading: const FaIcon(
              FontAwesomeIcons.users,
              size: iconSize,
            ),
            onPressed: showManageUsers,
          ),
          SettingsTile(
            title: const Text('Currencyapi.com api key'),
            description: Text((service.config?.canConvertCurrency ?? false)
                ? '${service.config?.convertCurrencyQuota ?? ''} remaining api calls \nthis month'
                : 'No api key set'),
            leading: const FaIcon(
              FontAwesomeIcons.dollarSign,
              size: iconSize,
            ),
            onPressed: (context) => setCurrencyApiKey(),
          ),
          SettingsTile(
            title: const Text('Set login screen message'),
            description: Text(motdController.text),
            leading: const FaIcon(
              FontAwesomeIcons.comment,
              size: iconSize,
            ),
            onPressed: (context) => setMotd(),
          ),
          SettingsTile.switchTile(
            title: const Text('Allow registration'),
            leading: const FaIcon(
              FontAwesomeIcons.pencil,
              size: iconSize,
            ),
            initialValue: allowSignUp,
            onToggle: (bool value) =>
                setSetting(ALLOW_SIGNUP, value ? "1" : "0", false),
            // onPressed: showEditProfile,
          ),
          SettingsTile.switchTile(
            title: const Text('Demo mode'),
            description: const Text(
                'Non-admin accounts cannot edit their profiles or change their passwords'),
            leading: const FaIcon(
              FontAwesomeIcons.userLock,
              size: iconSize,
            ),
            initialValue: demoMode,
            onToggle: (bool value) =>
                setSetting(DEMO_MODE, value ? "1" : "0", false),
            // onPressed: showEditProfile,
          ),
        ],
      ));
    }

    if (packageInfo != null) {
      sections.add(SettingsSection(
        title: Text('App info',
            style:
                TextStyle(color: colors.primary, fontWeight: FontWeight.bold)),
        tiles: [
          SettingsTile(
            title: Text('Version: ${packageInfo?.version ?? 'n/a'}'),
            description: Text('Build: ${packageInfo?.buildNumber ?? 'n/a'}'),
            leading: const FaIcon(FontAwesomeIcons.circleInfo),
            // onPressed: showEditProfile,
          ),
        ],
      ));
    }

    if (config?.backendVersion != null) {
      sections.add(SettingsSection(
        title: Text('Backend info',
            style:
                TextStyle(color: colors.primary, fontWeight: FontWeight.bold)),
        tiles: [
          SettingsTile(
            title:
                Text('Version: ${config?.backendVersion.toString() ?? 'n/a'}'),
            leading: const FaIcon(FontAwesomeIcons.server),
            // onPressed: showEditProfile,
          ),
        ],
      ));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // body: Visibility(visible: masterDetail != null, child: masterDetail ?? Container()),
      body: MasterDetail(
        key: masterDetailKey,
        master: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SettingsList(
            lightTheme: theme,
            darkTheme: theme,
            sections: sections,
          ),
        ),
      ),
    );
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    User user = await service.getCurrentUser();
    Config config = await service.getServerConfig(service.url);

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    refreshSettings();

    print(config.demoMode);

    setState(() {
      this.packageInfo = packageInfo;
      this.currentUser = user;
      this.showChangePassword = user.isAdmin || !config.demoMode;
      this.config = config;
    });
  }
}
