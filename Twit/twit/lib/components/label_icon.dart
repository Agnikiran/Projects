import 'package:flutter/material.dart';

class LabelIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const LabelIcon({required this.label, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.orange, size: 20),
        Text(
          label,
          style: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w900),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
