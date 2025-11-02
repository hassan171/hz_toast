import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hz_toast/src/hz_model.dart';

/// A singleton class that manages toast notifications throughout the application.
///
/// This class provides static methods to show, update, hide, and manage
/// toast notifications. It maintains a global state of active toasts
/// and coordinates their display through the HzToastInitializer widget.
///
/// ## Setup
///
/// Wrap your app with HzToastInitializer:
/// ```dart
/// MaterialApp(
///   builder: (context, child) {
///     return HzToastInitializer(child: child!);
///   },
///   home: MyHomePage(),
/// )
/// ```
///
/// ## Usage
/// ```dart
/// // Show a simple success toast
/// HzToast.show(HzToastData(
///   'Operation completed!',
///   type: HzToastType.success,
/// ));
///
/// // Hide a specific toast
/// HzToast.hide('toast-id');
///
/// // Hide all toasts
/// HzToast.hideAll();
/// ```
class HzToast {
  HzToast._privateConstructor();
  static final HzToast _instance = HzToast._privateConstructor();

  /// Creates and returns the singleton instance of [HzToast].
  ///
  /// This factory constructor ensures only one instance exists throughout
  /// the application lifecycle.
  factory HzToast() => _instance;

  /// Enable debug logging for troubleshooting toast issues
  static bool debugMode = false;

  /// Internal list of currently active toasts.
  ///
  /// This [ValueNotifier] is observed by [HzToastInitializer] to reactively
  /// update the UI when toasts are added or removed.
  static final ValueNotifier<List<HzToastData>> _toasts = ValueNotifier([]);

  /// Provides read-only access to the current list of active toasts.
  ///
  /// The [HzToastInitializer] listens to this notifier to automatically
  /// update the display when toasts change.
  static ValueNotifier<List<HzToastData>> get toasts => _toasts;

  /// Internal stream controller for coordinating toast removal animations.
  ///
  /// When a toast needs to be hidden, its ID is sent through this stream
  /// to trigger the exit animation before actual removal.
  static final StreamController<String> _toastRemoveController = StreamController.broadcast();

  /// Stream of toast IDs that should start their exit animations.
  ///
  /// [HzToastInitializer] listens to this stream to coordinate smooth
  /// removal animations before updating the toast list.
  static Stream<String> get onRemove => _toastRemoveController.stream;

  /// Displays a new toast notification.
  ///
  /// Adds the provided [toast] to the active toasts list if a toast
  /// with the same ID doesn't already exist.
  ///
  /// Returns `true` if the toast was successfully added, or `false`
  /// if a toast with the same ID already exists.
  ///
  /// Example:
  /// ```dart
  /// final success = HzToast.show(HzToastData(
  ///   'File saved successfully',
  ///   type: HzToastType.success,
  /// ));
  /// if (!success) {
  ///   print('Toast with this ID already exists');
  /// }
  /// ```
  static bool show(HzToastData toast) {
    if (debugMode) {
      debugPrint('🍞 HzToast Debug: show() called for toast: "${toast.message}"');
      debugPrint('🍞 HzToast Debug: Toast ID: ${toast.id}');
    }

    if (exists(toast.id)) {
      if (debugMode) {
        debugPrint('🍞 HzToast Debug: Toast with ID ${toast.id} already exists - skipping');
      }
      return false;
    }

    // Add to the list - toasts will be displayed via HzToastInitializer's built-in overlay
    _toasts.value = [..._toasts.value, toast];

    if (debugMode) {
      debugPrint('🍞 HzToast Debug: Toast added to list. Total toasts: ${_toasts.value.length}');
    }

    return true;
  }

