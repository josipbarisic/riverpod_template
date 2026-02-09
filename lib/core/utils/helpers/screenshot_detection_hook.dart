import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:no_screenshot/screenshot_snapshot.dart';

NoScreenshot get _screenshotManager => NoScreenshot.instance;

Stream<ScreenshotSnapshot> get _screenshotStream => _screenshotManager.screenshotStream;

/// Hook that detects screenshots and calls [onScreenshotDetected].
///
/// Usage:
/// ```dart
/// class SensitiveView extends HookWidget {
///   @override
///   Widget build(BuildContext context) {
///     useScreenshotDetection(
///       context,
///       onScreenshotDetected: () {
///         showInfoSnackbar(context, 'Screenshots are not allowed on this screen.');
///       },
///     );
///     return const Scaffold(...);
///   }
/// }
/// ```
void useScreenshotDetection(
  BuildContext context, {
  required VoidCallback onScreenshotDetected,
}) =>
    useEffect(() {
      StreamSubscription<ScreenshotSnapshot>? subscription;

      _screenshotManager
          .startScreenshotListening()
          .then<void>(
            (_) => subscription = _screenshotStream.listen((snapshot) {
              if (context.mounted && snapshot.wasScreenshotTaken) {
                onScreenshotDetected();
              }
            }),
          )
          .catchError(
            (Object error, StackTrace st) => log(
              'Error starting screenshot listener: ',
              error: error,
              stackTrace: st,
            ),
          );

      return () {
        subscription?.cancel();
        _screenshotManager.stopScreenshotListening();
      };
    }, const []);
