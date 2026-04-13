import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shefa/core/theme/color_app.dart';

/// Polished indeterminate ring: breathing sweep, soft glow, rotating brand gradient.
class ShefaCircularLoader extends StatefulWidget {
  const ShefaCircularLoader({
    super.key,
    this.size = 56,
    this.strokeWidth = 4,
    this.color,
    this.accentColor,
    this.duration = const Duration(milliseconds: 1500),
    this.showTrack = true,
  });

  final double size;
  final double strokeWidth;
  final Color? color;
  /// Highlight at the arc tip (defaults to app secondary green).
  final Color? accentColor;
  final Duration duration;
  final bool showTrack;

  @override
  State<ShefaCircularLoader> createState() => _ShefaCircularLoaderState();
}

class _ShefaCircularLoaderState extends State<ShefaCircularLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void didUpdateWidget(covariant ShefaCircularLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
      if (_controller.isAnimating) {
        _controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color base =
        widget.color ?? Theme.of(context).colorScheme.primary;
    final Color accent =
        widget.accentColor ?? ColorApp.secondary;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _ShefaRingPainter(
              progress: _controller.value,
              strokeWidth: widget.strokeWidth,
              baseColor: base,
              accentColor: accent,
              showTrack: widget.showTrack,
            ),
          );
        },
      ),
    );
  }
}

class _ShefaRingPainter extends CustomPainter {
  _ShefaRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.baseColor,
    required this.accentColor,
    required this.showTrack,
  });

  /// 0..1
  final double progress;
  final double strokeWidth;
  final Color baseColor;
  final Color accentColor;
  final bool showTrack;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final t = progress;

    // Breathing sweep + steady spin (Material-like indeterminate feel).
    final spin = t * 2 * math.pi * 1.35;
    final breathe = 0.5 + 0.5 * math.sin(t * 2 * math.pi);
    final sweep = math.pi * (0.42 + 0.48 * breathe);
    final startAngle = spin - math.pi / 2;

    if (showTrack) {
      final track = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.0, strokeWidth * 0.75)
        ..color = baseColor.withValues(alpha: 0.07);
      canvas.drawArc(rect, 0, 2 * math.pi, false, track);
    }

    // Soft bloom behind the arc.
    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 7
      ..strokeCap = StrokeCap.round
      ..color = accentColor.withValues(alpha: 0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawArc(rect, startAngle, sweep, false, glow);

    // Rotating sweep gradient around the ring; arc reveals a moving highlight.
    final gradientRotation = spin * 0.85;
    final shader = SweepGradient(
      center: Alignment.center,
      colors: [
        baseColor.withValues(alpha: 0.08),
        baseColor.withValues(alpha: 0.35),
        baseColor,
        accentColor,
        Color.lerp(accentColor, Colors.white, 0.45)!,
        accentColor,
        baseColor,
        baseColor.withValues(alpha: 0.35),
        baseColor.withValues(alpha: 0.08),
      ],
      stops: const [0.0, 0.12, 0.28, 0.42, 0.5, 0.58, 0.72, 0.88, 1.0],
      transform: GradientRotation(gradientRotation),
      tileMode: TileMode.clamp,
    ).createShader(rect);

    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = shader;

    canvas.drawArc(rect, startAngle, sweep, false, arc);

    // Light catch on the leading end of the arc.
    final headLen = math.min(sweep * 0.12, 0.18);
    final headPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.0, strokeWidth * 0.32)
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.5);
    final headStart = startAngle + sweep - headLen;
    canvas.drawArc(rect, headStart, headLen, false, headPaint);
  }

  @override
  bool shouldRepaint(covariant _ShefaRingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.baseColor != baseColor ||
      oldDelegate.accentColor != accentColor ||
      oldDelegate.showTrack != showTrack;
}
