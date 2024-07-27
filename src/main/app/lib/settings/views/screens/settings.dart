import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/settings/models/config.dart';
import 'package:spend_spent_spent/settings/models/settings.dart';
import 'package:spend_spent_spent/settings/models/user.dart';
import 'package:spend_spent_spent/router.dart';
import 'package:spend_spent_spent/settings/state/app_settings.dart';
import 'package:spend_spent_spent/settings/views/components/change_password.dart';
import 'package:spend_spent_spent/settings/views/components/edit_profile.dart';
import 'package:spend_spent_spent/settings/views/components/manageUsers.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';
import 'package:spend_spent_spent/utils/views/components/masterDetail.dart';

const ALLOW_SIGNUP = "allowSignUp",
    DEMO_MODE = "demoMode",
    MOTD = "motd",
    MATERIAL_YOU = "material-you",
    BLACK_BACKGROUND = "black-background",
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
  bool loading = false;
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
        .changeDetails(context, 'Change password', const ChangePassword());
  }

  showManageUsers(BuildContext context) {
    masterDetailKey.currentState!
        .changeDetails(context, 'Manage users', const ManageUsers());
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
    try {
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
    } catch (e) {
      print("Can't get admin settings and it's ok");
    }
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

    return BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, state) {
      final cubit = context.read<AppSettingsCubit>();
      return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // body: Visibility(visible: masterDetail != null, child: masterDetail ?? Container()),
        body: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : MasterDetail(
                key: masterDetailKey,
                master: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SettingsList(
                    platform: DevicePlatform.android,
                    lightTheme: theme,
                    darkTheme: theme,
                    sections: [
                      SettingsSection(
                        title: Text(
                          '${currentUser?.firstName ?? ""} ${currentUser?.lastName ?? ""}',
                          style: TextStyle(
                              color: colors.primary,
                              fontWeight: FontWeight.bold),
                        ),
                        tiles: [
                          if (showChangePassword) ...[
                            SettingsTile(
                              title: const Text('Edit profile'),
                              leading: const Icon(
                                Icons.person,
                                size: iconSize,
                              ),
                              onPressed: showEditProfile,
                            ),
                            SettingsTile(
                              title: const Text('Change password'),
                              leading: const Icon(
                                Icons.key,
                                size: iconSize,
                              ),
                              onPressed: showPasswordChange,
                            )
                          ],
                          SettingsTile(
                            title: const Text('Logout'),
                            leading: const Icon(
                              Icons.logout,
                              size: iconSize,
                            ),
                            onPressed: logOut,
                          )
                        ],
                      ),
                      if (currentUser?.isAdmin ?? false)
                        SettingsSection(
                            title: Text('Admin',
                                style: TextStyle(
                                    color: colors.primary,
                                    fontWeight: FontWeight.bold)),
                            tiles: [
                              SettingsTile(
                                title: const Text('Manage users'),
                                leading: const Icon(
                                  Icons.people,
                                  size: iconSize,
                                ),
                                onPressed: showManageUsers,
                              ),
                              SettingsTile(
                                title: const Text('Currencyapi.com api key'),
                                description: Text((service
                                            .config?.canConvertCurrency ??
                                        false)
                                    ? '${service.config?.convertCurrencyQuota ?? ''} remaining api calls \nthis month'
                                    : 'No api key set'),
                                leading: const Icon(
                                  Icons.attach_money,
                                  size: iconSize,
                                ),
                                onPressed: (context) => setCurrencyApiKey(),
                              ),
                              SettingsTile(
                                title: const Text('Set login screen message'),
                                description: Text(motdController.text),
                                leading: const Icon(
                                  Icons.comment_outlined,
                                  size: iconSize,
                                ),
                                onPressed: (context) => setMotd(),
                              ),
                              SettingsTile.switchTile(
                                title: const Text('Allow registration'),
                                leading: const Icon(
                                  Icons.key,
                                  size: iconSize,
                                ),
                                initialValue: allowSignUp,
                                onToggle: (bool value) => setSetting(
                                    ALLOW_SIGNUP, value ? "1" : "0", false),
                                // onPressed: showEditProfile,
                              ),
                              SettingsTile.switchTile(
                                title: const Text('Demo mode'),
                                description: const Text(
                                    'Non-admin accounts cannot edit their profiles or change their passwords'),
                                leading: const Icon(
                                  Icons.lock,
                                  size: iconSize,
                                ),
                                initialValue: demoMode,
                                onToggle: (bool value) => setSetting(
                                    MATERIAL_YOU, value ? "1" : "0", false),
                                // onPressed: showEditProfile,
                              ),
                            ]),
                      SettingsSection(title: const Text('Appearance'), tiles: [
                        if (!kIsWeb && Platform.isAndroid)
                          SettingsTile.switchTile(
                            title: const Text('Material you colors'),
                            description: const Text(
                                'Follow Material You colors, Android only'),
                            leading: const Icon(
                              Icons.color_lens_outlined,
                              size: iconSize,
                            ),
                            initialValue: state.materialYou,
                            onToggle: (bool value) =>
                                cubit.setMaterialYou(value),
                          ),
                        SettingsTile.switchTile(
                          title: const Text('Black background'),
                          description: const Text(
                              'Pure black background for dark theme'),
                          leading: const Icon(
                            Icons.color_lens_outlined,
                            size: iconSize,
                          ),
                          initialValue: state.blackBackground,
                          onToggle: (bool value) =>
                              cubit.setBlackBackground(value),
                        )
                      ]),
                      if (packageInfo != null)
                        SettingsSection(
                          title: Text('App info',
                              style: TextStyle(
                                  color: colors.primary,
                                  fontWeight: FontWeight.bold)),
                          tiles: [
                            SettingsTile(
                              title: Text(
                                  'Version: ${packageInfo?.version ?? 'n/a'}'),
                              description: Text(
                                  'Build: ${packageInfo?.buildNumber ?? 'n/a'}'),
                              leading: const Icon(Icons.info),
                              // onPressed: showEditProfile,
                            ),
                          ],
                        ),
                      if (config?.backendVersion != null)
                        SettingsSection(
                          title: Text('Backend info',
                              style: TextStyle(
                                  color: colors.primary,
                                  fontWeight: FontWeight.bold)),
                          tiles: [
                            SettingsTile(
                              title: Text(
                                  'Version: ${config?.backendVersion.toString() ?? 'n/a'}'),
                              leading: const Icon(Icons.dns),
                              // onPressed: showEditProfile,
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              ),
      );
    });
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    setState(() {
      loading = true;
    });
    User user = await service.getCurrentUser();
    Config config = await service.getServerConfig(service.url);

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    refreshSettings();

    print(config.demoMode);

    setState(() {
      this.packageInfo = packageInfo;
      currentUser = user;
      showChangePassword = user.isAdmin || !config.demoMode;
      loading = false;
    });
  }
}
