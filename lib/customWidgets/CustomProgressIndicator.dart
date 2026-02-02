import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_colors.dart';

class CustomProgressIndicator extends StatefulWidget {
  double value;
  CustomProgressIndicator(this.value);
  @override
  _ProgressIndicatorState createState() => new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<CustomProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(20)
      // ),
      margin: EdgeInsets.only(top: 10, right: 5, left: 2),
      child: LinearProgressIndicator(
        value: widget.value,
        backgroundColor: mediumGrayColor,
        valueColor: AlwaysStoppedAnimation<Color>(
          primaryColor.withOpacity(0.85),
        ),
      ),
    ));
  }
}
