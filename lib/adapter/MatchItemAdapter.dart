import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:need_resume/need_resume.dart';
import 'package:myrex11/appUtilities/defaultbutton.dart';
import 'package:myrex11/views/UpcomingContests.dart';
import 'package:get/get.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/date_utils.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/customWidgets/ScrollingText.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/banner_response.dart';
import 'package:myrex11/repository/model/base_request.dart';
import 'package:myrex11/repository/model/base_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';
import '../GetXController/HomeMatchesGetController.dart';
import 'package:myrex11/customWidgets/VisionCustomTimerController.dart';
import '../customWidgets/VisionCustomTimer.dart';
import '../customWidgets/VisionCustomTimerRemainingTime.dart';

class MatchItemAdapter extends StatefulWidget {
  late List<MatchDetails> list;
  late MatchDetails matchDetails;
  Function onMatchTimeUp;
  Function getMatchList;
  Function pullRefresh;
  Function bannerList;
  int index;
  bool? accountverified;
  VisionCustomTimerController controller;
  HomeMatchesGetController getController;
  String? check;
  Function? balanceUpdate;

  MatchItemAdapter(
      this.accountverified,
      this.list,
      this.matchDetails,
      this.onMatchTimeUp,
      this.index,
      this.controller,
      this.getController,
      this.getMatchList,
      this.pullRefresh,
      this.bannerList,
      {this.check,
      this.balanceUpdate});

  @override
  _MatchItemAdapterState createState() => new _MatchItemAdapterState();
}

class _MatchItemAdapterState extends ResumableState<MatchItemAdapter> {
  late String userId = '0';
  late DateTime endTime;
  final homeMatchesGetController = Get.put(HomeMatchesGetController());

  @override
  void initState() {
    super.initState();
    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
        .then((value) => {
              setState(() {
                userId = value;
              })
            });
    calculateEndTime();
    if (Platform.isAndroid) {
      startAlarm();
    }
  }

