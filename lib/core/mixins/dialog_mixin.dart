import 'package:flutter/material.dart';
import 'package:riverpod_template/presentation/widgets/custom_dialog.dart';

/// Mixin for showing standard dialogs.
///
/// Usage:
/// ```dart
/// class MyView extends ConsumerWidget with DialogMixin {
///   void _onDeletePressed(BuildContext context) {
///     showConfirmationDialog(
///       context,
///       title: 'Delete Account',
///       bodyText: 'Are you sure you want to delete your account?',
///       onConfirm: () { /* delete */ },
///     );
///   }
/// }
/// ```
mixin DialogMixin {
  void showConfirmationDialog(
    BuildContext context, {
    String? title,
    required String bodyText,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) =>
      showDialog(
        context: context,
        builder: (BuildContext ctx) => CustomDialog(
          title: title,
          bodyText: bodyText,
          onConfirmText: confirmText,
          onConfirm: onConfirm ?? () => Navigator.of(ctx).pop(),
          onCancelText: cancelText,
          onCancel: onCancel ?? () => Navigator.of(ctx).pop(),
        ),
      );
}
