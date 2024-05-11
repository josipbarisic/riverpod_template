import 'package:flutter/material.dart';
import 'package:riverpod_template/theme/colors/light_app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.isDisabled = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: isDisabled ? null : onPressed,
        child: Container(
          height: 44,
          constraints: const BoxConstraints(
            maxHeight: 50,
            minHeight: 44,
          ),
          decoration: BoxDecoration(
            color: isDisabled ? lightAppColors.primaryDark : lightAppColors.primary500,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: isLoading
                ? Padding(
                    padding: const EdgeInsets.all(8),
                    child: CircularProgressIndicator(
                      color: lightAppColors.primary300,
                    ),
                  )
                : child ??
                    Text(
                      (text ?? 'Button').toUpperCase(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: lightAppColors.primary600,
                            letterSpacing: 1.92,
                          ),
                    ),
          ),
        ),
      );
}
