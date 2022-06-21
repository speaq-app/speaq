import 'dart:math';

import 'package:flutter/services.dart';
//Quelle https://stackoverflow.com/questions/59427590/flutter-multiline-with-max-lines

class MaxLinesTextInputFormatter extends TextInputFormatter {
  MaxLinesTextInputFormatter(this.maxLines) : assert(maxLines == -1 || maxLines > 0);

  final int maxLines;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    if (maxLines <= 0) {
      return newValue;
    }

    final regEx = RegExp("^.*((\n?.*){0,${maxLines - 1}})");
    String newString = regEx.stringMatch(newValue.text) ?? "";
    final maxLength = newString.length;
    if (newValue.text.runes.length <= maxLength) {
      return newValue;
    }

    final TextSelection newSelection = newValue.selection.copyWith(
      baseOffset: min(newValue.selection.start, maxLength),
      extentOffset: min(newValue.selection.end, maxLength),
    );

    final RuneIterator iterator = RuneIterator(newValue.text);
    if (iterator.moveNext()) {
      for (int count = 0; count < maxLength; ++count) {
        if (!iterator.moveNext()) {
          break;
        }
      }
    }

    final String truncated = newValue.text.substring(0, iterator.rawIndex);
    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}
