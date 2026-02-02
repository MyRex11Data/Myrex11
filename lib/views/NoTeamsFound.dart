import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_images.dart';

class NoTeamsFound extends StatelessWidget {
  String sportKey;
  NoTeamsFound(this.sportKey);
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(top: 30),
      alignment: Alignment.center,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          new Container(
            margin: EdgeInsets.only(top: 5),
            child: new Text(
              "You haven't created a team yet!",
              style: TextStyle(
                  color: darkGrayColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          new Container(
            padding: EdgeInsets.all(20),
            child: new ConstrainedBox(
              constraints: new BoxConstraints(
                maxHeight: 148.0,
                maxWidth: 148.0,
              ),
              child: Image(
                image: AssetImage(
                  sportKey == 'CRICKET'
                      ? AppImages.cricPlayerIcon
                      : sportKey == 'LIVE'
                          ? AppImages.cricPlayerIcon
                          : sportKey == 'FOOTBALL'
                              ? AppImages.footPlayerIcon
                              : sportKey == 'BASKETBALL'
                                  ? AppImages.baskPlayerIcon
                                  : AppImages.kabPlayerIcon,
                ),
              ),
            ),
          ),
          new Container(
            margin: EdgeInsets.only(top: 5),
            child: new Text(
              'The first step to winning starts here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: darkGrayColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
