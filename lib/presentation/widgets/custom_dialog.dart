import 'package:flutter/material.dart';
import 'package:riverpod_template/presentation/widgets/primary_button.dart';
import 'package:riverpod_template/presentation/widgets/underlined_text_button.dart';
import 'package:riverpod_template/theme/colors/light_app_colors.dart';
import 'package:riverpod_template/utils/app_strings.dart';

class CustomDialog extends StatelessWidget {
  final String? title;
  final String bodyText;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final String? onCancelText;
  final String? onConfirmText;

  const CustomDialog({
    super.key,
    this.title,
    required this.bodyText,
    this.onCancel,
    this.onConfirm,
    this.onCancelText,
    this.onConfirmText,
  });

  @override
  Widget build(BuildContext context) => Dialog(
        insetPadding: EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (title != null)
                Container(
                  constraints: BoxConstraints(maxWidth: 230),
                  child: Text(
                    title!,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: lightAppColors.primary100,
                          fontSize: 26,
                        ),
                  ),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: 230,
                child: Text(
                  bodyText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: lightAppColors.primary200,
                        height: 1.3,
                      ),
                ),
              ),
              const SizedBox(height: 24),
              Column(
                children: <Widget>[
                  onConfirm != null
                      ? PrimaryButton(
                          text: onConfirmText ?? AppStrings.confirm,
                          onPressed: onConfirm,
                        )
                      : const SizedBox.shrink(),
                  onCancel != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: UnderlinedTextButton(
                            text: onCancelText ?? AppStrings.cancel,
                            onTap: onCancel,
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),
      );
}
