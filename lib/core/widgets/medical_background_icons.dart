import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/color_app.dart';

class MedicalIconsBackground extends StatelessWidget {
  const MedicalIconsBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark
        ? Colors.white.withOpacity(0.04)
        : ColorApp.icons.withOpacity(0.06);

    final List<IconData> medicalIcons = [
      Iconsax.health,
      Iconsax.hospital,
      Iconsax.status,
      Iconsax.heart,
      Iconsax.mask,
      Iconsax.monitor,
      Iconsax.microscope,
      Iconsax.clipboard_text,
      Iconsax.activity,
      Iconsax.add_square,
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final List<Widget> backgroundIcons = [];
        final random = math.Random(42); // Fixed seed for consistent layout

        const double iconSize = 35;
        const double spacing = 100;

        for (double y = 0; y < constraints.maxHeight; y += spacing) {
          for (double x = 0; x < constraints.maxWidth; x += spacing) {
            final icon = medicalIcons[random.nextInt(medicalIcons.length)];
            // Add some "random" drift and rotation
            final offsetX = (random.nextDouble() - 0.5) * 40;
            final offsetY = (random.nextDouble() - 0.5) * 40;
            final rotation = (random.nextDouble() - 0.5) * 0.4;

            backgroundIcons.add(
              Positioned(
                left: x + offsetX,
                top: y + offsetY,
                child: Transform.rotate(
                  angle: rotation,
                  child: Icon(
                    icon,
                    size: iconSize + (random.nextDouble() * 10),
                    color: iconColor,
                  ),
                ),
              ),
            );
          }
        }

        return Stack(
          children: backgroundIcons,
        );
      },
    );
  }
}
