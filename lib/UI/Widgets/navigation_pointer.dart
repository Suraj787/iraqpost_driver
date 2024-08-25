import 'package:flutter/material.dart';

class NavigationPointer extends StatelessWidget {
  final double rotation;

  const NavigationPointer({required this.rotation, super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: const Icon(
        Icons.navigation,
        color: Color(0xff234274),
        size: 36,
      ),
    );
  }
}
