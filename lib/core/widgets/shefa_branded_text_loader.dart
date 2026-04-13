import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shefa/core/manager/app_state_manager.dart';
import 'package:shefa/core/theme/color_app.dart';

/// Brand shimmer loader: primary line follows app language (شفاء vs Shefa).
class ShefaBrandedTextLoader extends StatefulWidget {
  const ShefaBrandedTextLoader({
    super.key,
    this.arabicWord = 'شفاء',
    this.latinWord = 'Shefa',
    this.arabicFontSize = 52,
    this.duration = const Duration(milliseconds: 2400),
    this.showDots = true,
  });

  final String arabicWord;
  final String latinWord;
  final double arabicFontSize;
  final Duration duration;
  final bool showDots;

  @override
  State<ShefaBrandedTextLoader> createState() => _ShefaBrandedTextLoaderState();
}

class _ShefaBrandedTextLoaderState extends State<ShefaBrandedTextLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant ShefaBrandedTextLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _c.duration = widget.duration;
      if (_c.isAnimating) _c.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appStateManager,
      builder: (context, _) {
        final isArabic = appStateManager.isArabic;
        final primarySemantics = isArabic
            ? widget.arabicWord
            : widget.latinWord;

        return Semantics(
          label: primarySemantics,
          hint: 'Loading',
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, child) {
              final t = _c.value;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isArabic) ...[
                    _ShimmerWord(
                      text: widget.arabicWord,
                      fontSize: widget.arabicFontSize,
                      fontWeight: FontWeight.w800,
                      phase: t,
                      fontFamily: 'AmiriQuran',
                    ),
                  ] else ...[
                    _ShimmerWord(
                      text: widget.latinWord.toUpperCase(),
                      fontSize: widget.arabicFontSize * 0.92,
                      fontWeight: FontWeight.w800,
                      phase: t,
                      letterSpacing: 5,
                      height: 1.05,
                      fontFamily: 'PermanentMarker',
                    ),
                  ],
                  if (widget.showDots) ...[
                    const SizedBox(height: 22),
                    _BrandDots(progress: t),
                  ],
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _ShimmerWord extends StatelessWidget {
  const _ShimmerWord({
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    required this.phase,
    this.letterSpacing = 0,
    this.height,
    this.fontFamily,
  });

  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final double phase;
  final double letterSpacing;
  final double? height;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    final baseStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: Colors.white,
      fontFamily: fontFamily,
    );

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        final shift = -1.15 + 2.3 * phase;
        return LinearGradient(
          begin: Alignment(shift, -0.35),
          end: Alignment(shift + 1.4, 0.35),
          colors: [
            ColorApp.primary.withValues(alpha: 0.55),
            ColorApp.primary,
            ColorApp.secondary,
            Colors.white.withValues(alpha: 0.92),
            ColorApp.textFieldHighlight,
            ColorApp.secondary,
            ColorApp.primary,
            ColorApp.primary.withValues(alpha: 0.55),
          ],
          stops: const [0.0, 0.12, 0.28, 0.42, 0.5, 0.58, 0.78, 1.0],
        ).createShader(bounds);
      },
      child: Text(text, textAlign: TextAlign.center, style: baseStyle),
    );
  }
}

class _BrandDots extends StatelessWidget {
  const _BrandDots({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final wave = math.sin(progress * 2 * math.pi + i * 0.65);
        final scale = 0.55 + 0.45 * (0.5 + 0.5 * wave);
        final glow = 0.35 + 0.35 * (0.5 + 0.5 * wave);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.lerp(ColorApp.primary, ColorApp.secondary, glow),
                boxShadow: [
                  BoxShadow(
                    color: ColorApp.secondary.withValues(alpha: 0.55 * glow),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
