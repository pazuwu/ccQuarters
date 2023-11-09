import 'package:ccquarters/utils/consts.dart';
import 'package:flutter/material.dart';

class ChipKeyboardInput<T> extends StatefulWidget {
  const ChipKeyboardInput({
    super.key,
    this.label = "",
    this.choices = const [],
    this.additionalWidget,
    required this.onAdded,
    required this.textEditingController,
    this.validation,
  });

  final String label;
  final List<T> choices;
  final Widget? additionalWidget;
  final Function() onAdded;
  final TextEditingController textEditingController;
  final String? validation;

  @override
  State<ChipKeyboardInput> createState() => _ChipKeyboardInputState();
}

class _ChipKeyboardInputState extends State<ChipKeyboardInput> {
  bool _showClearButton = false;
  @override
  void initState() {
    widget.textEditingController.addListener(() {
      setState(() {
        _showClearButton = widget.textEditingController.text.isNotEmpty;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 4,
          children: [
            for (final choice in widget.choices)
              InputChip(
                onPressed: () {},
                label: Text(choice.toString()),
                onDeleted: () {
                  setState(() {
                    widget.choices.remove(choice);
                  });
                },
              ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        if (widget.additionalWidget != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.additionalWidget!,
          ),
        Row(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: widget.textEditingController,
                decoration: InputDecoration(
                  label: widget.label.isNotEmpty ? Text(widget.label) : null,
                  suffixIcon: _showClearButton
                      ? IconButton(
                          padding: const EdgeInsets.all(paddingSize),
                          icon: const Icon(Icons.clear, size: iconSize),
                          onPressed: () {
                            widget.textEditingController.clear();
                          },
                        )
                      : null,
                ),
                onSubmitted: (newValue) {
                  widget.onAdded();
                },
              ),
            ),
          ),
          IconButton(
            enableFeedback: false,
            icon: const Icon(Icons.add),
            onPressed: widget.onAdded,
          ),
        ]),
        if (widget.validation != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Text(
              widget.validation!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