  @override
  void dispose() {
    stopAlarm();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      print('mytimerHome');
      // setState(() {
      //   resetAndSetTimer();
      // });
    } else if (state == AppLifecycleState.resumed) {
      if (Platform.isIOS) {
        setState(() {
          Future.delayed(Duration(milliseconds: 200), () {
            resetAndSetTimer();
            print('mytimerresumehome');
          });
        });
      }

      print('mytimerresume');
    }
  }

  void resetAndSetTimer() {
    // Get current time
    DateTime currentTime = MethodUtils.getDateTime();

    // Parse the header text into a DateTime object
    DateTime startTime =
        DateFormat.getFormattedDateObj(widget.matchDetails.time_start!)!;

    // Calculate the difference
    Duration timeDifference = startTime.difference(currentTime);

    if (timeDifference.isNegative) {
      // Handle the case where the match time has already passed
      print('The match has already started or ended');
    } else {
      // Reset and set the timer controller to the time difference
      widget.controller.reset();
      widget.controller.start();
    }
  }

  void calculateEndTime() {
    DateTime currentTime = MethodUtils.getDateTime();
    DateTime startTime =
        DateFormat.getFormattedDateObj(widget.matchDetails.time_start!)!;
    endTime = startTime.add(Duration(
        milliseconds: startTime.millisecondsSinceEpoch -
            currentTime.millisecondsSinceEpoch));
  }

  void onTimeUp() {}

  void startAlarm() {
    int alarmId = 0;
    AndroidAlarmManager.oneShotAt(
      endTime,
      alarmId,
      alarmCallback,
      exact: true,
      wakeup: true,
    );
  }

  void stopAlarm() {
    int alarmId = 0;
    if (Platform.isAndroid) {
      AndroidAlarmManager.cancel(alarmId);
    }
  }

  void alarmCallback() {}

  void onResume() {
    super.onResume();
    setState(() {
      calculateEndTime();
      startAlarm();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: new GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            widget.matchDetails.toss!.isNotEmpty
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/toss_bg.png"),
                            fit: BoxFit.fill)),
                    height: 40,
                    margin: EdgeInsets.only(left: 0, right: 0, top: 135),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image(
                            height: 15,
                            width: 15,
                            image: AssetImage(
                              AppImages.megaphoneIcon1,
                            ),
                            // color: orangeColor2,
                          ),
                          widget.matchDetails.toss!.length > 35
                              ? Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(left: 5),
                                    child: ScrollingText(
                                      text: widget.matchDetails.toss!,
                                      textStyle: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12),
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text(
                                      widget.matchDetails.toss!,
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Color(0xFF076e39),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12),
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                  )
                : Container(),
            widget.matchDetails.highlights!.isNotEmpty
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      color: Color(0xffA66DFB).withOpacity(0.15),
                      // image: DecorationImage(
                      //     image: AssetImage("assets/images/toss_bg.png"),
                      //     fit: BoxFit.fill),
                    ),
                    height: 40,
                    margin: EdgeInsets.only(left: 0, right: 0, top: 135),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 9),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image(
                            height: 15,
                            width: 15,
                            image: AssetImage(
                              AppImages.megaphoneIcon1,
                            ),
                            color: primaryColor,
                            // color: orangeColor2,
                          ),
                          widget.matchDetails.highlights!.length > 45
                              ? Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(left: 5),
                                    child: ScrollingText(
                                      text:
                                          widget.matchDetails.highlights ?? "",
                                      textStyle: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12),
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text(
                                      widget.matchDetails.highlights ?? '',
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12),
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                  )
                : Container(),
            Opacity(
              opacity: widget.matchDetails.is_fixture == 1 ? 0.4 : 1.0,
              child: Card(
                elevation: 0.5,
                // color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Circular radius
                  side: BorderSide(
                      color: Colors.transparent,
                      width: 1), // Border color and width
                ),
                margin: EdgeInsets.only(
                    top: 10,
                    //bottom: (widget.matchDetails.highlights != null && widget.matchDetails.highlights!.isNotEmpty) || (widget.matchDetails.toss!.isNotEmpty) ? 25 : 14),
                    bottom: (4)),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 28,
                        margin: EdgeInsets.only(
                          top: 5,
                          bottom: 1,
                          left: 10,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            // margin: EdgeInsets.only(top: ),
                            child: Center(
                              child: Text(
                                widget.matchDetails.name ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  color: Color(0xff666666),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        // margin: EdgeInsets.only(left: 20,right: 20,top: 6),
                        height: 1,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/ic_graident.png"),
                                fit: BoxFit.cover)),
                      ),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            /* decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                              colors: [MethodUtils.hexToColor(widget.matchDetails.team1_color!).withOpacity(.1), Colors.white.withOpacity(.05),MethodUtils.hexToColor(widget.matchDetails.team2_color!).withOpacity(.1)],)
                        ),*/
                            padding: EdgeInsets.only(bottom: 0),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      ShaderMask(
                                        blendMode: BlendMode.srcATop,
                                        shaderCallback: (Rect bounds) {
                                          return LinearGradient(
                                            colors: [
                                              MethodUtils.hexToColor(widget
                                                      .matchDetails
                                                      .team1_color!)
                                                  .withOpacity(.2),
                                              Colors.white
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ).createShader(bounds);
                                        },
                                        child: Image.asset(
                                          AppImages.home_match_item_bg_left,
                                        ),
                                      ),
                                      Container(
                                        width: 220,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Stack(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  children: [
                                                    Container(
                                                      height: 20,
                                                      width: 110,
                                                      child: Image(
                                                        image: AssetImage(
                                                            AppImages
                                                                .leftTeamIcon),
                                                        fit: BoxFit.fill,
                                                        color: MethodUtils
                                                                .hexToColor(widget
                                                                    .matchDetails
                                                                    .team1_color!)
                                                            .withOpacity(.01),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 7),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                            child: Container(
                                                              height: 30,
                                                              width: 30,
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: widget
                                                                    .matchDetails
                                                                    .team1logo!,
                                                                placeholder: (context,
                                                                        url) =>
                                                                    Image.asset(
                                                                  AppImages
                                                                      .logoPlaceholderURL,
                                                                ),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Image.asset(
                                                                  AppImages
                                                                      .logoPlaceholderURL,
                                                                ),
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 0),
                                                                width: 60,
                                                                child: Text(
                                                                    widget
                                                                        .matchDetails
                                                                        .team1display!,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "Roboto",
                                                                        color:
                                                                            lightBlack,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            14)),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  flex: 1,
                                ),
                                Flexible(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        // VS Image in the middle

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            widget.matchDetails
                                                        .unlimited_credit_match ==
                                                    1
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 0, top: 5),
                                                    child: Text(
                                                        widget.matchDetails
                                                            .unlimited_credit_text!,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Roboto",
                                                            color: Color(
                                                                0xFFe6a100),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 13)),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  flex: 1,
                                ),
                                Flexible(
                                  child: Stack(
                                    alignment: Alignment.centerRight,
                                    children: [
                                      ShaderMask(
                                        blendMode: BlendMode.srcATop,
                                        shaderCallback: (Rect bounds) {
                                          return LinearGradient(
                                            colors: [
                                              MethodUtils.hexToColor(widget
                                                      .matchDetails
                                                      .team2_color!)
                                                  .withOpacity(.2),
                                              Colors.white
                                            ],
                                            begin: Alignment.centerRight,
                                            end: Alignment.centerLeft,
                                          ).createShader(bounds);
                                        },
                                        child: Image.asset(
                                          AppImages.home_match_item_bg_right,
                                        ),
                                      ),
                                      Container(
                                        width: 220,
                                        child: new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Stack(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  children: [
                                                    new Container(
                                                      height: 20,
                                                      width: 110,
                                                      child: Image(
                                                        image: AssetImage(
                                                            AppImages
                                                                .rightTeamIcon),
                                                        fit: BoxFit.fill,
                                                        color: MethodUtils
                                                                .hexToColor(widget
                                                                    .matchDetails
                                                                    .team2_color!)
                                                            .withOpacity(.01),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 5),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 0),
                                                                width: 60,
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: Text(
                                                                    widget
                                                                        .matchDetails
                                                                        .team2display!,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "Roboto",
                                                                        color:
                                                                            lightBlack,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            14)),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 7),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                            child: Container(
                                                              height: 30,
                                                              width: 30,
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: widget
                                                                    .matchDetails
                                                                    .team2logo!,
                                                                placeholder: (context,
                                                                        url) =>
                                                                    Image.asset(
                                                                  AppImages
                                                                      .logoPlaceholderURL,
                                                                  //   color: Colors.grey
                                                                ),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Image.asset(
                                                                  AppImages
                                                                      .logoPlaceholderURL,
                                                                  //   color: Colors.grey
                                                                ),
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  flex: 1,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 2),
                            child: Image.asset(
                              AppImages.home_match_item_middle,
                              height: 24,
                              width: 242,
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 100,
                                  margin: EdgeInsets.only(
                                      bottom: 0, left: 10, top: 2),
                                  child: new Text(
                                    widget.matchDetails.team1name!,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        color: lightBlack,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10),
                                  ),
                                ),
                                Container(
                                  width: 105,
                                  margin: EdgeInsets.only(
                                      bottom: 0, right: 8, top: 2),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    widget.matchDetails.team2name!,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        color: lightBlack,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Container(
                              // alignment: Alignment.center,
                              child: VisionCustomTimer(
                                from: Duration(
                                    seconds: DateFormat.getFormattedDateObj(
                                            widget.matchDetails.time_start!)!
                                        .difference(MethodUtils.getDateTime())
                                        .inSeconds),
                                to: Duration(seconds: 0),
                                controller: widget.controller,
                                onBuildAction: CustomTimerAction.auto_start,
                                builder: (CustomTimerRemainingTime remaining) {
                                  if (remaining.hours == '00' &&
                                          remaining.minutes == '00' &&
                                          remaining.seconds == '00' ||
                                      (remaining.minutes.contains('-') ||
                                          remaining.seconds.contains('-'))) {
                                    if (widget.check == 'home') {
                                      AppConstants.fromHomeScreen = true;
                                      widget.controller.pause();
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        print('myHOme');
                                        widget.pullRefresh();

                                        // widget.bannerList();
                                      });
                                    }
                                    // widget.onMatchTimeUp(widget.index);
                                    // widget.getController.TimeFunction(remaining.minutes, remaining.seconds, widget.index);
                                  }
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: Text(
                                          getTime(remaining),
                                          style: TextStyle(
                                              // fontFamily: "Roboto",
                                              color: lightBlack,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: Text(
                                          ' | ${widget.matchDetails.match_date}',
                                          style: TextStyle(
                                              // fontFamily: "Roboto",
                                              color: lightBlack,
                                              fontSize: 11,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Divider(
                      //   color: Color(0xFFFFE8E8),
                      //   thickness: 1,
                      //   height: 1.5,
                      // ),
                      Container(
                        decoration: BoxDecoration(
                          // image: DecorationImage(
                          //     image: AssetImage(
                          //         "assets/images/bottom_match_bg.png"),
                          //     fit: BoxFit.fill),
                          color: Color(0xffF1E7FF),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.matchDetails.mega_contest_prize!.isNotEmpty
                                ? Expanded(
                                    // <-- Wrap with Expanded
                                    child: Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                          // image: DecorationImage(
                                          //   image: AssetImage(
                                          //       AppImages.giveAwayIconURL),
                                          //   fit: BoxFit.fill,
                                          // ),
                                          ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 9, right: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 6),
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                child: Image.asset(
                                                    AppImages.trophyicon),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 6),
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                child: Image.asset(
                                                    AppImages.goldcoin),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 50,
                                              child: Text(
                                                widget.matchDetails
                                                    .mega_contest_prize
                                                    .toString(),
                                                style: TextStyle(
                                                  fontFamily: "Roboto",
                                                  color: secondaryTextColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Spacer(),

                            SizedBox(width: 8), // Add some spacing

                            Expanded(
                              // <-- Wrap with Expanded
                              child: Container(
                                height: 35,
                                width: MediaQuery.of(context).size.width /
                                    2.1, // Optional
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    widget.matchDetails.lineup == 1
                                        ? Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(
                                                right: 10, left: 0, top: 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: 5, right: 5),
                                                  height: 21,
                                                  // width: 37,
                                                  child: Image(
                                                      image: AssetImage(
                                                          AppImages
                                                              .lineupsout)),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 0),
                                                  child: Text(
                                                    'Lineups Out',
                                                    style: TextStyle(
                                                        fontFamily: 'roboto',
                                                        color: greenColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              remindMeDialog(widget.matchDetails
                                                  .is_notification_subscribed);
                                            },
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                height: 21,
                                                width: 37,
                                                child: widget.matchDetails
                                                            .is_notification_subscribed ==
                                                        1
                                                    ? Image(
                                                        image: AssetImage(
                                                          AppImages
                                                              .notification_check,
                                                        ),
                                                        color: primaryColor,
                                                      )
                                                    : Image(
                                                        image: AssetImage(
                                                        AppImages.bellicon,
                                                      ))),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        onTap: () =>
            "${widget.getController.HomeSecTestTimingVariable}:${widget.getController.HomeSecTestTimingVariable}" ==
                    "00:-1"
                ? null
                : {
                    if (widget.matchDetails.is_fixture == 1)
                      {
                        MethodUtils.showOrange(context,
                            "Contests for this match will open soon. Stay tuned!")
                      }
                    else
                      {
                        setState(() {
                          widget.check = '';
                          AppConstants.homecount = 0;
                          AppConstants.onContestScreen = true;
                        }),
                        Platform.isAndroid
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpcomingContests(new GeneralModel(
                                      toss: widget.matchDetails.toss,
                                      isaccountverified: widget.accountverified,
                                      seriesName:
                                          widget.matchDetails.seriesname,
                                      bannerImage:
                                          widget.matchDetails.banner_image,
                                      matchKey: widget.matchDetails.matchkey,
                                      teamVs: (widget
                                              .matchDetails.team1display! +
                                          ' VS ' +
                                          widget.matchDetails.team2display!),
                                      firstUrl: widget.matchDetails.team1logo,
                                      secondUrl: widget.matchDetails.team2logo,
                                      headerText:
                                          widget.matchDetails.time_start,
                                      sportKey: widget.matchDetails.sport_key,
                                      battingFantasy:
                                          widget.matchDetails.battingfantasy,
                                      bowlingFantasy:
                                          widget.matchDetails.bowlingfantasy,
                                      liveFantasy:
                                          widget.matchDetails.livefantasy,
                                      secondInningFantasy:
                                          widget.matchDetails.secondinning,
                                      reverseFantasy:
                                          widget.matchDetails.reversefantasy,
                                      fantasySlots: widget.matchDetails.slotes,
                                      team1Name: widget.matchDetails.team1name,
                                      team2Name: widget.matchDetails.team2name,
                                      team1Logo: widget.matchDetails.team1logo,
                                      team2Logo: widget.matchDetails.team2logo,
                                      unlimited_credit_match: widget
                                          .matchDetails.unlimited_credit_match,
                                      unlimited_credit_text: widget
                                          .matchDetails.unlimited_credit_text)),
                                  settings: RouteSettings(name: "home"),
                                )).then((value) {
                                widget.check = 'home';
                                widget.balanceUpdate!();
                                AppConstants.onContestScreen = false;
                                print(AppConstants.onContestScreen);
                                print(widget.check);
                              })
                            : Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => UpcomingContests(new GeneralModel(
                                        toss: widget.matchDetails.toss,
                                        isaccountverified:
                                            widget.accountverified,
                                        seriesName:
                                            widget.matchDetails.seriesname,
                                        bannerImage:
                                            widget.matchDetails.banner_image,
                                        matchKey: widget.matchDetails.matchkey,
                                        teamVs: (widget
                                                .matchDetails.team1display! +
                                            ' VS ' +
                                            widget.matchDetails.team2display!),
                                        firstUrl: widget.matchDetails.team1logo,
                                        secondUrl:
                                            widget.matchDetails.team2logo,
                                        headerText:
                                            widget.matchDetails.time_start,
                                        sportKey: widget.matchDetails.sport_key,
                                        battingFantasy:
                                            widget.matchDetails.battingfantasy,
                                        bowlingFantasy:
                                            widget.matchDetails.bowlingfantasy,
                                        liveFantasy:
                                            widget.matchDetails.livefantasy,
                                        secondInningFantasy:
                                            widget.matchDetails.secondinning,
                                        reverseFantasy:
                                            widget.matchDetails.reversefantasy,
                                        fantasySlots:
                                            widget.matchDetails.slotes,
                                        team1Name:
                                            widget.matchDetails.team1name,
                                        team2Name:
                                            widget.matchDetails.team2name,
                                        team1Logo: widget.matchDetails.team1logo,
                                        team2Logo: widget.matchDetails.team2logo,
                                        unlimited_credit_match: widget.matchDetails.unlimited_credit_match,
                                        unlimited_credit_text: widget.matchDetails.unlimited_credit_text)))).then((value) {
                                // setState(() {
                                //   // Future.delayed(Duration(milliseconds: 400),
                                //   //     () {
                                //   //   widget.getMatchList();
                                //   //   //widget.bannerList();
                                //   //   AppConstants.createTimeUp = false;
                                //   // });

                                // });
                                widget.getMatchList(showloading: true);
                                widget.balanceUpdate!();
                                widget.check = 'home';
                                print(widget.check);
                              })
                      }
                  },
      ),
    );
  }

  void remindMeDialog(isMatchAlert) {
    AlertDialog alertDialog = AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 0.0),
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text("Match alert",
          style: TextStyle(fontFamily: "Roboto", color: Colors.black)),
      content: Text(
          "Remind me when match " +
              widget.matchDetails.team1display! +
              " vs " +
              widget.matchDetails.team2display! +
              " is about to start (before 25 min)",
          style: TextStyle(
            fontFamily: "Roboto",
            color: Colors.grey,
          )),
      actions: [
        continueButton(context)
        /*if(isMatchAlert==0)
          continueButton(context)
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              noButton(context),
              yesButton(context)
            ],
          )*/
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  Widget yesButton(context) {
    return DefaultButton(
      text: "YES",
      onpress: () {
        remindMe();
      },
    );
  }

  Widget noButton(context) {
    return DefaultButton(
      text: "NO",
      onpress: () {
        Navigator.pop(context);
      },
    );
  }

  Widget continueButton(context) {
    return DefaultButton(
      borderRadius: 20,
      text: "REMIND ME",
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.3,
      color: primaryColor,
      textcolor: Colors.white,
      onpress: () {
        remindMe();
      },
    );
  }

  void remindMe() async {
    AppLoaderProgress.showLoader(context);
    GeneralRequest loginRequest = new GeneralRequest(
        user_id: userId, matchkey: widget.matchDetails.matchkey);
    final client = ApiClient(AppRepository.dio);
    GeneralResponse myBalanceResponse = await client.remindMe(loginRequest);
    AppLoaderProgress.hideLoader(context);
    if (myBalanceResponse.status == 1) {
      Navigator.pop(context);
      widget.getMatchList(showloading: true);
    }
    Fluttertoast.showToast(
        msg: myBalanceResponse.message!,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1);
  }

  String getTime(CustomTimerRemainingTime remaining) {
    return int.parse(remaining.days) >= 1
        ? int.parse(remaining.days) > 1
            ? "${remaining.days} Days"
            : "${remaining.days} Day "
        : int.parse(remaining.hours) >= 1
            ? ("${remaining.hours}h : ${remaining.minutes}m ")
            : " ${remaining.minutes}m : ${remaining.seconds == '-1' ? "00" : remaining.seconds}s";
  }
}
