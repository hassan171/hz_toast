import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hz_toast/hz_toast.dart';

void main() {
  group('HzToast', () {
    setUp(() {
      // Clear any existing toasts before each test by directly setting the list
      HzToast.toasts.value = [];
    });

    test('should show toast and add to list', () {
      final toast = HzToastData('Test message');
      final result = HzToast.show(toast);

      expect(result, true);
      expect(HzToast.toasts.value.length, 1);
      expect(HzToast.toasts.value.first.message, 'Test message');
    });

    test('should not show duplicate toast with same ID', () {
      final toast1 = HzToastData('Test message', id: 'test-id');
      final toast2 = HzToastData('Another message', id: 'test-id');

      final result1 = HzToast.show(toast1);
      final result2 = HzToast.show(toast2);

      expect(result1, true);
      expect(result2, false);
      expect(HzToast.toasts.value.length, 1);
    });

    test('should check if toast exists', () {
      final toast = HzToastData('Test message', id: 'test-id');

      expect(HzToast.exists('test-id'), false);
      HzToast.show(toast);
      expect(HzToast.exists('test-id'), true);
    });

    test('should update existing toast', () {
      final toast = HzToastData('Original message', id: 'test-id');
      final updatedToast = HzToastData('Updated message', type: HzToastType.success);

      HzToast.show(toast);
      final updateResult = HzToast.update('test-id', updatedToast);

      expect(updateResult, true);
      expect(HzToast.toasts.value.first.message, 'Updated message');
      expect(HzToast.toasts.value.first.type, HzToastType.success);
      expect(HzToast.toasts.value.first.id, 'test-id'); // ID should remain the same
    });

    test('should not update non-existing toast', () {
      final updatedToast = HzToastData('Updated message');
      final updateResult = HzToast.update('non-existing-id', updatedToast);

      expect(updateResult, false);
    });
  });

  group('HzToastData', () {
    test('should create with default values', () {
      final toast = HzToastData('Test message');

      expect(toast.message, 'Test message');
      expect(toast.type, HzToastType.error);
      expect(toast.duration, Duration(seconds: 4));
      expect(toast.clickable, true);
      expect(toast.autoHide, true);
      expect(toast.maxWidth, 0.8);
      expect(toast.showIcon, true);
      expect(toast.showCloseIcon, true);
      expect(toast.showProgressBar, false);
    });

    test('should create with custom values', () {
      final toast = HzToastData(
        'Custom message',
        type: HzToastType.success,
        duration: Duration(seconds: 10),
        clickable: false,
        autoHide: false,
        maxWidth: 0.9,
        showProgressBar: true,
      );

      expect(toast.message, 'Custom message');
      expect(toast.type, HzToastType.success);
      expect(toast.duration, Duration(seconds: 10));
      expect(toast.clickable, false);
      expect(toast.autoHide, false);
      expect(toast.maxWidth, 0.9);
      expect(toast.showProgressBar, true);
    });

    test('should copy with updated values', () {
      final original = HzToastData('Original message');
      final copied = original.copyWith(
        message: 'Updated message',
        type: HzToastType.warning,
      );

      expect(copied.message, 'Updated message');
      expect(copied.type, HzToastType.warning);
      expect(copied.id, original.id); // ID should remain the same
      expect(copied.duration, original.duration); // Unchanged values should remain
    });
  });

  group('HzToastType', () {
    test('should have correct default colors', () {
      expect(HzToastType.error.iconColor, Colors.red);
      expect(HzToastType.success.iconColor, Colors.green);
      expect(HzToastType.warning.iconColor, Colors.orange);
      expect(HzToastType.info.iconColor, Colors.blue);
    });

    test('should have correct default icons', () {
      expect(HzToastType.error.defaultIcon, Icons.error);
      expect(HzToastType.success.defaultIcon, Icons.check_circle);
      expect(HzToastType.warning.defaultIcon, Icons.warning);
      expect(HzToastType.info.defaultIcon, Icons.info);
    });
  });
}
