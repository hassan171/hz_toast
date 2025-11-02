import 'package:flutter/widgets.dart';
import 'package:hz_toast/src/hz_type_enum.dart';
import 'package:hz_toast/src/hz_alignment_enum.dart';

/// Configuration data for a toast notification.
///
/// This class contains all the properties needed to create and display
/// a customizable toast notification. It supports various styling options,
/// animations, and interactive behaviors.
///
/// Example:
/// ```dart
/// final toast = HzToastData(
///   'Operation completed successfully!',
///   type: HzToastType.success,
///   duration: Duration(seconds: 3),
///   showProgressBar: true,
/// );
/// HzToast.show(toast);
/// ```
class HzToastData {
  /// Unique identifier for this toast instance.
  ///
  /// Used internally to track and manage individual toasts. If not provided,
  /// a unique ID will be automatically generated.
  final String id;

  /// The text message to display in the toast.
  ///
  /// This is the primary content that users will see. Can be customized
  /// further using [titleBuilder] for complex text styling.
  final String message;

  /// The visual style and color scheme for the toast.
  ///
  /// Determines the default colors for icons, text, and other elements.
  /// See [HzToastType] for available options.
  final HzToastType type;

  /// The positioning alignment for the toast notification.
  ///
  /// Determines which corner of the screen the toast will appear in.
  /// Defaults to [HzToastAlignment.topRight] if not specified.
  final HzToastAlignment alignment;

  /// Callback function executed when the toast is tapped.
  ///
  /// Only called if [clickable] is true. The toast will automatically
  /// hide after the callback is executed.
  final Function()? onTap;

  /// How long the toast should remain visible before auto-hiding.
  ///
  /// Only applies when [autoHide] is true. Defaults to 4 seconds.
  final Duration duration;

  /// Whether the toast responds to tap gestures.
  ///
  /// When true, tapping the toast will call [onTap] and hide the toast.
  /// When false, the toast ignores touch input.
  final bool clickable;

  /// Callback function executed when the toast is closed or hidden.
  ///
  /// Called regardless of how the toast was dismissed (auto-hide, manual close,
  /// or programmatic hiding).
  final Function()? onClose;

  /// Maximum width as a fraction of screen width (0.0 to 1.0).
  ///
  /// Controls how much of the screen width the toast can occupy.
  /// For example, 0.8 means the toast can be at most 80% of screen width.
  /// Maximum width as a fraction of screen width (0.0 to 1.0).
  ///
  /// Controls how much of the screen width the toast can occupy.
  /// For example, 0.8 means the toast can be at most 80% of screen width.
  final double maxWidth;

  /// Custom decoration for the toast container.
  ///
  /// When provided, this overrides the default styling including
  /// [backgroundColor], [borderRadius], and shadow effects.
  final BoxDecoration? decoration;

  /// Background color of the toast container.
  ///
  /// Only used when [decoration] is null. Defaults to white if not specified.
  final Color? backgroundColor;

  /// Border radius for the toast container corners.
  ///
  /// Only used when [decoration] is null. Defaults to rounded left corners.
  final BorderRadiusGeometry? borderRadius;

  /// Internal padding within the toast container.
  ///
  /// Controls spacing between the container edges and its content.
  /// Defaults to 8px horizontal and 8px vertical.
  final EdgeInsetsGeometry? padding;

  /// External margin around the toast container.
  ///
  /// Controls spacing between the toast and screen edges or other toasts.
  final EdgeInsetsGeometry? margin;

  /// Spacing between elements within the toast (icon, text, close button).
  ///
  /// Controls horizontal spacing between the toast's internal components.
  /// Defaults to 8px.
  final double? spacing;

  /// Color for the message text.
  ///
  /// Overrides the default color from [type] when specified.
  final Color? textColor;

  /// Custom builder for the title/message text widget.
  ///
  /// Allows complete customization of how the message is displayed.
  /// When provided, this overrides the default text rendering.
  ///
  /// The function receives the message string and the computed text color.
  /// Custom builder for the title/message text widget.
  ///
  /// Allows complete customization of how the message is displayed.
  /// When provided, this overrides the default text rendering.
  ///
  /// The function receives the message string and the computed text color.
  final Widget Function(String title, Color color)? titleBuilder;

  /// Whether to display the main icon.
  ///
  /// When true, shows the icon specified by [icon] or the default icon
  /// from [type]. When false, no main icon is displayed.
  final bool showIcon;

  /// Custom icon to display instead of the default type icon.
  ///
  /// When null, uses the default icon from [HzToastType.defaultIcon].
  final IconData? icon;

  /// Color for the main icon.
  ///
  /// Overrides the default color from [type] when specified.
  final Color? iconColor;

  /// Custom builder for the main icon widget.
  ///
  /// Allows complete customization of the main icon appearance.
  /// When provided, this overrides both [icon] and the default icon.
  ///
  /// The function receives the computed icon color.
  final Widget Function(Color color)? iconBuilder;

