import 'package:flutter/material.dart';
import 'package:shefa/core/theme/color_app.dart';
import 'package:shefa/core/widgets/shefa_branded_text_loader.dart';
import 'package:shefa/core/widgets/shefa_circular_loader.dart';
import 'package:shefa/l10n/app_localizations.dart';

class LoadingRingPreviewScreen extends StatelessWidget {
  static const String routeName = 'LoadingRingPreviewScreen';

  const LoadingRingPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final muted = Theme.of(context).textTheme.bodyMedium?.color?.withValues(
          alpha: 0.72,
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.loadingRingPreviewTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 8,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: const ShefaBrandedTextLoader(
                      arabicFontSize: 56,
                      duration: Duration(milliseconds: 2600),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  l10n.loadingRingPreviewBrandedCaption,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : ColorApp.icons,
                      ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.loadingRingPreviewHint,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: muted,
                        height: 1.5,
                      ),
                ),
                const SizedBox(height: 36),
                Text(
                  l10n.loadingRingPreviewClassicCaption,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: muted,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 16),
                ShefaCircularLoader(
                  size: 48,
                  strokeWidth: 3.5,
                  color: ColorApp.primary,
                  duration: const Duration(milliseconds: 1500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
