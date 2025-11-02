/// A highly customizable and feature-rich toast notification package for Flutter.
///
/// This library provides a complete solution for displaying toast notifications
/// in Flutter applications with extensive customization options, smooth animations,
/// and interactive features.
///
/// ## Key Features
///
/// - **Multiple Toast Types**: Error, Success, Warning, and Info with predefined color schemes
/// - **Fully Customizable**: Colors, icons, decorations, padding, margins, and more
/// - **Auto-hide with Progress Bar**: Optional progress bar showing remaining time
/// - **Dynamic Updates**: Update toast content while it's displayed
/// - **Responsive**: Adapts to different screen sizes with configurable max width
/// - **Smooth Animations**: Beautiful slide and fade animations
/// - **Interactive**: Clickable toasts with custom tap handlers
/// - **Positioned**: Top-right positioned toasts that stack properly
/// - **Builder Pattern**: Custom builders for title, icons, and close buttons
///
/// ## Basic Usage
///
/// ```dart
/// // Show a simple success toast
/// HzToast.show(HzToastData(
///   'Operation completed successfully!',
///   type: HzToastType.success,
/// ));
///
/// // Show an error toast with custom styling
/// HzToast.show(HzToastData(
///   'Something went wrong!',
///   type: HzToastType.error,
///   duration: Duration(seconds: 5),
///   showProgressBar: true,
/// ));
/// ```
///
/// ## Setup
///
/// Wrap your app with [HzToastInitializer]:
///
/// ```dart
/// MaterialApp(
///   builder: (context, child) {
///     return HzToastInitializer(child: child!);
///   },
///   home: MyHomePage(),
/// )
/// ```
library;

export 'src/hz_toast.dart';
export 'src/hz_model.dart';
export 'src/hz_toast_widget.dart';
export 'src/hz_toast_initializer.dart';
export 'src/hz_type_enum.dart';
export 'src/hz_alignment_enum.dart';
