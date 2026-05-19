import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgCacheLoader {
  SvgCacheLoader._();

  static final SvgCacheLoader instance = SvgCacheLoader._();

  Widget getSvg(
    String asset, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
  }) {
    return SvgPicture.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
    );
  }

  /// Lightweight asset check to confirm the SVG exists and is readable.
  Future<bool> precache(BuildContext context, String asset) async {
    try {
      await rootBundle.load(asset);
      return true;
    } catch (e) {
      debugPrint('[SvgCacheLoader] Failed: $asset');
      debugPrint('[SvgCacheLoader] Error: $e');
      return false;
    }
  }

  void clearCache() {
    // no-op: SvgPicture.asset handles internal caching
  }
}