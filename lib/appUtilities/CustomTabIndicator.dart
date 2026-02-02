import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTabIndicator extends Decoration {
  final double radius;
  final Color color;
  final double indicatorHeight;
  final String isFrom;

  const CustomTabIndicator(
      {this.radius = 8,
      this.indicatorHeight = 4,
      this.color = const Color(0xFFffffff),
      this.isFrom = ''});

  @override
  _CustomPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(
      this,
      onChanged,
      radius,
      color,
      indicatorHeight,
      isFrom,
    );
  }
}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;
  final double radius;
  final Color color;
  final double indicatorHeight;
  final String isFrom;

  _CustomPainter(this.decoration, VoidCallback? onChanged, this.radius,
      this.color, this.indicatorHeight, this.isFrom)
      : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);

    final Paint paint = Paint();
    double xAxisPos = offset.dx +
        configuration.size!.width / (isFrom == 'buysellmultibegger' ? 1.84 : 2);
    double yAxisPos =
        offset.dy + configuration.size!.height - indicatorHeight / 2;
    paint.color = color;

    RRect fullRect = RRect.fromRectAndCorners(
      Rect.fromCenter(
        center: Offset(xAxisPos, yAxisPos),
        width: configuration.size!.width /
            (isFrom == 'buysellmultibegger' ? 1 : 2),
        height: indicatorHeight,
      ),
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
    );

    canvas.drawRRect(fullRect, paint);
  }
}
