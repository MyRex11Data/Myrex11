import 'package:flutter/widgets.dart';

class AppRoute {
  static Route createRoute(var targetWidgetClassName,
      {bool isFullScreen = false}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          targetWidgetClassName,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
        fullscreenDialog: isFullScreen
    );
  }
}
