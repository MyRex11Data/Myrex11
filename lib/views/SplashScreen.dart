import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_navigator.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/main.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MyApp> {


  bool isTimeOut = false;
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    //determinePosition();
    startTimeCount();
    super.initState();
  }

  startTimeCount() async {
    var _duration = const Duration(seconds: 1000);
    return Timer(_duration, navigateInside);
  }

  void navigateInside() => {
    AppPrefrence.getBoolean(AppConstants.SHARED_PREFERENCES_IS_LOGGED_IN).then((value) => {
      if (value){navigateToHomePage(context),}
      else
        {setState(() {isTimeOut = true;})}
    }),
  };


  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Scaffold(
          backgroundColor: borderColor,
          body:Stack(
            children: [
              /// gif background image
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset("assets/images/logo.gif",height:
                  MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width, fit: BoxFit.contain)
              ),

              /// sign in login ui
              bottomUi()
            ],
          )
      ),
    );
  }

  Widget bottomUi() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            new Container(
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () => {navigateToRegisterNew(context)},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Register'.toUpperCase(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.fromLTRB(20, 15, 20, 10),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => {navigateToRegisterNew(context)},
                    child: new Container(
                      child: new Column(
                        children: [
                          Text(
                            'Invited by a friend?',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.white,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal),
                          ),
                          new Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              'Enter Code',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                  ),
                  new GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: new Container(
                      child: new Column(
                        children: [
                          Text(
                            'Already a user?',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.white,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal),
                          ),
                          new Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              'Log In',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.end,
                      ),
                    ),
                    onTap: () => {navigateToLogin(context)},
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }



}