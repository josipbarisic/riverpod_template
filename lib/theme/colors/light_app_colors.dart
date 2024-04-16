import 'package:flutter/material.dart';
import 'package:riverpod_template/theme/colors/app_colors.dart';

final lightAppColors = LightAppColors();

class LightAppColors extends AppColors {
  @override
  Color get primary100 => const Color(0xFF013577);

  @override
  Color get primary200 => const Color(0xCC013577);

  @override
  Color get primary300 => const Color(0xAA013577);

  @override
  Color get primary400 => const Color(0x88013577);

  @override
  Color get primary500 => const Color(0x66013577);

  @override
  Color get primary600 => const Color(0x44013577);

  @override
  Color get primaryDark => const Color(0xFF001D4D);

  @override
  Color get backgroundColor => const Color(0xFFF0F5F0);

  @override
  Color get error => const Color(0xFFa32638);
}
