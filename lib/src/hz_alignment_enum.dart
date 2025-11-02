import 'package:flutter/material.dart';

/// Defines the positioning of toast notifications on the screen.
///
/// This enum determines where toasts will appear and how they stack
/// relative to each other.
enum HzToastAlignment {
  /// Toasts appear in the top-left corner of the screen.
  ///
  /// New toasts stack vertically downward from the top-left position.
  topLeft,

  /// Toasts appear in the top-right corner of the screen.
  ///
  /// New toasts stack vertically downward from the top-right position.
  /// This is the default alignment for backward compatibility.
  topRight,

  /// Toasts appear in the bottom-left corner of the screen.
  ///
  /// New toasts stack vertically upward from the bottom-left position.
  bottomLeft,

  /// Toasts appear in the bottom-right corner of the screen.
  ///
  /// New toasts stack vertically upward from the bottom-right position.
  bottomRight;

  /// Whether this alignment positions toasts at the top of the screen.
  ///
  /// Returns true for [topLeft] and [topRight], false for bottom alignments.
  bool get isTop => this == HzToastAlignment.topLeft || this == HzToastAlignment.topRight;

  /// Whether this alignment positions toasts at the bottom of the screen.
  ///
  /// Returns true for [bottomLeft] and [bottomRight], false for top alignments.
  bool get isBottom => !isTop;

  /// Whether this alignment positions toasts on the left side of the screen.
  ///
  /// Returns true for [topLeft] and [bottomLeft], false for right alignments.
  bool get isLeft => this == HzToastAlignment.topLeft || this == HzToastAlignment.bottomLeft;

  /// Whether this alignment positions toasts on the right side of the screen.
  ///
  /// Returns true for [topRight] and [bottomRight], false for left alignments.
  bool get isRight => !isLeft;

  /// The main axis alignment for positioning toasts horizontally.
  ///
  /// Returns [MainAxisAlignment.start] for left alignments and
  /// [MainAxisAlignment.end] for right alignments.
  MainAxisAlignment get mainAxisAlignment => isLeft ? MainAxisAlignment.start : MainAxisAlignment.end;

  /// The cross axis alignment for positioning toasts in their stack.
  ///
  /// Returns [CrossAxisAlignment.start] for left alignments and
  /// [CrossAxisAlignment.end] for right alignments.
  CrossAxisAlignment get crossAxisAlignment => isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end;
}
