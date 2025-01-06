import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final void Function() onTap;
  final String text;
  final Color color;
  final Color textColor;
  const Button(
      {required this.text,
      required this.onTap,
      this.color = const Color(0xff585e9d),
      this.textColor = Colors.white,
      super.key});

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(color: widget.color, boxShadow: const [
          BoxShadow(
              color: Colors.black38,
              offset: Offset(0, 4),
              blurRadius: 5,
              spreadRadius: 0,
              blurStyle: BlurStyle.normal)
        ]),
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: widget.textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
