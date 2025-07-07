import 'package:flutter/material.dart';

class AppTextLink extends StatelessWidget {
  final Function() onTap;
  final String linkText;
  final String? prefixText;
  const AppTextLink({
    super.key,
    required this.onTap,
    required this.linkText,
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefixText != null) ...{
          Text(
            prefixText!,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(width: 6.0),
        },
        GestureDetector(
          onTap: onTap,
          child: Text(
            linkText,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ),
      ],
    );
  }
}
