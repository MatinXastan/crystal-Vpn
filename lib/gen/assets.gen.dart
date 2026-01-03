/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/background.png
  AssetGenImage get background =>
      const AssetGenImage('assets/images/background.png');

  /// Directory path: assets/images/backgrounds
  $AssetsImagesBackgroundsGen get backgrounds =>
      const $AssetsImagesBackgroundsGen();

  /// Directory path: assets/images/connectButtons
  $AssetsImagesConnectButtonsGen get connectButtons =>
      const $AssetsImagesConnectButtonsGen();

  /// Directory path: assets/images/lottiefiles
  $AssetsImagesLottiefilesGen get lottiefiles =>
      const $AssetsImagesLottiefilesGen();

  /// File path: assets/images/play_blue.png
  AssetGenImage get playBlue =>
      const AssetGenImage('assets/images/play_blue.png');

  /// File path: assets/images/play_red.png
  AssetGenImage get playRed =>
      const AssetGenImage('assets/images/play_red.png');

  /// File path: assets/images/play_yellow.png
  AssetGenImage get playYellow =>
      const AssetGenImage('assets/images/play_yellow.png');

  /// File path: assets/images/stop_green.png
  AssetGenImage get stopGreen =>
      const AssetGenImage('assets/images/stop_green.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [background, playBlue, playRed, playYellow, stopGreen];
}

class $AssetsVideoGen {
  const $AssetsVideoGen();

  /// File path: assets/video/vpn_interdouce.mp4
  String get vpnInterdouce => 'assets/video/vpn_interdouce.mp4';

  /// List of all assets
  List<String> get values => [vpnInterdouce];
}

class $AssetsImagesBackgroundsGen {
  const $AssetsImagesBackgroundsGen();

  /// File path: assets/images/backgrounds/blue_background.png
  AssetGenImage get blueBackground =>
      const AssetGenImage('assets/images/backgrounds/blue_background.png');

  /// File path: assets/images/backgrounds/green_background.png
  AssetGenImage get greenBackground =>
      const AssetGenImage('assets/images/backgrounds/green_background.png');

  /// File path: assets/images/backgrounds/pink_background.png
  AssetGenImage get pinkBackground =>
      const AssetGenImage('assets/images/backgrounds/pink_background.png');

  /// File path: assets/images/backgrounds/red_background.png
  AssetGenImage get redBackground =>
      const AssetGenImage('assets/images/backgrounds/red_background.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [blueBackground, greenBackground, pinkBackground, redBackground];
}

class $AssetsImagesConnectButtonsGen {
  const $AssetsImagesConnectButtonsGen();

  /// File path: assets/images/connectButtons/blue.png
  AssetGenImage get blue =>
      const AssetGenImage('assets/images/connectButtons/blue.png');

  /// File path: assets/images/connectButtons/green.png
  AssetGenImage get green =>
      const AssetGenImage('assets/images/connectButtons/green.png');

  /// File path: assets/images/connectButtons/red.png
  AssetGenImage get red =>
      const AssetGenImage('assets/images/connectButtons/red.png');

  /// File path: assets/images/connectButtons/yellow.png
  AssetGenImage get yellow =>
      const AssetGenImage('assets/images/connectButtons/yellow.png');

  /// List of all assets
  List<AssetGenImage> get values => [blue, green, red, yellow];
}

class $AssetsImagesLottiefilesGen {
  const $AssetsImagesLottiefilesGen();

  /// File path: assets/images/lottiefiles/empty.json
  String get empty => 'assets/images/lottiefiles/empty.json';

  /// File path: assets/images/lottiefiles/error.json
  String get error => 'assets/images/lottiefiles/error.json';

  /// File path: assets/images/lottiefiles/loading.json
  String get loading => 'assets/images/lottiefiles/loading.json';

  /// List of all assets
  List<String> get values => [empty, error, loading];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const AssetGenImage luncherIcon =
      AssetGenImage('assets/luncher_icon.png');
  static const $AssetsVideoGen video = $AssetsVideoGen();

  /// List of all assets
  static List<AssetGenImage> get values => [luncherIcon];
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

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

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
