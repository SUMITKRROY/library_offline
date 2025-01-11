import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String? text;
  final void Function()? onTap;
  final Color? color;
  final Color? textColor;
  final double? height;
  final double? width;

  // Constructor
  const MyButton({
    Key? key,
    this.text,
    this.onTap,
    this.color,
    this.textColor,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            text == null
                ? SizedBox()
                : Text(
              text!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
