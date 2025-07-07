import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextFormField extends StatelessWidget {
  final String labelText;
  final TextEditingController textController;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final double? errorMessageHeight;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  const AppTextFormField({
    super.key,
    required this.labelText,
    required this.textController,
    this.validator,
    this.obscureText,
    this.errorMessageHeight,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      validator: validator,
      style: const TextStyle(
        fontSize: 22,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
            width: 2.0,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          gapPadding: 10,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
            width: 2.0,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        errorStyle: TextStyle(
          fontSize: errorMessageHeight ?? 14.0,
          color: Colors.red,
          height: errorMessageHeight,
          decorationThickness: errorMessageHeight,
        ),
        fillColor: Theme.of(context).colorScheme.surface,
        filled: true,
        focusColor: Theme.of(context).colorScheme.secondary,
        counterText: "",
      ),
      cursorColor: Theme.of(context).colorScheme.primary,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
    );
  }
}
