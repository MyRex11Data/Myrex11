import 'dart:math';

import 'package:flutter/material.dart';

const MaterialColor materialPrimaryColor = const MaterialColor(
  0xff000000,
  const <int, Color>{
    50: const Color(0xff000000),
    100: const Color(0xff000000),
    200: const Color(0xff000000),
    300: const Color(0xff000000),
    400: const Color(0xff000000),
    500: const Color(0xff000000),
    600: const Color(0xff000000),
    700: const Color(0xff000000),
    800: const Color(0xff000000),
    900: const Color(0xff000000),
  },
);

const MaterialColor materialPrimaryColor2 = const MaterialColor(
  0xffffffff,
  const <int, Color>{
    50: const Color(0xffffffff),
    100: const Color(0xffffffff),
    200: const Color(0xffffffff),
    300: const Color(0xffffffff),
    400: const Color(0xffffffff),
    500: const Color(0xffffffff),
    600: const Color(0xffffffff),
    700: const Color(0xffffffff),
    800: const Color(0xffffffff),
    900: const Color(0xffffffff),
  },
);
const MaterialColor gradientPrimaryColor = const MaterialColor(
  0xffffffff,
  const <int, Color>{
    50: const Color(0xff190304),
    100: const Color(0xff630f12),
  },
);

Color get primaryColor => Color(0xffA66DFB);

Color get LightprimaryColor => Color(0xffEDE2FE);
Color get bgColor => Color(0xffeeeeee);
Color get blueColor => Color(0xff6A0BF8);
Color get redColor => Color(0xffDF0E0E);

// Color get borderColor => Color(0xffeeeeee);
Color get borderColor => Color(0xffA66DFB).withOpacity(0.3);
Color get borderColor1 => Color(0xffF1E7FF);
Color get textCol => Color(0xff414141);
Color get bgColorDark => Color(0xffededed);
Color get textBrownColor => Color(0XFF666666);
Color get textFieldBgColor => Color(0xfff3f2f2);
// Color get textFieldBorderColoer => Color(0xffe1e1e1);
Color get greenColor => Color(0xff3F8F54);
Color get greenColorShadow => Color(0xffd1e1d6);
Color get greenColorBonusShadow => Color(0xffd5eadc);
Color get greenIconColor => Color(0xff218e31);
Color get buttonGreenColor => Color(0xff3F8F54);
Color get lightGrayColor => Color(0xfff5f5f5);
Color get lightGrayColor2 => Color(0xfff7f7f7);
Color get lightGrayColor3 => Color(0xffdbdfea);
Color get lightGrayColor4 => Color(0xffA1FFFFFF);
Color get darkGrayColor => Color(0xff747474);
Color get underlineColor => Color(0xFFe1e1e1);
Color get mediumGrayColor => Color(0xffD8D8D8);
Color get yellowColor => Color(0xffffd350);
Color get lightprimaryColor => Color(0xfff2f8f4);
Color get lightprimaryColor2 => Color(0xff92af9b);
Color get lightYellowColor => Color(0xfffefaef);
Color get lightSkyColor => Color(0xffedf6ff);
Color get lightBlack => Color(0xff242322);
Color get transBlack => Color(0xffCC0D141A);
Color get lightYellow => Color(0xffffffed);
Color get lightYellowColor2 => Color(0xfffffda6);
Color get darkBlue => Color(0xff08114d);
Color get orangeColor => Color(0xffff6f00);
Color get darkOrangeColor => Color(0xffE14C14);
Color get otherOrangeColor => Color(0xffDF7308);
Color get teamSelectedNew => Color(0xffffe0e0);
Color get teamSelected => Color(0xff33076e39);
Color get pointPlayerBg => Color(0xffffe8db);
Color get teamBg => Color(0xfffffaf4);
Color get red => Color(0xffe6292b);
Color get redBold => Color(0xffed1b24);
Color get textcolor => Color(0xff3a3a3a);
Color get textcolor1 => Color(0xffF0F2F5);
Color get textBlueDark => Color(0xff262970);
Color get lightprimaryColor3 => Color(0xff01bc8f);
Color get categoryIconCyan => Color(0xff1bbef9);
Color get dividerColor => Color(0xffdbdfea);
Color get champBg => Color(0xFFFFE2CC);
Color get refercodecolor => Color(0xFFf3f2f2);
Color get lightBlack1 => Color(0xff283935);
Color get newTextColor => Color(0xff747474);
Color get categoryTitleGrayDark => Color(0xff707070);
Color get secondaryTextColor => Color(0xff666666);
Color get secondaryColorBg => Color(0xffDBDBDB);

Color get categoryCardBg => Color(0xffe6ecf2);

Color get lightDividerColor => Colors.grey.shade200;

Color get lightchatBgColor => Colors.grey.shade50;

MaterialColor get randomColor =>
    Colors.primaries[Random().nextInt(Colors.primaries.length)];
