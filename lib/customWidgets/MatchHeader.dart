import 'dart:async';
import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:need_resume/need_resume.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_navigator.dart';
import 'package:myrex11/appUtilities/date_utils.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/customWidgets/VisionCustomTimerController.dart';
import '../customWidgets/VisionCustomTimer.dart';
import '../customWidgets/VisionCustomTimerRemainingTime.dart';
import '../localStoage/AppPrefrences.dart';

class MatchHeader extends StatefulWidget {
  String teamVs;
  String headerText;
  bool isFromLive;
  bool isFromLiveFinish;
  String? screenType;
  Color? teamColor;
  Color? timerColor;
  String? checkScreen;

  MatchHeader(
      this.teamVs, this.headerText, this.isFromLive, this.isFromLiveFinish,
      {this.screenType, this.teamColor, this.timerColor, this.checkScreen});

  @override
  _MatchHeaderState createState() => new _MatchHeaderState();
}

class _MatchHeaderState extends ResumableState<MatchHeader> {
  final VisionCustomTimerController controller = VisionCustomTimerController();
  late DateTime endTime;
  int count = 0;

  int isAccountDisable = 0;

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      AppConstants.callTimer = resetAndSetTimer;
    }

    calculateEndTime();

    AppPrefrence.getInt(AppConstants.IS_ACCOUNT_WALLET_DISABLE, 0)
        .then((value) => {
              setState(() {
                isAccountDisable = value;
              })
            });

    if (Platform.isAndroid) {
      if (Platform.isAndroid) {
        startAlarm();
      }
    }
    // initializeBackgroundService();  // Initialize background service for timer
    print(widget.checkScreen);
    print('Match Header ${AppConstants.homecount}');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      print('mytimerpause');
      // setState(() {
      //   resetAndSetTimer();
      // });
    } else if (state == AppLifecycleState.resumed) {
      if (Platform.isIOS) {
        setState(() {
          Future.delayed(Duration(milliseconds: 200), () {
            resetAndSetTimer();
            print('mytimerresumecreate');
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
    DateTime startTime = DateFormat.getFormattedDateObj(widget.headerText)!;

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

  @override
  void dispose() {
    stopAlarm();

    super.dispose();
  }
  // updateTime(){
  //   controller.onSetReset(() {
  //     calculateEndTime();
  //   });
  // }

  void calculateEndTime() async {
    DateTime currentTime = MethodUtils.getDateTime();
    DateTime startTime = DateFormat.getFormattedDateObj(widget.headerText)!;
    endTime = startTime.add(Duration(
        milliseconds: startTime.millisecondsSinceEpoch -
            currentTime.millisecondsSinceEpoch));
    setState(() {
      print('objectesume');
    });
  }

  void onTimeUp() {
    if (AppConstants.homecount == 0) {
      if (AppConstants.movetowallet == false) {
        print(
            'Match Header ${widget.checkScreen ?? 'other'} Count ${AppConstants.homecount}');
        if (widget.checkScreen != 'detailsContest' ||
            widget.checkScreen != 'fromallcontest') {
          AppConstants.homecount = 1;
          showDeadlinePassedDialog(context);
          // navigateToHomePage(context);
        } else if (widget.checkScreen == 'detailsContest') {
          Navigator.pop(context);
          Future.delayed(Duration(milliseconds: 200), () {
            AppConstants.homecount = 1;
            showDeadlinePassedDialog(context);
            // navigateToHomePage(context);
          });
        } else if (widget.checkScreen == 'fromallcontest') {
          Navigator.pop(context);
          Future.delayed(Duration(milliseconds: 200), () {
            AppConstants.homecount = 1;
            showDeadlinePassedDialog(context);
            // navigateToHomePage(context);
          });
        }
      }
    }
    print('Match Header ${AppConstants.homecount}');
  }

  void onTimeall() {
    // print('Match Header');
    // print(widget.checkScreen);
    // // if (!AppConstants.candvcTimeUp) {
    // //   AppConstants.createTimeUp = true;
    // Navigator.pop(context);
    // Future.delayed(Duration(milliseconds: 200), () {
    //   Navigator.pop(context);
    // });
    // Future.delayed(Duration(milliseconds: 350), () {
    //   Navigator.pop(context);
    // });
    // Future.delayed(Duration(milliseconds: 200), () {
    //   navigateToHomePage(context, check: 'MatchHeader');
    // });

    // }
  }

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

  static void alarmCallback() {
    // You can perform any action you want when the alarm goes off
    // For example, navigate to the home page
    // if (!AppConstants.candvcTimeUp) {
    //   AppConstants.createTimeUp = true;
    //   // Note: Navigating to the homepage directly from here might not work,
    //   // you might need to use a notification or other method to inform the app.
    // }
  }

  @override
  Widget build(BuildContext context) {
    return widget.screenType != null && widget.screenType == "contest"
        ? upComingContestTimer()
        : widget.screenType != null && widget.screenType == "createTeam"
            ? CreateTeamTimer()
            : allMatchesContestDetails();
  }

  CreateTeamTimer() {
    return Container(
        // margin: EdgeInsets.only(left: 10),
        child: VisionCustomTimer(
      controller: controller,
      from: Duration(
          milliseconds: DateFormat.getFormattedDateObj(widget.headerText!)!
                  .millisecondsSinceEpoch -
              MethodUtils.getDateTime().millisecondsSinceEpoch),
      to: Duration(milliseconds: 0),
      onBuildAction: CustomTimerAction.auto_start,
      // onFinish: onTimeUp,
      builder: (CustomTimerRemainingTime remaining) {
        if (remaining.hours == '00' &&
            remaining.minutes == '00' &&
            remaining.seconds == '00') {
          controller.pause();
          AppConstants.createTimeUp = true;

          // navigateToHomePage(
          //     context);
        }
        return Center(
          child: Text(
            int.parse(remaining.days) >= 1
                ? int.parse(remaining.days) > 1
                    ? "${remaining.days} Days Left"
                    : "${remaining.days} Day Left"
                : int.parse(remaining.hours) >= 1
                    ? "${remaining.hours}h : ${remaining.minutes}m Left"
                    : "${remaining.minutes}m :${remaining.seconds}s Left",
            style: TextStyle(
              fontFamily: "Roboto",
              color: Colors.white,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        );
      },
    ));
  }

  upComingContestTimer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Row(
            children: [
              Container(
                child: Text(
                  widget.teamVs.split(' VS ')[0],
                  style: TextStyle(
                      color: widget.teamColor ?? Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  'VS',
                  style: TextStyle(
                      color: widget.teamColor ?? Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 12),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  widget.teamVs.split(' VS ')[1],
                  style: TextStyle(
                      color: widget.teamColor ?? Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 0),
          child: !widget.isFromLiveFinish
              ? Row(
                  children: [
                    VisionCustomTimer(
                      controller: controller,
                      from: Duration(
                          milliseconds:
                              DateFormat.getFormattedDateObj(widget.headerText)!
                                      .millisecondsSinceEpoch -
                                  MethodUtils.getDateTime()
                                      .millisecondsSinceEpoch),
                      to: Duration(milliseconds: 0),
                      onBuildAction: CustomTimerAction.auto_start,
                      onFinish: onTimeUp,
                      builder: (CustomTimerRemainingTime remaining) {
                        if (remaining.hours == '00' &&
                            remaining.minutes == '00' &&
                            remaining.seconds == '00') {
                          // controller.pause();
                          // if (AppConstants.createTimeUp == false ||
                          //     AppConstants.candvcTimeUp == false) {
                          //   AppConstants.matchHeaderTimeUp = true;

                          //   Future.delayed(Duration(milliseconds: 200), () {
                          //     navigateToHomePage(context);
                          //   });
                          // } else {
                          //   controller.pause();
                          // }
                          // // widget.onMatchTimeUp(widget.index);
                          // widget.getController.TimeFunction(remaining.minutes, remaining.seconds, widget.index);
                        }
                        return Center(
                          child: Text(
                            int.parse(remaining.days) >= 1
                                ? int.parse(remaining.days) > 1
                                    ? "${remaining.days} Days"
                                    : "${remaining.days} Day" + " Left"
                                : int.parse(remaining.hours) >= 1
                                    ? ("${remaining.hours}h : ${remaining.minutes}m" +
                                        " Left")
                                    : "${remaining.minutes}m : ${remaining.seconds == '-1' ? "00" : remaining.seconds}s" +
                                        " Left",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: widget.timerColor ?? Colors.red,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ],
                )
              : Text(
                  widget.isFromLive ? "In Progress" : "Completed",
                  style: TextStyle(
                      fontFamily: "Roboto",
                      color: widget.timerColor ?? Colors.red,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
        ),
      ],
    );
  }

  allMatchesContestDetails() {
    return Center(
        child: Container(
      height: 40,
      margin: EdgeInsets.all(12),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(5)),
      child: Container(
        height: 20,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      widget.teamVs.split(' VS ')[0],
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      'Vs',
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      widget.teamVs.split(' VS ')[1],
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 10),
              child: !widget.isFromLiveFinish
                  ? VisionCustomTimer(
                      controller: controller,
                      from: Duration(
                          milliseconds:
                              DateFormat.getFormattedDateObj(widget.headerText)!
                                      .millisecondsSinceEpoch -
                                  MethodUtils.getDateTime()
                                      .millisecondsSinceEpoch),
                      to: Duration(milliseconds: 0),
                      onBuildAction: CustomTimerAction.auto_start,
                      onFinish: onTimeall,
                      builder: (CustomTimerRemainingTime remaining) {
                        if (remaining.hours == '00' &&
                            remaining.minutes == '00' &&
                            remaining.seconds == '00') {
                          // controller.pause();
                          // if (AppConstants.screenCheck == 'allcontest' &&
                          //         AppConstants.createTimeUp == false ||
                          //     AppConstants.candvcTimeUp == false) {
                          //   print(AppConstants.screenCheck);
                          //   Navigator.pop(context);
                          //   Future.delayed(Duration(milliseconds: 100), () {
                          //     Navigator.pop(context);
                          //   });
                          // }
                          // controller.pause();
                          // // widget.onMatchTimeUp(widget.index);
                          // widget.getController.TimeFunction(remaining.minutes, remaining.seconds, widget.index);
                        }
                        return Center(
                          child: Text(
                            int.parse(remaining.days) >= 1
                                ? int.parse(remaining.days) > 1
                                    ? "${remaining.days} Days"
                                    : "${remaining.days} Day" + " Left"
                                : int.parse(remaining.hours) >= 1
                                    ? ("${remaining.hours}h : ${remaining.minutes}m" +
                                        " Left")
                                    : "${remaining.minutes}m : ${remaining.seconds == '-1' ? "00" : remaining.seconds}s" +
                                        " Left",
                            style: TextStyle(
                                color: widget.timerColor ?? Colors.red,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                        );
                      },
                    )
                  : Text(
                      widget.isFromLive ? "In Progress" : "Completed",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.red,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
                    ),
            ),
          ],
        ),
      ),
    ));
  }

  void showDeadlinePassedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext DeadLineContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Close Button
                // Positioned(
                //   right: 0,
                //   top: 0,
                //   child: GestureDetector(
                //     onTap: () => Navigator.pop(context),
                //     child: const Icon(
                //       Icons.close,
                //       size: 24,
                //       color: Colors.black54,
                //     ),
                //   ),
                // ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 15),
                    const Text(
                      "Deadline Passed!",
                      style: TextStyle(
                        fontFamily: 'Trim',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 90,
                      child: Image.asset(
                        "assets/images/deadlinepass_clock.webp", // replace with your asset
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Worry not, you can join contests for\nother matches",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Trim',
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 25),
                    GestureDetector(
                      onTap: () {
                        navigateToHomePage(DeadLineContext);
                        Navigator.pop(DeadLineContext);
                        // TODO: Your upcoming matches navigation
                      },
                      child: Container(
                        // padding: const EdgeInsets.symmetric(
                        //   vertical: 14,
                        //   horizontal: 26,
                        // ),
                        height: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(AppImages.Btngradient),
                              fit: BoxFit.fill),
                          border: Border.all(
                            color: Color(0xFF6A0BF8),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: const Text(
                              "VIEW UPCOMING MATCHES",
                              style: TextStyle(
                                fontFamily: 'Trim',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
