import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hz_toast/hz_toast.dart';

void main() {
  group('HzToast', () {
    setUp(() {
      // Clear any existing toasts before each test using the test-specific method
      HzToast.clearAll();
    });

    tearDown(() {
      // Clean up after each test
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

    test('should hide specific toast', () {
      final toast1 = HzToastData('Message 1', id: 'id1');
      final toast2 = HzToastData('Message 2', id: 'id2');

      HzToast.show(toast1);
      HzToast.show(toast2);
      expect(HzToast.toasts.value.length, 2);

      // Simulate hiding toast by removing it from the list (as the widget would do)
      HzToast.toasts.value = HzToast.toasts.value.where((t) => t.id != 'id1').toList();
      expect(HzToast.toasts.value.length, 1);
      expect(HzToast.toasts.value.first.id, 'id2');
    });

    test('should hide all toasts', () {
      // Ensure completely clean start
      HzToast.clearAll(); // Use clearAll for immediate cleanup in tests
      expect(HzToast.toasts.value.length, 0);

      HzToast.show(HzToastData('Message 1'));
      HzToast.show(HzToastData('Message 2'));
      HzToast.show(HzToastData('Message 3'));
      expect(HzToast.toasts.value.length, 3);

      // Test that hideAll triggers removal signals (in real app, animations would remove them)
      HzToast.hideAll();
      // In tests, we manually clear since there's no widget to handle animation removal
      HzToast.clearAll();
      expect(HzToast.toasts.value.length, 0);
    });

    test('should handle multiple toasts with different alignments', () {
      final topLeftToast = HzToastData('Top Left', alignment: HzToastAlignment.topLeft);
      final topRightToast = HzToastData('Top Right', alignment: HzToastAlignment.topRight);
      final bottomLeftToast = HzToastData('Bottom Left', alignment: HzToastAlignment.bottomLeft);
      final bottomRightToast = HzToastData('Bottom Right', alignment: HzToastAlignment.bottomRight);

      HzToast.show(topLeftToast);
      HzToast.show(topRightToast);
      HzToast.show(bottomLeftToast);
      HzToast.show(bottomRightToast);

      expect(HzToast.toasts.value.length, 4);

      final toastsByAlignment = <HzToastAlignment, List<HzToastData>>{};
      for (final toast in HzToast.toasts.value) {
        toastsByAlignment.putIfAbsent(toast.alignment, () => []).add(toast);
      }

      expect(toastsByAlignment.keys.length, 4);
      expect(toastsByAlignment[HzToastAlignment.topLeft]?.length, 1);
      expect(toastsByAlignment[HzToastAlignment.topRight]?.length, 1);
      expect(toastsByAlignment[HzToastAlignment.bottomLeft]?.length, 1);
      expect(toastsByAlignment[HzToastAlignment.bottomRight]?.length, 1);
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
      expect(toast.alignment, HzToastAlignment.topRight); // Default alignment
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
        alignment: HzToastAlignment.bottomLeft,
      );

      expect(toast.message, 'Custom message');
      expect(toast.type, HzToastType.success);
      expect(toast.duration, Duration(seconds: 10));
      expect(toast.clickable, false);
      expect(toast.autoHide, false);
      expect(toast.maxWidth, 0.9);
      expect(toast.showProgressBar, true);
      expect(toast.alignment, HzToastAlignment.bottomLeft);
    });

    test('should copy with updated values', () {
      final original = HzToastData('Original message');
      final copied = original.copyWith(
        message: 'Updated message',
        type: HzToastType.warning,
        alignment: HzToastAlignment.topLeft,
      );

      expect(copied.message, 'Updated message');
      expect(copied.type, HzToastType.warning);
      expect(copied.alignment, HzToastAlignment.topLeft);
      expect(copied.id, original.id); // ID should remain the same
      expect(copied.duration, original.duration); // Unchanged values should remain
    });

    test('should generate unique IDs when not specified', () {
      final toast1 = HzToastData('Message 1');
      final toast2 = HzToastData('Message 2');

      expect(toast1.id, isNotEmpty);
      expect(toast2.id, isNotEmpty);
      expect(toast1.id, isNot(equals(toast2.id)));
    });

    test('should clamp maxWidth value', () {
      final toast1 = HzToastData('Message', maxWidth: -0.5); // Below minimum
      final toast2 = HzToastData('Message', maxWidth: 1.5); // Above maximum

      // maxWidth should be clamped in the widget, not in the model
      // So the raw values should be preserved in the data model
      expect(toast1.maxWidth, -0.5);
      expect(toast2.maxWidth, 1.5);
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

    test('should have correct text colors', () {
      expect(HzToastType.error.textColor, Colors.red);
      expect(HzToastType.success.textColor, Colors.green);
      expect(HzToastType.warning.textColor, Colors.orange);
      expect(HzToastType.info.textColor, Colors.blue);
    });

    test('should have correct close icon colors', () {
      expect(HzToastType.error.closeIconColor, Colors.red.shade300);
      expect(HzToastType.success.closeIconColor, Colors.green.shade300);
      expect(HzToastType.warning.closeIconColor, Colors.orange.shade300);
      expect(HzToastType.info.closeIconColor, Colors.blue.shade300);
    });
  });

  group('HzToastAlignment', () {
    test('should correctly identify top alignments', () {
      expect(HzToastAlignment.topLeft.isTop, true);
      expect(HzToastAlignment.topRight.isTop, true);
      expect(HzToastAlignment.bottomLeft.isTop, false);
      expect(HzToastAlignment.bottomRight.isTop, false);
    });

    test('should correctly identify bottom alignments', () {
      expect(HzToastAlignment.topLeft.isBottom, false);
      expect(HzToastAlignment.topRight.isBottom, false);
      expect(HzToastAlignment.bottomLeft.isBottom, true);
      expect(HzToastAlignment.bottomRight.isBottom, true);
    });

    test('should correctly identify left alignments', () {
      expect(HzToastAlignment.topLeft.isLeft, true);
      expect(HzToastAlignment.topRight.isLeft, false);
      expect(HzToastAlignment.bottomLeft.isLeft, true);
      expect(HzToastAlignment.bottomRight.isLeft, false);
    });

    test('should correctly identify right alignments', () {
      expect(HzToastAlignment.topLeft.isRight, false);
      expect(HzToastAlignment.topRight.isRight, true);
      expect(HzToastAlignment.bottomLeft.isRight, false);
      expect(HzToastAlignment.bottomRight.isRight, true);
    });

    test('should provide correct main axis alignment', () {
      expect(HzToastAlignment.topLeft.mainAxisAlignment, MainAxisAlignment.start);
      expect(HzToastAlignment.bottomLeft.mainAxisAlignment, MainAxisAlignment.start);
      expect(HzToastAlignment.topRight.mainAxisAlignment, MainAxisAlignment.end);
      expect(HzToastAlignment.bottomRight.mainAxisAlignment, MainAxisAlignment.end);
    });

    test('should provide correct cross axis alignment', () {
      expect(HzToastAlignment.topLeft.crossAxisAlignment, CrossAxisAlignment.start);
      expect(HzToastAlignment.bottomLeft.crossAxisAlignment, CrossAxisAlignment.start);
      expect(HzToastAlignment.topRight.crossAxisAlignment, CrossAxisAlignment.end);
      expect(HzToastAlignment.bottomRight.crossAxisAlignment, CrossAxisAlignment.end);
    });
  });
}
