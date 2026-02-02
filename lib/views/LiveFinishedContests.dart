import 'dart:async';
import 'package:myrex11/adapter/LiveFinishContestAdapter.dart';
import 'package:myrex11/adapter/TeamItemAdapter.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:flutter/services.dart';
import 'package:myrex11/buildType/buildType.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/contest_request.dart';
import 'package:myrex11/repository/model/player_points_response.dart';
import 'package:myrex11/repository/model/refresh_score_response.dart';
import 'package:myrex11/repository/model/team_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';
import 'PlayerPoints.dart';

class LiveFinishContests extends StatefulWidget {
  GeneralModel model;
  String? match_status;
  String? sports_key;
  LiveFinishContests(this.model, this.match_status, {this.sports_key});

  @override
  _LiveFinishContestsState createState() => _LiveFinishContestsState();
}

class _LiveFinishContestsState extends State<LiveFinishContests>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _currentMatchIndex = 0;
  List<Widget> tabs = <Widget>[];
  List<Team> teamList = [];
  List<MultiSportsPlayerPointItem> pointsList = [];
  List<LiveFinishedContestData> contestList = [];
  List<int> fantasyTypes = [];
  // late TabController _tabController;
  String userId = '0';
  String team1Score = '0/0 (0)';
  String team2Score = '0/0 (0)';
  String tvWinningText = '';
  bool loading = false;
  RefreshScoreItem refreshScoreItem = RefreshScoreItem();

  String? commentry_focus;
  String? score_card_focus;
  bool initialLoading = true;
  int show_popper = 0;
  bool showpopup = true;
  var decodedResponse;

  @override
  void initState() {
    super.initState();

    if (widget.sports_key != null) {
      widget.model.sportKey = widget.sports_key;
    }

    widget.model.fantasyType = 0;

    // connectWebSocket();

    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID).then(
      (value) => setState(() {
        userId = value;
        getMatchScores();
      }),
    );
  }

  void showPopUp() {
    Future.delayed(Duration(milliseconds: 6000), () {
      setState(() {
        showpopup = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            /* set Status bar color in Android devices. */
            statusBarIconBrightness: Brightness.light,
            /* set Status bar icons color in Android devices.*/
            statusBarBrightness: Brightness.dark)
        /* set Status bar icon color in iOS. */
        );
    // TODO: implement build
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Scaffold(
          backgroundColor: bgColor,
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              // initialLoading == false
              //     ?
              // matchScore(),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: primaryColor,
                ),
                //margin: EdgeInsets.fromLTRB(0, 40, 0, 10),
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 5),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: 15,
                              top: 15,
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () => {Navigator.pop(context)},
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: 12,
                                      right: 8,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      height: 30,
                                      child: Image(
                                        image:
                                            AssetImage(AppImages.backImageURL),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(widget.model.teamVs!,
                                      style: TextStyle(
                                          fontFamily: "Roboto",
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Container(
                              child: Image.asset(
                                AppImages.LogoWhite,
                                height: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // widget.match_status == "Completed"
                      //     ?
                      /* Image.asset(
                        AppImages.company_logo,
                        height: 20,
                      ),*/
                      // : SizedBox.shrink(),

                      Container(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width:
                                      MediaQuery.of(context).size.width * 0.34,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child:
                                            Text(widget.model.team1Name ?? '',
                                                style: TextStyle(
                                                    //fontFamily: "Roboto",
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12)),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Container(
                                        width: 110,
                                        child:
                                            Text(widget.model.team1Score ?? '',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    //fontFamily: "Roboto",
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  width:
                                      MediaQuery.of(context).size.width * 0.34,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child:
                                            Text(widget.model.team2Name ?? '',
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    //fontFamily: "Roboto",
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12)),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Container(
                                        // color: Colors.amber,
                                        width: 110,
                                        child: Text(
                                            widget.model.team2Score ?? '',
                                            // overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                //  fontFamily: "Roboto",
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: widget.match_status!.toLowerCase() ==
                                        'completed'
                                    ? Colors.white
                                    : widget.match_status!.toLowerCase() ==
                                                'live' ||
                                            widget.match_status!
                                                    .toLowerCase() ==
                                                'under review'
                                        ? Color(0xffF0D1D1)
                                        : Color(0xffDF0E0E1A).withAlpha(1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    new Container(
                                      height: 9,
                                      width: 9,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: widget.match_status == null
                                                  ? widget.model.isFromLive!
                                                      ? Color(0xffDF0E0E)
                                                      : Colors.green
                                                  : widget.match_status ==
                                                          "Completed"
                                                      ? Colors.green
                                                      : Color(0xffDF0E0E)),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: widget.match_status == null
                                              ? widget.model.isFromLive!
                                                  ? Color(0xffDF0E0E)
                                                  : Colors.green
                                              : widget.match_status ==
                                                      "Completed"
                                                  ? Colors.green
                                                  : Color(0xffDF0E0E)),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Text(
                                          widget.match_status == null
                                              ? widget.model.isFromLive!
                                                  ? 'Live'
                                                  : 'Completed'
                                              : widget.match_status!
                                                  .toUpperCase(),
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              color: widget.model.isFromLive!
                                                  ? Color(0xffDF0E0E)
                                                  : greenColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      widget.model.sportKey != 'CRICKET'
                          ? Container(
                              height: 5,
                            )
                          : Container(),

                      tvWinningText.isNotEmpty &&
                              (widget.match_status! != "Live" ||
                                  widget.match_status! != "LIVE")
                          ? Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(
                                  top: widget.model.sportKey == 'CRICKET'
                                      ? 10
                                      : 0,
                                  bottom: 5),
                              child: Text(tvWinningText,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12)),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),

              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    // image: DecorationImage(
                    //     image: AssetImage(AppImages.commanBackground),
                    //     fit: BoxFit.cover),
                    color: Colors.white),

                // color: _currentMatchIndex == 2 ? Colors.white : Colors.white,
                child: DefaultTabController(
                  length: tabs.length,
                  child: Column(
                    children: [
                      // widget.model.sportKey != "CRICKET"
                      //     ? SizedBox.shrink()
                      //     :
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1), // 👈 Divider line
                          ),
                        ),
                        child: TabBar(
                          labelPadding: widget.model.sportKey == "HOCKEY"
                              ? EdgeInsets.symmetric(horizontal: 16)
                              : EdgeInsets.all(0),
                          onTap: (int index) {
                            setState(() {
                              _currentMatchIndex = index;
                              if (widget.model.sportKey == "HOCKEY"
                                  ? _currentMatchIndex == 3
                                  : _currentMatchIndex == 2) {
                                widget.model.fantasyType = 0;
                                getPlayerPoints();
                              } else if (_currentMatchIndex == 2) {
                                widget.model.fantasyType = 3;
                              } else {
                                widget.model.fantasyType = 0;
                                getMatchScores();
                              }
                            });
                          },
                          indicatorWeight: 2,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: primaryColor,
                          isScrollable:
                              widget.model.sportKey == "HOCKEY" ? true : false,
                          tabs: getTabs(_currentMatchIndex),
                        ),
                      ),

                      widget.model.fantasyType == 0 ||
                              widget.model.fantasyType == 1 ||
                              widget.model.fantasyType == 2
                          ? Expanded(
                              child: RefreshIndicator(
                                onRefresh: _pullRefresh,
                                child: Container(
                                  child: ListView(
                                    //shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    children: [
                                      SizedBox(
                                        height: 12,
                                      ),
                                      widget.model.isFromLive == false &&
                                              _currentMatchIndex == 0 &&
                                              refreshScoreItem
                                                      .show_investment ==
                                                  1
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Stack(
                                                alignment: Alignment.topCenter,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 12,
                                                            right: 12,
                                                            bottom: 12),
                                                    child: Container(
                                                      // height: 112,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      // This will be covered by the image
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15)),
                                                        color:
                                                            LightprimaryColor,
                                                        // image: DecorationImage(
                                                        //   image: AssetImage(
                                                        //       AppImages
                                                        //           .investmentCard),
                                                        //   fit: BoxFit
                                                        //       .fill, // Ensures the image covers the entire container
                                                        // ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 14,
                                                                vertical: 8),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        'Investment',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "Roboto",
                                                                            color:
                                                                                Color(0xff393939),
                                                                            fontWeight: FontWeight.normal,
                                                                            fontSize: 11),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            top:
                                                                                4),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsets.only(right: 6),
                                                                              child: Container(
                                                                                height: 18,
                                                                                width: 18,
                                                                                child: Image.asset(AppImages.goldcoin),
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              "${refreshScoreItem.total_investment ?? "0"}",
                                                                              style: TextStyle(fontFamily: "Roboto", color: greenColor, fontWeight: FontWeight.w700, fontSize: 18),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    height: 40,
                                                                    color: Colors
                                                                        .white,
                                                                    width: 2,
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Text(
                                                                        'Winning',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "Roboto",
                                                                            color:
                                                                                Color(0xff393939),
                                                                            fontWeight: FontWeight.normal,
                                                                            fontSize: 11),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            top:
                                                                                4),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsets.only(right: 6),
                                                                              child: Container(
                                                                                height: 18,
                                                                                width: 18,
                                                                                child: Image.asset(AppImages.goldcoin),
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              "${refreshScoreItem.total_winning ?? "0"}",
                                                                              style: TextStyle(fontFamily: "Roboto", color: textcolor, fontWeight: FontWeight.w700, fontSize: 18),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    height: 40,
                                                                    color: Colors
                                                                        .white,
                                                                    width: 2,
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Text(
                                                                        'Net Profit & Loss',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "Roboto",
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.normal,
                                                                            fontSize: 11),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            top:
                                                                                4),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsets.only(right: 6),
                                                                              child: Container(
                                                                                height: 18,
                                                                                width: 18,
                                                                                child: Image.asset(AppImages.goldcoin),
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              "${refreshScoreItem.total_profit ?? "0"}",
                                                                              style: TextStyle(fontFamily: "Roboto", color: refreshScoreItem.total_profit.toString().contains('-') ? Colors.red : Color(0xff076e39), fontWeight: FontWeight.w700, fontSize: 18),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
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
                                            )
                                          : Container(),
                                      !loading
                                          ? _currentMatchIndex == 0
                                              ? contestList.length > 0
                                                  ? new ListView.builder(
                                                      padding: EdgeInsets.only(
                                                          bottom: 60),
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemCount:
                                                          contestList.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 6),
                                                          child: LiveFinishContestAdapter(
                                                              widget.model,
                                                              contestList[
                                                                  index],
                                                              match_status: widget
                                                                  .match_status),
                                                        );
                                                      })
                                                  : new Container(
                                                      margin: EdgeInsets.only(
                                                          top: 20),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "You haven't joined any challenge for this match.",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Roboto",
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 14),
                                                      ),
                                                    )
                                              : _currentMatchIndex == 1
                                                  ? new Container(
                                                      child: teamList.length > 0
                                                          ? new ListView
                                                              .builder(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8),
                                                              physics:
                                                                  NeverScrollableScrollPhysics(),
                                                              shrinkWrap: true,
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              itemCount:
                                                                  teamList
                                                                      .length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                return new TeamItemAdapter(
                                                                  widget.model,
                                                                  teamList[
                                                                      index],
                                                                  false,
                                                                  index,
                                                                  checkfrom:
                                                                      'isFromLive',
                                                                );
                                                              })
                                                          : new Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 20),
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                "You haven't created any team yet for this fantasy.",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Roboto",
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            ),
                                                    )
                                                  : widget.model.sportKey ==
                                                              "HOCKEY" &&
                                                          _currentMatchIndex ==
                                                              3
                                                      ? PlayerPoints(pointsList,
                                                          widget.model)
                                                      : widget.model.sportKey !=
                                                                  "HOCKEY" &&
                                                              _currentMatchIndex ==
                                                                  2
                                                          ? PlayerPoints(
                                                              pointsList,
                                                              widget.model)
                                                          : SizedBox.shrink()
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
        widget.model.isFromLive == true &&
                _currentMatchIndex == 0 &&
                refreshScoreItem.show_investment == 1
            ? Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor, // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12), // Padding inside button
                    elevation: 4, // Shadow (elevated effect)
                  ),
                  onPressed: () {
                    investmentBottomSheet(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Only take necessary space
                    children: [
                      Icon(Icons.show_chart,
                          color: Colors.white, size: 24), // Chart icon
                      SizedBox(width: 8), // Spacing between icon and text
                      Text(
                        'Show Investment',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500, // Medium weight
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container()
      ],
    );
  }

  void investmentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true, // Prevent closing by tapping outside
      enableDrag: false, // Prevent swipe down to close
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext investContext) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16, top: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'Investment Overview',
                      style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 12),
                          child: Container(
                            // height: 112,
                            width: MediaQuery.of(context).size.width,
                            // This will be covered by the image
                            decoration: BoxDecoration(
                              // color: Colors.pink,
                              image: DecorationImage(
                                image: AssetImage(AppImages.investmentCard),
                                fit: BoxFit
                                    .fill, // Ensures the image covers the entire container
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Investment',
                                            style: TextStyle(
                                                fontFamily: "Roboto",
                                                color: Color(0xff393939),
                                                fontWeight: FontWeight.normal,
                                                fontSize: 11),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 4),
                                                child: Container(
                                                  height: 16,
                                                  child: Image.asset(
                                                      AppImages.goldcoin),
                                                ),
                                              ),
                                              Text(
                                                "${refreshScoreItem.total_investment ?? "0"}",
                                                style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    color: buttonGreenColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Winning',
                                            style: TextStyle(
                                                fontFamily: "Roboto",
                                                color: Color(0xff393939),
                                                fontWeight: FontWeight.normal,
                                                fontSize: 11),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 6),
                                                child: Container(
                                                  height: 16,
                                                  child: Image.asset(
                                                      AppImages.goldcoin),
                                                ),
                                              ),
                                              Text(
                                                "${refreshScoreItem.total_winning ?? "0"}",
                                                style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xffCCCCCC)),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(7),
                                          ),
                                          color: Colors.white.withOpacity(0.5)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Net Profit & Loss',
                                                  style: TextStyle(
                                                      fontFamily: "Roboto",
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 11),
                                                ),
                                                Text(
                                                  "Winnings - Investment",
                                                  style: TextStyle(
                                                      fontFamily: "Roboto",
                                                      color: Color(0xff989898),
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 11),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 6),
                                                  child: Container(
                                                    height: 16,
                                                    child: Image.asset(
                                                        AppImages.goldcoin),
                                                  ),
                                                ),
                                                Text(
                                                  "${refreshScoreItem.total_profit ?? "0"}",
                                                  style: TextStyle(
                                                      fontFamily: "Roboto",
                                                      color: refreshScoreItem
                                                              .total_profit
                                                              .toString()
                                                              .contains('-')
                                                          ? redColor
                                                          : Color(0xff076e39),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: -20, // pull it above the top edge
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 243, 237, 244),
                      border: Border.all(color: primaryColor),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: primaryColor,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pullRefresh() async {
    getMatchScores();
  }

  Widget getClassicTab() {
    return new ClipRRect(
      // borderRadius: BorderRadius.horizontal(left:  Radius.circular(10),right: Radius.circular(_currentIndex==1 ? 0 : 10)),
      child: new Container(
        height: 35,
        alignment: Alignment.center,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Text(
          '7+4',
          style: TextStyle(
              fontFamily: "Roboto",
              color: Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 11),
        ),
      ),
    );
  }

  Widget getTenPlusOneTab() {
    return new ClipRRect(
      // borderRadius: BorderRadius.horizontal(left:  Radius.circular(10),right: Radius.circular(10)),
      child: new Container(
        height: 35,
        alignment: Alignment.center,
        margin: EdgeInsets.zero,
        color: Colors.white,
        child: Text(
          '10+1',
          style: TextStyle(
              fontFamily: "Roboto",
              color: Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 12),
        ),
      ),
    );
  }

  Widget getMyContestTab(int index) {
    return new ClipRRect(
      // borderRadius: BorderRadius.horizontal(left:  Radius.circular(10),right: Radius.circular(10)),
      child: new Container(
        height: 35,
        alignment: Alignment.center,
        margin: EdgeInsets.zero,
        color: Colors.white,
        child: Text(
          'My Contest (${contestList.length})',
          style: TextStyle(
              fontFamily: "Roboto",
              color: index == 0 ? primaryColor : Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 12),
        ),
      ),
    );
  }

  Widget getMyTeamsTab(int index) {
    return new ClipRRect(
      // borderRadius: BorderRadius.horizontal(left:  Radius.circular(10),right: Radius.circular(10)),
      child: new Container(
        height: 35,
        alignment: Alignment.center,
        margin: EdgeInsets.zero,
        color: Colors.white,
        child: Text(
          'My Teams (${teamList.length})',
          style: TextStyle(
              fontFamily: "Roboto",
              color: index == 1 ? primaryColor : Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 12),
        ),
      ),
    );
  }

  Widget getPlayerStateTab(int index) {
    return new ClipRRect(
      // borderRadius: BorderRadius.horizontal(left:  Radius.circular(10),right: Radius.circular(10)),
      child: new Container(
        height: 35,
        alignment: Alignment.center,
        margin: EdgeInsets.zero,
        color: Colors.white,
        child: Text(
          'Stats',
          style: TextStyle(
              fontFamily: "Roboto",
              color: //(widget.model.sportKey == "CRICKET" && index == 3) ||
                  (index == 2) ? primaryColor : Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 12),
        ),
      ),
    );
  }

  Widget getFivePlusOneTab() {
    return new ClipRRect(
      // borderRadius: BorderRadius.horizontal(left: Radius.circular(10),right: Radius.circular(10)),
      child: new Container(
        height: 35,
        alignment: Alignment.center,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Text(
          '5+1',
          style: TextStyle(
              fontFamily: "Roboto",
              color: Colors.grey,
              fontWeight: FontWeight.normal,
              fontSize: 12),
        ),
      ),
    );
  }

  Widget getScoreCardTab(int index) {
    return ClipRRect(
      // borderRadius: BorderRadius.horizontal(left: Radius.circular(10),right: Radius.circular(10)),
      child: Container(
        height: 35,
        alignment: Alignment.center,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Text(
          'Scorecard',
          style: TextStyle(
              fontFamily: "Roboto",
              color: index == 2 ? primaryColor : Colors.grey,
              fontWeight: FontWeight.normal,
              fontSize: 12),
        ),
      ),
    );
  }

  Widget getCommentaryTab() {
    return new ClipRRect(
      // borderRadius: BorderRadius.horizontal(left: Radius.circular(10),right: Radius.circular(10)),
      child: new Container(
        height: 35,
        alignment: Alignment.center,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Text(
          'Commentary',
          style: TextStyle(
              fontFamily: "Roboto",
              color: Colors.grey,
              fontWeight: FontWeight.normal,
              fontSize: 10),
        ),
      ),
    );
  }

  List<Widget> getTabs(int TabIndex) {
    tabs.clear();
    fantasyTypes.clear();

    tabs.add(getMyContestTab(TabIndex));
    //fantasyTypes.add(0);

    tabs.add(getMyTeamsTab(TabIndex));

    // fantasyTypes.add(1);
    // tabs.add(getClassicTab());
    // fantasyTypes.add(2);
    if (widget.model.sportKey == 'HOCKEY') {
      tabs.add(getScoreCardTab(TabIndex));
      fantasyTypes.add(3);

      tabs.add(getPlayerStateTab(TabIndex));
      // fantasyTypes.add(4);
    } else {
      // tabs.add(getScoreCardTab(TabIndex));
      // fantasyTypes.add(0);
      widget.model.fantasyType = 2;

      tabs.add(getPlayerStateTab(TabIndex));
    }

    /*  tabs.add(getReverseTab());
      fantasyTypes.add(5);*/

    return tabs;
  }

  int getFantasyTabCount() {
    int count = 1;
    if (widget.model.battingFantasy == 1) {
      count += 1;
    }
    if (widget.model.bowlingFantasy == 1) {
      count += 1;
    }
    if (widget.model.reverseFantasy == 1) {
      count += 1;
    }
    if (widget.model.commentry == 1) {
      count += 1;
    }
    if (widget.model.scorecard == 1) {
      count += 1;
    }
    return count;
  }

  Widget getFullMatchTab() {
    return Container(
      height: 45,
      alignment: Alignment.center,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Text(
        'Full Match',
        style: TextStyle(
            fontFamily: "Roboto",
            color: _currentIndex == 0 ? primaryColor : Colors.grey,
            fontWeight: FontWeight.w400,
            fontSize: 14),
      ),
    );
  }

  Widget getBattingTab() {
    return Container(
      height: 45,
      alignment: Alignment.center,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Text(
        'Batting',
        style: TextStyle(
            fontFamily: "Roboto",
            color: _currentIndex == 1 ? primaryColor : Colors.grey,
            fontWeight: FontWeight.w400,
            fontSize: 14),
      ),
    );
  }

  Widget getBowlingTab() {
    return new Container(
      height: 45,
      alignment: Alignment.center,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Text(
        'Bowling',
        style: TextStyle(
            fontFamily: "Roboto",
            color: _currentIndex == 2 ? primaryColor : Colors.grey,
            fontWeight: FontWeight.w400,
            fontSize: 14),
      ),
    );
  }

  Widget getReverseTab() {
    return Container(
      height: 45,
      alignment: Alignment.center,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Text(
        'Reverse',
        style: TextStyle(
            fontFamily: "Roboto",
            color: _currentIndex == 3 ? primaryColor : Colors.grey,
            fontWeight: FontWeight.w400,
            fontSize: 14),
      ),
    );
  }

  void getMatchScores() async {
    setState(() {
      loading = true;
    });
    AppLoaderProgress.showLoader(context);
    ContestRequest contestRequest = new ContestRequest(
        user_id: userId,
        matchkey: widget.model.matchKey,
        sport_key: widget.model.sportKey,
        fantasy_type: widget.model.fantasyType.toString(),
        fantasy_type_id: CricketTypeFantasy.getCricketType(
            widget.model.fantasyType.toString(),
            sportsKey: widget.model
                .sportKey) /*widget.model.fantasyType==1?"7":widget.model.fantasyType==2?"6":"0"*/,
        slotes_id: widget.model.slotId.toString());
    final client = ApiClient(AppRepository.dio);
    RefreshScoreResponse response = await client.getMatchScores(contestRequest);
    if (response.status == 1) {
      refreshScoreItem = response.result ?? RefreshScoreItem();
      show_popper = refreshScoreItem.show_popper ?? 0;
      contestList = response.result!.contest ?? [];
      teamList = response.result!.teams ?? [];
      LiveFinishedScoreItem scoreItem = refreshScoreItem.matchruns![0];
      team1Score = widget.model.sportKey == 'CRICKET'
          ? scoreItem.Team1_Totalruns.toString() +
              "/" +
              scoreItem.Team1_Totalwickets.toString() +
              " (" +
              scoreItem.Team1_Totalovers.toString() +
              ")"
          : scoreItem.Team1_Totalruns.toString();
      team2Score = widget.model.sportKey == 'CRICKET'
          ? scoreItem.Team2_Totalruns.toString() +
              "/" +
              scoreItem.Team2_Totalwickets.toString() +
              " (" +
              scoreItem.Team2_Totalovers.toString() +
              ")"
          : scoreItem.Team2_Totalruns.toString();
      tvWinningText = scoreItem.Winning_Status ?? '';
      widget.model.team1Score = team1Score;
      widget.model.team2Score = team2Score;
      widget.model.winningText = tvWinningText;
      showPopUp();
    }
    setState(() {
      loading = false;
      initialLoading = false;
      AppLoaderProgress.hideLoader(context);
    });
  }

  void getPlayerPoints() async {
    AppLoaderProgress.showLoader(context);
    ContestRequest contestRequest = new ContestRequest(
        user_id: userId,
        matchkey: widget.model.matchKey,
        sport_key: widget.model.sportKey,
        fantasy_type: widget.model.fantasyType.toString(),
        fantasy_type_id: CricketTypeFantasy.getCricketType(
            widget.model.fantasyType.toString(),
            sportsKey: widget.model
                .sportKey) /*widget.model.fantasyType==1 ? "7" : widget.model.fantasyType==2?"6":"0"*/,
        slotes_id: widget.model.slotId.toString());
    final client = ApiClient(AppRepository.dio);
    PlayerPointsResponse response =
        await client.getPlayerPoints(contestRequest);
    if (response.status == 1) {
      pointsList = response.result ?? [];
    }
    setState(() {
      AppLoaderProgress.hideLoader(context);
    });
  }

  Widget matchScore() {
    return Container(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    new GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => {Navigator.pop(context)},
                      child: new Container(
                        alignment: Alignment.centerLeft,
                        child: new Container(
                          height: 30,
                          child: Image(
                              image: AssetImage(AppImages.backImageURL),
                              fit: BoxFit.fill),
                        ),
                      ),
                    ),
                    new Container(
                      child: new Text(widget.model.teamVs ?? '',
                          style: TextStyle(
                              fontFamily: "Roboto",
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 15),
              child: Column(
                children: [
                  Image.asset(
                    AppImages.company_logo,
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: new Container(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              new Text(widget.model.team1Name ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12)),
                              new Container(
                                margin: EdgeInsets.only(
                                  top: 5,
                                ),
                                child: new Text(
                                    widget.model.team1Score == "/0 (0)"
                                        ? "Yet to bat"
                                        : widget.model.team1Score ?? '',
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16)),
                              ),
                            ],
                          ),
                        ),
                        flex: 1,
                      ),
                      // widget.match_status == "Completed"
                      //     ?

                      // : SizedBox.shrink(),
                      Expanded(
                        child: new Container(
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              new Container(
                                height: 10,
                                width: 10,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: widget.match_status == null
                                            ? widget.model.isFromLive!
                                                ? Color(0xffDF0E0E)
                                                : Colors.green
                                            : widget.match_status == "Completed"
                                                ? Colors.green
                                                : Color(0xffDF0E0E)),
                                    borderRadius: BorderRadius.circular(5),
                                    color: widget.match_status == null
                                        ? widget.model.isFromLive!
                                            ? Color(0xffDF0E0E)
                                            : Colors.green
                                        : widget.match_status == "Completed"
                                            ? Colors.green
                                            : Color(0xffDF0E0E)),
                              ),
                              new Container(
                                margin: EdgeInsets.only(left: 5),
                                child: new Text(
                                    widget.match_status == null
                                        ? widget.model.isFromLive!
                                            ? 'Live'
                                            : 'Completed'
                                        : widget.match_status ?? '',
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        color: widget.model.isFromLive!
                                            ? Colors.white
                                            : Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11)),
                              ),
                            ],
                          ),
                        ),
                        flex: 1,
                      ),

                      Expanded(
                        child: new Container(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              new Text(widget.model.team2Name ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12)),
                              new Container(
                                margin: EdgeInsets.only(top: 5),
                                child: new Text(
                                    widget.model.team2Score == "/0 (0)" ||
                                            widget.model.team2Score == "0"
                                        ? "Yet to bat"
                                        : widget.model.team2Score ?? '',
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16)),
                              ),
                            ],
                          ),
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            widget.model.winningText != null
                ? widget.model.winningText!.isNotEmpty
                    ? Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 20, bottom: 0),
                        child: new Text(widget.model.winningText ?? '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 12)),
                      )
                    : Container()
                : Container(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
