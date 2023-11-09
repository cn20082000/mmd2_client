import 'package:flutter/material.dart';

class BasicItem extends StatelessWidget {
  final void Function()? onPressed;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final BoxConstraints constraints;

  const BasicItem({super.key, this.onPressed, this.child, this.padding, this.constraints = const BoxConstraints()});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: Colors.grey.shade100,
      child: InkWell(
        onTap: onPressed,
        hoverColor: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        child: ConstrainedBox(
          constraints: constraints,
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: child,
          ),
        ),
      ),
    );
  }
}
