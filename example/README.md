# Hz Toast Example

This example demonstrates how to use the `hz_toast` package in a Flutter application.

## Features Demonstrated

- Basic toast types (success, error, warning, info)
- Toast with progress bars
- Dynamic toast updates with live progress
- Custom styled toasts
- Interactive toasts with tap handlers

## Running the Example

1. Make sure you have Flutter installed
2. Clone the repository:
   ```bash
   git clone https://github.com/hassan171/hz_toast.git
   cd hz_toast/example
   ```
3. Get dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Key Implementation

The main setup is in `lib/main.dart` where we add the `HzToastWidget` to the app's overlay:

```dart
builder: (context, child) {
  return Material(
    child: Overlay(
      initialEntries: [
        OverlayEntry(builder: (context) => child!),
        OverlayEntry(builder: (context) => const HzToastWidget()),
      ],
    ),
  );
},
```

Then you can show toasts from anywhere in your app:

```dart
HzToast.show(HzToastData(
  'Your message here',
  type: HzToastType.success,
));
```

For more details, see the [main package documentation](https://pub.dev/packages/hz_toast).
