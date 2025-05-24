// This file is "main.dart"
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/expenses/state/last_expense.dart';
import 'package:spend_spent_spent/globals.dart' as globals;
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/login/models/login_page.dart';
import 'package:spend_spent_spent/oidc/states/oidc.dart';
import 'package:spend_spent_spent/settings/models/config.dart';
import 'package:spend_spent_spent/utils/models/exceptions/BackendNeedUpgradeException.dart';
import 'package:spend_spent_spent/utils/models/exceptions/NeedUpgradeException.dart';
import 'package:spend_spent_spent/utils/models/with_error.dart';
import 'package:spend_spent_spent/utils/preferences.dart';

part 'login.freezed.dart';

class LoginCubit extends Cubit<LoginState> {
  final TextEditingController urlController =
      TextEditingController(text: 'https://sss.ftpix.com');
  final CategoriesCubit categoriesCubit;
  final LastExpenseCubit lastExpenseCubit;

  final OidcCubit oidcCubit;

  LoginCubit(super.initialState, this.categoriesCubit, this.lastExpenseCubit,
      this.oidcCubit) {
    init();
  }

  getConfig() async {
    print('$kIsWeb ${Uri.base.scheme} ${Uri.base.host} ${Uri.base.port}');
    try {
      print('getting config');
      Config c = await service.getServerConfig(urlController.text.trim());
      print('can register ? ${c.allowSignup}');

      if (c.oidc != null) {
        await oidcCubit.setupClient(c.oidc!);
      }

      emit(state.copyWith(config: c));
    } on NeedUpgradeException {
      emit(state.copyWith(
          error:
              "Application needs update\nThe server requires a newer application version please upgrade"));
    } on BackendNeedUpgradeException {
      emit(state.copyWith(
          error:
              "Backend needs update\nThe backends is out dated and needs to be updated"));
    } catch (e, s) {
      emit(state.copyWith(config: null, error: e, stackTrace: s));
    }
  }

  signUp(bool signUp) {
    emit(state.copyWith(page: signUp ? LoginPage.signUp : LoginPage.login));
  }

  resetPassword(bool resetPassword) {
    emit(state.copyWith(
        page: resetPassword ? LoginPage.resetPassword : LoginPage.login));
  }

  init() async {
    categoriesCubit.reset();
    lastExpenseCubit.refresh();

    Uri base = Uri.base;
    String server =
        await Preferences.get(Preferences.SERVER_URL, 'https://sss.ftpix.com');
    if (kIsWeb) {
      server = '${base.scheme}://${base.host}';

      if (base.port != 80 || base.port != 443) {
        server += ':${base.port}';
      }
    }

    print('server: $server');
    urlController.text = server;

    getConfig();
    urlController.addListener(() {
      EasyDebounce.debounce(
          'get-server-config', const Duration(milliseconds: 500), getConfig);
    });
  }

  Future<bool> logIn(String username, String password) async {
    emit(state.copyWith(loginError: ''));

    try {
      await globals.service.setUrl(urlController.text.trim());
      var loggedIn = await globals.service.login(username, password);

      emit(state.copyWith(loginError: ''));
      if (loggedIn) {
        categoriesCubit.getCategories();
      }
      return loggedIn;
    } catch (e) {
      emit(state.copyWith(
          loginError: e.toString().replaceFirst("Exception: ", '')));
      return false;
    }
  }
}

@freezed
sealed class LoginState with _$LoginState implements WithError {
  @Implements<WithError>()
  const factory LoginState(
      {Config? config,
      @Default('') String loginError,
      @Default(LoginPage.login) LoginPage page,
      dynamic error,
      StackTrace? stackTrace}) = _LoginState;
}
