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
import 'package:spend_spent_spent/identity/states/username_password.dart';
import 'package:spend_spent_spent/identity/utils/oidc.dart';
import 'package:spend_spent_spent/login/models/login_page.dart';
import 'package:spend_spent_spent/settings/models/config.dart';
import 'package:spend_spent_spent/utils/models/exceptions/BackendNeedUpgradeException.dart';
import 'package:spend_spent_spent/utils/models/exceptions/NeedUpgradeException.dart';
import 'package:spend_spent_spent/utils/models/with_error.dart';
import 'package:spend_spent_spent/utils/preferences.dart';

part 'login.freezed.dart';

class LoginCubit extends Cubit<LoginState> {
  final TextEditingController urlController = TextEditingController(
    text: 'https://sss.ftpix.com',
  );
  final CategoriesCubit categoriesCubit;
  final LastExpenseCubit lastExpenseCubit;

  final UsernamePasswordCubit usernamePasswordCubit;

  LoginCubit(
    super.initialState,
    this.categoriesCubit,
    this.lastExpenseCubit,
    this.usernamePasswordCubit,
  ) {
    init();
  }

  @override
  close() async {
    urlController.dispose();
    super.close();
  }

  getConfig() async {
    print('$kIsWeb ${Uri.base.scheme} ${Uri.base.host} ${Uri.base.port}');
    try {
      print('getting config');
      Config c = await service.getServerConfig(urlController.text.trim());
      print('can register ? ${c.allowSignup}');

      emit(state.copyWith(config: c, error: null, stackTrace: null));
    } on NeedUpgradeException {
      emit(
        state.copyWith(
          error:
              "Application needs update\nThe server requires a newer application version please upgrade",
        ),
      );
    } on BackendNeedUpgradeException {
      emit(
        state.copyWith(
          error:
              "Backend needs update\nThe backends is out dated and needs to be updated",
        ),
      );
    } catch (e, s) {
      emit(state.copyWith(config: null, error: e, stackTrace: s));
    }
  }

  signUp(bool signUp) {
    emit(state.copyWith(page: signUp ? LoginPage.signUp : LoginPage.login));
  }

  resetPassword(bool resetPassword) {
    emit(
      state.copyWith(
        page: resetPassword ? LoginPage.resetPassword : LoginPage.login,
      ),
    );
  }

  init() async {
    categoriesCubit.reset();
    lastExpenseCubit.refresh();

    Uri base = Uri.base;
    String server = await Preferences.get(
      Preferences.SERVER_URL,
      'https://sss.ftpix.com',
    );
    if (kIsWeb) {
      server = '${base.scheme}://${base.host}';

      if (base.port != 80 && base.port != 443) {
        server += ':${base.port}';
      }
    }

    urlController.text = server;

    getConfig();
    urlController.addListener(() {
      EasyDebounce.debounce(
        'get-server-config',
        const Duration(milliseconds: 500),
        getConfig,
      );
    });
  }

  Future<bool> logIn(String username, String password) async {
    emit(state.copyWith(loginError: ''));

    try {
      var url = urlController.text.trim();
      await globals.service.setUrl(url);
      var token = await globals.service.login(username, password);

      emit(state.copyWith(loginError: ''));

      usernamePasswordCubit.setToken(url, token);

      return true;
    } catch (e) {
      emit(
        state.copyWith(
          loginError: e.toString().replaceFirst("Exception: ", ''),
        ),
      );
      return false;
    }
  }

  Future<bool> logInWithOidc() async {
    emit(state.copyWith(loginError: ''));

    try {
      var url = urlController.text.trim();
      await globals.service.setUrl(url);
      if (state.config?.oidc != null) {
        final accessToken = await oidcLogin(state.config!.oidc!);

        if (accessToken != null) {
          final token = await service.loginWithOidcToken(accessToken);

          emit(state.copyWith(loginError: ''));

          usernamePasswordCubit.setToken(url, token);

          return true;
        }
      }
      return false;
    } catch (e) {
      emit(
        state.copyWith(
          loginError: e.toString().replaceFirst("Exception: ", ''),
        ),
      );
      return false;
    }
  }
}

@freezed
sealed class LoginState with _$LoginState implements WithError {
  @Implements<WithError>()
  const factory LoginState({
    Config? config,
    @Default('') String loginError,
    @Default(LoginPage.login) LoginPage page,
    dynamic error,
    StackTrace? stackTrace,
  }) = _LoginState;
}
