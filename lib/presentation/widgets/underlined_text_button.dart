import 'package:flutter/material.dart';
import 'package:riverpod_template/theme/colors/light_app_colors.dart';

class UnderlinedTextButton extends StatelessWidget {
  const UnderlinedTextButton({
    super.key,
    required this.text,
    this.onTap,
    this.textColor,
  });

  final String text;
  final Function()? onTap;
  final Color? textColor;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(left: 6, top: 6, bottom: 6),
          child: Stack(
            children: [
              Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: textColor ?? lightAppColors.primary300,
                    ),
              ),
              Positioned(
                bottom: 2.8,
                child: Container(
                  color: textColor ?? lightAppColors.primary600,
                  height: 1,
                  width: text.length * 10,
                ),
              ),
            ],
          ),
        ),
      );
}
