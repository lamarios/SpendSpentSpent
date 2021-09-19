import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';


part 'config.g.dart';


@JsonSerializable()
class Config {
  bool allowSignup, canResetPassword, demoMode, hasSubscription;
  String announcement;


  Config({required this.demoMode, required this.allowSignup, required this.announcement, required this.canResetPassword, required this.hasSubscription});


  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigToJson(this);
}