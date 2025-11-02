import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hz_toast/hz_toast.dart';

/// A widget that displays and manages toast notifications in an overlay.
///
/// This widget should be placed in your app's overlay to handle the
/// display of all toast notifications. It listens to [HzToast.toasts]
/// and automatically shows, animates, and positions toasts.
///
/// The widget positions toasts in the top-right area of the screen
/// and stacks multiple toasts vertically with proper spacing.
///
/// Example usage:
/// ```dart
/// MaterialApp(
///   builder: (context, child) {
///     return Material(
///       child: Overlay(
///         initialEntries: [
///           OverlayEntry(builder: (context) => child!),
///           OverlayEntry(builder: (context) => const HzToastWidget()),
///         ],
///       ),
///     );
///   },
/// )
/// ```
class HzToastWidget extends StatelessWidget {
  /// Distance from the top of the screen to the first toast.
  ///
  /// Controls the top margin for the toast stack. Defaults to 20 pixels.
  final double? topSpacing;

  /// Vertical spacing between multiple toasts.
  ///
  /// Controls the gap between stacked toasts. This is in addition to
  /// any margins specified in individual [HzToastData.margin] properties.
  final double? spacing;

  /// Creates a toast display widget.
  ///
  /// The [topSpacing] and [spacing] parameters are optional and provide
  /// control over toast positioning and layout.
  const HzToastWidget({super.key, this.topSpacing, this.spacing});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return ValueListenableBuilder<List<HzToastData>>(
      valueListenable: HzToast.toasts,
      builder: (context, toasts, child) {
        return Stack(
          children: [
            for (int i = 0; i < toasts.length; i++)
              AnimatedPositioned(
                key: ValueKey('position_${toasts[i].id}'),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                // Calculate position based on previous toasts' heights and margins
                top: (topSpacing ?? 20) +
                    toasts.sublist(0, i).fold<double>(
                          0,
                          (previousValue, element) =>
                              previousValue +
                              (spacing ?? 0) + // Default vertical spacing
                              (element.margin?.vertical ?? 0) + // Toast-specific margin
                              48, // Approximate height of each toast
                        ),
                right: 0,
                child: _AnimatedToast(
                  key: ValueKey(toasts[i].id),
                  data: toasts[i],
                  width: width,
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Internal widget that handles the animation and lifecycle of a single toast.
///
/// This widget manages the entry and exit animations, auto-hide timer,
/// progress bar updates, and user interaction for individual toasts.
/// It should not be used directly; instead, use [HzToastWidget].
class _AnimatedToast extends StatefulWidget {
  /// The toast configuration data.
  final HzToastData data;

  /// The available screen width for layout calculations.
  final double width;

  const _AnimatedToast({super.key, required this.data, required this.width});

  @override
  State<_AnimatedToast> createState() => _AnimatedToastState();
}

class _AnimatedToastState extends State<_AnimatedToast> {
  /// Controls the visibility state for entry/exit animations.
  bool _visible = false;

  /// Prevents multiple exit animations from running simultaneously.
  bool _exiting = false;

  /// Subscription to the global toast removal stream.
  late final StreamSubscription<String> _removeSub;

  /// Tracks elapsed time for auto-hide functionality.
  final Stopwatch _stopwatch = Stopwatch();

  /// Notifies progress bar of remaining time (1.0 = full time, 0.0 = no time left).
  final ValueNotifier<double> _progress = ValueNotifier<double>(1.0);

  @override
  void initState() {
    super.initState();

    // Set up auto-hide timer and progress tracking if enabled
    if (widget.data.autoHide) {
      _stopwatch.start();
      Timer.periodic(const Duration(milliseconds: 10), (timer) {
        if (!mounted || _exiting) {
          timer.cancel();
          return;
        }
        if (_stopwatch.elapsed >= widget.data.duration) {
          timer.cancel();
          _startExitAnimation();
        } else {
          // Update progress bar (1.0 = full time remaining, 0.0 = no time left)
          _progress.value = 1.0 - (_stopwatch.elapsed.inMilliseconds / widget.data.duration.inMilliseconds);
        }
      });
    }

    // Start entry animation after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _visible = true);
    });

    // Listen for external removal requests
    _removeSub = HzToast.onRemove.listen((id) {
      if (id == widget.data.id && mounted) _startExitAnimation();
    });
  }

  /// Initiates the exit animation sequence.
  ///
  /// This method ensures that exit animations only run once and coordinates
  /// the visual exit with the actual removal from the toast list.
  void _startExitAnimation() {
    if (_exiting) return;
    setState(() {
      _exiting = true;
      _visible = false;
    });

    // Wait for animation to complete before removing from the list
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        HzToast.toasts.value = HzToast.toasts.value.where((t) => t.id != widget.data.id).toList();
        widget.data.onClose?.call();
      }
    });
  }

  @override
  void dispose() {
    _removeSub.cancel();
    _stopwatch.stop();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate animation values based on visibility state
    final offset = _visible ? Offset.zero : const Offset(1.0, 0.0);
    final opacity = _visible ? 1.0 : 0.0;

    return AnimatedSlide(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      offset: offset,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: opacity,
        child: Stack(
          children: [
            _ToastBody(width: widget.width, data: widget.data),

            // Progress bar overlay (only visible when auto-hide is enabled and progress bar is requested)
            if (widget.data.showProgressBar && widget.data.autoHide)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: ValueListenableBuilder<double>(
                      valueListenable: _progress,
                      builder: (context, value, child) {
                        return LinearProgressIndicator(
                          value: widget.data.autoHide ? value : null,
                          valueColor: AlwaysStoppedAnimation(widget.data.progressBarColor ?? widget.data.type.iconColor),
                          backgroundColor: Colors.transparent,
                          minHeight: 4,
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Internal widget that renders the visual content of a toast.
///
/// This widget handles the layout, styling, and user interaction
/// for the toast body, including icons, text, and close button.
/// It applies the configuration from [HzToastData] to create the final appearance.
class _ToastBody extends StatelessWidget {
  /// The available screen width for layout calculations.
  final double width;

  /// The toast configuration data containing all styling and content information.
  final HzToastData data;

  const _ToastBody({required this.width, required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: data.clickable
          ? () {
              data.onTap?.call();
              HzToast.hide(data.id);
            }
          : null,
      child: Container(
        constraints: BoxConstraints(maxWidth: width * data.maxWidth.clamp(0.0, 1.0)),
        margin: data.margin,
        padding: data.padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: data.decoration ??
            BoxDecoration(
              color: data.backgroundColor ?? Colors.white,
              borderRadius: data.borderRadius ??
                  const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(50),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
        child: Row(
          spacing: data.spacing ?? 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main icon (if enabled)
            if (data.showIcon)
              data.iconBuilder?.call(data.iconColor ?? data.type.iconColor) ??
                  Icon(
                    data.icon ?? data.type.defaultIcon,
                    color: data.iconColor ?? data.type.iconColor,
                  ),

            // Message text (with optional custom builder)
            data.titleBuilder?.call(data.message, data.textColor ?? data.type.textColor) ??
                Flexible(
                  child: Text(
                    data.message,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: data.textColor ?? data.type.textColor,
                    ),
                  ),
                ),

            // Close button (if enabled)
            if (data.showCloseIcon)
              data.closeIconBuilder?.call(data.closeIconColor ?? data.type.closeIconColor) ??
                  Icon(
                    data.closeIcon ?? Icons.close,
                    color: data.closeIconColor ?? data.type.closeIconColor,
                  ),
          ],
        ),
      ),
    );
  }
}
