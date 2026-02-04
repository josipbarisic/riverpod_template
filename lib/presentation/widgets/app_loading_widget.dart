import 'package:flutter/material.dart';

/// A centered loading indicator widget.
class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) => Center(
        child: CircularProgressIndicator(
          color: color,
        ),
      );
}
