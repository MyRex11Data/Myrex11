import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_colors.dart';

class CustomText extends StatelessWidget {
  final String? title;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextDecoration? textDecoration;
  const CustomText(
      {this.title,
      this.fontSize,
      this.fontWeight,
      this.color,
      this.textDecoration,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title ?? "",
      maxLines: 3,

      style: TextStyle(

        color: color ?? textcolor,
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.normal,
        fontFamily: "Roboto",
        decoration: textDecoration ?? TextDecoration.none,
      ),
    );
  }
}
