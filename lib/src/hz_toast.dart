import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hz_toast/src/hz_model.dart';

class HzToast {
  HzToast._privateConstructor();
  static final HzToast _instance = HzToast._privateConstructor();
  factory HzToast() => _instance;

  static final ValueNotifier<List<HzToastData>> _toasts = ValueNotifier([]);
  static ValueNotifier<List<HzToastData>> get toasts => _toasts;

  static final StreamController<String> _toastRemoveController = StreamController.broadcast();
  static Stream<String> get onRemove => _toastRemoveController.stream;

  static bool show(HzToastData toast) {
    if (exists(toast.id)) return false;
    _toasts.value = [..._toasts.value, toast];
    return true;
  }

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

  static bool exists(String id) {
    return _toasts.value.any((t) => t.id == id);
  }

  static void hide(String id) {
    _toastRemoveController.add(id);
  }

  static void hideIn(String id, Duration duration) {
    Future.delayed(duration, () => hide(id));
  }

  static void hideAll() {
    for (final t in _toasts.value) {
      hide(t.id);
    }
  }
}
