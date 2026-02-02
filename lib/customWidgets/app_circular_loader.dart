import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';

class AppLoaderProgress extends StatelessWidget {
  const AppLoaderProgress();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: new Center(
        child: new Container(
          padding: const EdgeInsets.all(8.0),
          child: !Platform.isIOS
              ? Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : CupertinoActivityIndicator(
                  radius: 20,
                ),
        ),
      ),
    );

//   BOX LOADER
//
//    Container _loaderView = new Container(
//      color: Colors.black26,
//      child: new Center(
//        child: new Container(
//          height: 75.0,
//          width: 75.0,
//          decoration: BoxDecoration(
//            shape: BoxShape.rectangle,
//            color: Colors.white,
//            borderRadius: new BorderRadius.circular(4.0),
//          ),
//          padding: EdgeInsets.all(15.0),
//          child: new CircularProgressIndicator(),
//        ),
//      ),
//    );
  }

  static void showLoader(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          AppConstants.loderContext = context;
          AppConstants.showLoader = true;
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: new Center(
              child: new Container(
                padding: const EdgeInsets.all(8.0),
                child: !Platform.isIOS
                    ? Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : CupertinoActivityIndicator(
                        radius: 20,
                      ),
              ),
            ),
          );
        });
  }

  static void hideLoader(BuildContext context) {
    Navigator.pop(context);
    AppConstants.showLoader = false;
  }

  static void hideLoaderIOS(BuildContext context) {
    if (AppConstants.onApiError == true && AppConstants.showLoader == true) {
      Future.delayed(Duration(milliseconds: 5000), () {
        AppConstants.showLoader = false;
        if (AppConstants.loderContext.mounted) {
          Navigator.pop(AppConstants.loderContext);
        }
        Fluttertoast.showToast(msg: 'Oops something went wrong...');
      });
    } else {
      if (AppConstants.loderContext.mounted) {
        Navigator.pop(AppConstants.loderContext);
      }
      AppConstants.showLoader = false;
    }
  }
}
