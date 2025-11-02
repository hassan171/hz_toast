## 0.0.6

- **Simplified Setup**: Major architectural improvement with `HzToastInitializer` widget
  - **Breaking Change**: `ToastInitializer` renamed to `HzToastInitializer` for better naming consistency
  - **Self-Contained Overlay**: Eliminated "No Overlay widget found" errors by creating built-in overlay
  - **One-Line Setup**: Simply wrap your app with `HzToastInitializer` - no manual overlay configuration needed
  - **Context Independence**: Toast system no longer depends on finding overlay in widget tree
- **Streamlined Architecture**: Merged `HzToastManager` functionality into main `HzToast` singleton
  - Removed complex context-based initialization methods
  - Simplified API with only essential methods: `show()`, `hide()`, `hideAll()`, `clearAll()`
  - Enhanced debug logging system with `HzToast.debugMode` flag
- **Developer Experience**: Significantly reduced setup complexity
  - MaterialApp.builder integration becomes trivial: `builder: (context, child) => HzToastInitializer(child: child!)`
  - Eliminated timing issues with overlay access and context initialization
  - Comprehensive debug logs help troubleshoot any remaining issues
- **Code Cleanup**: Removed unused legacy code and context-dependent methods
  - Cleaned up ~100 lines of legacy overlay management code
  - Updated all documentation and examples to reflect new simplified approach
  - All tests updated and passing with new architecture

## 0.0.5

- **Toast Alignment System**: Added comprehensive alignment support with `HzToastAlignment` enum
  - Four corner positioning: `topLeft`, `topRight`, `bottomLeft`, `bottomRight`
  - Automatic positioning calculations with responsive layouts
  - Helper properties for alignment logic (`isTop`, `isBottom`, `isLeft`, `isRight`)
- **Simplified Architecture**: Refactored from multiple overlay widgets to single `HzToastWidget`
  - Users now only need to add one `HzToastWidget` to handle all alignments
  - Automatic internal management of different toast positions
  - Improved developer experience with simpler setup
- **Enhanced Animation System**: Fixed `hideAll()` method to properly trigger exit animations
  - All toasts now animate out gracefully when dismissed collectively
  - Added `clearAll()` method for testing scenarios requiring immediate cleanup
  - Preserved individual toast animations while improving batch operations
- **Comprehensive Test Suite**: Added extensive unit and widget tests
  - 23+ test cases covering core functionality, alignment system, and edge cases
  - Proper test cleanup and state management
  - Validation of enum properties, toast lifecycle, and error handling
- **License Compliance**: Updated LICENSE file with complete MIT license text
  - Fixed pub.dev OSI-approved license recognition issue
  - Improved package scoring and community accessibility
- **Example Enhancements**: Updated example app to showcase new alignment features
  - Demonstration of all four corner positions
  - Interactive buttons for testing different alignment combinations
  - Simplified overlay setup showing best practices

## 0.0.4

- **Documentation Overhaul**: Added comprehensive inline documentation following Flutter's style guidelines
- **API Documentation**: Detailed documentation for all classes, methods, and properties
- **Code Examples**: Added practical usage examples throughout the codebase
- **Developer Experience**: Improved IDE support with better parameter descriptions and auto-completion
- **Library Documentation**: Enhanced main library file with feature overview and setup instructions
- **Cross-References**: Added proper linking between related classes and methods

## 0.0.3

- Added animated GIF demo to README for better visual showcase
- Improved documentation with visual demonstration of package features

## 0.0.2

- Added repository field to pubspec.yaml for better pub.dev integration
- Improved example documentation and README
- Updated package metadata for better discoverability

## 0.0.1

- Initial release of hz_toast package.
- Added customizable toast notifications with various types and styles.
- Implemented progress toast feature with dynamic updates.
- The example app demonstrates all functionalities of the hz_toast package.
