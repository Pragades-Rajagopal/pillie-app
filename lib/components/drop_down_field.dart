import 'package:flutter/material.dart';

class AppDropDownField extends StatefulWidget {
  final List<String> items;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String label;

  const AppDropDownField({
    super.key,
    required this.items,
    required this.controller,
    this.validator,
    required this.label,
  });

  @override
  State<AppDropDownField> createState() => _AppDropDownFieldState();
}

class _AppDropDownFieldState extends State<AppDropDownField> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    _syncWithController();
    widget.controller.addListener(_controllerListener);
  }

  @override
  void didUpdateWidget(covariant AppDropDownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_controllerListener);
      widget.controller.addListener(_controllerListener);
      _syncWithController();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_controllerListener);
    super.dispose();
  }

  void _controllerListener() {
    if (widget.controller.text != selectedValue &&
        widget.items.contains(widget.controller.text)) {
      setState(() {
        selectedValue = widget.controller.text;
      });
    }
  }

  void _syncWithController() {
    if (widget.controller.text.isNotEmpty &&
        widget.items.contains(widget.controller.text)) {
      selectedValue = widget.controller.text;
    } else {
      selectedValue = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      initialValue: selectedValue,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
            width: 1.0,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          gapPadding: 10,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
            width: 1.0,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        fillColor: Theme.of(context).colorScheme.surface,
        filled: true,
        counterText: "",
      ),
      items: widget.items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: TextStyle(fontSize: 22)),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedValue = value;
          widget.controller.text = value ?? '';
        });
      },

      // set the initial value of the dropdown
      validator: widget.validator,
    );
  }
}
