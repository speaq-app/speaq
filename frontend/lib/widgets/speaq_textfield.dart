import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/utils/input_formatter/max_lines_text_input_formatter.dart';
import 'package:frontend/utils/speaq_styles.dart';

class SpeaqTextField extends StatelessWidget {
  final int newLines;
  final int minLines;
  final int maxLines;
  final int maxLength;
  final MaxLengthEnforcement enforcement;
  final TextEditingController controller;
  final String label;

  const SpeaqTextField(
      {Key? key,
      this.newLines = 1,
      this.minLines = 1,
      this.maxLines = 1,
      required this.maxLength,
      this.enforcement = MaxLengthEnforcement.none,
      required this.controller,
      required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
        inputFormatters: [MaxLinesTextInputFormatter(newLines)],
        minLines: minLines,
        maxLines: maxLines,
        maxLength: maxLength,
        maxLengthEnforcement: enforcement,
        controller: controller,
        decoration: InputDecoration(
          errorStyle: const TextStyle(
            color: spqErrorRed,
          ),
          labelText: label,
          prefixIcon: const Icon(Icons.alternate_email),
          border: const OutlineInputBorder(),
        ));
  }
}
