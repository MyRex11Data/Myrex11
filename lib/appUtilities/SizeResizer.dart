import 'package:flutter/cupertino.dart';

class SizeResizer {
  static double getFontSize(double size, BuildContext context) {
    double nSize = size;

    double width = MediaQuery.of(context).size.width;
    if (width < 320) {
      nSize = size * 0.7;
    } else if (width > 320 && width <= 375) {
      nSize = size * 0.8;
    } else if (width > 375 && width < 480) {
      nSize = size * 0.9;
    }
    return nSize;
  }
}
