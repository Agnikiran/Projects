import 'package:flutter/material.dart';
import '../main.dart';

class LocationSelector extends StatefulWidget {
  final TextEditingController controller;
  final IconData icon;
  final String placeholder;
  final void Function(Object? locationDetails) onTap;
  const LocationSelector(this.controller,
      {required this.icon,
      required this.placeholder,
      required this.onTap,
      super.key});

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        children: [
          TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0),
              border: const OutlineInputBorder(),
              prefixIcon: Icon(
                widget.icon,
                color: Colors.white,
              ),
              suffixIcon: GestureDetector(
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ));
                  Object? result =
                      await httpService.searchLocation(widget.controller.text);
                  if (!mounted) return;
                  Navigator.of(this.context).pop();
                  widget.onTap(result);
                },
                child: const SizedBox(
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
              hintText: widget.placeholder,
            ),
            onChanged: (value) => widget.controller.text,
          ),
        ],
      ),
    );
  }
}
