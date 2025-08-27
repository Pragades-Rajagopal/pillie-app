import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  final Function() onTap;
  final String buttonText;
  final Color? buttonColor;
  final Color? textColor;
  const AppTextButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.textColor,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: buttonColor ?? Colors.lightBlue,
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: textColor ?? Theme.of(context).colorScheme.surface,
              // fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
