import 'package:flutter/material.dart';

bool _isSnackbarShowing = false;

/// Mixin that provides snackbar functionality with duplicate prevention.
mixin SnackbarMixin {
  bool get isSnackbarShowing => _isSnackbarShowing;

  /// Shows an info snackbar with the given message.
  /// Prevents duplicate snackbars from being shown.
  void showInfoSnackbar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    EdgeInsets margin = const EdgeInsets.only(bottom: 80),
    Color? backgroundColor,
  }) {
    if (_isSnackbarShowing) return;
    _isSnackbarShowing = true;
    
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text(message),
            duration: duration,
            margin: margin,
            behavior: SnackBarBehavior.floating,
            backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.secondary,
          ),
        )
        .closed
        .then((_) {
          _isSnackbarShowing = false;
        });
  }

  /// Shows an error snackbar with red background.
  void showErrorSnackbar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    EdgeInsets margin = const EdgeInsets.only(bottom: 80),
  }) {
    showInfoSnackbar(
      context,
      message,
      duration: duration,
      margin: margin,
      backgroundColor: Theme.of(context).colorScheme.error,
    );
  }

  /// Shows a success snackbar with green background.
  void showSuccessSnackbar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    EdgeInsets margin = const EdgeInsets.only(bottom: 80),
  }) {
    showInfoSnackbar(
      context,
      message,
      duration: duration,
      margin: margin,
      backgroundColor: Colors.green,
    );
  }
}
