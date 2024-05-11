import 'package:flutter/material.dart';
import 'package:riverpod_template/gen/assets.gen.dart';
import 'package:riverpod_template/presentation/widgets/primary_button.dart';
import 'package:riverpod_template/theme/colors/light_app_colors.dart';
import 'package:riverpod_template/theme/helpers/app_icons_helper.dart';

class ContinueWithButton extends StatelessWidget {
  final String? iconPath;
  final String? text;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final bool isLoading;

  const ContinueWithButton({
    super.key,
    this.iconPath,
    this.text,
    this.onPressed,
    this.isDisabled = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) => PrimaryButton(
        onPressed: onPressed,
        isDisabled: isDisabled,
        isLoading: isLoading,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            children: [
              AppIcons.icon(
                iconPath ?? Assets.icons.appIcon,
                size: 12,
                color: lightAppColors.primary500,
              ),
              if (text != null) const SizedBox(width: 8),
              if (text != null)
                Text(
                  text!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: lightAppColors.primary500,
                        height: 1.2,
                        letterSpacing: 1.92,
                      ),
                ),
            ],
          ),
        ),
      );
}
