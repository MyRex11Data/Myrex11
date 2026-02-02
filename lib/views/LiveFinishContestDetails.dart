import 'dart:async';
import 'package:dotted_border/dotted_border.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
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
import 'package:myrex11/repository/model/contest_details_response.dart';
import 'package:myrex11/repository/model/contest_request.dart';
import 'package:myrex11/repository/model/player_points_response.dart';
import 'package:myrex11/repository/model/refresh_score_response.dart';
import 'package:myrex11/repository/model/score_card_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';
import 'package:myrex11/views/PlayerPoints.dart';
import '../repository/model/team_response.dart';
import 'Leaderboard.dart';
import 'WinningBreakups.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class LiveFinishContestDetails extends StatefulWidget {
  LiveFinishedContestData contest;
  GeneralModel model;
  String? match_status;
  LiveFinishContestDetails(this.contest, this.model, {this.match_status});
  @override
  _LiveFinishContestDetailsState createState() =>
      _LiveFinishContestDetailsState();
}

class _LiveFinishContestDetailsState extends State<LiveFinishContestDetails> {
  var title = 'Home';
  bool back_dialog = false;
  int _currentMatchIndex = 1;
  List<Widget> tabs = <Widget>[];
  String userId = '0';
  String team1Score = '0/0 (0)';
  String team2Score = '0/0 (0)';
  String tvWinningText = '';
  bool loading = false;
  RefreshScoreItem refreshScoreItem = new RefreshScoreItem();
  List<WinnerScoreCardItem> breakupList = [];
  List<JoinedContestTeam> leaderboardList = [];
  List<Team> teamList = [];
  List<MultiSportsPlayerPointItem> pointsList = [];
  List<LiveFinishedContestData> contestList = [];
  dynamic isLeaderboardCall = 0;
  dynamic totalUser;
  int page = 0;

  @override
  void initState() {
    super.initState();
    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
        .then((value) => {
              setState(() {
                userId = value;
                getMatchScores();
                getLeaderboardList();
              })
            });
  }

