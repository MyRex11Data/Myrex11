import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:need_resume/need_resume.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/app_navigator.dart';
import 'package:myrex11/appUtilities/date_utils.dart';
import 'package:myrex11/appUtilities/defaultbutton.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/customWidgets/VisionCustomTimer.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/banner_response.dart';
import 'package:myrex11/repository/model/base_request.dart';
import 'package:myrex11/repository/model/base_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';
import '../customWidgets/VisionCustomTimerController.dart';
import '../customWidgets/VisionCustomTimerRemainingTime.dart';
import '../views/UpcomingContests.dart';

class UserMyMatchesItemAdapter extends StatefulWidget {
  late MatchDetails matchDetails;
  Function pullRefresh;
  Function getBannerList;
  String? sport_key;
  String? check;
  Function? balanceUpdate;

  UserMyMatchesItemAdapter(
    this.matchDetails,
    this.pullRefresh,
    this.getBannerList,
    this.sport_key, {
    this.check,
  });

  @override
  _UserMyMatchesItemAdapterState createState() =>
      new _UserMyMatchesItemAdapterState();
}

class _UserMyMatchesItemAdapterState
    extends ResumableState<UserMyMatchesItemAdapter> {
  // final CustomTimerController controller = CustomTimerController();
  late DateTime endTime;
  late String userId = '0';
  final VisionCustomTimerController controller = VisionCustomTimerController();

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
      if (Platform.isIOS || Platform.isAndroid) {
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
      controller.reset();
      controller.start();
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

  void alarmCallback() {
    // You can perform any action you want when the alarm goes off
    // For example, navigate to the home page
    // if (!AppConstants.candvcTimeUp) {
    //   AppConstants.createTimeUp = true;
    //   // Note: Navigating to the homepage directly from here might not work,
    //   // you might need to use a notification or other method to inform the app.
    // }
  }
  void onResume() {
    super.onResume();
    setState(() {
      calculateEndTime();
      startAlarm();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: Container(
            // height: 180,
            margin: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 0),
            child: Card(
              // shadowColor: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  // Container(
                  //   margin: EdgeInsets.only(top: 7),
                  //   child: new Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       // Row(
                  //       //   children: [
                  //       //     widget.matchDetails.lineup == 1
                  //       //         ? new Container(
                  //       //             alignment: Alignment.center,
                  //       //             child: new Row(
                  //       //               children: [
                  //       //                 new Container(
                  //       //                   margin: EdgeInsets.only(
                  //       //                       left: 5, right: 5),
                  //       //                   height: 10,
                  //       //                   width: 10,
                  //       //                   child: Image(
                  //       //                       image: AssetImage(
                  //       //                           AppImages.lineupOutImageURL)),
                  //       //                 ),
                  //       //                 new Container(
                  //       //                   margin: EdgeInsets.only(top: 2),
                  //       //                   child: new Text('LINEUPS OUT',
                  //       //                       style: TextStyle(
                  //       //                           fontFamily: "Roboto",
                  //       //                           color: primaryColor,
                  //       //                           fontWeight: FontWeight.w600,
                  //       //                           fontSize: 12)),
                  //       //                 ),
                  //       //               ],
                  //       //             ),
                  //       //           )
                  //       //         : SizedBox.shrink(),
                  //       //   ],
                  //       // ),
                  //       Container(
                  //         width: MediaQuery.of(context).size.width * 0.65,
                  //         // margin:
                  //         child: Padding(
                  //           padding:
                  //               EdgeInsets.only(left: 10, top: 10, bottom: 3),
                  //           child: Text(
                  //             widget.matchDetails.name!,
                  //             overflow: TextOverflow.ellipsis,
                  //             style: TextStyle(
                  //                 fontFamily: "Roboto",
                  //                 //fontFamily: "Roboto",
                  //                 color: Color(0xff747474),
                  //                 fontWeight: FontWeight.w400,
                  //                 fontSize: 12),
                  //           ),
                  //         ),
                  //       ),
                  //       widget.matchDetails.lineup == 1
                  //           ? Padding(
                  //               padding: const EdgeInsets.only(right: 6),
                  //               child: Container(
                  //                 // padding: EdgeInsets.all(2),
                  //                 child: Container(
                  //                   width: 83,
                  //                   height: 18,
                  //                   child: Image(
                  //                     image: AssetImage(
                  //                       AppImages.lineupimg_bell,
                  //                     ), //color: Colors.amber,
                  //                   ),
                  //                 ),
                  //               ),
                  //             )
                  //           : SizedBox.shrink(),
                  //     ],
                  //   ),
                  // ),
                  // Divider(
                  //   height: 1,
                  // ),
                  // Spacer(),
                  Container(
                    height: 20,
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
                            widget.matchDetails.name!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: "Roboto",
                              color: Color(0xff202b3d),
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
                            image: AssetImage("assets/images/ic_graident.png"),
                            fit: BoxFit.cover)),
                  ),
                  Stack(
                    alignment: Alignment.center,
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
                                                  .matchDetails.team1_color!)
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
                                              alignment: Alignment.centerLeft,
                                              children: [
                                                Container(
                                                  height: 20,
                                                  width: 110,
                                                  child: Image(
                                                    image: AssetImage(
                                                        AppImages.leftTeamIcon),
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
                                                      padding: EdgeInsets.only(
                                                          left: 7),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20)),
                                                        child: Container(
                                                          height: 30,
                                                          width: 30,
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: widget
                                                                .matchDetails
                                                                .team1logo!,
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Image.asset(
                                                              AppImages
                                                                  .logoPlaceholderURL,
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Image.asset(
                                                              AppImages
                                                                  .logoPlaceholderURL,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 0),
                                                            width: 60,
                                                            child: Text(
                                                                widget
                                                                    .matchDetails
                                                                    .team1display!,
                                                                textAlign: TextAlign
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
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Image.asset(
                                        AppImages.home_match_item_middle,
                                        height: 24,
                                        width: 242,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        widget.matchDetails
                                                    .unlimited_credit_match ==
                                                1
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 0, top: 20),
                                                child: Text(
                                                    widget.matchDetails
                                                        .unlimited_credit_text!,
                                                    style: TextStyle(
                                                        fontFamily: "Roboto",
                                                        color:
                                                            Color(0xFFe6a100),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 13)),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                    // widget.matchDetails
                                    //             .is_leaderboard ==
                                    //         1
                                    //     ? Container(
                                    //         height: 32,
                                    //         padding: EdgeInsets.all(3),
                                    //         margin: EdgeInsets.only(
                                    //             bottom: 0),
                                    //         child: Image(
                                    //             image: AssetImage(AppImages
                                    //                 .matchLeaderboardIcon)),
                                    //       )
                                    //     : Container(),
                                    // SizedBox(
                                    //   height: 4,
                                    // ),
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
                                                  .matchDetails.team2_color!)
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
                                              alignment: Alignment.centerRight,
                                              children: [
                                                new Container(
                                                  height: 20,
                                                  width: 110,
                                                  child: Image(
                                                    image: AssetImage(AppImages
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
                                                      margin: EdgeInsets.only(
                                                          right: 5),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 0),
                                                            width: 60,
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                                widget
                                                                    .matchDetails
                                                                    .team2display!,
                                                                overflow: TextOverflow
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
                                                      padding: EdgeInsets.only(
                                                          right: 7),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20)),
                                                        child: Container(
                                                          height: 30,
                                                          width: 30,
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: widget
                                                                .matchDetails
                                                                .team2logo!,
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Image.asset(
                                                              AppImages
                                                                  .logoPlaceholderURL,
                                                              //   color: Colors.grey
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Image.asset(
                                                              AppImages
                                                                  .logoPlaceholderURL,
                                                              //   color: Colors.grey
                                                            ),
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

                      // Padding(
                      //   padding: const EdgeInsets.only(top: 14),
                      //   child: Container(
                      //     height: 33, width:33,
                      //     child: Image.asset(
                      //       AppImages.teamVs,
                      //     ),
                      //   ),
                      // )
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 2),
                      //   child: Container(
                      //       alignment: Alignment.bottomCenter,
                      //       // margin: EdgeInsets.only(top: 30),
                      //       child: Column(
                      //         children: [
                      //           Text(
                      //             "${widget.matchDetails.match_date}",
                      //             // widget.matchDetails.match_time.toString(),
                      //             style: TextStyle(
                      //                 fontSize: 11,
                      //                 color: Colors.black,
                      //                 fontFamily: 'Roboto'),
                      //           ),
                      //           Text(
                      //             "${widget.matchDetails.match_time}",
                      //             // widget.matchDetails.match_time.toString(),
                      //             style: TextStyle(
                      //                 fontSize: 11,
                      //                 color: Color(0xff747474),
                      //                 fontFamily: 'Roboto'),
                      //           ),
                      //         ],
                      //       )),
                      // ),
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
                              width: 105,
                              margin:
                                  EdgeInsets.only(bottom: 0, left: 10, top: 0),
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
                              margin:
                                  EdgeInsets.only(bottom: 0, right: 10, top: 0),
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
                        padding: const EdgeInsets.only(bottom: 3, top: 2),
                        child: VisionCustomTimer(
                          controller: controller,
                          from: Duration(
                              milliseconds: DateFormat.getFormattedDateObj(
                                      widget.matchDetails.time_start!)!
                                  .difference(MethodUtils.getDateTime())
                                  .inMilliseconds),
                          to: Duration(milliseconds: 0),
                          onBuildAction: CustomTimerAction.auto_start,
                          onFinish: () {
                            // widget.onMatchTimeUp(widget.index);
                          },
                          builder: (CustomTimerRemainingTime remaining) {
                            if (remaining.hours == '00' &&
                                remaining.minutes == '00' &&
                                remaining.seconds == '00') {
                              // controller.pause();
                              // WidgetsBinding.instance.addPostFrameCallback((_) {
                              //   if (widget.check == 'home') {
                              //     widget.pullRefresh();
                              //   }
                              //   // widget.bannerList();
                              // });
                            }
                            return Container(
                              // width: 105,
                              // height: 25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),

                                color: widget.matchDetails.match_status!
                                            .toLowerCase() ==
                                        'completed'
                                    ? Color(0xff3F8F54).withAlpha(20)
                                    : widget.matchDetails.match_status!
                                                    .toLowerCase() ==
                                                'live' ||
                                            widget.matchDetails.match_status!
                                                    .toLowerCase() ==
                                                'under review'
                                        ? Color(0xffDF0E0E).withAlpha(20)
                                        : Color(0xffDF0E0E1A).withAlpha(1),
                                // image:
                                //     DecorationImage(
                                //         image:
                                //             AssetImage(
                                //   widget.matchListResponse!.result![index].match_status!
                                //               .toLowerCase() ==
                                //           'completed'
                                //       ? AppImages
                                //           .finishMatch
                                //       : widget.matchListResponse!.result![index].match_status!.toLowerCase() == 'live' ||
                                //               widget.matchListResponse!.result![index].match_status!.toLowerCase() ==
                                //                   'under review'
                                //           ? AppImages
                                //               .livematch
                                //       :"",
                                //           // : AppImages
                                //           //     .home_card_icon,
                                // )),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 3, bottom: 3),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      int.parse(remaining.days) >= 1
                                          ? int.parse(remaining.days) > 1
                                              ? "${remaining.days} Days"
                                              : "${remaining.days} Day"
                                          : int.parse(remaining.hours) >= 1
                                              ? "${remaining.hours}h : ${remaining.minutes}m"
                                              : int.parse(remaining.seconds) >=
                                                      1
                                                  ? "${remaining.minutes}m : ${remaining.seconds}s"
                                                  : widget.matchDetails
                                                                  .match_status ==
                                                              'upcoming' &&
                                                          remaining.minutes !=
                                                              '00'
                                                      ? "${remaining.minutes}m : ${remaining.seconds}s"
                                                      : widget.matchDetails
                                                          .match_status!
                                                          .toUpperCase(),

                                      // int.parse(remaining
                                      //             .milliseconds) <
                                      //         0
                                      //     ? '00m : 00s'
                                      //     : int.parse(remaining
                                      //                 .days) >=
                                      //             1
                                      //         ? int.parse(remaining
                                      //                     .days) >
                                      //                 1
                                      //             ? "${remaining.days} Days"
                                      //             : "${remaining.days} Day"
                                      //         : int.parse(remaining
                                      //                     .hours) >=
                                      //                 1
                                      //             ? "${int.parse(remaining.hours) < 10 ? remaining.hours.split("0").last : remaining.hours}h : ${remaining.minutes}m"
                                      //             : "${remaining.minutes}m : ${remaining.seconds}s",
                                      //int.parse(remaining.milliseconds)<0?'00m : 00s':int.parse(remaining.days)>=1?int.parse(remaining.days)>1?"${remaining.days} Days":"${remaining.days} Day":int.parse(remaining.hours)>=1?"${remaining.hours.length<10?remaining.hours.split("0").last:remaining.hours}h : ${remaining.minutes}m":"${remaining.minutes}m : ${remaining.seconds}s",
                                      style: TextStyle(
                                          // fontFamily: "Roboto",
                                          color: widget.matchDetails.match_status!
                                                      .toLowerCase() ==
                                                  'completed'
                                              ? greenColor
                                              : widget.matchDetails.match_status!
                                                              .toLowerCase() ==
                                                          'live' ||
                                                      widget.matchDetails
                                                              .match_status!
                                                              .toLowerCase() ==
                                                          'under review'
                                                  ? Color(0xffDF0E0E)
                                                  : widget.matchDetails.match_status ==
                                                          'upcoming'
                                                      ? lightBlack
                                                      : Color(0xffDF0E0E),
                                          fontWeight:
                                              widget.matchDetails.match_status ==
                                                      'upcoming'
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                          fontSize: widget.matchDetails.match_status! ==
                                                  'Completed'
                                              ? 11
                                              : widget.matchDetails.match_status ==
                                                      'Abandoned'
                                                  ? 11
                                                  : widget.matchDetails.match_status ==
                                                          'Under Review'
                                                      ? 11
                                                      : 11),
                                    ),
                                    if (widget.matchDetails.match_status ==
                                        'upcoming')
                                      Text(
                                        ' | ${widget.matchDetails.match_date}',
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            color: lightBlack,
                                            fontSize: 11,
                                            fontWeight: FontWeight.normal),
                                      )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  //
                  // Divider(
                  //   height: 1,
                  // ),
                  Container(
                    height: 30,
                    // color: Colors.white,
                    color: Color(0xffF1E7FF),
                    // margin: EdgeInsets.only(left: 10, top: 2, bottom: 2),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Row(
                              children: [
                                Text(
                                  widget.matchDetails.team_count.toString(),
                                  style: TextStyle(
                                      color: Color(0xFF666666),
                                      fontSize: 11,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ' Team -'.toUpperCase(),
                                  style: TextStyle(
                                      color: Color(0xFF666666),
                                      fontSize: 11,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          new Container(
                            margin: EdgeInsets.only(left: 3, right: 4, top: 0),
                            child: Row(
                              children: [
                                new Text(
                                  widget.matchDetails.joined_count.toString(),
                                  style: TextStyle(
                                      color: Color(0xFF666666),
                                      fontSize: 11,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ' Contests Joined'.toUpperCase(),
                                  style: TextStyle(
                                      color: Color(0xFF666666),
                                      fontSize: 11,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          widget.matchDetails.match_status!.toLowerCase() ==
                                      'completed' &&
                                  double.parse(widget.matchDetails.winning_total
                                          .toString()) >
                                      0
                              ? new Container(
                                  height: 30,
                                  // width: 130,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              AppImages.MyMatchesWonBg),
                                          fit: BoxFit.fill)),
                                  //margin: EdgeInsets.only(right: 10),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          new Text(
                                            'You Won: ',
                                            style: TextStyle(
                                                fontFamily: "Roboto",
                                                color: Color(0xff076e39),
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(right: 2),
                                            child: Container(
                                              height: 12,
                                              width: 12,
                                              child: Image.asset(
                                                  AppImages.goldcoin),
                                            ),
                                          ),
                                          new Text(
                                            widget.matchDetails.winning_total!
                                                .toString(),
                                            style: TextStyle(
                                                fontFamily: "Roboto",
                                                color: Color(0xff076e39),
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                          widget.matchDetails.lineup == 1
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(
                                        right: 10, left: 0, top: 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 5, right: 5),
                                          height: 18,
                                          // width: 37,
                                          child: Image(
                                              image: AssetImage(
                                                  AppImages.lineupsout)),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 0),
                                          child: Text(
                                            'Lineups Out',
                                            style: TextStyle(
                                                fontFamily: 'roboto',
                                                color: greenColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 11),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () => {
            if ((widget.matchDetails.match_status)?.toLowerCase() == 'upcoming')
              {
                setState(() {
                  AppConstants.homecount = 0;
                  AppConstants.onContestScreen = true;
                }),
                Platform.isAndroid
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpcomingContests(
                            GeneralModel(
                              bannerImage: widget.matchDetails.banner_image,
                              matchKey: widget.matchDetails.matchkey,
                              teamVs: (widget.matchDetails.team1display! +
                                  ' VS ' +
                                  widget.matchDetails.team2display!),
                              firstUrl: widget.matchDetails.team1logo,
                              secondUrl: widget.matchDetails.team2logo,
                              headerText: widget.matchDetails.time_start,
                              sportKey: widget.matchDetails.sport_key,
                              battingFantasy:
                                  widget.matchDetails.battingfantasy,
                              bowlingFantasy:
                                  widget.matchDetails.bowlingfantasy,
                              liveFantasy: widget.matchDetails.livefantasy,
                              secondInningFantasy:
                                  widget.matchDetails.secondinning,
                              reverseFantasy:
                                  widget.matchDetails.reversefantasy,
                              fantasySlots: widget.matchDetails.slotes,
                              team1Name: widget.matchDetails.team1name,
                              team2Name: widget.matchDetails.team2name,
                              team1Logo: widget.matchDetails.team1logo,
                              team2Logo: widget.matchDetails.team2logo,
                              format: widget.matchDetails.format,
                            ),
                            sports_key: widget.sport_key,
                          ),
                          settings: RouteSettings(name: "home"),
                        )).then((value) {
                        widget.check = 'home';

                        widget.balanceUpdate!();
                        AppConstants.onContestScreen = false;
                        print(widget.check);
                      })
                    : Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => UpcomingContests(
                                  GeneralModel(
                                    bannerImage:
                                        widget.matchDetails.banner_image,
                                    matchKey: widget.matchDetails.matchkey,
                                    teamVs: (widget.matchDetails.team1display! +
                                        ' VS ' +
                                        widget.matchDetails.team2display!),
                                    firstUrl: widget.matchDetails.team1logo,
                                    secondUrl: widget.matchDetails.team2logo,
                                    headerText: widget.matchDetails.time_start,
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
                                    format: widget.matchDetails.format,
                                  ),
                                  sports_key: widget.sport_key,
                                ))).then((value) {
                        // setState(() {
                        //   // Future.delayed(Duration(milliseconds: 400),
                        //   //     () {
                        //   //   widget.getMatchList();
                        //   //   //widget.bannerList();
                        //   //   AppConstants.createTimeUp = false;
                        //   // });

                        // });
                        widget.pullRefresh(true);
                        widget.balanceUpdate!();
                        widget.check = 'home';
                        print(widget.check);
                      })
                // navigateToUpcomingContests(
                //   context,
                //   GeneralModel(
                //     bannerImage: widget.matchDetails.banner_image,
                //     matchKey: widget.matchDetails.matchkey,
                //     teamVs: (widget.matchDetails.team1display! +
                //         ' VS ' +
                //         widget.matchDetails.team2display!),
                //     firstUrl: widget.matchDetails.team1logo,
                //     secondUrl: widget.matchDetails.team2logo,
                //     headerText: widget.matchDetails.time_start,
                //     sportKey: widget.matchDetails.sport_key,
                //     battingFantasy: widget.matchDetails.battingfantasy,
                //     bowlingFantasy: widget.matchDetails.bowlingfantasy,
                //     liveFantasy: widget.matchDetails.livefantasy,
                //     secondInningFantasy: widget.matchDetails.secondinning,
                //     reverseFantasy: widget.matchDetails.reversefantasy,
                //     fantasySlots: widget.matchDetails.slotes,
                //     team1Name: widget.matchDetails.team1name,
                //     team2Name: widget.matchDetails.team2name,
                //     team1Logo: widget.matchDetails.team1logo,
                //     team2Logo: widget.matchDetails.team2logo,
                //     format: widget.matchDetails.format,
                //   ),
                //   sports_key: widget.sport_key,
                // )
              }
            else if ((widget.matchDetails.match_status)?.toLowerCase() ==
                    'live' ||
                (widget.matchDetails.match_status)?.toLowerCase() ==
                    'under review')
              {
                setState(() {
                  widget.check = '';
                }),
                navigateToLiveFinishContests(
                  context,
                  GeneralModel(
                    bannerImage: widget.matchDetails.banner_image,
                    matchKey: widget.matchDetails.matchkey,
                    teamVs: (widget.matchDetails.team1display! +
                        ' VS ' +
                        widget.matchDetails.team2display!),
                    firstUrl: widget.matchDetails.team1logo,
                    secondUrl: widget.matchDetails.team2logo,
                    headerText: widget.matchDetails.time_start,
                    sportKey: widget.matchDetails.sport_key,
                    battingFantasy: widget.matchDetails.battingfantasy,
                    bowlingFantasy: widget.matchDetails.bowlingfantasy,
                    liveFantasy: widget.matchDetails.livefantasy,
                    secondInningFantasy: widget.matchDetails.secondinning,
                    reverseFantasy: widget.matchDetails.reversefantasy,
                    fantasySlots: widget.matchDetails.slotes,
                    team1Name: widget.matchDetails.team1name,
                    team2Name: widget.matchDetails.team2name,
                    team1Logo: widget.matchDetails.team1logo,
                    team2Logo: widget.matchDetails.team2logo,
                    isFromLive: true,
                    isFromLiveFinish: true,
                    launch_status: widget.matchDetails.final_status,
                    format: widget.matchDetails.format,
                  ),
                  sports_key: widget.sport_key,
                  match_status: widget.matchDetails.match_status,
                )
              }
            else
              {
                setState(() {
                  widget.check = '';
                }),
                navigateToLiveFinishContests(
                    context,
                    GeneralModel(
                      bannerImage: widget.matchDetails.banner_image,
                      matchKey: widget.matchDetails.matchkey,
                      teamVs: (widget.matchDetails.team1display! +
                          ' VS ' +
                          widget.matchDetails.team2display!),
                      firstUrl: widget.matchDetails.team1logo,
                      secondUrl: widget.matchDetails.team2logo,
                      headerText: widget.matchDetails.time_start,
                      sportKey: widget.matchDetails.sport_key,
                      battingFantasy: widget.matchDetails.battingfantasy,
                      bowlingFantasy: widget.matchDetails.bowlingfantasy,
                      liveFantasy: widget.matchDetails.livefantasy,
                      secondInningFantasy: widget.matchDetails.secondinning,
                      reverseFantasy: widget.matchDetails.reversefantasy,
                      fantasySlots: widget.matchDetails.slotes,
                      team1Name: widget.matchDetails.team1name,
                      team2Name: widget.matchDetails.team2name,
                      team1Logo: widget.matchDetails.team1logo,
                      team2Logo: widget.matchDetails.team2logo,
                      isFromLive: false,
                      isFromLiveFinish: true,
                      launch_status: widget.matchDetails.final_status,
                      format: widget.matchDetails.format,
                    ),
                    sports_key: widget.sport_key,
                    match_status: widget.matchDetails.match_status)
              }
          },
        ),
      ],
    );
  }

  void remindMeDialog() {
    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text("Match alert", style: TextStyle(color: Colors.black)),
      content: Text(
          "Remind me when match CON vs STL is about to start (before 25 min)",
          style: TextStyle(color: Colors.grey)),
      actions: [
        continueButton(context),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  Widget continueButton(context) {
    return DefaultButton(
      text: "REMIND ME",
      textcolor: Colors.black,
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
    }
    Fluttertoast.showToast(
        msg: myBalanceResponse.message!,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1);
  }
}
