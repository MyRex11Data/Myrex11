import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_constants.dart';

class TouchHandler extends StatefulWidget {
  final Widget child;

  TouchHandler({required this.child});

  @override
  State<TouchHandler> createState() => _TouchHandlerState();
}

class _TouchHandlerState extends State<TouchHandler> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          AppConstants.showLeaderboardSpots = false;
        });
      },
      child: widget.child,
    );
  }
}
