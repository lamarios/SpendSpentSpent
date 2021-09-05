import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String email, firstName, id, lastName, password;
  bool isAdmin;
  int subscriptionExpiry;

  User({required this.email, required this.id, required this.firstName, required this.isAdmin, required this.lastName, required this.password, required this.subscriptionExpiry});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
