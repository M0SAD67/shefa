import 'package:flutter/material.dart';

void showCustomSnackBar(
  BuildContext context, {
  required String message,
  IconData? icon,
  String? actionLabel,
  VoidCallback? onAction,
  double bottomMargin = 30, // Default lower margin
  bool top = false,
  Duration duration = const Duration(seconds: 3),
  Color? backgroundColor,
  /// How many lines of text before ellipsis (validation errors can be long).
  int maxMessageLines = 6,
}) {
  if (top) {
    _showTopOverlay(
      context,
      message,
      icon,
      duration: duration,
      backgroundColor: backgroundColor,
      maxMessageLines: maxMessageLines,
    );
    return;
  }

  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: _buildSnackBarContent(
        context,
        message,
        icon,
        actionLabel,
        onAction,
        maxMessageLines: maxMessageLines,
      ),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.only(bottom: bottomMargin),
      width: null,
    ),
  );
}

void _showTopOverlay(
  BuildContext context,
  String message,
  IconData? icon, {
  Duration duration = const Duration(seconds: 3),
  Color? backgroundColor,
  int maxMessageLines = 6,
}) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).chatty_padding_top + 16,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: _AnimatedTopSnackbar(
          child: _buildSnackBarContent(
            context,
            message,
            icon,
            null,
            null,
            bgColor: backgroundColor,
            maxMessageLines: maxMessageLines,
          ),
          onDismiss: () => entry.remove(),
          duration: duration,
        ),
      ),
    ),
  );

  overlay.insert(entry);
}

Widget _buildSnackBarContent(
  BuildContext context,
  String message,
  IconData? icon,
  String? actionLabel,
  VoidCallback? onAction, {
  Color? bgColor,
  int maxMessageLines = 6,
}) {
  return Center(
    child: Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.95,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),

            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: Theme.of(context).colorScheme.onSurface,
              size: 20,
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.35,
              ),
              textAlign: TextAlign.start,
              maxLines: maxMessageLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(width: 12),
            Container(
              height: 20,
              width: 1,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

extension on MediaQueryData {
  double get chatty_padding_top => padding.top > 0 ? padding.top : 24;
}

class _AnimatedTopSnackbar extends StatefulWidget {
  final Widget child;
  final VoidCallback onDismiss;
  final Duration duration;

  const _AnimatedTopSnackbar({
    required this.child,
    required this.onDismiss,
    required this.duration,
  });

  @override
  State<_AnimatedTopSnackbar> createState() => _AnimatedTopSnackbarState();
}

class _AnimatedTopSnackbarState extends State<_AnimatedTopSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _offset = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    Future.delayed(widget.duration, () async {
      if (mounted) {
        await _controller.reverse();
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offset,
      child: FadeTransition(opacity: _opacity, child: widget.child),
    );
  }
}
