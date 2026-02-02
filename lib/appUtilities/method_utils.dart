import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myrex11/appUtilities/defaultbutton.dart';
import 'package:myrex11/buildType/buildType.dart';
import 'package:myrex11/repository/model/series_leaderboard_response.dart';
import 'package:myrex11/repository/model/verify_response.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/dataModels/JoinChallengeDataModel.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/base_request.dart';
import 'package:myrex11/repository/model/category_contest_response.dart';
import 'package:myrex11/repository/model/join_contest_request.dart';
import 'package:myrex11/repository/model/join_contest_response.dart';
import 'package:myrex11/repository/model/my_balance_response.dart';
import 'package:myrex11/repository/model/score_card_response.dart';
import 'package:myrex11/repository/model/usable_balance_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myrex11/views/AddBalance.dart';
import 'app_colors.dart';
import 'app_constants.dart';
import 'app_images.dart';
import 'app_navigator.dart';

String fill(int n) => n.toString().padLeft(2, "0");

class MethodUtils {
  static StateSetter? _setState;
  static bool apicall = false;
  static String? latitude;
  static String? longitude;
  var userLocation = '';
  var states = '';
  static var state = '';
  static var countryname = '';

  static String contestNumber = '1';
  static dynamic calCalculatedAmount = 0;
  static int isSelected = 0;
  static int newIndexForUi = 10;
  static bool isClick = false;

  static String currentTimeStamp({bool includeNano = false}) {
    DateTime now = DateTime.now();

    if (includeNano) {
      return "${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}${now.millisecondsSinceEpoch}${now.microsecondsSinceEpoch}";
    } else {
      return "${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}";
    }
  }

  static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static String getCurrentDateTime({bool isYMD = true}) {
    return getCurrentDate(isYMD: isYMD) + " " + getCurrentTime();
  }

  static String getCurrentDate({bool isYMD = true, DateTime? now}) {
    if (now == null) {
      now = DateTime.now();
    }
    return isYMD
        ? "${now.year}-${now.month > 9 ? now.month : "0${now.month}"}-${now.day > 9 ? now.day : "0${now.day}"}"
        : "${now.day > 9 ? now.day : "0${now.day}"}-${now.month > 9 ? now.month : "0${now.month}"}-${now.year}";
  }

  static String getCurrentTime({DateTime? now}) {
    if (now == null) {
      now = DateTime.now();
    }

    return "${now.hour > 9 ? now.hour : "0${now.hour}"}:${now.minute > 9 ? now.minute : "0${now.minute}"}:${now.second > 9 ? now.second : "0${now.second}"}";
  }

  static DateTime getDateTime() {
    // return DateTime.now();
    DateTime utcTime = DateTime.now().toUtc();
    // print('UTC Time: $utcTime');

    // Convert to Asia/Kolkata time (UTC +5:30)
    DateTime indiaTime = utcTime.add(Duration(hours: 5, minutes: 30));
    // print('India Time: $indiaTime');
    // print('ApiTIme + ${widget.matchDetails.time_start}');

    String formattedIndiaTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(indiaTime);
    return DateTime.parse(formattedIndiaTime);
  }

