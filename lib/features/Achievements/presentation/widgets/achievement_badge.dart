import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Achievements/presentation/widgets/achievement_badge_mapper.dart';
import 'achievement_badge_fallback.dart';

/// Reusable achievement badge widget.
/// - Uses the [AchievementBadgeMapper] to resolve asset paths.
/// - Loads SVGs via SvgPicture.asset for stability.
/// - Supports locked/unlocked states (visual desaturation and a small lock indicator).
/// - Smooth unlock animation.
class AchievementBadge extends StatefulWidget {
  final String achievementId;
  final bool unlocked;
  final double size;
  final VoidCallback? onTap;

  const AchievementBadge({
    super.key,
    required this.achievementId,
    this.unlocked = false,
    this.size = 48,
    this.onTap,
  });

  @override
  State<AchievementBadge> createState() => _AchievementBadgeState();
}

class _AchievementBadgeState extends State<AchievementBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  String? _resolvedAsset;
  bool _resolving = false;
  String? _fallbackReason;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // If the badge starts unlocked, show the animation once.
    if (widget.unlocked) {
      _playUnlock();
    }

    // Resolve the best asset candidate for this badge.
    _resolveAsset();
  }

  @override
  void didUpdateWidget(covariant AchievementBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.unlocked && widget.unlocked) {
      _playUnlock();
    }

    // If the badge id changed or locked state changed, re-resolve candidates.
    if (oldWidget.achievementId != widget.achievementId || oldWidget.unlocked != widget.unlocked) {
      _resolveAsset();
    }
  }

  void _playUnlock() async {
    try {
      await _controller.forward(from: 0.0);
      await _controller.reverse();
    } catch (_) {}
  }

  Future<void> _resolveAsset() async {
    final id = widget.achievementId;
    final preferLocked = !widget.unlocked;

    setState(() {
      _resolving = true;
      _resolvedAsset = null;
      _fallbackReason = null;
    });

    final candidates = AchievementBadgeMapper.assetCandidatesFor(id, preferLockedVariant: preferLocked);
    AchievementBadgeMapper.debugLog('Resolving asset for id="$id"; preferLocked=$preferLocked');

    for (final candidate in candidates) {
      try {
        final ok = await _assetExists(candidate);
        if (ok) {
          AchievementBadgeMapper.debugLog('SVG found for id="$id" -> $candidate');
          if (!mounted) return;
          setState(() {
            _resolvedAsset = candidate;
            _resolving = false;
          });
          return;
        }
      } catch (e, st) {
        AchievementBadgeMapper.debugLog('SVG load failed for $candidate: $e\n$st');
      }
    }

    // Nothing found — stay with null so build shows minimal fallback.
    AchievementBadgeMapper.debugLog('No SVG asset resolved for id="$id"; fallback rendered');
    if (!mounted) return;
    setState(() {
      _resolvedAsset = null;
      _resolving = false;
      _fallbackReason = 'Asset not found';
    });
  }

  Future<bool> _assetExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool locked = !widget.unlocked;

    Widget child;
    final assetToUse = _resolvedAsset;
    if (assetToUse != null) {
      child = SvgPicture.asset(
        assetToUse,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.contain,
        semanticsLabel: widget.achievementId,
      );
    } else if (_resolving) {
      child = const SizedBox.shrink();
    } else {
      if (_fallbackReason != null) {
        AchievementBadgeMapper.debugLog(
          'Fallback for id="${widget.achievementId}": $_fallbackReason',
        );
      }
      child = AchievementBadgeFallback(size: widget.size);
    }

    // Locked state visual: desaturate + dim
    if (locked) {
      child = ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126, 0.7152, 0.0722, 0, 0, // R
          0.2126, 0.7152, 0.0722, 0, 0, // G
          0.2126, 0.7152, 0.0722, 0, 0, // B
          0, 0, 0, 1, 0, // A
        ]),
        child: Opacity(opacity: 0.65, child: child),
      );
    }

    // Wrap with animated scale for unlock pulse
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final scale = 1.0 + (_controller.value * 0.12);
          final rotation = _controller.value * 0.03; // subtle rotation
          return Transform.rotate(
            angle: rotation,
            child: Transform.scale(
              scale: scale,
              child: SizedBox(
                width: widget.size,
                height: widget.size,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    child,
                    if (locked)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: widget.size * 0.28,
                          height: widget.size * 0.28,
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(160),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.lock_rounded,
                            size: widget.size * 0.16,
                            color: Colors.white.withAlpha(230),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
