import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'consts.dart';

class NumberTextField extends StatefulWidget {
  const NumberTextField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.isDecimal = false,
  });

  final String label;
  final String initialValue;
  final Function(String) onChanged;
  final bool isDecimal;

  @override
  State<NumberTextField> createState() => _NumberTextFieldState();
}

class _NumberTextFieldState extends State<NumberTextField> {
  final _controller = TextEditingController();
  bool _showClearButton = false;
  @override
  void initState() {
    _controller.text = widget.initialValue;
    _controller.addListener(() {
      setState(() {
        _showClearButton = _controller.text.isNotEmpty;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        widget.isDecimal
            ? FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
            : FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          borderSide: BorderSide.none,
        ),
        labelText: widget.label,
        suffixIcon: _showClearButton
            ? IconButton(
                padding: const EdgeInsets.all(paddingSize),
                icon: const Icon(Icons.clear, size: iconSize),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged("");
                },
              )
            : null,
      ),
      onChanged: widget.onChanged,
    );
  }
}
