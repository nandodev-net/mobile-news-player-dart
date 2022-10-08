import 'package:flutter/material.dart';

class CustomFooterTile extends StatelessWidget {
  const CustomFooterTile({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      top: 16,
      bottom: 16,
    ),
    child: Center(child: child),
  );
}
