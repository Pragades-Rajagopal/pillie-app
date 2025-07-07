import 'package:flutter/material.dart';

class SwipableCard extends StatelessWidget {
  final String uniqueKey;
  final Widget cardWidget;
  final Function(DismissDirection) onDismissedAction;
  final IconData swipeRightActionIcon;
  final String swipeRightActionText;
  const SwipableCard({
    super.key,
    required this.uniqueKey,
    required this.cardWidget,
    required this.onDismissedAction,
    required this.swipeRightActionIcon,
    required this.swipeRightActionText,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(uniqueKey),
      direction: DismissDirection.startToEnd,
      background: Container(
        margin: const EdgeInsets.fromLTRB(0, 14, 0, 0),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Theme.of(context).colorScheme.tertiary.withOpacity(0.05),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  Icon(
                    swipeRightActionIcon,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    swipeRightActionText,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onDismissed: onDismissedAction,
      child: cardWidget,
    );
  }
}
