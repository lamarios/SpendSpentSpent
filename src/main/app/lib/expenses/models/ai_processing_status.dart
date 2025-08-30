import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum AiProcessingStatus {
  NO_PROCESSING,
  PENDING,
  PROCESSING,
  DONE,
  ERROR;

  IconData? getIcon() {
    return switch (this) {
      (NO_PROCESSING) => null,
      PENDING => Icons.hourglass_bottom,
      PROCESSING => Icons.auto_mode,
      DONE => Icons.auto_awesome,
      ERROR => Icons.error,
    };
  }

  String getLabel() {
    return switch (this) {
      (NO_PROCESSING) => '',
      PENDING => 'Pending',
      PROCESSING => 'Processing',
      DONE => '',
      ERROR => '',
    };
  }
}
