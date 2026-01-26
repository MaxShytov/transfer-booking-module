import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;

import '../atoms/app_text_field.dart';

/// Password field with show/hide toggle using Cupertino style.
class PasswordField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool enabled;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final String? errorText;

  const PasswordField({
    super.key,
    this.label = 'Password',
    this.hint,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.textInputAction,
    this.focusNode,
    this.errorText,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      hint: widget.hint,
      errorText: widget.errorText,
      controller: widget.controller,
      obscureText: _obscureText,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      enabled: widget.enabled,
      textInputAction: widget.textInputAction,
      focusNode: widget.focusNode,
      keyboardType: TextInputType.visiblePassword,
      suffixIcon: CupertinoButton(
        padding: const EdgeInsets.all(8),
        minimumSize: Size.zero,
        onPressed: _toggleVisibility,
        child: Icon(
          _obscureText
              ? Icons.visibility_off
              : Icons.visibility,
          color: CupertinoColors.secondaryLabel,
          size: 20,
        ),
      ),
    );
  }
}
