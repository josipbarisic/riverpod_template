import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:riverpod_template/theme/colors/light_app_colors.dart';

class VerificationCodeWidget extends HookWidget {
  const VerificationCodeWidget({
    super.key,
    this.orientation = Axis.horizontal,
    this.length = 6,
    this.itemWidth = 40,
    this.itemHeight = 40,
    this.spaceBetweenItems = 8,
    this.borderRadius = 10,
    this.borderWidth = 0.5,
    this.borderColor,
    this.onCompleted,
  });

  final Axis orientation;
  final int length;
  final double itemWidth;
  final double itemHeight;
  final double spaceBetweenItems;
  final double borderRadius;
  final double borderWidth;
  final Color? borderColor;
  final Function(String?)? onCompleted;

  @override
  Widget build(BuildContext context) {
    final List<TextEditingController> textControllers =
        List.generate(length, (index) => useTextEditingController());

    return SingleChildScrollView(
      child: Wrap(
        clipBehavior: Clip.none,
        direction: Axis.horizontal,
        children: List.generate(
          length,
          (index) {
            return Container(
              width: itemWidth,
              height: itemHeight,
              margin: EdgeInsets.only(right: index < length - 1 ? spaceBetweenItems : 0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: borderColor ?? lightAppColors.primary100,
                  width: borderWidth,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Center(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number,
                  controller: textControllers[index],
                  onChanged: (value) {
                    if (value.isNotEmpty && index < length - 1) {
                      FocusScope.of(context).nextFocus();
                    } else if (value.isEmpty && index > 0) {
                      FocusScope.of(context).previousFocus();
                    }

                    if (textControllers[index].text.isNotEmpty &&
                        textControllers.every((controller) => controller.text.isNotEmpty)) {
                      onCompleted
                          ?.call(textControllers.map((controller) => controller.text).join());
                    } else {
                      onCompleted?.call(null);
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
