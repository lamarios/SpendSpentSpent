import 'dart:core';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.g.dart';

part 'user.freezed.dart';

@freezed
sealed class User with _$User {
  const factory User({
    required String email,
    required String firstName,
    required String lastName,
    String? id,
    String? password,
    required bool isAdmin,
    int? subscriptionExpiry,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
