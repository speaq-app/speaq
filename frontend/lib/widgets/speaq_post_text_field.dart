import 'package:flutter/material.dart';
import 'package:frontend/pages/all_pages_export.dart';
import 'package:frontend/utils/speaq_styles.dart';

/// Custom [TextFormField] used for instance in [NewPostPage].
class SpqPostTextField extends StatelessWidget {
  const SpqPostTextField({
    Key? key,
    required this.controller,
    this.obscureText = false,
    this.isPassword = false,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.validator,
    this.keyboardType,
    this.minLines,
    this.maxLines,
    this.width,
    this.height = 56,
    this.contentPadding =
    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
    this.enabled = true,
  }) : super(key: key);

  final TextEditingController? controller;
  final bool obscureText;
  final bool isPassword;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function()? onTap;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? minLines;
  final int? maxLines;
  final double? width;
  final double? height;
  final EdgeInsets? contentPadding;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        minLines: minLines,
        maxLines: maxLines,
        obscureText: obscureText,
        readOnly: isPassword,
        keyboardType: keyboardType,
        enableSuggestions: !isPassword,
        autocorrect: !isPassword,
        controller: controller,
        validator: (value) => validator!(value),
        style: const TextStyle(color: spqBlack, fontSize: 16),
        enabled: enabled,
        decoration: InputDecoration(
          isDense: true,
          label: Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: Text(hintText,
                style: const TextStyle(
                    color: spqLightGrey, fontWeight: FontWeight.w100)),
          ),
          contentPadding: contentPadding,
          labelStyle:
          const TextStyle(color: spqLightGrey, fontWeight: FontWeight.w100),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          alignLabelWithHint: true,
          prefixIcon: prefixIcon != null
              ? Padding(
            padding: const EdgeInsets.all(12.0),
            child: prefixIcon,
          )
              : null,
          suffixIcon: suffixIcon,
          fillColor: spqWhite,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: spqPrimaryBlue, width: 1.0),
          ),
          hintStyle: const TextStyle(
              color: spqLightGrey, fontSize: 16, fontWeight: FontWeight.w100),
          //hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: spqWhite, width: 1.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: spqWhite, width: 1.0),
          ),
          border: const OutlineInputBorder(),
        ),
        onTap: onTap,
      ),
    );
  }
}
