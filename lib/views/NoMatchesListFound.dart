import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_images.dart';

class NoMatchesListFound extends StatelessWidget {
  String? sportKey;
  NoMatchesListFound({this.sportKey});
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
            child: Text(
              "You haven't joined a contest yet!",
              style: TextStyle(
                  color: darkGrayColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 148.0,
                maxWidth: 148.0,
              ),
              child: Image(
                image: AssetImage(sportKey == 'CRICKET'
                    ? AppImages.cricPlayerIcon
                    : sportKey == 'LIVE'
                        ? AppImages.cricPlayerIcon
                        : sportKey == 'FOOTBALL'
                            ? AppImages.footPlayerIcon
                            : sportKey == 'BASKETBALL'
                                ? AppImages.baskPlayerIcon
                                : AppImages.kabPlayerIcon),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: new Text(
              //'Join Contests for any of the upcoming matches',
              'Find a contest to join and start winning.',
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
