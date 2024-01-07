import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../consts.dart';

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
      inputFormatters: widget.isDecimal
          ? [
              FilteringTextInputFormatter.allow(
                  RegExp(r'^(\d+([.,])?)?\d{0,2}'),
                  replacementString: ""),
              TextInputFormatter.withFunction((oldValue, newValue) {
                return newValue.copyWith(
                    text: newValue.text.replaceFirst(',', '.'));
              }),
            ]
          : [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: _showClearButton
            ? IconButton(
                padding: const EdgeInsets.only(
                  top: largePaddingSize,
                  bottom: mediumPaddingSize,
                ),
                alignment: Alignment.bottomCenter,
                icon: const Icon(Icons.clear, size: iconSize),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged("");
                },
                visualDensity: VisualDensity.compact,
              )
            : null,
      ),
      onChanged: widget.onChanged,
    );
  }
}
