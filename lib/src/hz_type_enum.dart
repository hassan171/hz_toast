import 'package:flutter/material.dart';

/// Defines the visual style and behavior of a toast notification.
///
/// Each type provides default colors for icons, text, and close buttons
/// that follow common UI patterns for different message types.
enum HzToastType {
  /// Represents an error or failure state.
  ///
  /// Uses red colors and an error icon to indicate something went wrong.
  error,

  /// Represents a successful operation or positive confirmation.
  ///
  /// Uses green colors and a check circle icon to indicate success.
  success,

  /// Represents a warning or cautionary message.
  ///
  /// Uses orange colors and a warning icon to draw attention to potential issues.
  warning,

  /// Represents informational content or neutral messages.
  ///
  /// Uses blue colors and an info icon for general information.
  info;

  /// The default color for the main icon based on the toast type.
  ///
  /// This color is used for the primary icon displayed in the toast unless
  /// overridden by [HzToastData.iconColor].
  Color get iconColor {
    return switch (this) {
      HzToastType.error => Colors.red,
      HzToastType.success => Colors.green,
      HzToastType.warning => Colors.orange,
      HzToastType.info => Colors.blue,
    };
  }

  /// The default color for the close icon based on the toast type.
  ///
  /// This color is used for the close button icon unless overridden by
  /// [HzToastData.closeIconColor]. Uses a lighter shade than [iconColor]
  /// for better visual hierarchy.
  Color get closeIconColor {
    return switch (this) {
      HzToastType.error => Colors.red.shade300,
      HzToastType.success => Colors.green.shade300,
      HzToastType.warning => Colors.orange.shade300,
      HzToastType.info => Colors.blue.shade300,
    };
  }

  /// The default color for the message text based on the toast type.
  ///
  /// This color is used for the main message text unless overridden by
  /// [HzToastData.textColor].
  Color get textColor {
    return switch (this) {
      HzToastType.error => Colors.red,
      HzToastType.success => Colors.green,
      HzToastType.warning => Colors.orange,
      HzToastType.info => Colors.blue,
    };
  }

  /// The default icon data for the main icon based on the toast type.
  ///
  /// This icon is displayed as the primary visual indicator unless
  /// overridden by [HzToastData.icon].
  IconData get defaultIcon {
    return switch (this) {
      HzToastType.error => Icons.error,
      HzToastType.success => Icons.check_circle,
      HzToastType.warning => Icons.warning,
      HzToastType.info => Icons.info,
    };
  }
}
