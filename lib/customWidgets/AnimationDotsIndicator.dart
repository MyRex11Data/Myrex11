import 'package:flutter/material.dart';

class DotsIndicator extends AnimatedWidget {
  final PageController controller;
  final int itemCount;
  final int currentPage;

  DotsIndicator({
    required this.controller,
    required this.itemCount,
    required this.currentPage,
  }) : super(listenable: controller);

  Widget _buildDot(int index) {
    bool isActive = index == currentPage;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      height: isActive ? 8.0 : 8.0,
      width: isActive ? 25.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color(0xffC2C1C1),
        borderRadius: BorderRadius.circular(
            !isActive?
            20:5)

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
