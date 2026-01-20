import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_dimensions.dart';

/// A styled text field widget with Cupertino style.
class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool enabled;
  final int maxLines;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool autofocus;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.maxLines = 1,
    this.textInputAction,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: CupertinoColors.secondaryLabel,
            ),
          ),
        ),
        CupertinoTextFormFieldRow(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          enabled: enabled,
          maxLines: maxLines,
          textInputAction: textInputAction,
          autofocus: autofocus,
          padding: EdgeInsets.zero,
          placeholder: hint,
          prefix: prefixIcon,
          decoration: BoxDecoration(
            color: CupertinoColors.tertiarySystemFill,
            borderRadius: BorderRadius.circular(10),
            border: errorText != null
                ? Border.all(color: CupertinoColors.systemRed, width: 1)
                : null,
          ),
          style: const TextStyle(
            fontSize: 17,
            color: CupertinoColors.label,
          ),
          placeholderStyle: const TextStyle(
            fontSize: 17,
            color: CupertinoColors.placeholderText,
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 4),
            child: Text(
              errorText!,
              style: const TextStyle(
                fontSize: 12,
                color: CupertinoColors.systemRed,
              ),
            ),
          ),
      ],
    );
  }
}

/// iOS-style grouped text field for forms.
class CupertinoGroupedTextField extends StatelessWidget {
  final String? label;
  final String? placeholder;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefix;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;

  const CupertinoGroupedTextField({
    super.key,
    this.label,
    this.placeholder,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefix,
    this.suffix,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTextFormFieldRow(
      controller: controller,
      focusNode: focusNode,
      placeholder: placeholder,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      prefix: label != null
          ? SizedBox(
              width: 100,
              child: Text(
                label!,
                style: const TextStyle(
                  color: CupertinoColors.label,
                ),
              ),
            )
          : prefix,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.paddingSm,
      ),
    );
  }
}
