import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  final IconData icon;
  final String? tooltip;
  final bool highlight;
  final void Function()? onPressed;
  const NavigationButton({super.key, this.onPressed, required this.icon, this.highlight = false, this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: IconButton(
        padding: const EdgeInsets.all(16),
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: highlight ? Theme.of(context).colorScheme.primary : Colors.grey,
        ),
      ),
    );
  }
}