  @override
  void dispose() {
    super.dispose();
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
        slotes_id: widget.model.slotId.toString());
    final client = ApiClient(AppRepository.dio);
    RefreshScoreResponse response = await client.getMatchScores(contestRequest);
    if (response.status == 1) {
      refreshScoreItem = response.result!;
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
    }
    setState(() {
      loading = false;
      AppLoaderProgress.hideLoader(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            /* set Status bar color in Android devices. */

            statusBarIconBrightness: Brightness.light,
            /* set Status bar icons color in Android devices.*/

            statusBarBrightness:
                Brightness.dark) /* set Status bar icon color in iOS. */
        );
    // TODO: implement build
    return new Scaffold(
        body: RefreshIndicator(
      onRefresh: _pullRefresh,
      child: new WillPopScope(
          child: new Scaffold(
            backgroundColor: Colors.transparent,
            body: new Container(
              height: MediaQuery.of(context).size.height,
              // color: Colors.white,
              child: new Column(
                mainAxisSize: MainAxisSize.max,
                children: [
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
                                            image: AssetImage(
                                                AppImages.backImageURL),
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
                                  child: Image.asset(AppImages.LogoWhite,
                                      height: 40),
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
                            padding:
                                EdgeInsets.only(left: 15, right: 15, top: 0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: MediaQuery.of(context).size.width *
                                          0.34,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 5),
                                            child: Text(
                                                widget.model.team1Name ?? '',
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
                                            child: Text(
                                                widget.model.team1Score ?? '',
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
                                      width: MediaQuery.of(context).size.width *
                                          0.34,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 5),
                                            child: Text(
                                                widget.model.team2Name ?? '',
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
                                      color:
                                          widget.match_status!.toLowerCase() ==
                                                  'completed'
                                              ? Colors.white
                                              : widget.match_status!
                                                              .toLowerCase() ==
                                                          'live' ||
                                                      widget.match_status!
                                                              .toLowerCase() ==
                                                          'under review'
                                                  ? Color(0xffF0D1D1)
                                                  : Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        new Container(
                                          height: 9,
                                          width: 9,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: widget.match_status ==
                                                          null
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
                                                  color:
                                                      widget.model.isFromLive!
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
                      child: DefaultTabController(
                        length: 2,
                        initialIndex: 1,
                        child: Column(
                          children: [
                            Container(
                              color: LightprimaryColor,
                              child: TabBar(
                                padding: EdgeInsets.zero,
                                labelPadding: EdgeInsets.all(0),
                                onTap: (int index) {
                                  setState(() {
                                    _currentMatchIndex = index;
                                    if (_currentMatchIndex == 0) {
                                      getWinnerPriceCard();
                                    } else if (_currentMatchIndex == 1) {
                                      getLeaderboardList();
                                    } else {
                                      getPlayerPoints();
                                    }
                                  });
                                },
                                indicatorWeight: 2,
                                indicatorSize: TabBarIndicatorSize.label,
                                indicatorPadding:
                                    EdgeInsets.only(left: 16.0, right: 16.0),
                                indicatorColor: primaryColor,
                                // indicator: ShapeDecoration(
                                //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
                                //     color: Colors.black
                                // ),
                                isScrollable: false,
                                tabs: getTabs(),
                              ),
                            ),
                            Expanded(
                                child: Container(
                              child: _currentMatchIndex == 0
                                  ? new WinningBreakups(
                                      breakupList,
                                    )
                                  : _currentMatchIndex == 1
                                      ? new Leaderboard(
                                          totalUser,
                                          leaderboardList,
                                          userId,
                                          false,
                                          widget.contest.pdf!,
                                          widget.model,
                                          isLeaderboardCall: isLeaderboardCall,
                                          getLeaderboardList:
                                              getLeaderboardList,
                                        )
                                      : new SingleChildScrollView(
                                          child: new Container(
                                            child: new Column(
                                              children: [
                                                new PlayerPoints(
                                                    pointsList, widget.model)
                                              ],
                                            ),
                                          ),
                                        ),
                            ))
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          onWillPop: _onWillPop),
    ));
  }

  Future<void> _pullRefresh() async {
    getMatchScores();
    getLeaderboardList();
    getWinnerPriceCard();
  }

  Future<bool> _onWillPop() async {
    setState(() {
      Navigator.pop(context);
    });
    return Future.value(false);
  }

  List<Widget> getTabs() {
    tabs.clear();
    tabs.add(getWinningTab());
    tabs.add(getLeaderboardTab());
    //tabs.add(getPlayerStatsTab());
    return tabs;
  }

  Widget getWinningTab() {
    return new ClipRRect(
      borderRadius: BorderRadius.horizontal(left: Radius.circular(0)),
      child: new Container(
        height: 45,
        alignment: Alignment.center,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(color: LightprimaryColor),
        child: Text(
          'Winning Breakup',
          style: TextStyle(
              // fontFamily: "Roboto",
              color: _currentMatchIndex == 0 ? primaryColor : Color(0xff686869),
              fontWeight: FontWeight.w500,
              fontSize: 14),
        ),
      ),
    );
  }

  Widget getLeaderboardTab() {
    return new ClipRRect(
      borderRadius: BorderRadius.horizontal(left: Radius.circular(0)),
      child: new Container(
        height: 45,
        alignment: Alignment.center,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(color: LightprimaryColor),
        child: Text(
          'Leaderboard',
          style: TextStyle(
              // fontFamily: "Roboto",
              color: _currentMatchIndex == 1 ? primaryColor : Color(0xff686869),
              fontWeight: FontWeight.w500,
              fontSize: 14),
        ),
      ),
    );
  }

  Widget getPlayerStatsTab() {
    return new ClipRRect(
      borderRadius: BorderRadius.horizontal(left: Radius.circular(0)),
      child: new Container(
        height: 45,
        alignment: Alignment.center,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Text(
          'Player Stats',
          style: TextStyle(
              fontFamily: "Roboto",
              color: _currentMatchIndex == 2 ? Colors.black : Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 14),
        ),
      ),
    );
  }

  void getWinnerPriceCard() async {
    AppLoaderProgress.showLoader(context);
    ContestRequest request = new ContestRequest(
      user_id: userId,
      challenge_id: widget.contest.id.toString(),
      fantasy_type_id: CricketTypeFantasy.getCricketType(
          widget.model.fantasyType.toString(),
          sportsKey: widget.model
              .sportKey) /*widget.model.fantasyType==1?"7":widget.model.fantasyType==2 ?"6":"0"*/,
      matchkey: widget.model.matchKey,
    );
    final client = ApiClient(AppRepository.dio);
    ScoreCardResponse response = await client.getWinnersPriceCard(request);
    if (response.status == 1) {
      breakupList = response.result!;
    }
    // Fluttertoast.showToast(msg: response.message, toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 1);
    setState(() {
      AppLoaderProgress.hideLoader(context);
    });
  }

  getLeaderboardList() async {
    page++;
    AppLoaderProgress.showLoader(context);
    ContestRequest request = new ContestRequest(
        user_id: userId,
        challenge_id: widget.contest.id.toString(),
        matchkey: widget.model.matchKey,
        fantasy_type_id: CricketTypeFantasy.getCricketType(
            widget.model.fantasyType.toString(),
            sportsKey: widget.model
                .sportKey) /*widget.model.fantasyType==1?"7":widget.model.fantasyType==2 ?"6":"0"*/,
        sport_key: widget.model.sportKey,
        page: "$page");
    final client = ApiClient(AppRepository.dio);
    ContestDetailResponse response = await client.getLeaderboardList(request);
    if (response.status == 1) {
      totalUser = response.result!.totaljoin;
      isLeaderboardCall = response.pages_status;
      leaderboardList.addAll(response.result!.contest!);
    }
    // Fluttertoast.showToast(msg: response.message, toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 1);
    setState(() {
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
        slotes_id: widget.model.slotId.toString());
    final client = ApiClient(AppRepository.dio);
    PlayerPointsResponse response =
        await client.getPlayerPoints(contestRequest);
    if (response.status == 1) {
      pointsList = response.result!;
    }
    setState(() {
      AppLoaderProgress.hideLoader(context);
    });
  }
}
