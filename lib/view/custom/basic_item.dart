import 'package:flutter/material.dart';

class BasicItem extends StatelessWidget {
  final void Function()? onPressed;
  final Widget? child;
  final EdgeInsetsGeometry? padding;

  const BasicItem({super.key, this.onPressed, this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: Colors.grey.shade100,
      child: InkWell(
        onTap: onPressed,
        hoverColor: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}
