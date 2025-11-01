import 'package:flutter/widgets.dart';
import 'package:hz_toast/src/hz_type_enum.dart';

class HzToastData {
  final String id;
  final String message;
  final HzToastType type;
  final Function()? onTap;
  final Duration duration;
  final bool clickable;
  final Function()? onClose;

  /// Max width as a fraction of screen width (0.0 to 1.0)
  final double maxWidth;

  final BoxDecoration? decoration;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? spacing;

  final Color? textColor;
  final Widget Function(String title, Color color)? titleBuilder;

  final bool showIcon;
  final IconData? icon;
  final Color? iconColor;
  final Widget Function(Color color)? iconBuilder;

  final bool showCloseIcon;
  final IconData? closeIcon;
  final Color? closeIconColor;
  final Widget Function(Color color)? closeIconBuilder;

  final bool autoHide;
  final bool showProgressBar;
  final Color? progressBarColor;

  HzToastData(
    this.message, {
    String? id,
    this.type = HzToastType.error,
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

  HzToastData copyWith({
    String? id,
    String? message,
    HzToastType? type,
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