  /// Whether to display the close button.
  ///
  /// When true, shows a close button that allows manual dismissal.
  /// When false, the toast can only be dismissed programmatically or by auto-hide.
  final bool showCloseIcon;

  /// Custom icon for the close button.
  ///
  /// When null, uses [Icons.close] as the default close icon.
  final IconData? closeIcon;

  /// Color for the close button icon.
  ///
  /// Overrides the default color from [type] when specified.
  final Color? closeIconColor;

  /// Custom builder for the close button widget.
  ///
  /// Allows complete customization of the close button appearance.
  /// When provided, this overrides both [closeIcon] and the default close icon.
  ///
  /// The function receives the computed close icon color.
  final Widget Function(Color color)? closeIconBuilder;

  /// Whether the toast should automatically hide after [duration].
  ///
  /// When true, the toast will automatically dismiss itself after the
  /// specified duration. When false, the toast persists until manually dismissed.
  final bool autoHide;

  /// Whether to show a progress bar indicating remaining time.
  ///
  /// Only visible when [autoHide] is true. The progress bar shows how much
  /// time is left before the toast automatically hides.
  final bool showProgressBar;

  /// Color for the progress bar.
  ///
  /// When null, uses the same color as the main icon.
  /// Color for the progress bar.
  ///
  /// When null, uses the same color as the main icon.
  final Color? progressBarColor;

  /// Creates a new toast configuration.
  ///
  /// The [message] parameter is required and contains the text to display.
  /// All other parameters are optional and have sensible defaults.
  ///
  /// Example:
  /// ```dart
  /// HzToastData(
  ///   'File uploaded successfully',
  ///   type: HzToastType.success,
  ///   duration: Duration(seconds: 3),
  ///   onTap: () => print('Toast tapped'),
  /// )
  /// ```
  HzToastData(
    this.message, {
    String? id,
    this.type = HzToastType.error,
    this.alignment = HzToastAlignment.topRight,
    this.onTap,
    this.onClose,
    this.duration = const Duration(seconds: 4),
    this.clickable = true,
    this.autoHide = true,
    this.maxWidth = 0.8,
    this.decoration,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.margin,
    this.spacing,
    this.textColor,
    this.titleBuilder,
    this.showIcon = true,
    this.icon,
    this.iconColor,
    this.iconBuilder,
    this.showCloseIcon = true,
    this.closeIcon,
    this.closeIconColor,
    this.closeIconBuilder,
    this.showProgressBar = false,
    this.progressBarColor,
  }) : id = id ?? UniqueKey().toString();

  /// Creates a copy of this toast data with the given fields replaced.
  ///
  /// This method is useful for updating existing toast configurations
  /// while preserving other properties.
  ///
  /// Example:
  /// ```dart
  /// final updatedToast = originalToast.copyWith(
  ///   message: 'Updated message',
  ///   type: HzToastType.success,
  /// );
  /// ```
  HzToastData copyWith({
    String? id,
    String? message,
    HzToastType? type,
    HzToastAlignment? alignment,
    Function()? onTap,
    Duration? duration,
    bool? clickable,
    bool? autoHide,
    double? maxWidth,
    BoxDecoration? decoration,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? spacing,
    Color? textColor,
    Widget Function(String title, Color color)? titleBuilder,
    bool? showIcon,
    IconData? icon,
    Color? iconColor,
    Widget Function(Color color)? iconBuilder,
    bool? showCloseIcon,
    IconData? closeIcon,
    Color? closeIconColor,
    Widget Function(Color color)? closeIconBuilder,
    bool? showProgressBar,
    Color? progressBarColor,
  }) {
    return HzToastData(
      message ?? this.message,
      id: id ?? this.id,
      type: type ?? this.type,
      alignment: alignment ?? this.alignment,
      onTap: onTap ?? this.onTap,
      duration: duration ?? this.duration,
      clickable: clickable ?? this.clickable,
      autoHide: autoHide ?? this.autoHide,
      maxWidth: maxWidth ?? this.maxWidth,
      decoration: decoration ?? this.decoration,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      spacing: spacing ?? this.spacing,
      textColor: textColor ?? this.textColor,
      titleBuilder: titleBuilder ?? this.titleBuilder,
      showIcon: showIcon ?? this.showIcon,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      iconBuilder: iconBuilder ?? this.iconBuilder,
      showCloseIcon: showCloseIcon ?? this.showCloseIcon,
      closeIcon: closeIcon ?? this.closeIcon,
      closeIconColor: closeIconColor ?? this.closeIconColor,
      closeIconBuilder: closeIconBuilder ?? this.closeIconBuilder,
      showProgressBar: showProgressBar ?? this.showProgressBar,
      progressBarColor: progressBarColor ?? this.progressBarColor,
    );
  }
}
