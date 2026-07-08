import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// The visual style a [NeuBox] should render as.
enum NeuStyle {
  /// Raised above the surface — the default "resting" look.
  flat,

  /// Pressed into the surface — used for active/selected states.
  concave,

  /// Perfectly flat with no shadow — used to group content quietly.
  none,
}

/// A soft-UI ("neumorphic") container: a surface molded out of the same
/// background color as its parent, using a light shadow (top-left) and a
/// dark shadow (bottom-right) to fake depth without borders or flat
/// material elevation.
class NeuBox extends StatelessWidget {
  const NeuBox({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 20,
    this.style = NeuStyle.flat,
    this.depth = 6.0,
    this.color,
    this.width,
    this.height,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final NeuStyle style;
  final double depth;
  final Color? color;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.surface;
    final radius = BorderRadius.circular(borderRadius);

    if (style == NeuStyle.concave) {
      // Emulate an "inset/pressed" look with a subtle inward gradient
      // (true CSS-style inset shadows aren't available in Flutter).
      return Container(
        width: width,
        height: height,
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.shadowDark.withOpacity(0.35),
              bg,
              AppColors.shadowLight.withOpacity(0.6),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: child,
      );
    }

    if (style == NeuStyle.none) {
      return Container(
        width: width,
        height: height,
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(color: bg, borderRadius: radius),
        child: child,
      );
    }

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark.withOpacity(0.55),
            offset: Offset(depth, depth),
            blurRadius: depth * 2.4,
          ),
          BoxShadow(
            color: AppColors.shadowLight,
            offset: Offset(-depth, -depth),
            blurRadius: depth * 2.4,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// A tappable neumorphic button that visually "presses in" on tap-down
/// and springs back on release, with an optional accent-gradient fill.
class NeuButton extends StatefulWidget {
  const NeuButton({
    super.key,
    required this.child,
    required this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    this.borderRadius = 16,
    this.filled = false,
  });

  final Widget child;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final bool filled;

  @override
  State<NeuButton> createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: widget.padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: widget.filled ? AppColors.accentGradient : null,
            color: widget.filled ? null : AppColors.surface,
            boxShadow: _pressed
                ? []
                : [
                    BoxShadow(
                      color: widget.filled
                          ? AppColors.accentStart.withOpacity(0.35)
                          : AppColors.shadowDark.withOpacity(0.5),
                      offset: const Offset(4, 4),
                      blurRadius: 10,
                    ),
                    BoxShadow(
                      color: widget.filled
                          ? Colors.white.withOpacity(0.4)
                          : AppColors.shadowLight,
                      offset: const Offset(-4, -4),
                      blurRadius: 10,
                    ),
                  ],
          ),
          child: DefaultTextStyle.merge(
            style: TextStyle(
              color: widget.filled ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// A soft-UI search field with a concave (pressed-in) background.
class NeuSearchField extends StatelessWidget {
  const NeuSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hint = 'Search…',
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return NeuBox(
      style: NeuStyle.concave,
      borderRadius: 18,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A pulsing three-dot neumorphic loading indicator, used in place of a
/// plain [CircularProgressIndicator] to stay on-brand with the soft UI.
class NeuLoadingIndicator extends StatefulWidget {
  const NeuLoadingIndicator({super.key, this.size = 16});
  final double size;

  @override
  State<NeuLoadingIndicator> createState() => _NeuLoadingIndicatorState();
}

class _NeuLoadingIndicatorState extends State<NeuLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final t = (_controller.value - (i * 0.2)) % 1.0;
            final scale = 0.5 + 0.5 * (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.scale(
                scale: 0.6 + scale * 0.6,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: const BoxDecoration(
                    gradient: AppColors.accentGradient,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
