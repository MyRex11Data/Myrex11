import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myrex11/buildType/buildType.dart';
import 'package:intl/intl.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/app_navigator.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/team_preview_point_request.dart';
import 'package:myrex11/repository/model/team_preview_point_response.dart';
import 'package:myrex11/repository/model/team_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';

class TeamPreview extends StatefulWidget {
  GeneralModel model;
  String? check;
  bool? isTeamShare;
  TeamPreview(this.model, {this.check, this.isTeamShare});

  @override
  _TeamPreviewState createState() => new _TeamPreviewState();
}

class _TeamPreviewState extends State<TeamPreview> {
  List<Widget> wkList = <Widget>[];
  List<Widget> batList = <Widget>[];
  List<Widget> arList = <Widget>[];
  List<Widget> bowlList = <Widget>[];
  List<Widget> cList = <Widget>[];
  List<Widget> allPlayer = [];
  double credits = 0.0;
  double points = 0.0;
  int team1Counts = 0;
  int team2Counts = 0;
  String userId = '0';
  String teamName = '';
  String teamNumber = '0';
  int sportsPlayerCount = 0;
  var team = [];

  @override
  void initState() {
    super.initState();
    widget.model.selectedList = [];
    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
        .then((value) => {
              setState(() {
                widget.model.isTeamShare = widget.isTeamShare;
                userId = value;
                if (widget.model.isForLeaderBoard ?? false) {
                  // TODO:  here we are getting team from api
                  getPreviewPlayers();
                } else if (widget.check == 'isFromLive') {
                  getPreviewPlayers();
                } else {
                  // TODO:  here we are updating team in local array
                  createPlayers();
                  hasSelectedPlayers();
                }
              })
            });
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool hasSelectedPlayers() {
    return (widget.model.selectedWkList?.isNotEmpty == true) ||
        (widget.model.selectedBatLiSt?.isNotEmpty == true) ||
        (widget.model.selectedArList?.isNotEmpty == true) ||
        (widget.model.selectedBowlList?.isNotEmpty == true) ||
        (widget.model.selectedcList?.isNotEmpty == true);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: set Status bar icon color in iOS.
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        /* set Status bar color in Android devices. */
        statusBarIconBrightness: Brightness.light,
        /* set Status bar icons color in Android devices.*/

        statusBarBrightness: Brightness.dark));

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          decoration: BoxDecoration(
              color: widget.model.sportKey == AppConstants.TAG_BASKETBALL
                  ? Color(0xff9C5F2E)
                  : Color(0xff037F21),
              image: DecorationImage(
                  scale: 1,
                  image: AssetImage(
                      widget.model.sportKey == AppConstants.TAG_CRICKET
                          ? AppImages.ground
                          : widget.model.sportKey == AppConstants.TAG_FOOTBALL
                              ? AppImages.football_feild
                              : widget.model.sportKey ==
                                      AppConstants.TAG_BASKETBALL
                                  ? AppImages.basketball_feild
                                  : AppImages.ground
                      // : AppImages.kabaddi_preview
                      ),
                  fit: BoxFit.fill)),
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(105),
              // Set th
              child: Column(
                children: [
                  Container(
                    // height: 90,
                    width: MediaQuery.of(context).size.width,
                    color: primaryColor,
                    // decoration: BoxDecoration(
                    //   image: DecorationImage(
                    //     image: AssetImage("assets/images/ic_black.png"),
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    padding: EdgeInsets.only(
                        top: 42, left: 16, right: 16, bottom: 13),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  _onWillPop();
                                },
                                child: Container(
                                  // width: 24,
                                  height: 29,
                                  child: Image(
                                    image: AssetImage(AppImages.crossIcon),
                                    // fit: BoxFit.fill,
                                    // color: Colors.white,
                                  ),
                                )),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              widget.model.isFromEditOrClone == true ||
                                      widget.model.isFromLiveFinish == true ||
                                      widget.model.isForLeaderBoard == true ||
                                      widget.model.isFromLive == true
                                  ? '${widget.model.teamName ?? 0 + 1}'
                                  : 'TEAM',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 3),
                          child: !(widget.model.isFromLiveFinish ?? false) &&
                                  widget.isTeamShare != true
                              ? InkWell(
                                  onTap: () {
                                    if (widget.check == "Create Team") {
                                      Navigator.pop(context);
                                    } else if (widget.check == 'CandVc') {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    } else {
                                      widget.model.selectedList!.addAll(
                                          widget.model.selectedWkList ?? []);
                                      widget.model.selectedList!.addAll(
                                          widget.model.selectedBatLiSt ?? []);
                                      widget.model.selectedList!.addAll(
                                          widget.model.selectedArList ?? []);
                                      widget.model.selectedList!.addAll(
                                          widget.model.selectedBowlList ?? []);
                                      widget.model.selectedList!.addAll(
                                          widget.model.selectedcList ?? []);
                                      widget.model.isFromEditOrClone = true;
                                      Navigator.pop(context);
                                      navigateToCreateTeam(
                                          context, widget.model,
                                          onTeamCreated:
                                              widget.model.onTeamCreated);
                                    }
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    child: Image(
                                      image: AssetImage(AppImages.editIcon),
                                      //fit: BoxFit.fill,
                                    ),
                                  ))
                              : Container(
                                  height: 24,
                                  width: 91,
                                  margin: EdgeInsets.only(right: 12),
                                ),
                        ),
                        if (!(widget.model.isFromLiveFinish ?? false) &&
                            widget.isTeamShare == true)
                          pickTeamButton(),
                      ],
                    ),
                  ),
                  Container(
                    // height: 51,
                    //padding: EdgeInsets.only(bottom: 10, top: 2),
                    color: Color(0xFF9155EB),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Players",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 222, 220, 220),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${team1Counts + team2Counts} / ${SportTypeFantasy.getSportType(widget.model.sportKey, widget.model)}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    // height: 26,
                                    //  width: 62,
                                    // margin: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 0.5,
                                        ),
                                        borderRadius: BorderRadius.circular(2),
                                        color: Color(0xFF333333)),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 5,
                                              left: 5,
                                              top: 3,
                                              bottom: 3),
                                          child: Text(
                                            widget.model.teamVs!
                                                    .contains(' VS ')
                                                ? widget.model.teamVs!
                                                    .split(' VS ')[0]
                                                : widget.model.teamVs!
                                                        .contains(' Vs ')
                                                    ? widget.model.teamVs!
                                                        .split(' Vs ')[0]
                                                    : widget.model.teamVs!
                                                        .split(' vs ')[0],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  team1Counts.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                                Text(
                                  " : " + team2Counts.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    //height: 26,
                                    //  margin: EdgeInsets.only(bottom: 2, top: 10),
                                    padding: EdgeInsets.only(
                                        right: 5, left: 5, top: 3, bottom: 3),
                                    // alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color(0xff333333),
                                          width: 0.5,
                                        ),
                                        borderRadius: BorderRadius.circular(2),
                                        color: Color(0xFFffffff)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        new Text(
                                          widget.model.teamVs!.contains(' VS ')
                                              ? widget.model.teamVs!
                                                  .split(' VS ')[1]
                                              : widget.model.teamVs!
                                                      .contains(' Vs ')
                                                  ? widget.model.teamVs!
                                                      .split(' Vs ')[1]
                                                  : widget.model.teamVs!
                                                      .split(' vs ')[1],
                                          //
                                          style: TextStyle(
                                              color: Color(0xff333333),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    //   alignment: Alignment.topLeft,
                                    child: Text(
                                      widget.model.isFromLiveFinish ?? false
                                          ? 'Total Points'
                                          : widget.model.fantasyType != 1
                                              ? 'Credits Left'
                                              : "",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 222, 220, 220),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 2),
                                    //  alignment: Alignment.topLeft,
                                    child: Text(
                                      widget.model.isFromLiveFinish ?? false
                                          ? NumberFormat('##.##')
                                              .parse(points.toStringAsFixed(2))
                                              .toString()
                                          : widget.model.fantasyType != 1
                                              ? widget.model
                                                          .unlimited_credit_match ==
                                                      1
                                                  ? widget.model
                                                      .unlimited_credit_text!
                                                      .split(" ")
                                                      .first
                                                  : '${100 - NumberFormat('##.##').parse(credits.toString())}'
                                              : "",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: WillPopScope(
                child: Container(
                  alignment: Alignment.topCenter,
                  // margin: EdgeInsets.only(top: Platform.isAndroid ? 0 : 0),

                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Container(
                            margin: EdgeInsets.only(
                                top: Platform.isIOS ? 10 : 0, bottom: 0),
                            // height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            // color: Colors.amber,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: widget.model.sportKey ==
                                          AppConstants.TAG_FOOTBALL
                                      ? 25
                                      : 10,
                                ),
                                SizedBox(
                                  height: 0,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 0,
                                  ),
                                  // height: Platform.isIOS
                                  //     ? MediaQuery.of(context).size.height - 170
                                  //     : MediaQuery.of(context).size.height - 30,
                                  alignment: Alignment.center,
                                  child: widget.model.fantasyType != 1
                                      ? SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  if (hasSelectedPlayers())
                                                    widget.model.fantasyType !=
                                                            1
                                                        ? Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 4,
                                                                    horizontal:
                                                                        8),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4)),
                                                            // alignment: Alignment.center,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 5,
                                                                    top: 10),
                                                            child: Text(
                                                              widget.model.sportKey ==
                                                                      AppConstants
                                                                          .TAG_CRICKET
                                                                  ? 'Wicket Keeper'
                                                                      .toUpperCase()
                                                                  : widget.model
                                                                              .sportKey ==
                                                                          AppConstants
                                                                              .TAG_KABADDI
                                                                      ? 'DEFENDERS'
                                                                          .toUpperCase()
                                                                      : widget.model.sportKey ==
                                                                              AppConstants
                                                                                  .TAG_BASKETBALL
                                                                          ? 'Point Guard'
                                                                              .toUpperCase()
                                                                          : 'Goal Keeper'
                                                                              .toUpperCase(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12),
                                                            ),
                                                          )
                                                        : Container(
                                                            height: 20,
                                                          ),
                                                  wkList.length > 0
                                                      ? Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: Wrap(
                                                            alignment:
                                                                WrapAlignment
                                                                    .spaceAround,
                                                            direction:
                                                                Axis.horizontal,
                                                            children: wkList,
                                                          ),
                                                        )
                                                      : Container(height: 65)
                                                ],
                                              ),
                                              // batList.length > 0
                                              //     ?
                                              Container(
                                                child: Column(
                                                  children: [
                                                    if (hasSelectedPlayers())
                                                      widget.model.fantasyType !=
                                                              1
                                                          ? Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          4,
                                                                      horizontal:
                                                                          8),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.1),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4)),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom: 5,
                                                                      top: 10),
                                                              child: Text(
                                                                widget.model.sportKey ==
                                                                        AppConstants
                                                                            .TAG_CRICKET
                                                                    ? 'Batsman'
                                                                        .toUpperCase()
                                                                    : widget.model.sportKey ==
                                                                            AppConstants
                                                                                .TAG_KABADDI
                                                                        ? 'ALL ROUNDER'
                                                                            .toUpperCase()
                                                                        : widget.model.sportKey ==
                                                                                AppConstants.TAG_BASKETBALL
                                                                            ? 'Shooting-Guard'.toUpperCase()
                                                                            : 'Defenders'.toUpperCase(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            )
                                                          : SizedBox.shrink(),
                                                    batList.length > 0
                                                        ? Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Wrap(
                                                              alignment:
                                                                  WrapAlignment
                                                                      .spaceEvenly,
                                                              direction: Axis
                                                                  .horizontal,
                                                              children: batList,
                                                            ),
                                                          )
                                                        : Container(height: 100)
                                                  ],
                                                ),
                                              ),
                                              // : Container(),

                                              Container(
                                                child: Column(
                                                  children: [
                                                    if (hasSelectedPlayers())
                                                      widget.model.fantasyType !=
                                                              1
                                                          ? Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          4,
                                                                      horizontal:
                                                                          8),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.1),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4)),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom: 5,
                                                                      top: 5),
                                                              child: Text(
                                                                widget.model.sportKey ==
                                                                        AppConstants
                                                                            .TAG_CRICKET
                                                                    ? 'All Rounders'
                                                                        .toUpperCase()
                                                                    : widget.model.sportKey ==
                                                                            AppConstants
                                                                                .TAG_KABADDI
                                                                        ? 'RAIDERS'
                                                                            .toUpperCase()
                                                                        : widget.model.sportKey ==
                                                                                AppConstants.TAG_BASKETBALL
                                                                            ? 'Small Forward'.toUpperCase()
                                                                            : 'Mid-fielders'.toUpperCase(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            )
                                                          : SizedBox.shrink(),
                                                    arList.length > 0
                                                        ? Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Wrap(
                                                              alignment:
                                                                  WrapAlignment
                                                                      .spaceAround,
                                                              direction: Axis
                                                                  .horizontal,
                                                              children: arList,
                                                            ),
                                                          )
                                                        : Container(height: 65)
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  if (hasSelectedPlayers())
                                                    widget.model.fantasyType !=
                                                            1
                                                        ? Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 4,
                                                                    horizontal:
                                                                        8),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4)),
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 5,
                                                                    bottom: 5),
                                                            child: Text(
                                                              widget.model.sportKey ==
                                                                      AppConstants
                                                                          .TAG_CRICKET
                                                                  ? 'Bowlers'
                                                                      .toUpperCase()
                                                                  : widget.model
                                                                              .sportKey ==
                                                                          AppConstants
                                                                              .TAG_BASKETBALL
                                                                      ? 'Power Forward'
                                                                          .toUpperCase()
                                                                      : 'Forward'
                                                                          .toUpperCase(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12),
                                                            ),
                                                          )
                                                        : SizedBox.shrink(),
                                                  bowlList.length > 0
                                                      ? Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: Wrap(
                                                            alignment:
                                                                WrapAlignment
                                                                    .spaceEvenly,
                                                            direction:
                                                                Axis.horizontal,
                                                            children: bowlList,
                                                          ),
                                                        )
                                                      : Container(height: 65),
                                                ],
                                              ),
                                              if (widget.model.sportKey ==
                                                  AppConstants.TAG_BASKETBALL)
                                                Column(
                                                  children: [
                                                    if (hasSelectedPlayers())
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 4,
                                                                horizontal: 8),
                                                        decoration: BoxDecoration(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4)),
                                                        margin: EdgeInsets.only(
                                                            top: 5, bottom: 5),
                                                        child: Text(
                                                          'Center',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14),
                                                        ),
                                                      ),
                                                    cList.length > 0
                                                        ? Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Wrap(
                                                              alignment:
                                                                  WrapAlignment
                                                                      .spaceAround,
                                                              direction: Axis
                                                                  .horizontal,
                                                              children: cList,
                                                            ),
                                                          )
                                                        : Container(height: 65)
                                                  ],
                                                )
                                              // : Container(),
                                            ],
                                          ),
                                        )
                                      : allPlayer.length > 0
                                          ? Container(
                                              child: Column(
                                                children: [
                                                  widget.model.fantasyType != 1
                                                      ? Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 4,
                                                                  horizontal:
                                                                      8),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4)),
                                                          margin:
                                                              EdgeInsets.only(
                                                            bottom: 5,
                                                          ),
                                                          child: Text(
                                                            widget.model.sportKey ==
                                                                    AppConstants
                                                                        .TAG_CRICKET
                                                                ? 'Wicket Keeper'
                                                                : widget.model
                                                                            .sportKey ==
                                                                        AppConstants
                                                                            .TAG_KABADDI
                                                                    ? 'Defender'
                                                                    : widget.model.sportKey ==
                                                                            AppConstants.TAG_BASKETBALL
                                                                        ? 'Point Guard'
                                                                        : 'Goal Keeper',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14),
                                                          ),
                                                        )
                                                      : Container(
                                                          height: 20,
                                                        ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Wrap(
                                                      alignment: WrapAlignment
                                                          .spaceAround,
                                                      direction:
                                                          Axis.horizontal,
                                                      children: wkList +
                                                          batList +
                                                          bowlList +
                                                          arList,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                )
                              ],
                            ),
                          ),
                        ),

                        // new Container(
                        //   padding: EdgeInsets.only(bottom: 5,top: 5),
                        //   color: transBlack,
                        //   width: MediaQuery.of(context).size.width,
                        //   child: new Container(
                        //     alignment: Alignment.center,
                        //     child: Text(
                        //       widget.model.fantasyType==AppConstants.BATTING_FANTASY_TYPE?'Batting':widget.model.fantasyType==AppConstants.BOWLING_FANTASY_TYPE?'Bowling':widget.model.fantasyType==AppConstants.SECOND_INNINGS_FANTASY_TYPE?'2nd Innings':widget.model.fantasyType==AppConstants.LIVE_FANTASY_TYPE?'Live':widget.model.fantasyType==AppConstants.REVERSE_FANTASY?'Reverse':'Full Match',
                        //       style: TextStyle(
                        //           color: Colors.white,Batter
                        //           fontWeight: FontWeight.w500,
                        //           fontSize: 12),
                        //     ),
                        //   ),
                        // ),

                        // SizedBox(height: 2,)
                      ],
                    ),
                  ),
                ),
                onWillPop: _onWillPop)),
      ],
    );
  }

  Widget getPlayer(Player player, int count, int playerNumber) {
    return new Container(
      width: 65,
      margin: EdgeInsets.only(
          left: count < 3
              ? 50
              : count > 6
                  ? 10
                  : count > 4
                      ? 20
                      : 10,
          right: count < 3
              ? 50
              : count > 6
                  ? 10
                  : count > 4
                      ? 20
                      : 10,
          bottom: Platform.isAndroid
              ? 15
              : count > 4
                  ? 15
                  : 30,
          top: 5),
      // width: widget.model.sportKey == 'CRICKET'
      //     ? widget.model.fantasyType != 1
      //         ? count == 5
      //             ? 75
      //             : 75
      //         : 80
      //     : 65,
      // margin: EdgeInsets.only(
      //     left: widget.model.fantasyType != 1
      //         ? getLeftMargin(count, playerNumber)
      //         : 50,
      //     // count!=6 ? count > 4  ? playerNumber == 4 ? 50 : playerNumber == 5  ? 10 :  10 : 10 : 20,
      //     right: widget.model.fantasyType != 1
      //         ? getRightMargin(count, playerNumber)
      //         : 50,
      //     //count!=6 ? count > 4  ? playerNumber == 4 ? 0 : playerNumber == 5 ? 10 :  10 : 10 : 20,
      //     top: widget.model.sportKey == 'CRICKET'
      //         ? widget.model.fantasyType != 1
      //             ? 0
      //             : 100
      //         : 10),
      child: new Stack(
        children: [
          new Stack(
            alignment: Alignment.topCenter,
            children: [
              playerImage(player),
              Stack(
                children: [
                  nameCard(player),
                  // isPlayerOnBetting(player)
                ],
              ),
              livePoints(player),
            ],
          ),
          Container(
              margin: EdgeInsets.only(top: 10, right: 20),
              child: checkCaptainAndVC(player)),
          // subPlayer(player),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (widget.model.sportKey == AppConstants.TAG_CRICKET ||
        widget.model.sportKey != AppConstants.TAG_CRICKET) {
      widget.model.selectedList!.addAll(widget.model.selectedWkList ?? []);
      widget.model.selectedList!.addAll(widget.model.selectedBatLiSt ?? []);
      widget.model.selectedList!.addAll(widget.model.selectedArList ?? []);
      widget.model.selectedList!.addAll(widget.model.selectedBowlList ?? []);
    }

    Navigator.pop(context);
    return Future.value(false);
  }

  void createPlayers() {
    var i = 0;
    getCreditAndPoints();
    for (Player player in widget.model.selectedWkList!) {
      player.isCaptain = player.isCaptain ?? false;
      player.isVcCaptain = player.isVcCaptain ?? false;
      i += 1;
      wkList.add(getPlayer(player, widget.model.selectedWkList!.length, i));
    }
    i = 0;

    for (Player player in widget.model.selectedBatLiSt!) {
      player.isCaptain = player.isCaptain ?? false;
      player.isVcCaptain = player.isVcCaptain ?? false;
      i += 1;
      batList.add(getPlayer(player, widget.model.selectedBatLiSt!.length, i));
    }
    i = 0;

    for (Player player in widget.model.selectedArList!) {
      player.isCaptain = player.isCaptain ?? false;
      player.isVcCaptain = player.isVcCaptain ?? false;
      i += 1;
      arList.add(getPlayer(player, widget.model.selectedArList!.length, i));
    }
    i = 0;

    if (widget.model.selectedBowlList != null) {
      for (Player player in widget.model.selectedBowlList!) {
        player.isCaptain = player.isCaptain ?? false;
        player.isVcCaptain = player.isVcCaptain ?? false;
        i += 1;
        bowlList
            .add(getPlayer(player, widget.model.selectedBowlList!.length, i));
      }
    }
    i = 0;

    if (widget.model.selectedcList != null) {
      for (Player player in widget.model.selectedcList!) {
        player.isCaptain = player.isCaptain ?? false;
        player.isVcCaptain = player.isVcCaptain ?? false;
        i += 1;
        cList.add(getPlayer(player, widget.model.selectedcList!.length, i));
      }
    }

    allPlayer.addAll(wkList);
    allPlayer.addAll(batList);
    allPlayer.addAll(arList);
    allPlayer.addAll(bowlList);
    allPlayer.addAll(cList);
  }

  void getCreditAndPoints() {
    for (int i = 0; i < widget.model.selectedWkList!.length; i++) {
      credits = credits + double.parse(widget.model.selectedWkList![i].credit);
      points = points +
          double.parse(
              (widget.model.selectedWkList![i].points ?? 0).toString());
      if ("team1" != widget.model.selectedWkList![i].team) {
        team2Counts++;
      } else {
        team1Counts++;
      }
    }
    for (int i = 0; i < widget.model.selectedBatLiSt!.length; i++) {
      credits = credits +
          double.parse(widget.model.selectedBatLiSt?[i].credit ?? "0");
      points = points +
          double.parse(
              (widget.model.selectedBatLiSt![i].points ?? 0).toString());
      if ("team1" != widget.model.selectedBatLiSt![i].team) {
        team2Counts++;
      } else {
        team1Counts++;
      }
    }
    for (int i = 0; i < widget.model.selectedArList!.length; i++) {
      credits = credits + double.parse(widget.model.selectedArList![i].credit);
      points = points +
          double.parse(
              (widget.model.selectedArList![i].points ?? 0).toString());
      if ("team1" != widget.model.selectedArList![i].team) {
        team2Counts++;
      } else {
        team1Counts++;
      }
    }
    if (widget.model.selectedBowlList != null) {
      for (int i = 0; i < widget.model.selectedBowlList!.length; i++) {
        credits =
            credits + double.parse(widget.model.selectedBowlList![i].credit);
        points = points +
            double.parse(
                (widget.model.selectedBowlList![i].points ?? 0).toString());
        if ("team1" != widget.model.selectedBowlList![i].team) {
          team2Counts++;
        } else {
          team1Counts++;
        }
      }
    }
    if (widget.model.selectedcList != null) {
      for (int i = 0; i < widget.model.selectedcList!.length; i++) {
        credits = credits + double.parse(widget.model.selectedcList![i].credit);
        points = points +
            double.parse(
                (widget.model.selectedcList![i].points ?? 0).toString());
        if ("team1" != widget.model.selectedcList![i].team) {
          team2Counts++;
        } else {
          team1Counts++;
        }
      }
    }
  }

  void getPreviewPlayers() async {
    AppLoaderProgress.showLoader(context);
    TeamPreviewPointRequest request = new TeamPreviewPointRequest(
        user_id: userId,
        teamid: widget.model.teamId.toString(),
        challenge: widget.model.challengeId.toString(),
        sport_key: widget.model.sportKey,
        fantasy_type_id: CricketTypeFantasy.getCricketType(
            widget.model.fantasyType.toString(),
            sportsKey: widget.model
                .sportKey) /*widget.model.fantasyType == 2 ? '6' : widget.model.fantasyType==1 ? '7' : '0'*/,
        fantasy_type: widget.model.fantasyType.toString(),
        slotes_id: widget.model.slotId.toString());

    final client = ApiClient(AppRepository.dio);
    TeamPointPreviewResponse response = await client.getPreviewPlayers(request);
    if (response.status == 1) {
      teamName = response.result!.teamname!;
      teamNumber = response.result!.teamnumber.toString();
      if (widget.model.sportKey == AppConstants.TAG_CRICKET) {
        widget.model.selectedWkList = response.result!.keeper ?? [];
        widget.model.selectedBatLiSt = response.result!.batsman ?? [];
        widget.model.selectedArList = response.result!.allrounder ?? [];
        widget.model.selectedBowlList = response.result!.bowler ?? [];
      } else if (widget.model.sportKey == AppConstants.TAG_FOOTBALL) {
        widget.model.selectedWkList = response.result!.Goalkeeper!;
        widget.model.selectedBatLiSt = response.result!.Defender!;
        widget.model.selectedArList = response.result!.Midfielder!;
        widget.model.selectedBowlList = response.result!.Forward!;
      } else if (widget.model.sportKey == AppConstants.TAG_BASKETBALL) {
        widget.model.selectedWkList = response.result!.pgList!;
        widget.model.selectedBatLiSt = response.result!.sgList!;
        widget.model.selectedArList = response.result!.smallForwardList!;
        widget.model.selectedBowlList = response.result!.powerForwardList!;
        widget.model.selectedcList = response.result!.centreList!;
      } else {
        widget.model.selectedWkList = response.result!.Defender ?? [];
        widget.model.selectedBatLiSt = response.result!.Goalkeeper ?? [];
        widget.model.selectedArList = response.result!.Forward ?? [];
      }

      createPlayers();
      setState(() {
        AppLoaderProgress.hideLoader(context);
      });
    }
  }

  Widget isPlayerOnBetting(Player player) {
    return player.is_playing_show == 1 &&
            player.is_playing == 0 &&
            player.is_substitute != 1 &&
            widget.model.sportKey != AppConstants.TAG_BASKETBALL
        ? Container(
            width: 200,
            margin: EdgeInsets.only(top: 73, left: 0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(4),
                color: Colors.white),
            child: Text(
              'Player',
              style: TextStyle(fontSize: 10),
            ),
          )
        : player.is_playing_show == 1 &&
                player.is_playing == 0 &&
                widget.model.sportKey == AppConstants.TAG_BASKETBALL
            ? Container(
                margin: EdgeInsets.only(top: 2, left: 5),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white)),
              )
            : SizedBox();
  }

  Widget nameCard(Player player) {
    return Card(
      margin:
          EdgeInsets.only(top: widget.model.sportKey == 'CRICKET' ? 40 : 40),
      elevation: 0,
      color: player.team != 'team1' ? Colors.black : Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: player.team == 'team1' ? Colors.black : Colors.white,
        ),
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: new Container(
        padding: widget.model.fantasyType != 1
            ? EdgeInsets.symmetric(horizontal: 1, vertical: 2)
            : EdgeInsets.all(4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                player.getPreviewShortName().replaceAll('', '\u200B').length >
                        30
                    ? player
                            .getPreviewShortName()
                            .replaceAll('', '\u200B')
                            .substring(0, 30) +
                        "..."
                    : player.getPreviewShortName().replaceAll('',
                        '\u200B') /*+player
                    .getPreviewShortName()
                    .replaceAll('', '\u200B')*/
                ,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: player.team != 'team1' ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: widget.model.fantasyType == 1 ? 4 : 0,
            ),
            widget.model.fantasyType == 1
                ? Image.asset(
                    getRoleIcon(player),
                    color: Colors.white,
                    height: 12,
                  )
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  String getRoleIcon(Player list) {
    if (list.role == "batsman") {
      return AppImages.batting_icon_51;
    } else if (list.role == "bowler") {
      return AppImages.baller_51;
    } else if (list.role == "allrounder") {
      return AppImages.allrounder_51;
    } else {
      return AppImages.keeper_51;
    }
  }

  Widget livePoints(Player player) {
    return Padding(
      padding: EdgeInsets.only(
          top: widget.model.sportKey == 'CRICKET'
              ? widget.model.fantasyType == 1
                  ? 70
                  : 58
              : 58),
      child: Container(
        margin: EdgeInsets.only(
          left: 4,
          right: 4,
          // top: widget.model.sportKey == 'CRICKET'
          //     ? widget.model.fantasyType == 1
          //         ? 70
          //         ? 70
          //     : 70
        ),
        padding: EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
            color: Colors.transparent),
        alignment: Alignment.center,
        child: Text(
          widget.model.isFromLiveFinish ?? false
              ? NumberFormat('###.#')
                      .parse(player.points.toString())
                      .toStringAsFixed(2) +
                  ' Pt.'
              : NumberFormat('###.#')
                      .parse(player.credit.toString())
                      .toStringAsFixed(2) +
                  ' Cr.',
          style: TextStyle(
              fontFamily: "Roboto",
              color: /*widget.model.fantasyType!=2 ? Colors.white :*/
                  Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 10),
        ),
      ),
    );
  }

  Widget checkCaptainAndVC(Player player) {
    return player.isCaptain ||
            player.captain == 1 ||
            player.isVcCaptain ||
            player.vicecaptain == 1
        ? new Container(
            height: 20,
            width: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(
                  color: player.team ==
                          'team2' //player.isCaptain || player.captain == 1
                      ? Colors.black
                      : Colors.white,
                ),
                borderRadius: BorderRadius.circular(10),
                color: player.team ==
                        'team2' //player.isCaptain || player.captain == 1
                    ? Colors.white
                    : Colors.black),
            child: new Text(
              player.isCaptain || player.captain == 1
                  ? 'C'
                  : player.isVcCaptain || player.vicecaptain == 1
                      ? 'VC'
                      : '',
              style: TextStyle(
                  fontFamily: "Roboto",
                  color: player.team ==
                          'team2' //player.isCaptain || player.captain == 1
                      ? Colors.black
                      : Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 10),
              textAlign: TextAlign.center,
            ),
          )
        : Container();
  }

  Widget playerImage(Player player) {
    return Stack(
      children: [
        Container(
          height: widget.model.sportKey == 'CRICKET'
              ? widget.model.fantasyType == 1
                  ? 45
                  : 40
              : 45,
          // width: widget.model.sportKey == 'CRICKET'
          //     ? widget.model.fantasyType == 1
          //         ? 42
          //         : 40
          //     : 42,
          child: CachedNetworkImage(
            imageUrl: player.image!,
            placeholder: (context, url) =>
                new Image.asset(AppImages.TeamPreviewAvatarIcon),
            errorWidget: (context, url, error) =>
                new Image.asset(AppImages.TeamPreviewAvatarIcon),
            // fit: BoxFit.fill,
          ),
        ),
        player.is_playing_show == 1 && player.is_playing == 0
            ? Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: new Container(
                  height: 10,
                  width: 10,
                  margin: EdgeInsets.only(top: 1, left: 3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.red),
                ),
              )
            : SizedBox(),
        player.is_playing_show == 1 && player.is_substitute == 1
            ? Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: new Container(
                  height: 10,
                  width: 10,
                  margin: EdgeInsets.only(top: 1, left: 3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(6),
                      color: Color(0xff102881)),
                ),
              )
            : SizedBox(),
      ],
    );
  }

  double getRightMargin(int count, int playerNumber) {
    if (count == 6) {
      return 20.0;
    } else if (count < 4) {
      return 10;
    } else if (playerNumber == 4 && count == 4) {
      return 20;
    } else if (playerNumber == 5 && count == 5) {
      return 40;
    }
    return 10;
  }

  double getLeftMargin(int count, int playerNumber) {
    if (count == 6) {
      return 20.0;
    } else if (count < 4) {
      return 10;
    } else if (playerNumber == 4 && count == 4) {
      return 20;
    } else if (playerNumber == 5) {
      return 40;
    }
    return 10;
  }

  subPlayer(Player player) {
    return player.is_substitute == 1
        ? Container(
            height: 20,
            width: 20,
            margin: EdgeInsets.only(left: 55),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
                color: player.team == 'team1' ? Colors.black : primaryColor),
            child: new Text(
              'SP',
              style: TextStyle(
                  fontFamily: "Roboto",
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 10),
              textAlign: TextAlign.center,
            ),
          )
        : SizedBox.shrink();
  }

  Widget pickTeamButton() {
    // final bool shouldShowPickTeam = (widget.isTeamShare ?? false) &&
    //     widget.isSameUser == 0 &&
    //     !isDataLoaded;
    // if (shouldShowPickTeam) {
    return InkWell(
      onTap: () {
        if (widget.check == "Create Team") {
          Navigator.pop(context);
        } else if (widget.check == 'CandVc') {
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          widget.model.selectedList!.addAll(widget.model.selectedWkList ?? []);
          widget.model.selectedList!.addAll(widget.model.selectedBatLiSt ?? []);
          widget.model.selectedList!.addAll(widget.model.selectedArList ?? []);
          widget.model.selectedList!
              .addAll(widget.model.selectedBowlList ?? []);
          widget.model.selectedList!.addAll(widget.model.selectedcList ?? []);
          widget.model.isFromEditOrClone = true;
          widget.model.teamId = 0;
          Navigator.pop(context);
          navigateToCreateTeam(context, widget.model,
              onTeamCreated: AppConstants.onteamUpdate);
        }
      },
      // onTap: () {
      //   TeamData();
      //   widget.model
      //     ..isFromEditOrClone = true
      //     ..isFromEditQuickTeam = true
      //     ..isFromPickTeam = true
      //     ..contest = null;
      //   navigateToCreateTeam(
      //     context,
      //     widget.model,
      //     nonplayinglist: widget.nonplayinglist,
      //   ).then((value) => onResume());
      // },
      child: Container(
        // alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppImages.Btngradient), fit: BoxFit.fill),
          border: Border.all(
            color: Color(0xFF6A0BF8),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Center(
            child: Text(
              'PICK TEAM',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
    // }
    // else {
    //   return const SizedBox.shrink();
    // }
  }
}
