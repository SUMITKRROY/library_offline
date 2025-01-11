import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextForm extends StatefulWidget {
  final String? initialValue;
  final void Function(String) onChanged;
  final String label;
  final double? labelFontSize;
  final dynamic validatorLabel;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscured;
  final bool validator;
  final dynamic prefix;
  final dynamic suffix;
  final dynamic validatorFunc;
  final dynamic maxline;
  final bool readOnly;

  const MyTextForm({
    super.key,
    required this.label,
    this.inputFormatters,
    this.validatorLabel,
    this.initialValue,
    required this.onChanged,
    this.controller,
    this.obscured = false,
    this.prefix,
    this.suffix,
    this.keyboardType,
    this.maxline,
    required this.validator,
    this.validatorFunc,
    this.labelFontSize,
    this.readOnly = false,
  });

  @override
  State<MyTextForm> createState() => _CustomTextField();
}

class _CustomTextField extends State<MyTextForm> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = widget.initialValue ?? '';
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly,
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: widget.maxline ?? 1,
      inputFormatters: widget.inputFormatters,
      validator: widget.validatorFunc ??
              (val) {
            if (widget.validator) {
              if (val == null || val.isEmpty) {
                return "Enter valid ${widget.validatorLabel}";
              }
            }
            return null;
          },
      controller: widget.controller ?? _controller,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      textInputAction: TextInputAction.next,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),

        prefixIcon: widget.prefix,
        suffixIcon: widget.suffix,
        labelText: widget.label,
        labelStyle: TextStyle(fontSize: widget.labelFontSize ?? 18.sp, color: Colors.white54),
        hintText: "Enter ${widget.label}",
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.black12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(width: 1.w, color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(width: 1.w, color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(width: 1.w, color: Colors.blueAccent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(width: 1.w, color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(width: 1.w, color: Colors.redAccent),
        ),
        errorStyle: TextStyle(fontSize: 14.sp, color: Colors.redAccent),
      ),
      obscureText: widget.obscured,
    );
  }
}
