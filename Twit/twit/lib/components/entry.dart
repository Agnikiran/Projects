import 'package:flutter/material.dart';
import '../constants.dart' as constants;

class Entry extends StatefulWidget {
  final String placeholder;
  final String title;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isVisibleErrorText;
  final void Function(TextEditingController controller) onChanged;

  const Entry(
      {required this.controller,
      required this.title,
      required this.placeholder,
      required this.onChanged,
      this.keyboardType = TextInputType.text,
      this.isVisibleErrorText = false,
      super.key});

  @override
  State<Entry> createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  bool showPassIcon = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontSize: 25),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: widget.controller,
                obscureText: widget.keyboardType == TextInputType.visiblePassword && !showPassIcon,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 0, color: Colors.transparent),
                        borderRadius: BorderRadius.circular(15)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 0, color: Colors.transparent),
                        borderRadius: BorderRadius.circular(15)),
                    fillColor: Colors.white,
                    hintText: widget.placeholder,
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    isCollapsed: true,
                    isDense: true,
                    suffixIconColor: Colors.black,
                    suffixIcon: (widget.keyboardType == TextInputType.visiblePassword)
                        ? GestureDetector(
                            onTap: () =>
                                setState(() => showPassIcon = !showPassIcon),
                            child: Container(
                              color: Colors.transparent,
                              child: Icon(showPassIcon
                                  ? constants.visiblePassword
                                  : constants.invisiblePassword),
                            ),
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10)),
                keyboardType: widget.keyboardType,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
                onChanged: (value) {
                  widget.controller.text = value;
                  widget.onChanged(widget.controller);
                },
              ),
            ),
          ],
        ),
        Visibility(
          visible: widget.isVisibleErrorText,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: widget.placeholder),
                const TextSpan(text: "\nThis is a required field"),
              ],
              style: const TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  wordSpacing: 2),
            ),
          ),
        ),
      ],
    );
  }
}
