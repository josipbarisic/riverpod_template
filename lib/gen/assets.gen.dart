// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/Manrope-Bold.ttf
  String get manropeBold => 'assets/fonts/Manrope-Bold.ttf';

  /// File path: assets/fonts/Manrope-ExtraBold.ttf
  String get manropeExtraBold => 'assets/fonts/Manrope-ExtraBold.ttf';

  /// File path: assets/fonts/Manrope-ExtraLight.ttf
  String get manropeExtraLight => 'assets/fonts/Manrope-ExtraLight.ttf';

  /// File path: assets/fonts/Manrope-Light.ttf
  String get manropeLight => 'assets/fonts/Manrope-Light.ttf';

  /// File path: assets/fonts/Manrope-Medium.ttf
  String get manropeMedium => 'assets/fonts/Manrope-Medium.ttf';

  /// File path: assets/fonts/Manrope-Regular.ttf
  String get manropeRegular => 'assets/fonts/Manrope-Regular.ttf';

  /// File path: assets/fonts/Manrope-SemiBold.ttf
  String get manropeSemiBold => 'assets/fonts/Manrope-SemiBold.ttf';

  /// List of all assets
  List<String> get values => [
    manropeBold,
    manropeExtraBold,
    manropeExtraLight,
    manropeLight,
    manropeMedium,
    manropeRegular,
    manropeSemiBold,
  ];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/app_icon.svg
  String get appIcon => 'assets/icons/app_icon.svg';

  /// File path: assets/icons/cinnamon_logo.svg
  String get cinnamonLogo => 'assets/icons/cinnamon_logo.svg';

  /// File path: assets/icons/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/icons/logo.png');

  /// File path: assets/icons/social_apple.svg
  String get socialApple => 'assets/icons/social_apple.svg';

  /// File path: assets/icons/social_email.svg
  String get socialEmail => 'assets/icons/social_email.svg';

  /// File path: assets/icons/social_facebook.svg
  String get socialFacebook => 'assets/icons/social_facebook.svg';

  /// File path: assets/icons/social_google.svg
  String get socialGoogle => 'assets/icons/social_google.svg';

  /// List of all assets
  List<dynamic> get values => [
    appIcon,
    cinnamonLogo,
    logo,
    socialApple,
    socialEmail,
    socialFacebook,
    socialGoogle,
  ];
}

class Assets {
  const Assets._();

  static const String aEnv = '.env';
  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();

  /// List of all assets
  static List<String> get values => [aEnv];
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
