import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_club_link/common/constants.dart';

class MyTextFormField extends StatefulWidget {
  final bool autoFocus;
  final String hintText;
  final String? label;
  final TextInputType? keyboardType;
  final int? maxLength;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final bool showEye;
  final TextCapitalization textCapitalization;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final bool isPassword;
  final bool readOnly;
  final bool isEnableInteractiveSelection;
  final bool isEnable;
  final Widget? icon;
  final int? maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;

  const MyTextFormField(
      {Key? key,
      this.hintText = "",
      this.keyboardType,
      this.label,
      this.maxLength,
      this.focusNode,
      this.showEye = false,
      this.textCapitalization = TextCapitalization.sentences,
      this.validator,
      this.onChanged,
      this.onFieldSubmitted,
      this.controller,
      this.textInputAction,
      this.isPassword = false,
      this.readOnly = false,
      this.isEnableInteractiveSelection = true,
      this.icon,
      this.maxLines,
      this.minLines,
      this.contentPadding,
      this.inputFormatters,
      this.isEnable = true,
      this.autoFocus = false})
      : super(key: key);

  @override
  _MyTextFormFieldState createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  bool isPassword = false;

  @override
  void initState() {
    super.initState();
    isPassword = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: widget.autoFocus,
      enabled: widget.isEnable,
      enableInteractiveSelection: widget.isEnableInteractiveSelection,
      readOnly: widget.readOnly,
      controller: widget.controller,
      textCapitalization: widget.textCapitalization,
      keyboardType: widget.keyboardType,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      focusNode: widget.focusNode,
      // textAlignVertical: TextAlignVertical.bottom,
      onChanged: widget.onChanged,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      obscureText: widget.isPassword,
      inputFormatters: widget.inputFormatters,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        constraints: const BoxConstraints(minHeight: 40),
        hintText: widget.hintText,
        hintStyle: const TextStyle(fontSize: 12),
        alignLabelWithHint: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        counterText: "",
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12),
        errorStyle: TextStyle(
            color: Colors.red.shade500,
            fontWeight: FontWeight.w500,
            fontSize: 12),
        prefixIcon: widget.icon,
        suffixIcon: widget.showEye
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    isPassword = !isPassword;
                  });
                },
                child: isPassword
                    ? const Icon(
                        Icons.remove_red_eye_outlined,
                        color: Colors.grey,
                        size: 21,
                      )
                    : const Icon(
                        Icons.visibility_off,
                        color: Colors.grey,
                        size: 21,
                      ),
              )
            : null,
        errorMaxLines: 1,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(width: 0.5, color: Colors.grey)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(width: 0.5, color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide(width: 0.8, color: appPrimaryColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide:
              BorderSide(width: 0.5, color: Colors.grey.withOpacity(0.2)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(width: 0.5, color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(
            width: 0.5,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
