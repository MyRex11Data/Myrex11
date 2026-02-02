import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  void Function()? onpress;
  String? text;
  Color? textcolor;
  Color? color;
  Color? borderColor;
  double? height;
  double? width;
  EdgeInsetsGeometry? margin;
  EdgeInsetsGeometry? padding;
  double? borderRadius;
  DefaultButton(
      {this.borderColor,
      this.color,
      this.text,
      this.onpress,
      this.textcolor,
      this.height,
      this.margin,
      this.borderRadius,
      this.width,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
      child: Card(
        margin: margin,
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 0.0)),
        child: Container(
          alignment: Alignment.center,
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
              border: Border.all(color: borderColor ?? Colors.transparent),
              color: color ?? Colors.white,
              borderRadius: BorderRadius.circular(borderRadius ?? 0)),
          child: Text(
            text!,
            style: TextStyle(
              color: textcolor,
              fontFamily: "Roboto",
            ),
          ),
        ),
      ),
    );
  }
}
