import 'package:flutter/material.dart';

enum HzToastType {
  error,
  success,
  warning,
  info;

  Color get iconColor {
    return switch (this) {
      HzToastType.error => Colors.red,
      HzToastType.success => Colors.green,
      HzToastType.warning => Colors.orange,
      HzToastType.info => Colors.blue,
    };
  }

  Color get closeIconColor {
    return switch (this) {
      HzToastType.error => Colors.red.shade300,
      HzToastType.success => Colors.green.shade300,
      HzToastType.warning => Colors.orange.shade300,
      HzToastType.info => Colors.blue.shade300,
    };
  }

  Color get textColor {
    return switch (this) {
      HzToastType.error => Colors.red,
      HzToastType.success => Colors.green,
      HzToastType.warning => Colors.orange,
      HzToastType.info => Colors.blue,
    };
  }

  IconData get defaultIcon {
    return switch (this) {
      HzToastType.error => Icons.error,
      HzToastType.success => Icons.check_circle,
      HzToastType.warning => Icons.warning,
      HzToastType.info => Icons.info,
    };
  }
}
