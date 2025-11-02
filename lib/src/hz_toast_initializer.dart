import 'package:flutter/material.dart';
import 'package:hz_toast/src/hz_toast.dart';
import 'package:hz_toast/src/hz_toast_widget.dart';

/// Widget that initializes the toast system for the entire app.
///
/// This widget creates its own overlay to display toasts, eliminating the need
/// to find an overlay in the widget tree. Simply wrap your app with this widget.
///
/// Example usage with MaterialApp.builder:
/// ```dart
/// MaterialApp(
///   builder: (context, child) {
///     return HzToastInitializer(child: child!);
///   },
///   home: MyHomePage(),
/// )
/// ```
///
/// Or wrap your home widget directly:
/// ```dart
/// MaterialApp(
///   home: HzToastInitializer(
///     child: MyHomePage(),
///   ),
/// )
/// ```
class HzToastInitializer extends StatefulWidget {
  /// The child widget to display.
  final Widget child;

  /// The spacing between the toasts and the screen edges.
  final double? edgeSpacing;

  /// The spacing between individual toasts.
  final double? spacing;

  /// Creates a widget that initializes the toast system.
  const HzToastInitializer({
    super.key,
    required this.child,
    this.edgeSpacing,
    this.spacing,
  });

  @override
  State<HzToastInitializer> createState() => _HzToastInitializerState();
}

class _HzToastInitializerState extends State<HzToastInitializer> {
  @override
  void initState() {
    super.initState();
    HzToast.initializeWithBuiltInOverlay();
  }

  @override
  Widget build(BuildContext context) {
    // Create our own overlay that contains both the child and toast system
    return Overlay(
      initialEntries: [
        // Main app content
        OverlayEntry(
          builder: (context) => widget.child,
        ),
        // Toast display overlay
        OverlayEntry(
          builder: (context) => HzToastWidget(
            edgeSpacing: widget.edgeSpacing,
            spacing: widget.spacing,
          ),
        ),
      ],
    );
  }
}
