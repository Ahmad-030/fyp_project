import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChanged;
  final Function()? onTap;
  final bool readOnly;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final List<Color>? gradientColors;
  final double borderRadius;
  final double borderWidth;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final bool showShadow;
  final double shadowBlurRadius;
  final double shadowSpreadRadius;
  final Offset shadowOffset;
  final Color? shadowColor;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.hintText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.contentPadding,
    this.fillColor,
    this.gradientColors,
    this.borderRadius = 15.0,
    this.borderWidth = 1.0,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.textStyle,
    this.labelStyle,
    this.hintStyle,
    this.showShadow = true,
    this.shadowBlurRadius = 10.0,
    this.shadowSpreadRadius = 0.0,
    this.shadowOffset = const Offset(0, 4),
    this.shadowColor,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with TickerProviderStateMixin {
  bool _isPasswordVisible = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  bool _isFocused = false;

  // Default theme colors matching your app theme
  List<Color> get _defaultGradientColors => [
    const Color(0xFF1E3A8A), // Deep blue
    const Color(0xFF3B82F6), // Blue
    const Color(0xFF6366F1), // Indigo
  ];

  Color get _defaultBorderColor => const Color(0xFF4F46E5).withOpacity(0.3);
  Color get _defaultFocusedBorderColor => const Color(0xFF6366F1);
  Color get _defaultErrorBorderColor => const Color(0xFFEF4444);
  Color get _defaultShadowColor => const Color(0xFF4F46E5).withOpacity(0.2);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: _defaultBorderColor,
      end: _defaultFocusedBorderColor,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleFocusChange(bool hasFocus) {
    setState(() {
      _isFocused = hasFocus;
    });

    if (hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
            child: Text(
              widget.label,
              style: widget.labelStyle ??
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
            ),
          ),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  gradient: widget.gradientColors != null
                      ? LinearGradient(
                    colors: widget.gradientColors!,
                  )
                      : LinearGradient(
                    colors: _defaultGradientColors.map((c) => c.withOpacity(0.1)).toList(),
                  ),
                  boxShadow: widget.showShadow
                      ? [
                    BoxShadow(
                      color: widget.shadowColor ?? _defaultShadowColor,
                      blurRadius: widget.shadowBlurRadius,
                      spreadRadius: widget.shadowSpreadRadius,
                      offset: widget.shadowOffset,
                    ),
                  ]
                      : null,
                ),
                child: TextFormField(
                  controller: widget.controller,
                  obscureText: widget.isPassword && !_isPasswordVisible,
                  keyboardType: widget.keyboardType,
                  validator: widget.validator,
                  enabled: widget.enabled,
                  maxLines: widget.maxLines,
                  inputFormatters: widget.inputFormatters,
                  onChanged: widget.onChanged,
                  onTap: widget.onTap,
                  readOnly: widget.readOnly,
                  focusNode: widget.focusNode,
                  textCapitalization: widget.textCapitalization,
                  style: widget.textStyle ??
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: widget.hintStyle ??
                        TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                    prefixIcon: widget.prefixIcon,
                    suffixIcon: widget.isPassword
                        ? IconButton(
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          key: ValueKey(_isPasswordVisible),
                          color: _isFocused
                              ? _defaultFocusedBorderColor
                              : Colors.white.withOpacity(0.7),
                          size: 22,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    )
                        : widget.suffixIcon,
                    contentPadding: widget.contentPadding ??
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    fillColor: widget.fillColor ?? Colors.transparent,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide(
                        color: widget.borderColor ?? _defaultBorderColor,
                        width: widget.borderWidth,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide(
                        color: widget.borderColor ?? _defaultBorderColor,
                        width: widget.borderWidth,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide(
                        color: _colorAnimation.value ?? _defaultFocusedBorderColor,
                        width: widget.borderWidth + 0.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide(
                        color: widget.errorBorderColor ?? _defaultErrorBorderColor,
                        width: widget.borderWidth,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide(
                        color: widget.errorBorderColor ?? _defaultErrorBorderColor,
                        width: widget.borderWidth + 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}