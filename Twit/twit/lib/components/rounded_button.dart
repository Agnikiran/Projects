import 'package:flutter/material.dart';
import '../components/button.dart';

class RoundedButton extends Button {
  final double roundness;
  const RoundedButton(
      {required super.text,
      required super.onTap,
      super.color,
      super.textColor,
      required this.roundness,
      super.key});

  @override
  State<RoundedButton> createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
            color: super.widget.color,
            borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(widget.roundness),
                topEnd: Radius.circular(widget.roundness),
                bottomStart: Radius.circular(widget.roundness),
                bottomEnd: Radius.circular(widget.roundness)),
            boxShadow: const [
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
            color: super.widget.textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