  static String getCurrTimestamp({bool includeMillisecond = true}) {
    DateTime now = DateTime.now();
    return includeMillisecond
        ? "${now.day}${now.month}${now.year}${now.hour}${now.minute}${now.second}${now.millisecond}"
        : "${now.day}${now.month}${now.year}${now.hour}${now.minute}${now.second}";
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static void showSnackBar(BuildContext ctx, msgToDisplay) {
    var snackBar = SnackBar(
      content: Text(msgToDisplay),
    );
    ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
  }

  // static void showSuccess(BuildContext ctx, msgToDisplay, {Color? color}) {
  //   Flushbar(
  //     message: msgToDisplay,
  //     flushbarPosition: FlushbarPosition.TOP,
  //     isDismissible: true,
  //     backgroundColor: color == null ? primaryColor : color,
  //     duration: Duration(seconds: 5),
  //     animationDuration: Duration(milliseconds: 500),
  //   ).show(ctx);
  // }

  // static void showError(BuildContext ctx, msgToDisplay, {Color? color}) {
  //   Flushbar(
  //     message: msgToDisplay,
  //     flushbarPosition: FlushbarPosition.TOP,
  //     isDismissible: true,
  //     backgroundColor: primaryColor,
  //     duration: Duration(seconds: 2),
  //     animationDuration: Duration(milliseconds: 500),
  //   ).show(ctx);
  // }

  static void showOrange(BuildContext ctx, msgToDisplay) {
    Flushbar(
      message: msgToDisplay,
      flushbarPosition: FlushbarPosition.TOP,
      isDismissible: true,
      backgroundColor: orangeColor,
      duration: Duration(seconds: 2),
      animationDuration: Duration(milliseconds: 500),
    ).show(ctx);
  }

  static void showSuccess(BuildContext ctx, String? msgToDisplay,
      {Color? color}) {
    late OverlayEntry overlayEntry;
    final overlay = Overlay.of(ctx);
    if (overlay == null) return;

    final animationController = AnimationController(
      vsync: Navigator.of(ctx),
      duration: const Duration(milliseconds: 300),
    );

    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1), // starts above screen
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    ));

    final fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    ));

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        width: MediaQuery.of(context).size.width,
        child: Material(
          color: Colors.transparent,
          child: SlideTransition(
            position: slideAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: Container(
                decoration: BoxDecoration(
                  color: color ?? greenColor,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 3),
                  ],
                ),
                padding: const EdgeInsets.only(
                    top: 54, bottom: 20, left: 15, right: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        msgToDisplay ?? "",
                        style: const TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                        ),
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    animationController.forward();

    // Hide after 3 seconds with slide-up animation
    Future.delayed(const Duration(seconds: 3), () async {
      await animationController.reverse();
      if (overlayEntry.mounted) overlayEntry.remove();
      animationController.dispose();
    });
  }

  static void showError(BuildContext ctx, String? msgToDisplay,
      {Color? color}) {
    late OverlayEntry overlayEntry;
    final overlay = Overlay.of(ctx);
    if (overlay == null) return;

    final animationController = AnimationController(
      vsync: Navigator.of(ctx),
      duration: const Duration(milliseconds: 300),
    );

    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1), // starts above screen
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    ));

    final fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    ));

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        width: MediaQuery.of(context).size.width,
        child: Material(
          color: Colors.transparent,
          child: SlideTransition(
            position: slideAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: Container(
                decoration: BoxDecoration(
                  color: color ?? redColor,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 3),
                  ],
                ),
                padding: const EdgeInsets.only(
                    top: 54, bottom: 20, left: 15, right: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        msgToDisplay ?? "",
                        style: const TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                        ),
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    animationController.forward();

    // Hide after 3 seconds with slide-up animation
    Future.delayed(const Duration(seconds: 3), () async {
      await animationController.reverse();
      if (overlayEntry.mounted) overlayEntry.remove();
      animationController.dispose();
    });
  }

  // static void showSnackBarGK(
  //     GlobalKey<ScaffoldState> globalScaffoldKey, msgToDisplay) {
  //   print(msgToDisplay);

  //   var snackBar = SnackBar(
  //     content: Text(msgToDisplay),
  //   );

  //   ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
  // }

  static String getGreetingText() {
    String wText = "";
    DateTime c = DateTime.now();
    int timeOfDay = c.hour;

    if (timeOfDay >= 0 && timeOfDay < 12) {
      wText = "Good Morning";
    } else if (timeOfDay >= 12 && timeOfDay < 16) {
      wText = "Good Afternoon";
    } else if (timeOfDay >= 16 && timeOfDay < 21) {
      wText = "Good Evening";
    } else if (timeOfDay >= 21 && timeOfDay < 24) {
      wText = "Good Night";
    }
    return wText;
  }

  static Future<bool> isInternetPresentOld() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //  print('connected');
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      //print('not connected');
      return false;
    }
  }

  static Future<bool> isInternetPresent() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        print("Connected to Mobile Network");

        return true;
      } else if (connectivityResult == ConnectivityResult.wifi) {
        print("Connected to WiFi");
        return true;
      } else {
        print("Unable to connect. Please Check Internet Connection");
        return false;
      }
    } on SocketException catch (_) {
      //print('not connected');
      return false;
    }
  }

  static Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static void promotershowGadgetPopup(
      BuildContext context, List<WinningBreakupDataModel> breakupList) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        builder: (context) {
          return DraggableScrollableSheet(
            initialChildSize: .6,
            minChildSize: .6,
            maxChildSize: .95,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0))),
                      width: MediaQuery.of(context).size.width,
                      height: 65,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Container(
                            decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.grey),
                            width: 55,
                            height: 6,
                            margin: EdgeInsets.only(bottom: 15, top: 0),
                          ),
                          new Text(
                            'Leaderboard Prizes Breakup',
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    new Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                      height: 40,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          new Text(
                            "Winning Prize",
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: new Text(
                              'Rank',
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: new Container(
                        color: Colors.white,
                        child: breakupList.length == 0
                            ? Center(
                                child: Text(
                                  "No Data Found.",
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : new ListView.builder(
                                controller: scrollController,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: breakupList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: new Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(5),
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              new Text(
                                                '${breakupList[index].price.toString()}',
                                                style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              /*new Text(breakupList[index].position.toString(),style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600),),*/
                                              (breakupList[index]
                                                              .gadgets_image ??
                                                          "") !=
                                                      ""
                                                  ? new Container(
                                                      height: 50,
                                                      width: 100,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            breakupList[index]
                                                                .gadgets_image
                                                                .toString(),
                                                        filterQuality:
                                                            FilterQuality.low,
                                                      ),
                                                    )
                                                  : Container(),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: new Text(
                                                      '#' +
                                                          breakupList[index]
                                                              .position
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontFamily: "Roboto",
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider()
                                    ],
                                  );
                                }),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  static void showGadgetPopup(
      BuildContext context, List<WinningBreakupDataModel> breakupList) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        builder: (context) {
          return DraggableScrollableSheet(
            initialChildSize: .6,
            minChildSize: .6,
            maxChildSize: .95,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(24),
                        topLeft: Radius.circular(24))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Container(
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: primaryColor /*Color(0xff009eac)*/),
                      width: 55,
                      height: 6,
                      margin: EdgeInsets.only(bottom: 0, top: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 28,
                      width: 258.6,
                      /*alignment: Alignment.center,*/
                      /* decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/ic_leaderboardPrice.webp"),fit: BoxFit.fill
                          )
                      ),*/
                      child: Center(
                        child: new Text(
                          'Leaderboard Prizes Breakup',
                          style: TextStyle(
                              fontFamily: "Roboto",
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Color(0xff80dbdfea),
                      height: 0,
                      thickness: 1,
                    ),
                    new Container(
                      width: MediaQuery.of(context).size.width,
                      color: primaryColor,
                      height: 40,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          new Text(
                            "Rank",
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: new Text(
                              'Prize',
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Color(0xff80dbdfea),
                      height: 0,
                      thickness: 1,
                    ),
                    Expanded(
                      child: new Container(
                        color: Colors.white,
                        child: breakupList.length == 0
                            ? Center(
                                child: Text(
                                  "No Data Found.",
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : new ListView.builder(
                                controller: scrollController,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: breakupList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                            vertical:
                                                breakupList[index].price != null
                                                    ? 8.0
                                                    : 0),
                                        child: new Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(
                                              breakupList[index].price != null
                                                  ? 5
                                                  : 0),
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: new Text(
                                                  '#' +
                                                      breakupList[index]
                                                          .position
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontFamily: "Roboto",
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              breakupList[index].is_gadgets != 1
                                                  ? Text(
                                                      '${breakupList[index].price.toString()}',
                                                      style: TextStyle(
                                                          fontFamily: "Roboto",
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )
                                                  : (breakupList[index]
                                                                  .gadgets_image ??
                                                              "") !=
                                                          ""
                                                      ? Row(
                                                          children: [
                                                            breakupList[index]
                                                                        .gadgets_name !=
                                                                    null
                                                                ? Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            5),
                                                                    child: Text(
                                                                      '${breakupList[index].gadgets_name.toString()}',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "Roboto",
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  )
                                                                : SizedBox
                                                                    .shrink(),
                                                            CachedNetworkImage(
                                                              width: 40,
                                                              height: 40,
                                                              imageUrl: breakupList[
                                                                      index]
                                                                  .gadgets_image
                                                                  .toString(),
                                                              filterQuality:
                                                                  FilterQuality
                                                                      .low,
                                                            ),
                                                          ],
                                                        )
                                                      : SizedBox.shrink(),
                                              /*new Text(breakupList[index].position.toString(),style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600),),*/
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider()
                                    ],
                                  );
                                }),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  static void checkBalance(
      int _currentContestIndex, JoinChallengeDataModel model,
      {int? contestNumber,
      bool? createContest,
      GeneralModel? genModel,
      double? scrollPosition,
      String? isLineUp,
      int? joinSimilar,
      String? fromSinglePlayer,
      int? notnow,
      String? check,
      int? teamCount}) async {
    print(contestNumber);

    if (apicall == false && fromSinglePlayer != 'h2h') {
      AppLoaderProgress.showLoader(model.context);
    }
    JoinContestRequest contestRequest = new JoinContestRequest(
      user_id: model.userId.toString(),
      teamid: model.teamId,
      challengeid: model.newChallengeId == 0
          ? model.ChallengeId.toString()
          : model.newChallengeId.toString(),
      fantasy_type: model.selectedFantasyType.toString(),
      join_similar_count: model.multiple_contest ?? '1',
      multiple_contest: model.multiple_contest ?? '1',
      // slotes_id: model.selectedSlotId.toString()
    );
    final client = ApiClient(AppRepository.dio);
    BalanceResponse response = await client.getUsableBalance(contestRequest);
    if (apicall == false && fromSinglePlayer != 'h2h') {
      AppLoaderProgress.hideLoader(model.context);
    }

    if (response.status == 1 && response.result!.length > 0) {
      model.availableB = double.parse(response.result![0].usertotalbalance!);
      model.usableB = double.parse(response.result![0].usablebalance!);
      model.is_bonus = response.result![0].is_bonus!;
      model.entryFee = response.result![0].entry_fees;
      model.total_team_text = response.result![0].total_team_text;
      model.total_team = response.result![0].total_team;
      model.discount_amount_text = response.result![0].discount_amount_text;
      model.discount_amount = response.result![0].discount_amount;
      model.total_entry_fee_text = response.result![0].total_entry_fee_text;
      model.total_entry_fee = response.result![0].total_entry_fee;
      model.is_free_for_referrer = response.result![0].is_free_for_referrer;
      model.to_pay_amount = response.result![0].to_pay_amount;
      model.to_pay_stmt = response.result![0].to_pay_stmt;
      model.terms_text = response.result![0].terms_text;
      model.Usable_cash_bonus_stmt = response.result![0].Usable_cash_bonus_stmt;

      model.Usable_cash_bonus_amount =
          response.result![0].Usable_cash_bonus_amount;
      model.uti_balance_stmt = response.result![0].uti_balance_stmt;
      model.entry_fee_stmt = response.result![0].entry_fee_stmt;
      if (apicall == true) {
        _setState!(() {});
      } else if (model.newChallengeId == 0) {
        // _setState!(() {});
        // showJoinContestBottomSheet(
        showJoinContestPopup(
          _currentContestIndex,
          model,
          10,
          result: response.result![0],
          createContest: createContest,
          genModel: genModel,
          scrollPosition: scrollPosition,
          isgstBonus: response.result![0].is_gstbonus,
          isLineUp: isLineUp,
          joinSimilar: joinSimilar,
          fromSinglePlayer: fromSinglePlayer,
          notnow: notnow,
          check: check,
          teamCount: teamCount,
        );
      } else {}
      // if (model.newChallengeId == 0) {
      //   showDialog(_currentContestIndex, model, 10,
      //       result: response.result![0],
      //       createContest: createContest,
      //       genModel: genModel,
      //       scrollPosition: scrollPosition,
      //       isgstBonus: response.result![0].is_gstbonus,
      //       isLineUp: isLineUp);
      // } else {}
    }
  }

  // static Widget label(int index, JoinChallengeDataModel contest,
  //     StateSetter stateSetter, int newIndexForUi_) {
  //   if (isClick) {
  //     newIndexForUi = newIndexForUi_;
  //     isClick = false;
  //   }
  //   if (index < 10) {
  //     return InkWell(
  //       onTap: () {
  //         isClick = true;
  //         isSelected = index;
  //         contestNumber = index + 1;
  //         calCalculatedAmount =
  //             (index + 1) * int.parse(contest.entryFee.toString());
  //         contest.totalSelected = contestNumber;
  //         stateSetter(() {});
  //       },
  //       child: Card(
  //         margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
  //         elevation: 3,
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //         child: Container(
  //           alignment: Alignment.center,
  //           height: 50,
  //           width: 50,
  //           decoration: BoxDecoration(
  //               color: isSelected == index ? primaryColor : Colors.white,
  //               borderRadius: BorderRadius.circular(16)),
  //           child: CustomText(
  //             title: "${index + 1}",
  //             fontSize: 20,
  //             color: isSelected == index ? Colors.white : Colors.black,
  //           ),
  //         ),
  //       ),
  //     );
  //   } else if (index >= 10 && index <= 11) {
  //     newIndexForUi += 5;
  //     return InkWell(
  //       onTap: () {
  //         isClick = true;

  //         if (index == 10) {
  //           newIndexForUi = 15;
  //         } else if (index == 9) {
  //           newIndexForUi = 10;
  //         } else if (index == 11) {
  //           newIndexForUi = 20;
  //         }
  //         isSelected = newIndexForUi;
  //         contestNumber = newIndexForUi;
  //         calCalculatedAmount =
  //             (newIndexForUi) * int.parse(contest.entryFee.toString());
  //         contest.totalSelected = contestNumber;
  //         stateSetter(() {});
  //       },
  //       child: Card(
  //         margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
  //         elevation: 3,
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //         child: Container(
  //           alignment: Alignment.center,
  //           height: 50,
  //           width: 50,
  //           decoration: BoxDecoration(
  //               color:
  //                   isSelected == newIndexForUi ? primaryColor : Colors.white,
  //               borderRadius: BorderRadius.circular(16)),
  //           child: CustomText(
  //             title: "$newIndexForUi",
  //             fontSize: 20,
  //             color: isSelected == newIndexForUi ? Colors.white : Colors.black,
  //           ),
  //         ),
  //       ),
  //     );
  //   } else {
  //     newIndexForUi += 10;
  //     return InkWell(
  //       onTap: () {
  //         isClick = true;
  //         if (index == 14) {
  //           newIndexForUi = 50;
  //         } else if (index == 13) {
  //           newIndexForUi = 40;
  //         } else if (index == 12) {
  //           newIndexForUi = 30;
  //         } else if (index == 11) {
  //           newIndexForUi = 20;
  //         }

  //         isSelected = newIndexForUi;
  //         contestNumber = newIndexForUi;
  //         calCalculatedAmount =
  //             (newIndexForUi) * int.parse(contest.entryFee.toString());
  //         contest.totalSelected = contestNumber;
  //         stateSetter(() {});
  //       },
  //       child: Card(
  //         margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
  //         elevation: 3,
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //         child: Container(
  //           height: 50,
  //           width: 50,
  //           alignment: Alignment.center,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(16),
  //             color: isSelected == newIndexForUi ? primaryColor : Colors.white,
  //           ),
  //           child: CustomText(
  //             title: "$newIndexForUi",
  //             fontSize: 20,
  //             color: isSelected == newIndexForUi ? Colors.white : Colors.black,
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  // }

  static void showDialog1(
    int _currentContestIndex,
    JoinChallengeDataModel model,
    int newIndexForUi_, {
    UsableBalanceItem? result,
    bool? createContest,
    GeneralModel? genModel,
    double? scrollPosition,
    dynamic isgstBonus,
    String? isLineUp,
  }) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.8),
      transitionDuration: Duration(milliseconds: 300),
      context: model.context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Wrap(
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(color: Color(0xffD6B0B0))),
                    child: new Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 5, bottom: 16),
                          child: Column(
                            children: [
                              new Container(
                                height: 50,
                                width: MediaQuery.of(model.context).size.width,
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    new GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      child: new Container(
                                        alignment: Alignment.center,
                                        child: new Text(
                                          'Confirmation',
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              decoration: TextDecoration.none),
                                        ),
                                      ),
                                      onTap: () => {},
                                    ),
                                  ],
                                ),
                              ),
                              new Container(
                                alignment: Alignment.centerLeft,
                                child: new Text(
                                  model.uti_balance_stmt ?? '',
                                  style: TextStyle(
                                      fontFamily: AppConstants.textSemiBold,
                                      color: newTextColor,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      decoration: TextDecoration.none),
                                ),
                              ),
                              // new Container(
                              //   child: new Row(
                              //     children: [

                              //       // new Container(
                              //       //   alignment: Alignment.center,
                              //       //   child: new Text(
                              //       //     '₹' +
                              //       //         (NumberFormat('#.##')
                              //       //             .format(model.availableB)),
                              //       //     style: TextStyle(
                              //       //         fontFamily: AppConstants.textSemiBold,
                              //       //         color: newTextColor,
                              //       //         fontWeight: FontWeight.w500,
                              //       //         fontSize: 13,
                              //       //         decoration: TextDecoration.none),
                              //       //   ),
                              //       // )
                              //     ],
                              //   ),
                              // ),
                              new Container(
                                margin: EdgeInsets.only(top: 30),
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    new Container(
                                      alignment: Alignment.center,
                                      child: new Text(
                                        model.entry_fee_stmt ?? '',
                                        style: TextStyle(
                                            fontFamily:
                                                AppConstants.textRegular,
                                            color: newTextColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            decoration: TextDecoration.none),
                                      ),
                                    ),
                                    new Container(
                                      alignment: Alignment.center,
                                      child: new Text(
                                        "₹${model.entryFee}",
                                        // (NumberFormat('#.##').format(
                                        //     double.parse(model.entryFee) *
                                        //         model.totalSelected)),
                                        style: TextStyle(
                                            fontFamily:
                                                AppConstants.textRegular,
                                            color: newTextColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            decoration: TextDecoration.none),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(vertical: 5),
                              //   child: new Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       new Container(
                              //         alignment: Alignment.center,
                              //         child: new Text(
                              //           model.total_team_text ?? '',
                              //           style: TextStyle(
                              //               fontFamily: AppConstants.textRegular,
                              //               color: newTextColor,
                              //               fontWeight: FontWeight.w400,
                              //               fontSize: 14,
                              //               decoration: TextDecoration.none),
                              //         ),
                              //       ),
                              //       new Container(
                              //         alignment: Alignment.center,
                              //         child: new Text(
                              //           "${model.total_team ?? ''}",
                              //           // (NumberFormat('#.##').format(
                              //           //     double.parse(model.entryFee) *
                              //           //         model.totalSelected)),
                              //           style: TextStyle(
                              //               fontFamily: AppConstants.textRegular,
                              //               color: newTextColor,
                              //               fontWeight: FontWeight.w400,
                              //               fontSize: 14,
                              //               decoration: TextDecoration.none),
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // ),
                              /*  Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            new Container(
                              alignment: Alignment.center,
                              child: new Text(
                                model.total_entry_fee_text ?? '',
                                style: TextStyle(
                                    fontFamily: AppConstants.textRegular,
                                    color: newTextColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    decoration: TextDecoration.none),
                              ),
                            ),
                            new Container(
                              alignment: Alignment.center,
                              child: new Text(
                                "${model.total_entry_fee ?? ''}",
                                // (NumberFormat('#.##').format(
                                //     double.parse(model.entryFee) *
                                //         model.totalSelected)),
                                style: TextStyle(
                                    fontFamily: AppConstants.textRegular,
                                    color: newTextColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    decoration: TextDecoration.none),
                              ),
                            )
                          ],
                          ),
                        ),*/
                              model.is_free_for_referrer == 1
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          new Container(
                                            alignment: Alignment.center,
                                            child: new Text(
                                              model.discount_amount_text ?? '',
                                              style: TextStyle(
                                                  fontFamily:
                                                      AppConstants.textRegular,
                                                  color: newTextColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                          ),
                                          new Container(
                                            alignment: Alignment.center,
                                            child: new Text(
                                              "${model.discount_amount ?? ''}",
                                              // (NumberFormat('#.##').format(
                                              //     double.parse(model.entryFee) *
                                              //         model.totalSelected)),
                                              style: TextStyle(
                                                  fontFamily:
                                                      AppConstants.textRegular,
                                                  color: newTextColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),

                              model.is_bonus == 1
                                  ? new Container(
                                      margin:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          new Container(
                                            alignment: Alignment.center,
                                            child: new Text(
                                              model.Usable_cash_bonus_stmt ??
                                                  '',
                                              style: TextStyle(
                                                  fontFamily:
                                                      AppConstants.textRegular,
                                                  color: newTextColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                          ),
                                          new Container(
                                            alignment: Alignment.center,
                                            child: new Text(
                                              (NumberFormat('#.##')
                                                  .format(model.usableB)),
                                              style: TextStyle(
                                                  fontFamily:
                                                      AppConstants.textRegular,
                                                  color: newTextColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                              new Divider(
                                color: borderColor,
                                thickness: .5,
                              ),
                              new Container(
                                margin: EdgeInsets.only(top: 10, bottom: 0),
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    new Container(
                                      alignment: Alignment.center,
                                      child: new Text(
                                        model.to_pay_stmt ?? '',
                                        style: TextStyle(
                                            fontFamily:
                                                AppConstants.textRegular,
                                            color: newTextColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            decoration: TextDecoration.none),
                                      ),
                                    ),
                                    // double.parse(model.entryFee) > 0
                                    // ?
                                    new Container(
                                      alignment: Alignment.center,
                                      child: new Text(
                                        "${model.to_pay_amount}",
                                        // (NumberFormat('#.##').format(
                                        //     (double.parse(model.entryFee) *
                                        //             model.totalSelected) -
                                        //         model.usableB)),
                                        style: TextStyle(
                                            fontFamily:
                                                AppConstants.textRegular,
                                            color: newTextColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            decoration: TextDecoration.none),
                                      ),
                                    )
                                    // : new Container(
                                    //     alignment: Alignment.center,
                                    //     child: new Text(
                                    //       '₹' +
                                    //           (NumberFormat('#.##').format(
                                    //               (double.parse(model.entryFee) *
                                    //                   model.totalSelected))),
                                    //       style: TextStyle(
                                    //           fontFamily: AppConstants.textRegular,
                                    //           color: newTextColor,
                                    //           fontWeight: FontWeight.w500,
                                    //           fontSize: 14,
                                    //           decoration: TextDecoration.none),
                                    //     ),
                                    //   )
                                  ],
                                ),
                              ),
                              /* new Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 0),
                          child: new Html(
                          data: model.terms_text,
                          //  "<span style='font-family:Roboto-Regular'>By joining this contest, you accept <font color='#c61d24'> myrex11 </font> <a href='" +
                          //     AppConstants.terms_url +
                          //     "' style='text-decoration: none;'><font color='#747474'>Terms &amp; Conditions </font> </a> and <a href='" +
                          //     AppConstants.privacy_url +
                          //     "' style='text-decoration: none;'><font color='#747474'>Privacy Policy </font></a> Confirm that you are not a resident of  Andhra Pradesh, Assam, Nagaland, Odisha, Sikkim or Telangana.</span>",
                          onLinkTap: (
                            link,
                            _,
                            __,
                          ) {
                            if (link!.contains("terms")) {
                              // AppConstants.toastmsg();
                              navigateToVisionWebView(
                                  model.context, 'Terms & Condition', link);
                            } else {
                              // AppConstants.toastmsg();
                              navigateToVisionWebView(
                                  model.context, 'Privacy Policy', link);
                            }
                          },
                          style: {
                            'html': Style(
                                fontSize: FontSize.medium,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.normal,
                                fontFamily: "Roboto",
                                color: Color(0xff747474),
                                textDecoration: TextDecoration.none)
                          },
                          ),
                        ),*/

                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 0),
                                child: Html(
                                  data:
                                      applyCustomStyles(model.terms_text ?? ''),
                                  onLinkTap: (link, _, __) {
                                    if (link!.contains("admirable")) {
                                      navigateToVisionWebView(model.context,
                                          'Terms & Condition', link);
                                    } else {
                                      navigateToVisionWebView(model.context,
                                          'Privacy Policy', link);
                                    }
                                  },
                                  style: {
                                    'html': Style(
                                      fontSize: FontSize(12),
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: "Roboto",
                                      color: Color(0xff747474),
                                      textDecoration: TextDecoration.none,
                                    ),
                                  },
                                ),
                              ),

                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 40, right: 40),
                                child: DefaultButton(
                                  margin: EdgeInsets.only(top: 10),
                                  color: primaryColor,
                                  width:
                                      MediaQuery.of(model.context).size.width,
                                  height: 45,
                                  text: "Join This Contest",
                                  textcolor: Colors.white,
                                  borderRadius: 30,
                                  onpress: () {
                                    double requiredBalance =
                                        (double.parse(model.entryFee) *
                                                model.totalSelected) -
                                            (model.usableB + model.availableB);
                                    if (model.isBonus == 1) {
                                      String? ammounttopay =
                                          NumberFormat('#.##').format(
                                              double.parse(model.to_pay_amount
                                                  .toString()
                                                  .split('₹')[1])
                                              //     -
                                              // model.usableB -
                                              // model.availableB
                                              );

                                      if ((model.usableB + model.availableB) <
                                              double.parse(model.to_pay_amount
                                                  .toString()
                                                  .split('₹')[1])
                                          // *
                                          //     model.totalSelected
                                          ) {
                                        print(double.parse(model.to_pay_amount
                                            .toString()
                                            .split('₹')[1]));
                                        print(ammounttopay);
                                        Platform.isAndroid
                                            ? Navigator.push(
                                                model.context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddBalance('',
                                                            entryFee:
                                                                ammounttopay,
                                                            isFromCheck:
                                                                'joinpopup'
                                                            // multiple_contest: _dropDownValue ?? '1', joinSimilar: widget.contest.is_join_similar_contest
                                                            )))
                                            : Navigator.push(
                                                model.context,
                                                CupertinoPageRoute(
                                                    builder: (context) => AddBalance(
                                                        '',
                                                        entryFee: ammounttopay,
                                                        isFromCheck: 'joinpopup'
                                                        // multiple_contest: _dropDownValue ?? '1',
                                                        // joinSimilar: widget.contest.is_join_similar_contest
                                                        )));
                                        // navigateToAddBalance(model.context, '',
                                        //     entryFee: ammounttopay,
                                        //     isFromCheck: 'joinpopup');
                                      } else {
                                        Navigator.pop(model.context);
                                        joinChallenge(_currentContestIndex,
                                            model, contestNumber,
                                            genModel: genModel,
                                            scrollPosition: scrollPosition,
                                            isLineUp: isLineUp);
                                      }
                                    } else {
                                      String? ammounttopay =
                                          NumberFormat('#.##').format(
                                              double.parse(model.to_pay_amount
                                                      .toString()
                                                      .split('₹')[1]) -
                                                  model.availableB);
                                      // String? ammounttopay = (NumberFormat('#.##').format(
                                      //     (double.parse(model.entryFee) *
                                      //             model.totalSelected) -
                                      //         model.availableB));
                                      if ((model.availableB) <
                                              double.parse(model.to_pay_amount
                                                  .toString()
                                                  .split('₹')[1])

                                          // *
                                          //     model.totalSelected
                                          ) {
                                        print(double.parse(model.to_pay_amount
                                            .toString()
                                            .split('₹')[1]));
                                        print(ammounttopay);
                                        // if (model.availableB <
                                        //     double.parse(model.entryFee) *
                                        //         model.totalSelected) {
                                        Platform.isAndroid
                                            ? Navigator.push(
                                                model.context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddBalance('',
                                                            entryFee:
                                                                ammounttopay,
                                                            isFromCheck:
                                                                'joinpopup'
                                                            // multiple_contest: _dropDownValue ?? '1', joinSimilar: widget.contest.is_join_similar_contest
                                                            )))
                                            : Navigator.push(
                                                model.context,
                                                CupertinoPageRoute(
                                                    builder: (context) => AddBalance(
                                                        '',
                                                        entryFee: ammounttopay,
                                                        isFromCheck: 'joinpopup'
                                                        // multiple_contest: _dropDownValue ?? '1',
                                                        // joinSimilar: widget.contest.is_join_similar_contest
                                                        )));
                                        // navigateToAddBalance(model.context, '',
                                        //     entryFee: ammounttopay,
                                        //     isFromCheck: 'joinpopup');
                                      } else {
                                        Navigator.pop(model.context);
                                        joinChallenge(_currentContestIndex,
                                            model, contestNumber,
                                            genModel: genModel,
                                            scrollPosition: scrollPosition,
                                            isLineUp: isLineUp);
                                      }
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),

                        // new Container(
                        //     width:
                        //     MediaQuery.of(model.context).size.width,
                        //     height: 45,
                        //     margin: EdgeInsets.only(top: 10),
                        //     child: RaisedButton(
                        //       textColor: Colors.white,
                        //       elevation: .5,
                        //       color: primaryColor,
                        //       child: Text(
                        //         'Join This Contest',
                        //         style: TextStyle(fontSize: 14,color: Colors.white),
                        //       ),
                        //       shape: RoundedRectangleBorder(
                        //           borderRadius:
                        //           BorderRadius.circular(3)),
                        //       onPressed: () {
                        //         Navigator.pop(model.context);
                        //         double requiredBalance=(double.parse(model.entryFee)*model.totalSelected) -(model.usableB+model.availableB);
                        //         if(model.isBonus==1){
                        //           if((model.usableB+model.availableB)<double.parse(model.entryFee)*model.totalSelected){
                        //             navigateToAddBalance(model.context,'');
                        //           }
                        //           else{
                        //             joinChallenge(model);
                        //           }
                        //         }
                        //         else{
                        //           if(model.availableB<double.parse(model.entryFee)*model.totalSelected){
                        //             navigateToAddBalance(model.context,'');
                        //           }
                        //           else{
                        //             joinChallenge(model);
                        //           }
                        //         }

                        //       },
                        //     ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16, top: 10),
                    child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: new Container(
                          //alignment: Alignment.center,
                          child: new Container(
                              child: Image.asset(
                            "assets/images/closeIcon.png",
                            scale: 2,
                          )),
                        ),
                        onTap: () => {
                              Navigator.pop(model.context),
                            }),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  static Future<bool> _onWillPop() async {
    Navigator.popUntil(
        AppConstants.context, (route) => route.settings.name == "home");
    return Future.value(false);
  }

  static selectionFunction() {
    _setState = null;
    apicall = false;
  }

  static void showJoinContestPopup(
    int _currentContestIndex,
    JoinChallengeDataModel model,
    int newIndexForUi_, {
    UsableBalanceItem? result,
    bool? createContest,
    GeneralModel? genModel,
    double? scrollPosition,
    dynamic isgstBonus,
    String? isLineUp,
    int? joinSimilar,
    String? fromSinglePlayer,
    int? notnow,
    String? check,
    int? teamCount,
  }) {
    String selectedIndex = AppConstants.contestJoinCountList[0];
    TextEditingController customXController = TextEditingController();

    showDialog<void>(
      context: model.context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Dialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Close button and header
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 24), // For balance
                                  Expanded(
                                    child: Text(
                                      'Confirmation',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),

                              // Balance info with gold coin icon
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    model.uti_balance_stmt ?? "",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Image.asset(
                                    AppImages.goldcoin,
                                    width: 20,
                                    height: 20,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '${(model.usableB + model.availableB).toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),

                              // Contest selection for joinSimilar
                              if (joinSimilar == 1)
                                Text(
                                  'Select No. of Contests you want to join',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              SizedBox(height: 8),
                              if (joinSimilar == 1)
                                GridView.count(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 14,
                                  mainAxisSpacing: 8,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  childAspectRatio: 2,
                                  children: AppConstants.contestJoinCountList
                                      .map((e) {
                                    bool isSelected = selectedIndex == e;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _setState = setState;
                                          selectedIndex = e;
                                          model.multiple_contest =
                                              selectedIndex;
                                          apicall = true;
                                          checkBalance(
                                              _currentContestIndex, model);
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? primaryColor
                                              : LightprimaryColor,
                                          border: Border.all(
                                              color: isSelected
                                                  ? primaryColor
                                                  : primaryColor),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: Text(
                                          '$e X',
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              if (joinSimilar == 1) SizedBox(height: 12),

                              // Custom X input for joinSimilar
                              if (joinSimilar == 1)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 4, bottom: 6),
                                  child: Text(
                                    'Enter X Value',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              if (joinSimilar == 1)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0),
                                  child: TextFormField(
                                    controller: customXController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 3,
                                    decoration: InputDecoration(
                                      counterText: '',
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      hintText: 'Enter X Value',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                          color: primaryColor.withOpacity(0.15),
                                          width: 1.0,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                          color: primaryColor.withOpacity(0.15),
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                          color: primaryColor.withOpacity(0.15),
                                          width: 1.0,
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 12),
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        if (val.isEmpty) {
                                          val = '1';
                                          _setState = setState;
                                          selectedIndex = val;
                                          model.multiple_contest =
                                              selectedIndex;
                                          apicall = true;
                                          checkBalance(
                                              _currentContestIndex, model);
                                        }
                                        _setState = setState;
                                        selectedIndex = val;
                                        model.multiple_contest = selectedIndex;
                                        apicall = true;
                                        checkBalance(
                                            _currentContestIndex, model);
                                      });
                                    },
                                  ),
                                ),
                              if (joinSimilar == 1) SizedBox(height: 20),

                              // Entry Fees row
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      joinSimilar == 1
                                          ? 'Entry Fees ( ${selectedIndex}X):'
                                          : model.entry_fee_stmt ?? '',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          AppImages.goldcoin,
                                          width: 20,
                                          height: 20,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '${model.entryFee}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),

                              // Usable Cash Bonus row
                              if (model.Usable_cash_bonus_stmt != null)
                                if (model.isBonus == 1 &&
                                    model.Usable_cash_bonus_stmt!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          model.Usable_cash_bonus_stmt ?? '',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              AppImages.goldcoin,
                                              width: 20,
                                              height: 20,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '${model.usableB.toStringAsFixed(0)}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                              if (model.isBonus == 1) SizedBox(height: 20),

                              // Divider
                              Container(
                                height: 1,
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: 20),

                              // To Pay row (highlighted)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      model.to_pay_stmt ?? '',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          AppImages.goldcoin,
                                          width: 22,
                                          height: 22,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '${model.to_pay_amount?.toString().replaceAll('₹', '') ?? '0'}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),

                              // Join button
                              GestureDetector(
                                onTap: () {
                                  if (model.isBonus == 1) {
                                    String? ammounttopay = NumberFormat('#.##')
                                        .format(double.parse(model.to_pay_amount
                                            .toString()
                                            .split('₹')[1]));

                                    if ((model.usableB + model.availableB) <
                                        double.parse(model.to_pay_amount
                                            .toString()
                                            .split('₹')[1])) {
                                      double checkamount =
                                          model.usableB + model.availableB;
                                      double val = double.parse(ammounttopay) -
                                          checkamount;
                                      Platform.isAndroid
                                          ? Navigator.push(
                                              model.context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddBalance('',
                                                          entryFee:
                                                              val.toString(),
                                                          isFromCheck:
                                                              'joinpopup')))
                                          : Navigator.push(
                                              model.context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      AddBalance('',
                                                          entryFee:
                                                              val.toString(),
                                                          isFromCheck:
                                                              'joinpopup')));
                                    } else {
                                      Navigator.pop(model.context);
                                      _setState = null;
                                      apicall = false;
                                      joinChallenge(_currentContestIndex, model,
                                          selectedIndex,
                                          genModel: genModel,
                                          scrollPosition: scrollPosition,
                                          isLineUp: isLineUp);
                                    }
                                  } else {
                                    String? ammounttopay = NumberFormat('#.##')
                                        .format(double.parse(model.to_pay_amount
                                            .toString()
                                            .split('₹')[1]));

                                    if ((model.availableB) <
                                        double.parse(model.to_pay_amount
                                            .toString()
                                            .split('₹')[1])) {
                                      double checkamount =
                                          model.usableB + model.availableB;
                                      double val = double.parse(ammounttopay) -
                                          checkamount;
                                      Platform.isAndroid
                                          ? Navigator.push(
                                              model.context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddBalance('',
                                                          entryFee:
                                                              val.toString(),
                                                          isFromCheck:
                                                              'joinpopup')))
                                          : Navigator.push(
                                              model.context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      AddBalance('',
                                                          entryFee:
                                                              val.toString(),
                                                          isFromCheck:
                                                              'joinpopup')));
                                    } else {
                                      _setState = null;
                                      apicall = false;
                                      Navigator.pop(model.context);
                                      joinChallenge(_currentContestIndex, model,
                                          selectedIndex,
                                          genModel: genModel,
                                          scrollPosition: scrollPosition,
                                          isLineUp: isLineUp);
                                    }
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 58.0),
                                  child: Container(
                                    // width: double.infinity,
                                    // width: 70,

                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: buttonGreenColor,
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                          color: primaryColor,
                                          width: 2,
                                        )),
                                    child: Center(
                                      child: Text(
                                        'JOIN THIS CONTEST',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),

                              // Terms and conditions text
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 0),
                                child: Html(
                                  data:
                                      applyCustomStyles(model.terms_text ?? ''),
                                  onLinkTap: (link, _, __) {
                                    if (link!.contains("admirable")) {
                                      navigateToVisionWebView(model.context,
                                          'Terms & Condition', link);
                                    } else {
                                      navigateToVisionWebView(model.context,
                                          'Privacy Policy', link);
                                    }
                                  },
                                  style: {
                                    'html': Style(
                                      fontSize: FontSize(12),
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: "Roboto",
                                      color: secondaryTextColor,
                                      textDecoration: TextDecoration.none,
                                    ),
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -12,
                      right: -12,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 243, 237, 244),

                              border: Border.all(color: primaryColor),
                              shape: BoxShape.circle,
                              //color: Colors.white,
                            ),
                            child: Icon(
                              Icons.close,
                              color: primaryColor,
                              size: 20,
                            )),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    ).whenComplete(() {
      selectionFunction();
    });
  }

  static void showJoinContestBottomSheet(
    int _currentContestIndex,
    JoinChallengeDataModel model,
    int newIndexForUi_, {
    UsableBalanceItem? result,
    bool? createContest,
    GeneralModel? genModel,
    double? scrollPosition,
    dynamic isgstBonus,
    String? isLineUp,
    int? joinSimilar,
    String? fromSinglePlayer,
    int? notnow,
    String? check,
    int? teamCount,
  }) {
    String selectedIndex = AppConstants.contestJoinCountList[0];
    TextEditingController customXController = TextEditingController();

    showModalBottomSheet(
      enableDrag: true,
      context: model.context,
      isScrollControlled: true, // This is important
      backgroundColor: Colors.transparent,
      builder: (context) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return GestureDetector(
                onTap: () {
                  // Dismiss keyboard when tapping outside
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context)
                        .viewInsets
                        .bottom, // This adjusts for keyboard
                    left: 20,
                    right: 20,
                    top: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(17),
                      topRight: Radius.circular(17),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Confirmation',
                              style: TextStyle(
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),

                        // Balance info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              model.uti_balance_stmt ?? '',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),

                        // Contest selection
                        if (joinSimilar == 1)
                          Text(
                            'Select No. of Contests you want to join',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        SizedBox(height: 8),
                        if (joinSimilar == 1)
                          GridView.count(
                            crossAxisCount: 4,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 8,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 2,
                            children:
                                AppConstants.contestJoinCountList.map((e) {
                              bool isSelected = selectedIndex == e;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _setState = setState;
                                    selectedIndex = e;
                                    model.multiple_contest = selectedIndex;
                                    apicall = true;
                                    checkBalance(_currentContestIndex, model);
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? primaryColor
                                        : Color.fromARGB(255, 250, 230, 230),
                                    border: Border.all(
                                        color: isSelected
                                            ? primaryColor
                                            : Color(0xFFe8adad)),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Text(
                                    '$e X',
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        if (joinSimilar == 1) SizedBox(height: 12),

                        // Custom X input
                        if (joinSimilar == 1)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 6),
                            child: Text(
                              'Enter X Value',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (joinSimilar == 1)
                          TextFormField(
                            controller: customXController,
                            keyboardType: TextInputType.number,
                            maxLength: 3,
                            decoration: InputDecoration(
                              counterText: '',
                              hintStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                              ),
                              hintText: 'Enter X Value',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: primaryColor.withOpacity(
                                      0.15), // You can change the color as per your design
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: primaryColor.withOpacity(
                                      0.15), // You can change the color as per your design
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: primaryColor.withOpacity(
                                      0.15), // The color when the field is focused
                                  width: 1.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                            ),
                            onChanged: (val) {
                              setState(() {
                                if (val.isEmpty) {
                                  val = '1';
                                  _setState = setState;
                                  selectedIndex = val;
                                  model.multiple_contest = selectedIndex;
                                  apicall = true;
                                  checkBalance(_currentContestIndex, model);
                                }
                                _setState = setState;
                                selectedIndex = val;
                                model.multiple_contest = selectedIndex;
                                apicall = true;
                                checkBalance(_currentContestIndex, model);
                              });
                            },
                          ),
                        SizedBox(height: 16),

                        // Confirmation summary
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: borderColor1,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              joinSimilar == 1
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            'Entry Fees ( ₹${model.entryFee} x ${selectedIndex}): '),
                                        Text('₹${model.entryFee}'),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Entry Fees: '),
                                        Text('₹${model.entryFee}'),
                                      ],
                                    ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Divider(
                                  height: 1,
                                  color: borderColor1,
                                ),
                              ),
                              // SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Tod Pay:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('${model.to_pay_amount}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),

                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.popUntil(context,
                                      (route) => route.settings.name == "home");
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Text('Cancel'),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  foregroundColor: Colors.black,
                                  side: BorderSide(color: Colors.grey),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (model.isBonus == 1) {
                                    String? ammounttopay = NumberFormat('#.##')
                                        .format(double.parse(model.to_pay_amount
                                            .toString()
                                            .split('₹')[1]));

                                    if ((model.usableB + model.availableB) <
                                        double.parse(model.to_pay_amount
                                            .toString()
                                            .split('₹')[1])) {
                                      print(double.parse(model.to_pay_amount
                                          .toString()
                                          .split('₹')[1]));
                                      print(ammounttopay);
                                      double checkamount =
                                          model.usableB + model.availableB;
                                      double val = double.parse(ammounttopay) -
                                          checkamount;
                                      Platform.isAndroid
                                          ? Navigator.push(
                                              model.context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddBalance('',
                                                          entryFee:
                                                              val.toString(),
                                                          isFromCheck:
                                                              'joinpopup')))
                                          : Navigator.push(
                                              model.context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      AddBalance('',
                                                          entryFee:
                                                              val.toString(),
                                                          isFromCheck:
                                                              'joinpopup')));
                                    } else {
                                      Navigator.pop(model.context);
                                      _setState = null;
                                      apicall = false;
                                      joinChallenge(_currentContestIndex, model,
                                          selectedIndex,
                                          genModel: genModel,
                                          scrollPosition: scrollPosition,
                                          isLineUp: isLineUp);
                                    }
                                  } else {
                                    String? ammounttopay = NumberFormat('#.##')
                                        .format(double.parse(model.to_pay_amount
                                            .toString()
                                            .split('₹')[1]));

                                    if ((model.availableB) <
                                        double.parse(model.to_pay_amount
                                            .toString()
                                            .split('₹')[1])) {
                                      print(double.parse(model.to_pay_amount
                                          .toString()
                                          .split('₹')[1]));
                                      print(ammounttopay);
                                      double checkamount =
                                          model.usableB + model.availableB;
                                      double val = double.parse(ammounttopay) -
                                          checkamount;
                                      Platform.isAndroid
                                          ? Navigator.push(
                                              model.context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddBalance('',
                                                          entryFee:
                                                              val.toString(),
                                                          isFromCheck:
                                                              'joinpopup')))
                                          : Navigator.push(
                                              model.context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      AddBalance('',
                                                          entryFee:
                                                              val.toString(),
                                                          isFromCheck:
                                                              'joinpopup')));
                                    } else {
                                      _setState = null;
                                      apicall = false;
                                      Navigator.pop(model.context);
                                      joinChallenge(_currentContestIndex, model,
                                          selectedIndex,
                                          genModel: genModel,
                                          scrollPosition: scrollPosition,
                                          isLineUp: isLineUp);
                                    }
                                  }
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Text('Join ${model.to_pay_amount}'),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    ).whenComplete(() {
      selectionFunction();
    });
  }

  static String applyCustomStyles(String htmlContent) {
    // Modify the HTML content to include custom styles for specific texts
    return htmlContent
        .replaceAll(
          RegExp(r'myrex11', caseSensitive: false),
          "<a href='${''}' style='text-decoration: none; color: #c61d24; font-weight: normal;'>myrex11</a>",
        )
        .replaceAll(
          RegExp(r'Terms & Conditions', caseSensitive: false),
          "<a href='${AppConstants.terms_url}' style='text-decoration: none; color: #c61d24; font-weight: normal;'>Terms & Conditions</a>",
        )
        .replaceAll(
          RegExp(r'Privacy Policy', caseSensitive: false),
          "<a href='${AppConstants.privacy_url}' style='text-decoration: none; color: #c61d24; font-weight: normal;'>Privacy Policy</a>",
        );
  }

  static void getCurrentLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            forceAndroidLocationManager: false,
            desiredAccuracy: LocationAccuracy.high);
        var lat = position.latitude;
        var long = position.longitude;
        latitude = "$lat";
        longitude = "$long";
        GetAddressFromLatLong(position);
      } catch (exception) {}
    } else {
      Fluttertoast.showToast(msg: "Please enable location or check network");
    }
  }

  static Future<void> GetAddressFromLatLong(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      state = place.administrativeArea!.toLowerCase();
      // stateOrCountryController.text = '${place.locality}, ${state}, ${place.country}';
      countryname = '${place.country}';
    } catch (e) {
      print([e, "exception===>"]);
    }
  }

  static void joinChallenge(int _currentContestIndex,
      JoinChallengeDataModel model, String? contestNumber,
      {GeneralModel? genModel,
      double? scrollPosition,
      String? isLineUp}) async {
    AppLoaderProgress.showLoader(model.context);
    JoinContestRequest contestRequest = new JoinContestRequest(
      user_id: model.userId.toString(),
      teamid: model.teamId,
      challengeid: model.newChallengeId == 0
          ? model.ChallengeId.toString()
          : model.newChallengeId.toString(),
      fantasy_type_id: CricketTypeFantasy.getCricketType(
          model.selectedFantasyType.toString(),
          sportsKey: model
              .sport_key) /*model.selectedFantasyType==1?"7":model.selectedFantasyType==2 ?"6":"0"*/,
      fantasy_type: model.selectedFantasyType.toString(),
      // slotes_id: model.selectedSlotId.toString(),

      multiple_contest: contestNumber == null ? "1" : contestNumber.toString(),
      matchkey: model.matchKey,
    );
    final client = ApiClient(AppRepository.dio);
    JoinContestResponse response = await client.joinChallenge(contestRequest);
    AppLoaderProgress.hideLoader(model.context);
    contestNumber = '1';
    isSelected = 0;
    if (response.status == 1 && response.result!.length > 0) {
      print(["isThisWokring"]);
      if (response.result![0].status!) {
        /* final Map eventValues = {
          "ToPayAmount": model.to_pay_amount,
          "AvailableBalance": model.availableB.toString(),
          "CUID": model.userId.toString(),
          "ChallangeId": model.newChallengeId.toString(),
          "MatchKey": model.matchKey.toString(),
          "EntryFees": model.entryFee.toString(),
          "EntryFees": model.entryFee.toString(),
        };
        AppFlyerSetup.logEvent('contest_join', eventValues);*/
        getUserBalance(
            model.matchKey,
            model.userId.toString(),
            response.result![0].isjoined!,
            response.result![0].refercode!,
            model.context,
            model.onJoinContestResult,
            scrollPosition: scrollPosition,
            genModel: genModel,
            isLineUp: isLineUp);
        print(["isThisWokring1"]);

        Fluttertoast.showToast(
            msg: response.message ?? '',
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1);

        if (model.leaderboardApi != null) {
          model.leaderboardApi!();
          print(["leaderbo"]);
        }
      }
    } else if (response.status == 0) {
      print(["isThisWokring2"]);
      model.newChallengeId = response.new_challenge_id!;
      Fluttertoast.showToast(msg: response.message!);
      if (model.newChallengeId != 0) {
        checkBalance(_currentContestIndex, model);
      } else {
        Fluttertoast.showToast(msg: response.message!);
        Navigator.pop(model.context);
      }
    } else {
      Fluttertoast.showToast(
          msg: response.message!,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1);
      model.onJoinContestResult(0, '');
    }
  }

  static void getUserBalance(String matchKey, String userId, int isJoined,
      String referCode, BuildContext context, Function onJoinContestResult,
      {GeneralModel? genModel,
      double? scrollPosition,
      String? isLineUp}) async {
    GeneralRequest loginRequest =
        new GeneralRequest(user_id: userId, fcmToken: '', matchkey: matchKey);
    final client = ApiClient(AppRepository.dio);
    MyBalanceResponse myBalanceResponse =
        await client.getUserBalance(loginRequest);
    if (myBalanceResponse.status == 1 && myBalanceResponse.result!.length > 0) {
      MyBalanceResultItem myBalanceResultItem = myBalanceResponse.result![0];
      AppPrefrence.putString(AppConstants.KEY_USER_BALANCE,
          myBalanceResultItem.balance.toString());
      AppPrefrence.putString(AppConstants.KYC_VERIFIED,
          myBalanceResultItem.kyc_verified.toString());
      AppPrefrence.putString(AppConstants.KEY_USER_WINING_AMOUNT,
          myBalanceResultItem.winning.toString());
      AppPrefrence.putString(AppConstants.KEY_USER_BONUS_BALANCE,
          myBalanceResultItem.bonus.toString());
      AppPrefrence.putString(AppConstants.KEY_USER_TOTAL_BALANCE,
          myBalanceResultItem.total.toString());
      onJoinContestResult(isJoined, referCode);

      // Fluttertoast.showToast(
      //     msg: 'You have Successfully join this contest',
      //     toastLength: Toast.LENGTH_SHORT,
      //     timeInSecForIosWeb: 1);

      //Navigator.of(context).pop();
      // if (isLineUp != null && isLineUp == "1") {
      //   Navigator.of(context).pop();
      // }
      /* if(genModel!=null){
        navigateToUpcomingContests(context,genModel,scrollPosition: scrollPosition);
      }*/
    }
    // Fluttertoast.showToast(
    //     msg: myBalanceResponse.message!,
    //     toastLength: Toast.LENGTH_SHORT,
    //     timeInSecForIosWeb: 1);
  }

  static void onShare(
      BuildContext context, Contest contest, GeneralModel model) async {
    String shareBody = "Hi, Inviting you to join " +
        AppConstants.APP_NAME +
        " and play fantasy sports to win cash daily.\n" +
        "Use Contest code - " +
        contest.refercode! +
        "\nTo join this Exclusive invite-only contest on " +
        AppConstants.APP_NAME +
        " for the " +
        model.teamVs! +
        " match, Download App from~ " +
        AppConstants.apk_url;
    final RenderBox box = context.findRenderObject() as RenderBox;
    await Share.share(shareBody,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  static void showWinningPopup(BuildContext context,
      List<WinnerScoreCardItem> breakupList, String winAmount) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        builder: (builder) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Container(
                padding: EdgeInsets.all(10),
                child: new Text(
                  'Winners Rank Calculation',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
              new Container(
                padding: EdgeInsets.only(bottom: 10),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Text(
                      'Total Winnings ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                    new Text(
                      winAmount,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                color: primaryColor,
                height: 40,
                alignment: Alignment.center,
                padding: EdgeInsets.all(5),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Text(
                      'Winning Position',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    new Text(
                      "Winning Amount",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                child: new ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: breakupList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        height: 40,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(5),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            new Text(
                              breakupList[index].start_position!,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            new Text(
                              breakupList[index].price.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      );
                    }),
              )),
              new Container(
                color: bgColor,
                alignment: Alignment.center,
                padding: EdgeInsets.all(5),
                child: new Text(
                  "Note: The actual price money may be different than the prize money mentioned above if there is a tie for any of the winning position. As per goverment regulations, a tax of 30% will be deducted if an individual wins more than ₹ 10,000.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w400),
                ),
              )
            ],
          );
        });
  }

  String prettify(double d) =>
      d.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '');

  static bool userVarified() {
    bool user = false;
    AppPrefrence.getBoolean(AppConstants.USER_VERIFIED)
        .then((value) => {user = value});
    print(user);
    if (user) {
      return true;
    } else {
      return false;
    }
  }

  static String getAmountPercentageWithLess(
      dynamic bonus_percent, dynamic entryfee) {
    return (double.parse(entryfee) -
            ((int.parse(bonus_percent.toString()) *
                    double.parse(entryfee.toString())) /
                100))
        .toString();
  }

  static String getAmountPercentage(dynamic bonus_percent, dynamic entryfee) {
    return (((int.parse(bonus_percent.toString()) *
                double.parse(entryfee.toString())) /
            100))
        .toString();
  }

  static String gstCoinsWalletChacking(
      String? isgstBonus,
      int? contestNumber,
      JoinChallengeDataModel model,
      String? wallet_bonus,
      String? wallet_gstbonus) {
    if (isgstBonus == "1") {
      if (wallet_gstbonus == "0") {
        return "0";
      } else {
        if (double.parse(getUseableBalance(isgstBonus, contestNumber, model)) <=
            double.parse(wallet_gstbonus.toString())) {
          return double.parse(
                  getUseableBalance(isgstBonus, contestNumber, model))
              .toStringAsFixed(2); // wallet_gstbonus!;
        } else if (double.parse(
                    getUseableBalance(isgstBonus, contestNumber, model)) >
                0 &&
            double.parse(getUseableBalance(isgstBonus, contestNumber, model)) >=
                double.parse(wallet_gstbonus.toString())) {
          return wallet_gstbonus
              .toString(); /*(double.parse(getUseableBalance(isgstBonus, contestNumber, model))-double.parse(wallet_gstbonus.toString())).toString();*/
        } else {
          return getUseableBalance(isgstBonus, contestNumber, model);
        }
      }
    } else {
      if (wallet_bonus == "0") {
        return "0";
      } else {
        if (double.parse(getUseableBalance(isgstBonus, contestNumber, model)) <=
            double.parse(wallet_bonus.toString())) {
          return double.parse(
                  getUseableBalance(isgstBonus, contestNumber, model))
              .toStringAsFixed(2);
        } else if (double.parse(
                    getUseableBalance(isgstBonus, contestNumber, model)) >
                0 &&
            double.parse(getUseableBalance(isgstBonus, contestNumber, model)) >=
                double.parse(wallet_bonus.toString())) {
          return wallet_bonus
              .toString(); //(double.parse(getUseableBalance(isgstBonus, contestNumber, model))-double.parse(wallet_bonus.toString())).toString();
        } else {
          return getUseableBalance(isgstBonus, contestNumber, model);
        }
      }
    }
  }

  static String getUseableBalance(
      String? isgstBonus, int? contestNumber, JoinChallengeDataModel model) {
    if (isgstBonus == "1") {
      if (contestNumber != null && contestNumber > 0) {
        return (double.parse(getAmountPercentage(
                    model.bonusPercentage.replaceAll("%", "").toString().trim(),
                    model.entryFee)) *
                double.parse(contestNumber.toString()))
            .toString();
      } else {
        return double.parse(getAmountPercentage(
                model.bonusPercentage.replaceAll("%", "").toString().trim(),
                model.entryFee))
            .toString();
      }
    } else {
      if (contestNumber != null && contestNumber > 0) {
        return (double.parse(contestNumber.toString()) *
                double.parse((NumberFormat('#.##').format(model.usableB))))
            .toString();
      } else {
        return (NumberFormat('#.##').format(model.usableB));
      }
    }

    return isgstBonus == 1
        ? contestNumber == null
            ? '₹' + (NumberFormat('#.##').format(model.usableB))
            : (double.parse(getAmountPercentage(
                        model.bonusPercentage
                            .replaceAll("%", "")
                            .toString()
                            .trim(),
                        model.entryFee)) *
                    double.parse(
                        contestNumber == null ? "1" : contestNumber.toString()))
                .toString()
        : contestNumber != null
            ? '₹' +
                (double.parse((NumberFormat('#.##').format(model.usableB))) *
                        double.parse(contestNumber.toString()))
                    .toString()
            : '₹' + (NumberFormat('#.##').format(model.usableB));
  }

  static String getRealAmount(int? contestNumber, JoinChallengeDataModel model,
      String? isgstBonus, String? wallet_gstbonus) {
    if (contestNumber != null) {
      if (wallet_gstbonus == "0") {
        return (NumberFormat('#.##')
                .format(double.parse(model.entryFee) * model.totalSelected))
            .toString();
      } else {
        if (double.parse(getUseableBalance(isgstBonus, contestNumber, model)) >
                0 &&
            double.parse(getUseableBalance(isgstBonus, contestNumber, model)) >=
                double.parse(wallet_gstbonus.toString())) {
          if (contestNumber == 0) {
            return ((double.parse((NumberFormat('#.##').format(
                        double.parse(model.entryFee) * model.totalSelected)))) -
                    double.parse(wallet_gstbonus.toString()))
                .toString();
          } else {
            return ((double.parse((NumberFormat('#.##').format(
                        double.parse(model.entryFee) *
                            double.parse(contestNumber
                                .toString()) /** model.totalSelected*/)))) -
                    double.parse(wallet_gstbonus.toString()))
                .toString();
          }
        } else {
          return (double.parse((NumberFormat('#.##').format(double.parse(
                          model.entryFee) *
                      double.parse(
                          contestNumber.toString()) /*model.totalSelected*/))) -
                  double.parse(getAmountPercentage(
                          model.bonusPercentage
                              .replaceAll("%", "")
                              .toString()
                              .trim(),
                          model.entryFee)) *
                      double.parse(contestNumber.toString()))
              .toString();
        }
      }
    } else {
      if (wallet_gstbonus == "0") {
        return (NumberFormat('#.##')
                .format(double.parse(model.entryFee) * model.totalSelected))
            .toString();
      } else {
        if (double.parse(getAmountPercentage(
                model.bonusPercentage.replaceAll("%", "").toString().trim(),
                model.entryFee)) >=
            double.parse(wallet_gstbonus.toString())) {
          return (double.parse((NumberFormat('#.##').format(
                      double.parse(model.entryFee) * model.totalSelected))) -
                  double.parse(wallet_gstbonus.toString()))
              .toString();
        } else {
          return (double.parse((NumberFormat('#.##').format(
                      double.parse(model.entryFee) * model.totalSelected))) -
                  double.parse(getAmountPercentage(
                      model.bonusPercentage
                          .replaceAll("%", "")
                          .toString()
                          .trim(),
                      model.entryFee)))
              .toString();
        }
      }
    }
  }
}
