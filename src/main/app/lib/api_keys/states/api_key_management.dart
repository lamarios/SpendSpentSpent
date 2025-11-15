import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:spend_spent_spent/api_keys/models/api_key.dart';
import 'package:spend_spent_spent/api_keys/services/api_key_service.dart';
import 'package:spend_spent_spent/api_keys/states/add_key_state.dart';
import 'package:spend_spent_spent/api_keys/views/components/add_api_key_dialog.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/utils/models/with_error.dart';

part 'api_key_management.freezed.dart';

final _log = Logger('ApiKeyManagementCubit');

class ApiKeyManagementCubit extends Cubit<ApiKeyManagementState> {
  ApiKeyManagementCubit(super.initialState) {
    init(true);
  }

  Future<void> init(bool loading) async {
    try {
      emit(state.copyWith(loading: loading));
      List<ApiKey> keys = await service.getKeys();
      emit(state.copyWith(keys: keys, loading: false));
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s, loading: false));
      _log.severe("Couldn't get api keys", e, s);
    }
  }

  Future<void> deleteKey(ApiKey apiKey) async {
    try {
      await service.deleteKey(apiKey.id);
      init(false);
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s, loading: false));
      _log.severe("Couldn't delete api keys", e, s);
    }
  }

  Future<ApiKey> addKey(AddKeyState newKey) async {
    try {
      var expiry = newKey.expiry == KeyExpiryPreset.never
          ? null
          : DateTime.now().add(Duration(days: newKey.expiry.days!)).millisecondsSinceEpoch;
      var createdKey = await service.createKey(name: newKey.name, expiryDate: expiry);
      init(false);
      return createdKey;
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s));
      _log.severe("Couldn't add api keys", e, s);
      rethrow;
    }
  }
}

@freezed
sealed class ApiKeyManagementState with _$ApiKeyManagementState implements WithError {
  @Implements<WithError>()
  const factory ApiKeyManagementState({
    @Default([]) List<ApiKey> keys,
    @Default(true) bool loading,
    dynamic error,
    StackTrace? stackTrace,
  }) = _ApiKeyManagementState;
}
