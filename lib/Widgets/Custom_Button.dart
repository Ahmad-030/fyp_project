import 'package:flutter/material.dart';

class CustomGradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final List<Color>? gradientColors;
  final Color? shadowColor;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double shadowBlurRadius;
  final double shadowSpreadRadius;
  final Offset shadowOffset;
  final double iconSize;
  final double spaceBetween;
  final bool enabled;
  final bool showIcon;

  const CustomGradientButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.gradientColors,
    this.shadowColor,
    this.textStyle,
    this.width,
    this.height,
    this.borderRadius = 28.0,
    this.padding,
    this.shadowBlurRadius = 15.0,
    this.shadowSpreadRadius = 2.0,
    this.shadowOffset = const Offset(0, 4),
    this.iconSize = 20.0,
    this.spaceBetween = 8.0,
    this.enabled = true,
    this.showIcon = true, SizedBox? child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Default gradient colors
    final List<Color> defaultGradientColors = gradientColors ?? [
      const Color(0xFF4A90C2),
      const Color(0xFF87CEEB),
    ];

    // Default shadow color
    final Color defaultShadowColor = shadowColor ?? const Color(0xFF4A90C2);

    // Default text style
    final TextStyle defaultTextStyle = textStyle ?? const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      letterSpacing: 1.0,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width ?? double.infinity,
      height: height ?? 56.0,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding ?? EdgeInsets.zero,
          elevation: 0,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: enabled
                ? LinearGradient(colors: defaultGradientColors)
                : LinearGradient(
              colors: [
                Colors.grey.shade400,
                Colors.grey.shade300,
              ],
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: enabled
                ? [
              BoxShadow(
                color: defaultShadowColor.withOpacity(0.4),
                blurRadius: shadowBlurRadius,
                spreadRadius: shadowSpreadRadius,
                offset: shadowOffset,
              ),
            ]
                : [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: shadowBlurRadius * 0.5,
                spreadRadius: shadowSpreadRadius * 0.5,
                offset: shadowOffset,
              ),
            ],
          ),
          child: Container(
            alignment: Alignment.center,
            child: showIcon && icon != null
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: defaultTextStyle.copyWith(
                    color: enabled ? defaultTextStyle.color : Colors.grey.shade600,
                  ),
                ),
                SizedBox(width: spaceBetween),
                Icon(
                  icon,
                  color: enabled ? Colors.white : Colors.grey.shade600,
                  size: iconSize,
                ),
              ],
            )
                : Text(
              text,
              style: defaultTextStyle.copyWith(
                color: enabled ? defaultTextStyle.color : Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}