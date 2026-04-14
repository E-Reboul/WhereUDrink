import 'package:flutter/material.dart';

class CustomGestureDetector extends StatelessWidget {
  final VoidCallback onTap;
  final double radius;
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;

  const CustomGestureDetector({
    super.key,
    required this.onTap,
    required this.radius,
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext? context) {
    return GestureDetector(
      onTap: () => this.onTap,
      child: CircleAvatar(
        radius: this.radius,
        backgroundColor: this.backgroundColor,
        child: Icon(this.icon),
      ),
    );
  }
}