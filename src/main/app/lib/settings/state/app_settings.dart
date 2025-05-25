import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/settings/views/screens/settings.dart';
import 'package:spend_spent_spent/utils/preferences.dart';

part 'app_settings.freezed.dart';

class AppSettingsCubit extends Cubit<AppSettingsState> {
  AppSettingsCubit(super.initialState) {
    init();
  }

  init() async {
    final materialYou = await Preferences.getBool(MATERIAL_YOU, false);
    emit(state.copyWith(materialYou: materialYou));
    final blackBackground = await Preferences.getBool(BLACK_BACKGROUND, false);
    emit(state.copyWith(blackBackground: blackBackground));
    service.getCurrentServerConfig();
  }

  setMaterialYou(bool value) async {
    await Preferences.setBool(MATERIAL_YOU, value);
    emit(state.copyWith(materialYou: value));
  }

  setBlackBackground(bool value) async {
    await Preferences.setBool(BLACK_BACKGROUND, value);
    emit(state.copyWith(blackBackground: value));
  }
}

@freezed
sealed class AppSettingsState with _$AppSettingsState {
  const factory AppSettingsState(
      {@Default(false) bool materialYou,
      @Default(false) bool blackBackground}) = _AppSettingsState;
}