  /// Updates an existing toast with new data.
  ///
  /// Finds the toast with the specified [id] and replaces its data
  /// with [newData]. The ID of the toast remains unchanged.
  ///
  /// Returns `true` if the toast was found and updated, or `false`
  /// if no toast with the given ID exists.
  ///
  /// This is useful for showing progress updates or changing the
  /// content of a toast that's already displayed.
  ///
  /// Example:
  /// ```dart
  /// // Show initial toast
  /// HzToast.show(HzToastData('Processing...', id: 'progress'));
  ///
  /// // Update with progress
  /// HzToast.update('progress', HzToastData('50% complete', id: 'progress'));
  ///
  /// // Update to completion
  /// HzToast.update('progress', HzToastData('Done!', type: HzToastType.success));
  /// ```
  static bool update(String id, HzToastData newData) {
    final index = _toasts.value.indexWhere((t) => t.id == id);
    if (index != -1) {
      final updatedToasts = List<HzToastData>.from(_toasts.value);
      updatedToasts[index] = newData.copyWith(id: id);
      _toasts.value = updatedToasts;
      return true;
    }
    return false;
  }

  /// Checks if a toast with the given [id] currently exists.
  ///
  /// Returns `true` if a toast with the specified ID is currently
  /// active, `false` otherwise.
  ///
  /// This is useful to avoid showing duplicate toasts or to check
  /// if a toast is still active before updating it.
  ///
  /// Example:
  /// ```dart
  /// if (!HzToast.exists('my-toast-id')) {
  ///   HzToast.show(HzToastData('New message', id: 'my-toast-id'));
  /// }
  /// ```
  static bool exists(String id) {
    return _toasts.value.any((t) => t.id == id);
  }

  /// Initiates the hiding process for a toast with the given [id].
  ///
  /// This triggers the exit animation for the specified toast.
  /// The toast will be removed from the list after the animation completes.
  ///
  /// If no toast with the given ID exists, this method has no effect.
  ///
  /// Example:
  /// ```dart
  /// HzToast.hide('my-toast-id');
  /// ```
  static void hide(String id) {
    _toastRemoveController.add(id);
  }

  /// Schedules a toast to be hidden after the specified [duration].
  ///
  /// This is useful for programmatically dismissing toasts after
  /// a delay, such as when an operation completes.
  ///
  /// Example:
  /// ```dart
  /// // Show a toast and hide it after 2 seconds
  /// final toastId = 'temp-message';
  /// HzToast.show(HzToastData('Temporary message', id: toastId));
  /// HzToast.hideIn(toastId, Duration(seconds: 2));
  /// ```
  static void hideIn(String id, Duration duration) {
    Future.delayed(duration, () => hide(id));
  }

  /// Hides all currently active toasts.
  ///
  /// This triggers the exit animation for every active toast.
  /// All toasts will be removed after their animations complete.
  ///
  /// This is useful for clearing all notifications at once,
  /// such as when navigating to a new screen.
  ///
  /// Example:
  /// ```dart
  /// // Clear all toasts when user logs out
  /// HzToast.hideAll();
  /// ```
  static void hideAll() {
    // Send remove signals for all current toasts to trigger animations
    for (final toast in _toasts.value) {
      _toastRemoveController.add(toast.id);
    }
  }

  /// Immediately clears all toasts without animations.
  ///
  /// This is primarily intended for testing scenarios where you need
  /// immediate cleanup without waiting for animations.
  @visibleForTesting
  static void clearAll() {
    _toasts.value = [];
  }

  /// Disposes of the toast system resources.
  ///
  /// This is primarily intended for testing scenarios where you need
  /// to clean up the overlay system.
  @visibleForTesting
  static void dispose() {
    _instance._dispose();
  }

  /// Disposes of the toast system resources.
  void _dispose() {
    // No cleanup needed currently
  }

  /// Initializes the toast system with a built-in overlay.
  ///
  /// This is used by HzToastInitializer when it creates its own overlay.
  /// No context lookup is needed since the overlay is provided directly.
  static void initializeWithBuiltInOverlay() {
    if (debugMode) {
      debugPrint('🍞 HzToastInitializer Debug: Toast system initialized with built-in overlay');
    }
  }
}
