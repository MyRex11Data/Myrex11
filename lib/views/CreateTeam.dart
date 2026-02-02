import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myrex11/appmixins/MinMaxPlayerSelectionMixin.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/app_navigator.dart';
import 'package:myrex11/appUtilities/date_utils.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/buildType/buildType.dart';
import 'package:myrex11/customWidgets/ScrollingText.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/dataModels/SelectedPlayer.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/contest_request.dart';
import 'package:myrex11/repository/model/player_list_response.dart';
import 'package:myrex11/repository/model/team_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';
import 'package:myrex11/views/CreateTeamPager.dart';
import '../customWidgets/MatchHeader.dart';
import '../repository/model/category_contest_response.dart';
import 'package:myrex11/customWidgets/VisionCustomTimerController.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

class CreateTeam extends StatefulWidget {
  Function? onTeamCreated;
  GeneralModel model;
  Contest? contest;
  String? check;
  double? scrollPosition;
  PlayerListResponse? isreponsegetting;
  int? contestNumber;
  int? teamId;
  bool? isDynaminLink;
  String? checkScreen;
  String? contestFrom;
  int? joinSimilar;

  CreateTeam(this.model,
      {this.isDynaminLink,
      this.contest,
      this.onTeamCreated,
      this.check,
      this.contestNumber,
      this.scrollPosition,
      this.teamId,
      this.checkScreen,
      this.contestFrom,
      this.joinSimilar});
  @override
  _CreateTeamState createState() => new _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam>
    with SingleTickerProviderStateMixin, MinMaxPlayer, WidgetsBindingObserver {
  // final timeController = CustomTimerController();
  int _currentMatchIndex = 0;
  int localTeamplayerCount = 0;
  int visitorTeamPlayerCount = 0;
  List<Widget> tabs = <Widget>[];
  List<Widget> tabsView = <Widget>[];
  bool clearTeamDialog = false;
  bool rulesDialog = false;
  bool exeedCredit = false;
  bool fantasyAlertShown = false;
  int isPointSorted = 0, isCreditSorted = 0, isPLayerSorted = 0;
  String userId = '0';
  int credittype = 0;
  String filterType = 'All';
  static final int WK = 1;
  static final int BAT = 2;
  static final int AR = 3;
  static final int BOWLER = 4;
  static final int C = 5;
  late TabController _tabController;
  List<Player> team1wkList = [];
  List<Player> team2wkList = [];
  List<Player> wkListTemp = [];
  List<Player> wkList = [];
  List<Player> team1bolList = [];
  List<Player> team2bolList = [];
  List<Player> bolListTemp = [];
  List<Player> bolList = [];
  List<Player> team1batList = [];
  List<Player> team2batList = [];
  List<Player> batListTemp = [];
  List<Player> batList = [];
  List<Player> team1arList = [];
  List<Player> team2arList = [];
  List<Player> arListTemp = [];
  List<Player> arList = [];
  List<Player> team1cList = [];
  List<Player> team2cList = [];
  List<Player> cListTemp = [];
  List<Player> cList = [];
  List<Player> allPlayerList = [];
  List<Player> selectedList = [];
  List<Player> isPlayingPlayers1 = [];
  List<Player> isPlayingPlayers2 = [];
  var teamid;
  late Limit limit = Limit(total_credits: 0, maxplayers: 0);
  int? islineUp;
  int? islineUpOut;
  SelectedPlayer selectedPlayer = new SelectedPlayer();
  bool creditPopup = false;
  bool lineupPopup = false;
  GlobalKey btnKey = GlobalKey();
  GlobalKey btnKey1 = GlobalKey();
  String maxPlayerString = "";
  late Duration duration;
  Timer? timer;
  late DateTime endTime;
  bool timesend = false;
  String iosModel = '';
  final VisionCustomTimerController controller = VisionCustomTimerController();

  @override
  void initState() {
    super.initState();
    print(widget.checkScreen);
    if (widget.model.isFromEditOrClone ?? false) {
      selectedList = widget.model.selectedList ?? [];
      widget.model.isFromEditOrClone = false;
    }
    _tabController = new TabController(
        length: widget.model.sportKey == AppConstants.TAG_KABADDI
            ? 3
            : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                ? 5
                : 4,
        vsync: this);
    _tabController.animation!
      ..addListener(() {
        setState(() {
          _currentMatchIndex = (_tabController.animation!.value).round();
        });
      });

    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
        .then((value) => {
              setState(() {
                userId = value;
                getPlayerList();
              })
            });

    if (widget.model.fantasyType == AppConstants.BATTING_FANTASY_TYPE) {
      _tabController.index = 1;
    } else if (widget.model.fantasyType == AppConstants.BOWLING_FANTASY_TYPE) {
      _tabController.index = 3;
    }

    _tabController.index = 0;
    setState(() {
      if (widget.model.unlimited_credit_match == 1) {
        // widget.model.credittype = 1;
        creditPopup = true;
      }
    });
    calculateEndTime();
    if (Platform.isAndroid) {
      startAlarm();
    }
    // _loadProductName();

    // initializeTimer();
  }

  @override
  void dispose() {
    _tabController.dispose();
    stopAlarm();

    super.dispose();
  }

  void calculateEndTime() {
    DateTime currentTime = MethodUtils.getDateTime();
    DateTime startTime =
        DateFormat.getFormattedDateObj(widget.model.headerText!)!;
    endTime = startTime.add(Duration(
        milliseconds: startTime.millisecondsSinceEpoch -
            currentTime.millisecondsSinceEpoch));
  }

  void onTimeUp() {
    // if (!AppConstants.candvcTimeUp) {
    //   AppConstants.createTimeUp = true;
    //   print('create');
    //   Navigator.pop(context);
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
    if (!AppConstants.candvcTimeUp) {
      AppConstants.createTimeUp = true;
      // Note: Navigating to the homepage directly from here might not work,
      // you might need to use a notification or other method to inform the app.
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    teamid = widget.model.teamId;
  }

  uiUpdate() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark));
  }

  @override
  Widget build(BuildContext context) {
    uiUpdate();
    return new Scaffold(
        body: WillPopScope(
            child: Stack(
              children: [
                SafeArea(
                  top: false,
                  child: Scaffold(
                    body: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: primaryColor,
                              ),
                              child: Column(
                                children: [
                                  PreferredSize(
                                    preferredSize:
                                        Size.fromHeight(38), // Set this height
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 38),
                                      child: Container(
                                        // margin: EdgeInsets.only(top: 45),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 15,
                                              right: 12,
                                              top: 15,
                                              bottom: 15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    behavior: HitTestBehavior
                                                        .translucent,
                                                    onTap: () => {_onWillPop()},
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          right: 12),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Container(
                                                        height: 30,
                                                        child: Image(
                                                          image: AssetImage(
                                                              AppImages
                                                                  .backImageURL),

                                                          // color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        //width:50,
                                                        child: new Text(
                                                            "Create Team",
                                                            style: TextStyle(
                                                                // fontFamily: "Roboto",
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14)),
                                                      ),
                                                      Container(
                                                        // margin: EdgeInsets.only(left: 10),
                                                        child: MatchHeader(
                                                            widget
                                                                .model.teamVs!,
                                                            widget.model
                                                                .headerText!,
                                                            widget.model
                                                                    .isFromLive ??
                                                                false,
                                                            widget.model
                                                                    .isFromLiveFinish ??
                                                                false,
                                                            teamColor:
                                                                Colors.white,
                                                            timerColor:
                                                                Colors.white,
                                                            screenType:
                                                                "createTeam"),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              new Container(
                                                margin: EdgeInsets.only(
                                                    top: 0, right: 10),
                                                alignment: Alignment.center,
                                                child: new Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    if (AppConstants
                                                        .how_to_play_url
                                                        .isNotEmpty)
                                                      new GestureDetector(
                                                        behavior:
                                                            HitTestBehavior
                                                                .translucent,
                                                        child: new Container(
                                                          child: new Row(
                                                            children: [
                                                              new Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            5),
                                                                height: 30,
                                                                // width: 22,
                                                                child: Image(
                                                                  image: AssetImage(
                                                                      AppImages
                                                                          .helpIcon),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        onTap: () => {
                                                          navigateToVisionWebView(
                                                              context,
                                                              'How to Play',
                                                              AppConstants
                                                                  .how_to_play_url)
                                                        },
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Center(
                                    child: Text(
                                      // widget.model.fantasyType == 1 ? 'Max 10 Players from  a team':widget.model.fantasyType==2?'Max 5 Players from  a team':"Max 7 Players from  a team" ,
                                      "Max $maxPlayerString Players from  a team",
                                      style: TextStyle(
                                          // fontFamily: "Roboto",
                                          color: Colors.white,
                                          fontSize: 12),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(0),
                                    margin: EdgeInsets.only(
                                        left: 16,
                                        top: 10,
                                        bottom: 0,
                                        right: 16),
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        new Container(
                                          margin: EdgeInsets.only(top: 2),
                                          child: new Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              new Container(
                                                child: new Text(
                                                  'Players',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontFamily: "Roboto",
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12),
                                                ),
                                              ),
                                              new Container(
                                                child: new Text(
                                                  (selectedPlayer
                                                              .selectedPlayer)
                                                          .toString() +
                                                      '/${SportTypeFantasy.getSportType(widget.model.sportKey, widget.model)}',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      // fontFamily: "Roboto",
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        new Container(
                                            child: new Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                              new Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  new Column(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    30)),
                                                        child: new Container(
                                                          height: 38,
                                                          width: 38,
                                                          // margin: EdgeInsets.only(
                                                          //     bottom: 5),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: widget
                                                                .model
                                                                .team1Logo!,
                                                            placeholder: (context,
                                                                    url) =>
                                                                new Image.asset(
                                                                    AppImages
                                                                        .logoPlaceholderURL),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                new Image.asset(
                                                                    AppImages
                                                                        .logoPlaceholderURL),
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  new Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    child: new Column(
                                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        new Container(
                                                          // width: 50,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 2),
                                                          child: new Text(
                                                            widget.model.teamVs!
                                                                .split(
                                                                    ' VS ')[0],
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                                // fontFamily: "Roboto",
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                        new Container(
                                                          // height: 24,
                                                          // width: 24,
                                                          // margin: EdgeInsets.only(left: 5),
                                                          alignment:
                                                              Alignment.center,
                                                          // decoration: BoxDecoration(
                                                          //     border: Border.all(
                                                          //         color:
                                                          //         Colors.transparent),
                                                          //     borderRadius:
                                                          //     BorderRadius.circular(12),
                                                          //     color: Colors.white12),
                                                          child: new Text(
                                                            localTeamplayerCount
                                                                .toString(),
                                                            style: TextStyle(
                                                                //fontFamily: "Roboto",
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ])),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        new Container(
                                            child: new Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            new Row(
                                              children: [
                                                // new Container(

                                                new Container(
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  child: new Column(
                                                    // crossAxisAlignment:
                                                    // CrossAxisAlignment.start,
                                                    children: [
                                                      new Container(
                                                        // width: 60,
                                                        alignment: Alignment
                                                            .centerRight,
                                                        margin: EdgeInsets.only(
                                                            top: 2),
                                                        child: new Text(
                                                          " " +
                                                              widget
                                                                  .model.teamVs!
                                                                  .split(
                                                                      ' VS ')[1] +
                                                              "",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              // fontFamily: "Roboto",
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 14),
                                                        ),
                                                      ),
                                                      new Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: new Text(
                                                          "${visitorTeamPlayerCount.toString()}",
                                                          style: TextStyle(
                                                              //fontFamily: "Roboto",
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                new Column(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  30)),
                                                      child: new Container(
                                                        height: 38,
                                                        width: 38,
                                                        // margin: EdgeInsets.only(
                                                        //   bottom: 5,
                                                        // ),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: widget
                                                              .model.team2Logo!,
                                                          placeholder: (context,
                                                                  url) =>
                                                              new Image.asset(
                                                                  AppImages
                                                                      .logoPlaceholderURL),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              new Image.asset(
                                                                  AppImages
                                                                      .logoPlaceholderURL),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                        new Container(
                                          margin: EdgeInsets.only(top: 2),
                                          child: new Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              new Container(
                                                child: new Text(
                                                  'Credits Left',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      // fontFamily: "Roboto",
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12),
                                                ),
                                              ),
                                              widget.model.unlimited_credit_match ==
                                                          1 &&
                                                      credittype == 1
                                                  ? new Container(
                                                      child: new Text(
                                                        widget.model
                                                            .unlimited_credit_text!
                                                            .split(" ")
                                                            .first,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            // fontFamily: "Roboto",
                                                            color: Color(
                                                                0xFFffd84d),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16),
                                                      ),
                                                    )
                                                  : new Container(
                                                      child: new Text(
                                                        (limit.total_credits! -
                                                                selectedPlayer
                                                                    .total_credit)
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            //   fontFamily: "Roboto",
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: widget.model.toss != '' &&
                                            widget.model.toss != "" &&
                                            widget.model.toss != null
                                        ? const EdgeInsets.symmetric(
                                            vertical: 8)
                                        : const EdgeInsets.symmetric(
                                            vertical: 0),
                                    child: Text(
                                      widget.model.toss ?? ' ',
                                      style: TextStyle(
                                          //  fontFamily: "Roboto",
                                          color: Colors.white,
                                          fontSize: 12),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 0, bottom: 7, left: 10, right: 5),
                                    // width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            height: 18,
                                            child: new ListView.builder(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: limit.maxplayers,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return new Container(
                                                    width: 26,
                                                    margin: EdgeInsets.only(
                                                        right: 2),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        // shape: BoxShape.circle,
                                                        borderRadius: widget
                                                                    .model
                                                                    .sportKey ==
                                                                AppConstants
                                                                    .TAG_KABADDI
                                                            ? BorderRadius.only(
                                                                topLeft: Radius.circular(
                                                                    index == 0
                                                                        ? 6
                                                                        : 0),
                                                                bottomLeft: Radius.circular(
                                                                    index == 0
                                                                        ? 6
                                                                        : 0),
                                                                topRight: Radius.circular(
                                                                    index == 6
                                                                        ? 6
                                                                        : 0),
                                                                bottomRight:
                                                                    Radius.circular(index == 6 ? 6 : 0))
                                                            : BorderRadius.only(topLeft: Radius.circular(index == 0 ? 6 : 0), bottomLeft: Radius.circular(index == 0 ? 6 : 0), topRight: Radius.circular(index == 10 ? 6 : 0), bottomRight: Radius.circular(index == 10 ? 6 : 0)),
                                                        border: Border.all(color: index < selectedPlayer.selectedPlayer ? greenIconColor : Colors.white),
                                                        color: index < selectedPlayer.selectedPlayer ? greenIconColor : Colors.white),
                                                    child: new Container(
                                                      child: Center(
                                                        child: Text(
                                                          '${index + 1}',
                                                          style: TextStyle(
                                                              // fontFamily: "Roboto",
                                                              color: index <
                                                                      selectedPlayer
                                                                          .selectedPlayer
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 8,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                })),
                                        SizedBox(
                                          width: 14,
                                        ),
                                        GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          child: Container(
                                            height: 22,
                                            // padding: EdgeInsets.only(
                                            //     left: 5, right: 0),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.white),
                                                // borderRadius: BorderRadius.circular(3),
                                                color: primaryColor),
                                            child: new Container(
                                              child: Icon(
                                                Icons.remove,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            if (selectedPlayer.selectedPlayer >
                                                0) {
                                              setState(() {
                                                clearTeamDialog = true;
                                              });
                                            } else {
                                              MethodUtils.showError(context,
                                                  'No player selected to clear.');
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: 20,
                                  // )
                                ],
                              ),
                            ),
                            islineUp == 1
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFf7f7f7),
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade300)),
                                    ),
                                    // height: 100,
                                    child: new Row(
                                      children: [
                                        Container(
                                          height: 20,
                                          width: 20,
                                          // margin: EdgeInsets.only(
                                          //     top: 5, left: 10),
                                          child: Image(
                                            image: AssetImage(
                                                AppImages.megaphoneIcon),
                                            // color: greenIconColor,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              40,
                                          child: new ScrollingText(
                                            text:
                                                'Lineup feature is for your convenience. Please do due research before creating team.',
                                            textStyle: TextStyle(
                                              //fontFamily: "Roboto",
                                              //////fontFamily: AppConstants.textSemiBold,
                                              color: Color(0xFF666666),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    // margin: EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            Color(0xffA66DFB).withAlpha(1),
                                            Color(0xffA66DFB).withAlpha(1),
                                            // Colors.white
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight),
                                      color: Color(0xFFf7f7f7),
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade300)),
                                    ),
                                    height: 40,
                                    child: new Row(
                                      children: [
                                        new Container(
                                          height: 20,
                                          width: 20,
                                          margin: EdgeInsets.only(
                                              bottom: 0, left: 10, right: 4),
                                          child: Image(
                                            image: AssetImage(
                                                AppImages.megaphoneIcon),
                                            // color: greenIconColor,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              40,
                                          child: ScrollingText(
                                            text:
                                                'Lineup feature is for your convenience. Please do due research before creating team.',
                                            textStyle: TextStyle(
                                              // fontFamily: "Roboto",
                                              //////fontFamily: AppConstants.textSemiBold,
                                              color: Color(0xFF666666),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    // widget.model.fantasyType != 1
                                    //     ?
                                    Expanded(
                                        child: Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: Container(
                                        child: Column(
                                          children: [
                                            TabBar(
                                              controller: _tabController,
                                              labelPadding: EdgeInsets.all(0),
                                              onTap: (int index) {
                                                setState(() {
                                                  _currentMatchIndex = index;
                                                });
                                              },
                                              indicatorWeight: 2,
                                              indicatorSize:
                                                  TabBarIndicatorSize.label,
                                              indicatorColor: primaryColor,
                                              // indicator: ShapeDecoration(
                                              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
                                              //     color: Colors.black
                                              // ),
                                              isScrollable: false,
                                              labelColor: Colors.black,
                                              //  unselectedLabelColor: Colors.grey,
                                              tabs: getTabs(),
                                            ),
                                            Divider(
                                              height: .5,
                                              thickness: .5,
                                            ),
                                            Container(
                                              height: 32,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              color: Color(0xFFf5f5f5),
                                              child: new Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  new GestureDetector(
                                                    behavior: HitTestBehavior
                                                        .translucent,
                                                    child: new Container(
                                                      child: new Row(
                                                        children: [
                                                          new Text(
                                                              _currentMatchIndex ==
                                                                      0
                                                                  ? 'Pick ' +
                                                                      selectedPlayer
                                                                          .wk_min_count
                                                                          .toString() +
                                                                      (widget.model.sportKey ==
                                                                              AppConstants
                                                                                  .TAG_FOOTBALL
                                                                          ? ""
                                                                          : '-') +
                                                                      (widget.model.sportKey ==
                                                                              AppConstants
                                                                                  .TAG_FOOTBALL
                                                                          ? ""
                                                                          : selectedPlayer
                                                                              .wk_max_count
                                                                              .toString()) +
                                                                      (widget.model.sportKey ==
                                                                              AppConstants.TAG_CRICKET
                                                                          ? ' Wicket-Keeper'
                                                                          : widget.model.sportKey == AppConstants.TAG_KABADDI
                                                                              ? ' Defender'
                                                                              : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                                                                                  ? ' Point-Guard'
                                                                                  : ' Goal-Keeper')
                                                                  : _currentMatchIndex == 1
                                                                      ? 'Pick ' +
                                                                          selectedPlayer.bat_mincount.toString() +
                                                                          '-' +
                                                                          selectedPlayer.bat_maxcount.toString() +
                                                                          (widget.model.sportKey == AppConstants.TAG_CRICKET
                                                                              ? ' Batter'
                                                                              : widget.model.sportKey == AppConstants.TAG_KABADDI
                                                                                  ? ' All-Rounder'
                                                                                  : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                                                                                      ? ' Shooting-Guard'
                                                                                      : ' Defenders')
                                                                      : _currentMatchIndex == 2
                                                                          ? 'Pick ' +
                                                                              selectedPlayer.ar_mincount.toString() +
                                                                              '-' +
                                                                              selectedPlayer.ar_maxcount.toString() +
                                                                              (widget.model.sportKey == AppConstants.TAG_CRICKET
                                                                                  ? ' All-Rounders'
                                                                                  : widget.model.sportKey == AppConstants.TAG_KABADDI
                                                                                      ? ' Raider'
                                                                                      : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                                                                                          ? ' Small-Forward'
                                                                                          : ' Mid-Fielders')
                                                                          : _currentMatchIndex == 3
                                                                              ? 'Pick ' +
                                                                                  selectedPlayer.bowl_mincount.toString() +
                                                                                  '-' +
                                                                                  selectedPlayer.bowl_maxcount.toString() +
                                                                                  (widget.model.sportKey == AppConstants.TAG_CRICKET
                                                                                      ? ' Bowlers'
                                                                                      : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                                                                                          ? ' Power-Forward'
                                                                                          : ' Forward')
                                                                              : 'Pick ' + selectedPlayer.c_min_count.toString() + '-' + selectedPlayer.c_max_count.toString() + ' Center',
                                                              style: TextStyle(
                                                                  // fontFamily: "Roboto",
                                                                  color: textcolor,
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: 13)),
                                                          new Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 5),
                                                            height: 13,
                                                            width: 13,
                                                            child: Image(
                                                              image: AssetImage(
                                                                AppImages
                                                                    .infoIcon,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        rulesDialog = true;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              color: primaryColor,
                                              height: 40,
                                              child: new Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  new GestureDetector(
                                                    behavior: HitTestBehavior
                                                        .translucent,
                                                    child: new Container(
                                                      child: new Row(
                                                        children: [
                                                          new Container(
                                                            width: 28,
                                                            height: 28,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 5,
                                                                    left: 12),
                                                            child: Image(
                                                              image: AssetImage(
                                                                AppImages
                                                                    .filterImage,
                                                              ),
                                                            ),
                                                          ),
                                                          // new Text(
                                                          //     'Filter by Teams',
                                                          //     style: TextStyle( fontFamily: "Roboto",
                                                          //         fontFamily:
                                                          //             AppConstants
                                                          //                 .textBold,
                                                          //         color: Colors
                                                          //             .black87,
                                                          //         fontWeight:
                                                          //             FontWeight
                                                          //                 .normal,
                                                          //         fontSize: 11)),
                                                        ],
                                                      ),
                                                    ),
                                                    onTap: () => {
                                                      _modalBottomSheetMenu()
                                                    },
                                                  ),
                                                  new Flexible(
                                                    child: new Container(
                                                      margin: EdgeInsets.only(
                                                          right: 0),
                                                      child:
                                                          new GestureDetector(
                                                        behavior:
                                                            HitTestBehavior
                                                                .translucent,
                                                        child: new Row(
                                                          // mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            new Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 15),
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Text(
                                                                'Selected BY',
                                                                style: TextStyle(
                                                                    // fontFamily: "Roboto",
                                                                    color: textcolor1,
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: 13),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            isPLayerSorted != 0
                                                                ? new Container(
                                                                    height: 13,
                                                                    width: 5,
                                                                    child:
                                                                        Image(
                                                                      image:
                                                                          AssetImage(
                                                                        isPLayerSorted ==
                                                                                1
                                                                            ? AppImages.upSort
                                                                            : AppImages.downSort,
                                                                      ),
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  )
                                                                : new Container(),
                                                          ],
                                                        ),
                                                        onTap: () {
                                                          setState(() {
                                                            if (isPLayerSorted ==
                                                                    2 ||
                                                                isPLayerSorted ==
                                                                    0) {
                                                              isPLayerSorted =
                                                                  1;
                                                              wkList.sort((a, b) => a
                                                                  .getSelectedBy()
                                                                  .compareTo(b
                                                                      .getSelectedBy()));
                                                              batList.sort((a, b) => a
                                                                  .getSelectedBy()
                                                                  .compareTo(b
                                                                      .getSelectedBy()));
                                                              arList.sort((a, b) => a
                                                                  .getSelectedBy()
                                                                  .compareTo(b
                                                                      .getSelectedBy()));
                                                              bolList.sort((a, b) => a
                                                                  .getSelectedBy()
                                                                  .compareTo(b
                                                                      .getSelectedBy()));
                                                            } else {
                                                              isPLayerSorted =
                                                                  2;
                                                              wkList.sort((a, b) => b
                                                                  .getSelectedBy()
                                                                  .compareTo(a
                                                                      .getSelectedBy()));
                                                              batList.sort((a, b) => b
                                                                  .getSelectedBy()
                                                                  .compareTo(a
                                                                      .getSelectedBy()));
                                                              arList.sort((a, b) => b
                                                                  .getSelectedBy()
                                                                  .compareTo(a
                                                                      .getSelectedBy()));
                                                              bolList.sort((a, b) => b
                                                                  .getSelectedBy()
                                                                  .compareTo(a
                                                                      .getSelectedBy()));
                                                            }
                                                            isPointSorted = 0;
                                                            isCreditSorted = 0;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    flex: 1,
                                                  ),
                                                  new Flexible(
                                                    child: new Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        new GestureDetector(
                                                          behavior:
                                                              HitTestBehavior
                                                                  .translucent,
                                                          child: new Row(
                                                            children: [
                                                              new Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            5,
                                                                        left:
                                                                            20),
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  'Avg. Points',
                                                                  style: TextStyle(
                                                                      // fontFamily: "Roboto",
                                                                      color: textcolor1,
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 13),
                                                                ),
                                                              ),
                                                              isPointSorted != 0
                                                                  ? new Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                        right:
                                                                            8,
                                                                      ),
                                                                      height:
                                                                          13,
                                                                      width: 5,
                                                                      child:
                                                                          Image(
                                                                        image:
                                                                            AssetImage(
                                                                          isPointSorted == 1
                                                                              ? AppImages.upSort
                                                                              : AppImages.downSort,
                                                                        ),
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    )
                                                                  : new Container(),
                                                            ],
                                                          ),
                                                          onTap: () {
                                                            setState(() {
                                                              if (isPointSorted ==
                                                                      2 ||
                                                                  isPointSorted ==
                                                                      0) {
                                                                isPointSorted =
                                                                    1;
                                                                wkList.sort((a, b) => a
                                                                    .getPoints()
                                                                    .compareTo(b
                                                                        .getPoints()));
                                                                batList.sort((a, b) => a
                                                                    .getPoints()
                                                                    .compareTo(b
                                                                        .getPoints()));
                                                                arList.sort((a, b) => a
                                                                    .getPoints()
                                                                    .compareTo(b
                                                                        .getPoints()));
                                                                bolList.sort((a, b) => a
                                                                    .getPoints()
                                                                    .compareTo(b
                                                                        .getPoints()));
                                                              } else {
                                                                isPointSorted =
                                                                    2;
                                                                wkList.sort((a, b) => b
                                                                    .getPoints()
                                                                    .compareTo(a
                                                                        .getPoints()));
                                                                batList.sort((a, b) => b
                                                                    .getPoints()
                                                                    .compareTo(a
                                                                        .getPoints()));
                                                                arList.sort((a, b) => b
                                                                    .getPoints()
                                                                    .compareTo(a
                                                                        .getPoints()));
                                                                bolList.sort((a, b) => b
                                                                    .getPoints()
                                                                    .compareTo(a
                                                                        .getPoints()));
                                                              }
                                                              isPLayerSorted =
                                                                  0;
                                                              isCreditSorted =
                                                                  0;
                                                            });
                                                          },
                                                        ),
                                                        new Container(
                                                          child:
                                                              new GestureDetector(
                                                            behavior:
                                                                HitTestBehavior
                                                                    .translucent,
                                                            child: new Row(
                                                              children: [
                                                                new Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    'Credits',
                                                                    style: TextStyle(
                                                                        // fontFamily: "Roboto",
                                                                        color: textcolor1,
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: 13),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                isCreditSorted !=
                                                                        0
                                                                    ? new Container(
                                                                        height:
                                                                            13,
                                                                        width:
                                                                            5,
                                                                        child:
                                                                            Image(
                                                                          image:
                                                                              AssetImage(
                                                                            isCreditSorted == 1
                                                                                ? AppImages.upSort
                                                                                : AppImages.downSort,
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      )
                                                                    : new Container(),
                                                              ],
                                                            ),
                                                            onTap: () {
                                                              setState(() {
                                                                if (isCreditSorted ==
                                                                        2 ||
                                                                    isCreditSorted ==
                                                                        0) {
                                                                  isCreditSorted =
                                                                      1;
                                                                  wkList.sort((a, b) => a
                                                                      .getCredits()
                                                                      .compareTo(
                                                                          b.getCredits()));
                                                                  batList.sort((a, b) => a
                                                                      .getCredits()
                                                                      .compareTo(
                                                                          b.getCredits()));
                                                                  arList.sort((a, b) => a
                                                                      .getCredits()
                                                                      .compareTo(
                                                                          b.getCredits()));
                                                                  bolList.sort((a, b) => a
                                                                      .getCredits()
                                                                      .compareTo(
                                                                          b.getCredits()));
                                                                } else {
                                                                  isCreditSorted =
                                                                      2;
                                                                  wkList.sort((a, b) => b
                                                                      .getCredits()
                                                                      .compareTo(
                                                                          a.getCredits()));
                                                                  batList.sort((a, b) => b
                                                                      .getCredits()
                                                                      .compareTo(
                                                                          a.getCredits()));
                                                                  arList.sort((a, b) => b
                                                                      .getCredits()
                                                                      .compareTo(
                                                                          a.getCredits()));
                                                                  bolList.sort((a, b) => b
                                                                      .getCredits()
                                                                      .compareTo(
                                                                          a.getCredits()));
                                                                }
                                                                isPLayerSorted =
                                                                    0;
                                                                isPointSorted =
                                                                    0;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    flex: 2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Divider(
                                              height: .5,
                                              thickness: .5,
                                            ),
                                            Expanded(
                                              child: TabBarView(
                                                controller: _tabController,
                                                children: [
                                                  CreateTeamPager(
                                                    wkList,
                                                    onPlayerClick,
                                                    1,
                                                    selectedPlayer,
                                                    limit,
                                                    widget.model.fantasyType ??
                                                        0,
                                                    //  widget.model.slotId!,
                                                    exeedCredit,
                                                    widget.model.matchKey,
                                                    widget.model.sportKey,
                                                    uiUpdate: uiUpdate,
                                                  ),
                                                  CreateTeamPager(
                                                    batList,
                                                    onPlayerClick,
                                                    2,
                                                    selectedPlayer,
                                                    limit,
                                                    widget.model.fantasyType ??
                                                        0,
                                                    //     widget.model.slotId!,
                                                    exeedCredit,
                                                    widget.model.matchKey,
                                                    widget.model.sportKey,
                                                    uiUpdate: uiUpdate,
                                                  ),
                                                  CreateTeamPager(
                                                    arList,
                                                    onPlayerClick,
                                                    3,
                                                    selectedPlayer,
                                                    limit,
                                                    widget.model.fantasyType ??
                                                        0,
                                                    //    widget.model.slotId!,
                                                    exeedCredit,
                                                    widget.model.matchKey,
                                                    widget.model.sportKey,
                                                    uiUpdate: uiUpdate,
                                                  ),
                                                  if (widget.model.sportKey !=
                                                      AppConstants.TAG_KABADDI)
                                                    CreateTeamPager(
                                                      bolList,
                                                      onPlayerClick,
                                                      4,
                                                      selectedPlayer,
                                                      limit,
                                                      widget.model
                                                              .fantasyType ??
                                                          0,
                                                      //    widget.model.slotId!,
                                                      exeedCredit,
                                                      widget.model.matchKey,
                                                      widget.model.sportKey,
                                                      uiUpdate: uiUpdate,
                                                    ),
                                                  if (widget.model.sportKey ==
                                                      AppConstants
                                                          .TAG_BASKETBALL)
                                                    CreateTeamPager(
                                                      cList,
                                                      onPlayerClick,
                                                      5,
                                                      selectedPlayer,
                                                      limit,
                                                      widget.model.fantasyType!,
                                                      //    widget.model.slotId!,
                                                      exeedCredit,
                                                      widget.model.matchKey,
                                                      widget.model.sportKey,
                                                      uiUpdate: uiUpdate,
                                                    )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))
                                    // : islineUp == null
                                    //     ? SizedBox.shrink()
                                    //     : Expanded(
                                    //         child: FivePlusOneCreateTeam(
                                    //             wkList +
                                    //                 batList +
                                    //                 arList +
                                    //                 bolList,
                                    //             onPlayerClick,
                                    //             2,
                                    //             selectedPlayer,
                                    //             limit,
                                    //             widget.model.fantasyType!,
                                    //             // widget.model.slotId!,
                                    //             exeedCredit,
                                    //             widget.model.matchKey,
                                    //             widget.model.sportKey,
                                    //             islineUp!,
                                    //             wkList,
                                    //             batList,
                                    //             arList,
                                    //             bolList),
                                    //       )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: GestureDetector(
                                  onTap: (() {
                                    List<Player> selectedWkList = [];
                                    List<Player> selectedBatLiSt = [];
                                    List<Player> selectedArList = [];
                                    List<Player> selectedBowlList = [];
                                    List<Player> selectedCList = [];

                                    for (Player player in wkListTemp) {
                                      if (player.isSelected ?? false)
                                        selectedWkList.add(player);
                                    }

                                    for (Player player in batListTemp) {
                                      if (player.isSelected ?? false)
                                        selectedBatLiSt.add(player);
                                    }

                                    for (Player player in arListTemp) {
                                      if (player.isSelected ?? false)
                                        selectedArList.add(player);
                                    }

                                    for (Player player in bolListTemp) {
                                      if (player.isSelected ?? false)
                                        selectedBowlList.add(player);
                                    }

                                    for (Player player in cListTemp) {
                                      if (player.isSelected ?? false)
                                        selectedCList.add(player);
                                    }

                                    widget.model.selectedWkList =
                                        selectedWkList;
                                    widget.model.selectedBatLiSt =
                                        selectedBatLiSt;
                                    widget.model.selectedArList =
                                        selectedArList;
                                    widget.model.selectedBowlList =
                                        selectedBowlList;
                                    widget.model.selectedcList = selectedCList;
                                    // widget.model.teamName = "Team 0";
                                    widget.model.isEditable = false;
                                    widget.model.isForLeaderBoard = false;
                                    navigateToTeamPreview(
                                      context,
                                      widget.model,
                                      check: "Create Team",
                                    );
                                  }),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        border: Border.all(
                                          color: primaryColor,
                                          width: 2,
                                        )),
                                    width: MediaQuery.of(context).size.width,
                                    height: 40,
                                    // margin: EdgeInsets.only(left: 20, right: 10),
                                    child: Center(
                                        child: Text(
                                      "Team Preview",
                                      style: TextStyle(
                                          //  fontFamily: "Roboto",
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                ),
                                flex: 1,
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Flexible(
                                child: GestureDetector(
                                  onTap: () {
                                    widget.model.teamId =
                                        teamid ?? widget.model.teamId;
                                    if (selectedPlayer.selectedPlayer ==
                                        selectedPlayer.total_player_count) {
                                      List<Player> sellectedList = [];
                                      for (Player player in wkListTemp) {
                                        if (player.isSelected ?? false)
                                          sellectedList.add(player);
                                      }

                                      for (Player player in batListTemp) {
                                        if (player.isSelected ?? false)
                                          sellectedList.add(player);
                                      }

                                      for (Player player in arListTemp) {
                                        if (player.isSelected ?? false)
                                          sellectedList.add(player);
                                      }

                                      for (Player player in bolListTemp) {
                                        if (player.isSelected ?? false)
                                          sellectedList.add(player);
                                      }

                                      for (Player player in cListTemp) {
                                        if (player.isSelected ?? false)
                                          sellectedList.add(player);
                                      }

                                      widget.model.selectedList = sellectedList;
                                      widget.model.localTeamCount =
                                          selectedPlayer.localTeamplayerCount;
                                      widget.model.visitorTeamCount =
                                          selectedPlayer.visitorTeamPlayerCount;

                                      navigateToChooseCandVc(
                                          context, widget.model,
                                          contest: widget.contest,
                                          onTeamCreated: widget.onTeamCreated,
                                          contestNumber: widget.contestNumber,
                                          scrollPosition: widget.scrollPosition,
                                          isDynaminLink: widget.isDynaminLink,
                                          check: "Create Team",
                                          checkScreen: widget.checkScreen,
                                          contestFrom: widget.contestFrom,
                                          joinSimilar: widget.joinSimilar);
                                    } else {
                                      showTeamValidation("Please select " +
                                          selectedPlayer.total_player_count
                                              .toString() +
                                          " players.");
                                    }
                                  },

                                  // decoration: BoxDecoration(
                                  //   gradient: LinearGradient(
                                  //     transform: GradientRotation(52.61 * 3.14159 / 180), // Convert degrees to radians
                                  //     begin: Alignment.topLeft,
                                  //     end: Alignment.bottomRight,
                                  //     stops: [0.1502, 0.1706, 0.2410, 0.2781, 0.3280, 0.3681, 0.5620, 0.6553, 0.7411, 0.7849, 0.8103],
                                  //     colors: [
                                  //       Color(0xFFB2B2AF),
                                  //       Color(0xFFBEBEBB),
                                  //       Color(0xFFE1E1E1),
                                  //       Color(0xFFEFEFEF),
                                  //       Color(0xFFF2F2F2),
                                  //       Color(0xFFFCFCFC),
                                  //       Color(0xFFD1D1D1),
                                  //       Color(0xFFDBDBDB),
                                  //       Color(0xFFE8E8E8),
                                  //       Color(0xFFF5F5F5),
                                  //       Color(0xFFFFFFFF),
                                  //     ],
                                  //   ),
                                  //   border: Border.all(
                                  //     color: Color(0xFF6A0BF8),
                                  //     width: 2,
                                  //   ),
                                  //   borderRadius: BorderRadius.circular(26),
                                  // ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: selectedPlayer.selectedPlayer ==
                                              selectedPlayer.total_player_count
                                          ? primaryColor
                                          : Colors.grey,
                                      image: DecorationImage(
                                          image:
                                              AssetImage(AppImages.Btngradient),
                                          fit: BoxFit.fill),
                                      border: Border.all(
                                        color: selectedPlayer.selectedPlayer ==
                                                selectedPlayer
                                                    .total_player_count
                                            ? blueColor
                                            : Colors.grey,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    height: 40,
                                    width: MediaQuery.of(context).size.width,
                                    // margin: EdgeInsets.only(left: 10, right: 20),
                                    child: Center(
                                      child: Text(
                                        "Continue",
                                        style: TextStyle(
                                            // fontFamily: "Roboto",
                                            fontWeight: FontWeight.bold,
                                            color:
                                                selectedPlayer.selectedPlayer ==
                                                        selectedPlayer
                                                            .total_player_count
                                                    ? Colors.black
                                                    : const Color.fromARGB(
                                                        255, 106, 104, 104)),
                                      ),
                                    ),
                                  ),
                                ),
                                flex: 1,
                              ),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                clearTeamDialog
                    ? new Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black54,
                        child: AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          title: Text("Confirmation",
                              style: TextStyle(
                                  fontFamily: "Roboto", color: Colors.black)),
                          content: Text(
                              "Are you sure you want to clear selected team?",
                              style: TextStyle(
                                  fontFamily: "Roboto", color: Colors.grey)),
                          actions: [
                            cancelButton(context),
                            continueButton(context),
                          ],
                        ),
                      )
                    : new Container(),
                rulesDialog
                    ? new Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black54,
                        child: AlertDialog(
                          insetPadding: EdgeInsets.only(right: 26, left: 26),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          title: Text("Selection Rules!",
                              style: TextStyle(
                                  fontFamily: "Roboto", color: Colors.black)),
                          content: new Container(
                            // height: 170,
                            child: new Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    widget.model.sportKey ==
                                            AppConstants.TAG_CRICKET
                                        ? widget.model.fantasyType == 0
                                            ? "Now you can select upto 8 Wicket-Keepers, 8 Batter, 8 All-Rounders & 8 Bowlers."
                                            : widget.model.fantasyType == 1
                                                ? "Now you can select upto 3 Wicket-Keepers, 3 Batter, 3 All-Rounders & 3 Bowlers."
                                                : "Now you can select upto 4 Wicket-Keepers, 6 Batter, 4 All-Rounders & 6 Bowlers."
                                        : widget.model.sportKey ==
                                                AppConstants.TAG_KABADDI
                                            ? 'Now you can select upto 5 Defender, 5 All-Rounders & 5 Raiders.'
                                            : widget.model.sportKey ==
                                                    AppConstants.TAG_BASKETBALL
                                                ? 'Now you can select upto 4 Point Guard, 4 Shooting Guard, 4 Small Forward, 4 Power Forward & 4 Center.'
                                                : 'Now you can select upto 1 Goal-Keeper, 5 Defenders, 5 Mid-Fielders & 3 Forward.',
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        color: Colors.grey,
                                        fontSize: 13)),
                                SizedBox(
                                  height: 5,
                                ),
                                new Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: Colors.grey.shade300),
                                        right: BorderSide(
                                            color: Colors.grey.shade300),
                                        left: BorderSide(
                                            color: Colors.grey.shade300)),
                                  ),
                                  height: 40,
                                  child: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      new Flexible(
                                        child: new Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            '',
                                            style: TextStyle(
                                                // fontFamily: "Roboto",
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                        ),
                                        flex: 1,
                                      ),
                                      new Flexible(
                                        child: new Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            widget.model.sportKey ==
                                                    AppConstants.TAG_CRICKET
                                                ? 'WK'
                                                : widget.model.sportKey ==
                                                        AppConstants.TAG_KABADDI
                                                    ? 'DEF'
                                                    : widget.model.sportKey ==
                                                            AppConstants
                                                                .TAG_BASKETBALL
                                                        ? 'PG'
                                                        : 'GK',
                                            style: TextStyle(
                                                // fontFamily: "Roboto",
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                        ),
                                        flex: 1,
                                      ),
                                      new Flexible(
                                        child: new Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            widget.model.sportKey ==
                                                    AppConstants.TAG_CRICKET
                                                ? 'BAT'
                                                : widget.model.sportKey ==
                                                        AppConstants.TAG_KABADDI
                                                    ? 'ALL'
                                                    : widget.model.sportKey ==
                                                            AppConstants
                                                                .TAG_BASKETBALL
                                                        ? 'SG'
                                                        : 'DEF',
                                            style: TextStyle(
                                                //fontFamily: "Roboto",
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                        ),
                                        flex: 1,
                                      ),
                                      new Flexible(
                                        child: new Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            widget.model.sportKey ==
                                                    AppConstants.TAG_CRICKET
                                                ? 'AR'
                                                : widget.model.sportKey ==
                                                        AppConstants.TAG_KABADDI
                                                    ? 'RAIDER'
                                                    : widget.model.sportKey ==
                                                            AppConstants
                                                                .TAG_BASKETBALL
                                                        ? 'SF'
                                                        : 'MID',
                                            style: TextStyle(
                                                // fontFamily: "Roboto",
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                        ),
                                        flex: 1,
                                      ),
                                      widget.model.sportKey !=
                                              AppConstants.TAG_KABADDI
                                          ? new Flexible(
                                              child: new Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  widget.model.sportKey ==
                                                          AppConstants
                                                              .TAG_CRICKET
                                                      ? 'BOWL'
                                                      : widget.model.sportKey ==
                                                              AppConstants
                                                                  .TAG_BASKETBALL
                                                          ? 'PF'
                                                          : 'ST',
                                                  style: TextStyle(
                                                      // fontFamily: "Roboto",
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 13),
                                                ),
                                              ),
                                              flex: 1,
                                            )
                                          : new Flexible(
                                              child: new Container(),
                                              flex: 0,
                                            ),
                                      widget.model.sportKey ==
                                              AppConstants.TAG_BASKETBALL
                                          ? new Flexible(
                                              child: new Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'C',
                                                  style: TextStyle(
                                                      //fontFamily: "Roboto",
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 13),
                                                ),
                                              ),
                                              flex: 1,
                                            )
                                          : new Flexible(
                                              child: new Container(),
                                              flex: 0,
                                            ),
                                    ],
                                  ),
                                ),
                                new Divider(
                                  height: 2,
                                  thickness: 1,
                                ),
                                new Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                            color: Colors.grey.shade300),
                                        left: BorderSide(
                                            color: Colors.grey.shade300)),
                                  ),
                                  child: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      new Flexible(
                                        child: new Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'MIN',
                                            style: TextStyle(
                                                // fontFamily: "Roboto",
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                        ),
                                        flex: 1,
                                      ),
                                      new Flexible(
                                        child: new Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            widget.model.sportKey ==
                                                    AppConstants.TAG_CRICKET
                                                ? minWicketKeeper(widget
                                                        .model.fantasyType
                                                        .toString())
                                                    .toString() /*widget.model.fantasyType==1 ? '1' : '1'*/
                                                : widget.model.sportKey ==
                                                        AppConstants.TAG_KABADDI
                                                    ? '1'
                                                    : widget.model.sportKey ==
                                                            AppConstants
                                                                .TAG_BASKETBALL
                                                        ? '1'
                                                        : '1',
                                            style: TextStyle(
                                                // fontFamily: "Roboto",
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13),
                                          ),
                                        ),
                                        flex: 1,
                                      ),
                                      new Flexible(
                                        child: new Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            widget.model.sportKey ==
                                                    AppConstants.TAG_CRICKET
                                                ? minBatsman(widget
                                                        .model.fantasyType
                                                        .toString())
                                                    .toString()
                                                : widget.model.sportKey ==
                                                        AppConstants.TAG_KABADDI
                                                    ? '1'
                                                    : widget.model.sportKey ==
                                                            AppConstants
                                                                .TAG_BASKETBALL
                                                        ? '1'
                                                        : '3',
                                            style: TextStyle(
                                                // fontFamily: "Roboto",
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13),
                                          ),
                                        ),
                                        flex: 1,
                                      ),
                                      new Flexible(
                                        child: new Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            widget.model.sportKey ==
                                                    AppConstants.TAG_CRICKET
                                                ? minAllRounder(widget
                                                        .model.fantasyType
                                                        .toString())
                                                    .toString() /*widget.model.fantasyType==1 ? '1' : '1'*/
                                                : widget.model.sportKey ==
                                                        AppConstants.TAG_KABADDI
                                                    ? '1'
                                                    : widget.model.sportKey ==
                                                            AppConstants
                                                                .TAG_BASKETBALL
                                                        ? '1'
                                                        : '3',
                                            style: TextStyle(
                                                // fontFamily: "Roboto",
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13),
                                          ),
                                        ),
                                        flex: 1,
                                      ),
                                      widget.model.sportKey !=
                                              AppConstants.TAG_KABADDI
                                          ? new Flexible(
                                              child: new Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  widget.model.sportKey ==
                                                          AppConstants
                                                              .TAG_CRICKET
                                                      ? minBowler(widget
                                                              .model.fantasyType
                                                              .toString())
                                                          .toString() /*widget.model.fantasyType==1 ? '1' : '3'*/
                                                      : widget.model.sportKey ==
                                                              AppConstants
                                                                  .TAG_BASKETBALL
                                                          ? '1'
                                                          : '1',
                                                  style: TextStyle(
                                                      //   fontFamily: "Roboto",
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 13),
                                                ),
                                              ),
                                              flex: 1,
                                            )
                                          : new Flexible(
                                              child: new Container(),
                                              flex: 0,
                                            ),
                                      widget.model.sportKey ==
                                              AppConstants.TAG_BASKETBALL
                                          ? new Flexible(
                                              child: new Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  '1',
                                                  style: TextStyle(
                                                      //  fontFamily: "Roboto",
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 13),
                                                ),
                                              ),
                                              flex: 1,
                                            )
                                          : new Flexible(
                                              child: new Container(),
                                              flex: 0,
                                            ),
                                    ],
                                  ),
                                ),
                                new Divider(
                                  height: 2,
                                  thickness: 1,
                                ),
                                new Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade300),
                                        right: BorderSide(
                                            color: Colors.grey.shade300),
                                        left: BorderSide(
                                            color: Colors.grey.shade300)),
                                  ),
                                  child: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      new Flexible(
                                        child: new Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'MAX',
                                            style: TextStyle(
                                                //  fontFamily: "Roboto",
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                        ),
                                        flex: 1,
                                      ),
                                      new Flexible(
                                        child: new Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            widget.model.sportKey ==
                                                    AppConstants.TAG_CRICKET
                                                ? maxWicketKeeper(widget
                                                        .model.fantasyType
                                                        .toString())
                                                    .toString() /*widget.model.fantasyType==1 ? '8' : '4'*/
                                                : widget.model.sportKey ==
                                                        AppConstants.TAG_KABADDI
                                                    ? '5'
                                                    : widget.model.sportKey ==
                                                            AppConstants
                                                                .TAG_BASKETBALL
                                                        ? '4'
                                                        : '1',
                                            style: TextStyle(
                                                // fontFamily: "Roboto",
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13),
                                          ),
                                        ),
                                        flex: 1,
                                      ),
                                      new Flexible(
                                        child: new Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            widget.model.sportKey ==
                                                    AppConstants.TAG_CRICKET
                                                ? maxBatsman(widget
                                                        .model.fantasyType
                                                        .toString())
                                                    .toString() /*widget.model.fantasyType==1 ? '8' : '6'*/
                                                : widget.model.sportKey ==
                                                        AppConstants.TAG_KABADDI
                                                    ? '5'
                                                    : widget.model.sportKey ==
                                                            AppConstants
                                                                .TAG_BASKETBALL
                                                        ? '4'
                                                        : '5',
                                            style: TextStyle(
                                                // fontFamily: "Roboto",
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13),
                                          ),
                                        ),
                                        flex: 1,
                                      ),
                                      new Flexible(
                                        child: new Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            widget.model.sportKey ==
                                                    AppConstants.TAG_CRICKET
                                                ? maxWicketKeeper(widget
                                                        .model.fantasyType
                                                        .toString())
                                                    .toString() /*widget.model.fantasyType==1 ? '8' : '4'*/
                                                : widget.model.sportKey ==
                                                        AppConstants.TAG_KABADDI
                                                    ? '5'
                                                    : widget.model.sportKey ==
                                                            AppConstants
                                                                .TAG_BASKETBALL
                                                        ? '4'
                                                        : '5',
                                            style: TextStyle(
                                                //  fontFamily: "Roboto",
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13),
                                          ),
                                        ),
                                        flex: 1,
                                      ),
                                      widget.model.sportKey !=
                                              AppConstants.TAG_KABADDI
                                          ? new Flexible(
                                              child: new Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  widget.model.sportKey ==
                                                          AppConstants
                                                              .TAG_CRICKET
                                                      ? maxBowler(widget
                                                              .model.fantasyType
                                                              .toString())
                                                          .toString() /*widget.model.fantasyType==1 ? '8' : '6'*/
                                                      : widget.model.sportKey ==
                                                              AppConstants
                                                                  .TAG_BASKETBALL
                                                          ? '4'
                                                          : '3',
                                                  style: TextStyle(
                                                      //   fontFamily: "Roboto",
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 13),
                                                ),
                                              ),
                                              flex: 1,
                                            )
                                          : new Flexible(
                                              child: new Container(),
                                              flex: 0,
                                            ),
                                      widget.model.sportKey ==
                                              AppConstants.TAG_BASKETBALL
                                          ? new Flexible(
                                              child: new Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  '4',
                                                  style: TextStyle(
                                                      //  fontFamily: "Roboto",
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 13),
                                                ),
                                              ),
                                              flex: 1,
                                            )
                                          : new Flexible(
                                              child: new Container(),
                                              flex: 0,
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [gotItButton(context)],
                        ),
                      )
                    : new Container(),
                widget.model.unlimited_credit_match == 1
                    ? creditpopup()
                    : Container(),
                lineupPopup == true ? lineupoutpopup() : SizedBox.shrink(),
              ],
            ),
            onWillPop: _onWillPop));
  }

  Widget cancelButton(context) {
    return ElevatedButton(
      child: Text("CANCEL",
          style: TextStyle(
              //fontFamily: "Roboto",
              color: Colors.black)),
      onPressed: () {
        setState(() {
          clearTeamDialog = false;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget continueButton(context) {
    return ElevatedButton(
      child: Text(
        "CLEAR TEAM",
        style: TextStyle(
            //fontFamily: "Roboto",
            color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
      ),
      onPressed: () {
        for (int i = 0; i < allPlayerList.length; i++) {
          allPlayerList[i].isSelected = false;
        }
        createTeamData();
        setState(() {
          clearTeamDialog = false;
        });
      },
    );
  }

  Widget gotItButton(context) {
    return Container(
      margin: EdgeInsets.only(right: 19),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
        child: Text(
          "GOT IT",
          style: TextStyle(
              // fontFamily: "Roboto",
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w800),
        ),
        onPressed: () {
          setState(() {
            rulesDialog = false;
          });
        },
      ),
    );
  }

  Future<bool> _onWillPop() async {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: primaryColor,
            /* set Status bar color in Android devices. */
            statusBarIconBrightness: Brightness.light,
            /* set Status bar icons color in Android devices.*/

            statusBarBrightness:
                Brightness.dark) /* set Status bar icon color in iOS. */
        );
    widget.model.contest = null;
    Navigator.pop(context);
    return Future.value(false);
  }

  List<Widget> getTabs() {
    tabs.clear();
    tabs.add(getWKTab());
    tabs.add(getBATTab());
    tabs.add(getARTab());
    if (widget.model.sportKey != AppConstants.TAG_KABADDI) {
      tabs.add(getBOWLTab());
    }
    if (widget.model.sportKey == AppConstants.TAG_BASKETBALL) {
      tabs.add(getCTab());
    }
    return tabs;
  }

  Widget getWKTab() {
    return new ClipRRect(
      borderRadius: BorderRadius.horizontal(left: Radius.circular(0)),
      child: new Container(
        height: 45,
        alignment: Alignment.center,
        margin: EdgeInsets.zero,
        /*  decoration: BoxDecoration(
          color: bgColor,
        ),
      */
        child: Text(
          selectedPlayer.wk_selected == 0
              ? widget.model.sportKey == AppConstants.TAG_CRICKET
                  ? 'WK(0)'
                  : widget.model.sportKey == AppConstants.TAG_KABADDI
                      ? 'DEF(0)'
                      : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                          ? 'PG(0)'
                          : 'GK(0)'
              : (widget.model.sportKey == AppConstants.TAG_CRICKET
                      ? 'WK('
                      : widget.model.sportKey == AppConstants.TAG_KABADDI
                          ? 'DEF('
                          : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                              ? 'PG('
                              : 'GK(') +
                  selectedPlayer.wk_selected.toString() +
                  ')',
          style: TextStyle(
              //  fontFamily: "Roboto",
              color: _currentMatchIndex == 0 ? primaryColor : Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 14),
        ),
      ),
    );
  }

  Widget getBATTab() {
    return new ClipRRect(
      borderRadius: BorderRadius.horizontal(left: Radius.circular(0)),
      child: new Container(
        height: 45,
        alignment: Alignment.center,
        margin: EdgeInsets.zero,
        /*  decoration: BoxDecoration(
          color: bgColor,
        ),
      */
        child: Text(
          selectedPlayer.bat_selected == 0
              ? widget.model.sportKey == AppConstants.TAG_CRICKET
                  ? 'BAT(0)'
                  : widget.model.sportKey == AppConstants.TAG_KABADDI
                      ? 'ALL(0)'
                      : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                          ? 'SG(0)'
                          : 'DEF(0)'
              : (widget.model.sportKey == AppConstants.TAG_CRICKET
                      ? 'BAT('
                      : widget.model.sportKey == AppConstants.TAG_KABADDI
                          ? 'ALL('
                          : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                              ? 'SG('
                              : 'DEF(') +
                  selectedPlayer.bat_selected.toString() +
                  ')',
          style: TextStyle(
              // fontFamily: "Roboto",
              color: _currentMatchIndex == 1 ? primaryColor : Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 14),
        ),
      ),
    );
  }

  Widget getARTab() {
    return new ClipRRect(
      borderRadius: BorderRadius.horizontal(left: Radius.circular(0)),
      child: new Container(
        height: 45,
        alignment: Alignment.center,
        margin: EdgeInsets.zero,
        /*  decoration: BoxDecoration(
          color: bgColor,
        ),
      */
        child: Text(
          selectedPlayer.ar_selected == 0
              ? widget.model.sportKey == AppConstants.TAG_CRICKET
                  ? 'AR(0)'
                  : widget.model.sportKey == AppConstants.TAG_KABADDI
                      ? 'RAIDERS(0)'
                      : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                          ? 'SF(0)'
                          : 'MID(0)'
              : (widget.model.sportKey == AppConstants.TAG_CRICKET
                      ? 'AR('
                      : widget.model.sportKey == AppConstants.TAG_KABADDI
                          ? 'RAIDERS('
                          : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                              ? 'SF('
                              : 'MID(') +
                  selectedPlayer.ar_selected.toString() +
                  ')',
          style: TextStyle(
              //fontFamily: "Roboto",
              color: _currentMatchIndex == 2 ? primaryColor : Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 14),
        ),
      ),
    );
  }

  Widget getBOWLTab() {
    return new ClipRRect(
      borderRadius: BorderRadius.horizontal(left: Radius.circular(0)),
      child: new Container(
        height: 45,
        alignment: Alignment.center,
        margin: EdgeInsets.zero,
        child: Text(
          selectedPlayer.bowl_selected == 0
              ? widget.model.sportKey == AppConstants.TAG_CRICKET
                  ? 'BOWL(0)'
                  : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                      ? 'PF(0)'
                      : 'ST(0)'
              : (widget.model.sportKey == AppConstants.TAG_CRICKET
                      ? 'BOWL('
                      : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                          ? 'PF('
                          : 'ST(') +
                  selectedPlayer.bowl_selected.toString() +
                  ')',
          style: TextStyle(
              // fontFamily: "Roboto",
              color: _currentMatchIndex == 3 ? primaryColor : Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 14),
        ),
      ),
    );
  }

  Widget getCTab() {
    return new ClipRRect(
      borderRadius: BorderRadius.horizontal(left: Radius.circular(0)),
      child: new Container(
        height: 45,
        alignment: Alignment.center,
        margin: EdgeInsets.zero,
        /* decoration: BoxDecoration(
          color: bgColor,
        ),
       */
        child: Text(
          selectedPlayer.c_selected == 0
              ? 'C(0)'
              : 'C(' + selectedPlayer.c_selected.toString() + ')',
          style: TextStyle(
              // fontFamily: "Roboto",
              color: _currentMatchIndex == 3 ? primaryColor : Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 14),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0), topRight: Radius.circular(0))),
        builder: (builder) {
          return StatefulBuilder(
              builder: (context, setState) => SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          color: mediumGrayColor,
                          child: new Row(
                            children: [
                              new GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                child: new Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: new Container(
                                    child: Icon(
                                      Icons.clear,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                onTap: () => {Navigator.pop(context)},
                              ),
                              new GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                child: new Container(
                                  width: MediaQuery.of(context).size.width - 50,
                                  alignment: Alignment.center,
                                  child: new Text('Filter by Teams',
                                      style: TextStyle(
                                          //   fontFamily: "Roboto",
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16)),
                                ),
                                onTap: () => {},
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: new Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Container(
                                  alignment: Alignment.center,
                                  child: new Text(
                                      widget.model.teamVs!.split(' VS ')[0],
                                      style: TextStyle(
                                          //   fontFamily: "Roboto",
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14)),
                                ),
                                Radio(
                                  value: 'Team1',
                                  groupValue: filterType,
                                  activeColor: primaryColor,
                                  onChanged: (value) {
                                    team1Click(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            team1Click(context);
                          },
                        ),
                        new Divider(
                          height: 2,
                          thickness: 1,
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: new Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Container(
                                  alignment: Alignment.center,
                                  child: new Text(
                                      widget.model.teamVs!.split(' VS ')[1],
                                      style: TextStyle(
                                          //  fontFamily: "Roboto",
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14)),
                                ),
                                Radio(
                                  value: 'Team2',
                                  groupValue: filterType,
                                  activeColor: primaryColor,
                                  onChanged: (value) {
                                    team2Click(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            team2Click(context);
                          },
                        ),
                        new Divider(
                          height: 2,
                          thickness: 1,
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: new Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Container(
                                  alignment: Alignment.center,
                                  child: new Text('ALL',
                                      style: TextStyle(
                                          //  fontFamily: "Roboto",
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14)),
                                ),
                                Radio(
                                  value: 'All',
                                  groupValue: filterType,
                                  activeColor: primaryColor,
                                  onChanged: (value) {
                                    allClick(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            allClick(context);
                          },
                        ),
                      ],
                    ),
                  ));
        });
  }

  void team1Click(BuildContext context) {
    setState(() {
      filterType = 'Team1';
      wkList = team1wkList;
      batList = team1batList;
      arList = team1arList;
      bolList = team1bolList;
      cList = team1cList;
      Navigator.pop(context);
      refresh();
    });
  }

  void team2Click(BuildContext context) {
    setState(() {
      filterType = 'Team2';
      wkList = team2wkList;
      batList = team2batList;
      arList = team2arList;
      bolList = team2bolList;
      cList = team2cList;
      Navigator.pop(context);
      refresh();
    });
  }

  void allClick(BuildContext context) {
    setState(() {
      filterType = 'All';
      wkList = wkListTemp;
      batList = batListTemp;
      arList = arListTemp;
      bolList = bolListTemp;
      cList = cListTemp;
      Navigator.pop(context);
      refresh();
    });
  }

  void onPlayerClick(bool isSelect, int position, int type) {
    continuePlayerSelectionProcess(isSelect, position, type);

    /* if(widget.model.fantasyType==2){
      continuePlayerSelectionProcess(isSelect, position, type);
    }else{
      continuePlayerSelectionProcess_FivePlusOne(isSelect, position, type);
    }
   */
    // if (!fantasyAlertShown &&
    //     isSelect &&
    //     ((type == BOWLER && widget.model.fantasyType == AppConstants.BATTING_FANTASY_TYPE) ||
    //         ((type == BAT || type == WK) &&
    //             widget.model.fantasyType ==
    //                 AppConstants.BOWLING_FANTASY_TYPE))) {
    //   String text = '';
    //   if (type == BOWLER &&
    //       widget.model.fantasyType == AppConstants.BATTING_FANTASY_TYPE) {
    //     text = "This is batting fantasy! You want to choose a bowler?";
    //   } else if (type == BAT ||
    //       type == WK &&
    //           widget.model.fantasyType == AppConstants.BOWLING_FANTASY_TYPE) {
    //     if (type == BAT) {
    //       text = "This is bowling fantasy! You want to choose a batter?";
    //     } else if (type == WK) {
    //       text = "This is bowling fantasy! You want to choose a wicket-keeper?";
    //     }
    //   }
    //   showDialog(
    //       barrierDismissible: false,
    //       context: context,
    //       builder: (BuildContext context) {
    //         return new Dialog(
    //           backgroundColor: Colors.white,
    //           shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.all(Radius.circular(5.0))),
    //           child: new Container(
    //             height: 150,
    //             child: new Column(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               mainAxisAlignment: MainAxisAlignment.spaceAround,
    //               children: [
    //                 new Container(
    //                   alignment: Alignment.center,
    //                   child: new Text('Alert',
    //                       style: TextStyle( fontFamily: "Roboto",
    //                           fontFamily: "Roboto",
    //                           color: Colors.black,
    //                           fontWeight: FontWeight.w500,
    //                           fontSize: 16)),
    //                 ),
    //                 new Container(
    //                   alignment: Alignment.center,
    //                   child: new Text(text,
    //                       style: TextStyle( fontFamily: "Roboto",
    //                           fontFamily: "Roboto",
    //                           color: Colors.black,
    //                           fontWeight: FontWeight.w400,
    //                           fontSize: 16,
    //                           height: 1.5),
    //                       textAlign: TextAlign.center),
    //                 ),
    //                 new Container(
    //                   child: new Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     children: [
    //                       ElevatedButton(
    //                         style:
    //                             ElevatedButton.styleFrom(primary: primaryColor),
    //                         // color: primaryColor,
    //                         child: Text(
    //                           "NO",
    //                           style: TextStyle( fontFamily: "Roboto",
    //                               color: Colors.white,
    //                               fontSize: 14,
    //                               fontWeight: FontWeight.w800),
    //                         ),
    //                         onPressed: () {
    //                           setState(() {
    //                             fantasyAlertShown = false;
    //                             Navigator.pop(context);
    //                           });
    //                         },
    //                       ),
    //                       ElevatedButton(
    //                         style:
    //                             ElevatedButton.styleFrom(primary: primaryColor),
    //                         // color: primaryColor,
    //                         child: Text(
    //                           "YES",
    //                           style: TextStyle( fontFamily: "Roboto",
    //                               color: Colors.white,
    //                               fontSize: 14,
    //                               fontWeight: FontWeight.w800),
    //                         ),
    //                         onPressed: () {
    //                           setState(() {
    //                             fantasyAlertShown = true;
    //                             Navigator.pop(context);
    //                             continuePlayerSelectionProcess(
    //                                 isSelect, position, type);
    //                           });
    //                         },
    //                       )
    //                     ],
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //         );
    //       });
    // } else {
    //
    // }
  }

  void continuePlayerSelectionProcess(bool isSelect, int position, int type) {
    if (type == WK) {
      double player_credit;

      if (isSelect) {
        if (selectedPlayer.selectedPlayer >=
            (selectedPlayer.total_player_count)) {
          showTeamValidation("You can choose maximum " +
              (selectedPlayer.total_player_count.toString()) +
              " players.");

          return;
        }
        if (selectedPlayer.wk_selected >= (selectedPlayer.wk_max_count)) {
          showTeamValidation("You can select only " +
              (selectedPlayer.wk_max_count.toString()) +
              (widget.model.sportKey == AppConstants.TAG_CRICKET
                  ? ' Wicket-Keeper'
                  : widget.model.sportKey == AppConstants.TAG_KABADDI
                      ? ' Defender'
                      : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                          ? ' Point-Guard'
                          : ' Goal-Keeper') +
              '.');
          return;
        }

        if (wkList[position].team == "team1") {
          if (selectedPlayer.localTeamplayerCount >= limit.team_max_player!) {
            showTeamValidation("You can select only " +
                limit.team_max_player!.toString() +
                " from each team.");
            return;
          }
        } else {
          if (selectedPlayer.visitorTeamPlayerCount >= limit.team_max_player!) {
            showTeamValidation("You can select only " +
                limit.team_max_player!.toString() +
                " from each team.");
            return;
          }
        }

        if (selectedPlayer.wk_selected < (selectedPlayer.wk_max_count)) {
          if (selectedPlayer.selectedPlayer <
              (selectedPlayer.total_player_count)) {
            if (selectedPlayer.wk_selected < selectedPlayer.wk_min_count ||
                selectedPlayer.extra_player > 0) {
              int extra = selectedPlayer.extra_player;
              if (selectedPlayer.wk_selected >= selectedPlayer.wk_min_count) {
                extra = selectedPlayer.extra_player - 1;
              }

              player_credit = double.parse(wkList[position].credit);

              double total_credit = selectedPlayer.total_credit + player_credit;
              if (total_credit > limit.total_credits!) {
                exeedCredit = true;
                showTeamValidation("Not enough credits to select this player.");
                return;
              }
              int localTeamplayerCount = selectedPlayer.localTeamplayerCount;
              int visitorTeamPlayerCount =
                  selectedPlayer.visitorTeamPlayerCount;

              if (wkList[position].team == "team1")
                localTeamplayerCount = selectedPlayer.localTeamplayerCount + 1;
              else
                visitorTeamPlayerCount =
                    selectedPlayer.visitorTeamPlayerCount + 1;

              wkList[position].isSelected = isSelect;

              updateTeamData(
                  extra,
                  selectedPlayer.wk_selected + 1,
                  selectedPlayer.bat_selected,
                  selectedPlayer.ar_selected,
                  selectedPlayer.bowl_selected,
                  selectedPlayer.c_selected,
                  selectedPlayer.selectedPlayer + 1,
                  localTeamplayerCount,
                  visitorTeamPlayerCount,
                  total_credit);
            } else {
              minimumPlayerWarning();
            }
          }
        }
      } else {
        if (selectedPlayer.wk_selected > 0) {
          if (selectedPlayer.wk_selected < 2) {
            showTeamValidation("Pick " +
                selectedPlayer.wk_min_count.toString() +
                (widget.model.sportKey == AppConstants.TAG_CRICKET
                    ? ' Wicket-Keeper'
                    : widget.model.sportKey == AppConstants.TAG_KABADDI
                        ? ' Defender'
                        : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                            ? ' Point-Guard'
                            : ' Goal-Keeper') +
                '.');
          }
          player_credit = double.parse(wkList[position].credit);

          double total_credit = selectedPlayer.total_credit - player_credit;

          int extra = selectedPlayer.extra_player;
          if (selectedPlayer.wk_selected > selectedPlayer.wk_min_count) {
            extra = (selectedPlayer.extra_player) + 1;
          }
          int localTeamplayerCount = selectedPlayer.localTeamplayerCount;
          int visitorTeamPlayerCount = selectedPlayer.visitorTeamPlayerCount;

          if (wkList[position].team == "team1")
            localTeamplayerCount = selectedPlayer.localTeamplayerCount - 1;
          else
            visitorTeamPlayerCount = selectedPlayer.visitorTeamPlayerCount - 1;

          wkList[position].isSelected = isSelect;

          updateTeamData(
              extra,
              selectedPlayer.wk_selected - 1,
              selectedPlayer.bat_selected,
              selectedPlayer.ar_selected,
              selectedPlayer.bowl_selected,
              selectedPlayer.c_selected,
              selectedPlayer.selectedPlayer - 1,
              localTeamplayerCount,
              visitorTeamPlayerCount,
              total_credit);
        }
      }
    } else if (type == AR) {
      double player_credit;
      if (isSelect) {
        if (selectedPlayer.selectedPlayer >=
            (selectedPlayer.total_player_count)) {
          showTeamValidation("You can choose maximum " +
              selectedPlayer.total_player_count.toString() +
              " players.");

          return;
        }
        if (selectedPlayer.ar_selected >= (selectedPlayer.ar_maxcount)) {
          showTeamValidation("You can select only " +
              (selectedPlayer.ar_maxcount.toString()) +
              (widget.model.sportKey == AppConstants.TAG_CRICKET
                  ? ' All-Rounders'
                  : widget.model.sportKey == AppConstants.TAG_KABADDI
                      ? ' Raider'
                      : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                          ? ' Small-Forward'
                          : ' Midfielder') +
              '.');
          return;
        }

        if (arList[position].team == "team1") {
          if (selectedPlayer.localTeamplayerCount >= limit.team_max_player!) {
            showTeamValidation("You can select only " +
                limit.team_max_player!.toString() +
                " from each team.");
            return;
          }
        } else {
          if (selectedPlayer.visitorTeamPlayerCount >= limit.team_max_player!) {
            showTeamValidation("You can select only " +
                limit.team_max_player!.toString() +
                " from each team.");
            return;
          }
        }

        if (selectedPlayer.ar_selected < (selectedPlayer.ar_maxcount)) {
          if (selectedPlayer.selectedPlayer <
              selectedPlayer.total_player_count) {
            if (selectedPlayer.ar_selected < (selectedPlayer.ar_mincount) ||
                selectedPlayer.extra_player > 0) {
              int extra = selectedPlayer.extra_player;
              if (selectedPlayer.ar_selected >= (selectedPlayer.ar_mincount)) {
                extra = selectedPlayer.extra_player - 1;
              }

              player_credit = double.parse(arList[position].credit);

              double total_credit = selectedPlayer.total_credit + player_credit;
              if (total_credit > limit.total_credits!) {
                exeedCredit = true;
                showTeamValidation("Not enough credits to select this player.");
                return;
              }
              int localTeamplayerCount = selectedPlayer.localTeamplayerCount;
              int visitorTeamPlayerCount =
                  selectedPlayer.visitorTeamPlayerCount;

              if (arList[position].team == "team1")
                localTeamplayerCount = selectedPlayer.localTeamplayerCount + 1;
              else
                visitorTeamPlayerCount =
                    selectedPlayer.visitorTeamPlayerCount + 1;

              arList[position].isSelected = isSelect;
              updateTeamData(
                  extra,
                  selectedPlayer.wk_selected,
                  selectedPlayer.bat_selected,
                  selectedPlayer.ar_selected + 1,
                  selectedPlayer.bowl_selected,
                  selectedPlayer.c_selected,
                  selectedPlayer.selectedPlayer + 1,
                  localTeamplayerCount,
                  visitorTeamPlayerCount,
                  total_credit);
            } else {
              minimumPlayerWarning();
            }
          }
        }
      } else {
        if (selectedPlayer.ar_selected > 0) {
          if (selectedPlayer.ar_selected < 2) {
            showTeamValidation("Pick " +
                (selectedPlayer.ar_mincount.toString()) +
                "-" +
                (selectedPlayer.ar_maxcount.toString()) +
                (widget.model.sportKey == AppConstants.TAG_CRICKET
                    ? ' All-Rounders'
                    : widget.model.sportKey == AppConstants.TAG_KABADDI
                        ? ' Raider'
                        : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                            ? ' Small-Forward'
                            : ' Midfielder') +
                '.');
          }
          player_credit = double.parse(arList[position].credit);

          double total_credit = selectedPlayer.total_credit - player_credit;

          int extra = selectedPlayer.extra_player;
          if (selectedPlayer.ar_selected > (selectedPlayer.ar_mincount)) {
            extra = selectedPlayer.extra_player + 1;
          }
          int localTeamplayerCount = selectedPlayer.localTeamplayerCount;
          int visitorTeamPlayerCount = selectedPlayer.visitorTeamPlayerCount;

          if (arList[position].team == "team1")
            localTeamplayerCount = selectedPlayer.localTeamplayerCount - 1;
          else
            visitorTeamPlayerCount = selectedPlayer.visitorTeamPlayerCount - 1;

          arList[position].isSelected = isSelect;

          updateTeamData(
              extra,
              selectedPlayer.wk_selected,
              selectedPlayer.bat_selected,
              selectedPlayer.ar_selected - 1,
              selectedPlayer.bowl_selected,
              selectedPlayer.c_selected,
              selectedPlayer.selectedPlayer - 1,
              localTeamplayerCount,
              visitorTeamPlayerCount,
              total_credit);
        }
      }
    } else if (type == BAT) {
      double player_credit;
      if (isSelect) {
        if (selectedPlayer.selectedPlayer >=
            (selectedPlayer.total_player_count)) {
          showTeamValidation("You can choose maximum " +
              selectedPlayer.total_player_count.toString() +
              " players");
          return;
        }

        if (selectedPlayer.bat_selected >= (selectedPlayer.bat_maxcount)) {
          showTeamValidation("You can select only " +
              (selectedPlayer.bat_maxcount.toString()) +
              (widget.model.sportKey == AppConstants.TAG_CRICKET
                  ? ' Batter'
                  : widget.model.sportKey == AppConstants.TAG_KABADDI
                      ? ' All-Rounder'
                      : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                          ? ' Shooting-Guard'
                          : ' Defender') +
              '.');
          return;
        }

        if (batList[position].team == "team1") {
          if (selectedPlayer.localTeamplayerCount >= limit.team_max_player!) {
            showTeamValidation("You can select only " +
                limit.team_max_player!.toString() +
                " from each team.");
            return;
          }
        } else {
          if (selectedPlayer.visitorTeamPlayerCount >= limit.team_max_player!) {
            showTeamValidation("You can select only " +
                limit.team_max_player!.toString() +
                " from each team.");
            return;
          }
        }

        if (selectedPlayer.bat_selected < (selectedPlayer.bat_maxcount)) {
          if (selectedPlayer.selectedPlayer <
              selectedPlayer.total_player_count) {
            if (selectedPlayer.bat_selected < (selectedPlayer.bat_mincount) ||
                selectedPlayer.extra_player > 0) {
              int extra = selectedPlayer.extra_player;
              if (selectedPlayer.bat_selected >=
                  (selectedPlayer.bat_mincount)) {
                extra = (selectedPlayer.extra_player) - 1;
              }

              player_credit = double.parse(batList[position].credit);

              double total_credit = selectedPlayer.total_credit + player_credit;
              if (total_credit > limit.total_credits!) {
                exeedCredit = true;
                showTeamValidation("Not enough credits to select this player.");

                return;
              }
              int localTeamplayerCount = selectedPlayer.localTeamplayerCount;
              int visitorTeamPlayerCount =
                  selectedPlayer.visitorTeamPlayerCount;

              if (batList[position].team == "team1")
                localTeamplayerCount = selectedPlayer.localTeamplayerCount + 1;
              else
                visitorTeamPlayerCount =
                    selectedPlayer.visitorTeamPlayerCount + 1;

              batList[position].isSelected = isSelect;

              updateTeamData(
                  extra,
                  selectedPlayer.wk_selected,
                  selectedPlayer.bat_selected + 1,
                  selectedPlayer.ar_selected,
                  selectedPlayer.bowl_selected,
                  selectedPlayer.c_selected,
                  selectedPlayer.selectedPlayer + 1,
                  localTeamplayerCount,
                  visitorTeamPlayerCount,
                  total_credit);
            } else {
              minimumPlayerWarning();
            }
          }
        }
      } else {
        if (selectedPlayer.bat_selected > 0) {
          if (selectedPlayer.bat_selected < 2) {
            showTeamValidation("Pick " +
                ((selectedPlayer.bat_mincount.toString() +
                    "-" +
                    selectedPlayer.bat_maxcount.toString())) +
                (widget.model.sportKey == AppConstants.TAG_CRICKET
                    ? ' Batter'
                    : widget.model.sportKey == AppConstants.TAG_KABADDI
                        ? ' All-Rounder'
                        : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                            ? ' Shooting-Guard'
                            : ' Defender') +
                '.');
          }
          player_credit = double.parse(batList[position].credit);

          double total_credit = selectedPlayer.total_credit - player_credit;

          int extra = selectedPlayer.extra_player;
          if (selectedPlayer.bat_selected > (selectedPlayer.bat_mincount)) {
            extra = (selectedPlayer.extra_player) + 1;
          }
          int localTeamplayerCount = selectedPlayer.localTeamplayerCount;
          int visitorTeamPlayerCount = selectedPlayer.visitorTeamPlayerCount;

          if (batList[position].team == "team1")
            localTeamplayerCount = selectedPlayer.localTeamplayerCount - 1;
          else
            visitorTeamPlayerCount = selectedPlayer.visitorTeamPlayerCount - 1;

          batList[position].isSelected = isSelect;
          updateTeamData(
              extra,
              selectedPlayer.wk_selected,
              selectedPlayer.bat_selected - 1,
              selectedPlayer.ar_selected,
              selectedPlayer.bowl_selected,
              selectedPlayer.c_selected,
              selectedPlayer.selectedPlayer - 1,
              localTeamplayerCount,
              visitorTeamPlayerCount,
              total_credit);
        }
      }
    } else if (type == BOWLER) {
      double player_credit = 0.0;

      if (isSelect) {
        if (selectedPlayer.selectedPlayer >=
            selectedPlayer.total_player_count) {
          showTeamValidation("You can choose maximum " +
              selectedPlayer.total_player_count.toString() +
              " players.");

          return;
        }

        if (selectedPlayer.bowl_selected >= selectedPlayer.bowl_maxcount) {
          showTeamValidation("You can select only " +
              selectedPlayer.bowl_maxcount.toString() +
              (widget.model.sportKey == AppConstants.TAG_CRICKET
                  ? ' Bowlers'
                  : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                      ? ' Power-Forward'
                      : ' State-Forward') +
              '.');
          return;
        }

        if (bolList[position].team == "team1") {
          if (selectedPlayer.localTeamplayerCount >= limit.team_max_player!) {
            showTeamValidation("You can select only " +
                limit.team_max_player.toString() +
                " from each team.");
            return;
          }
        } else {
          if (selectedPlayer.visitorTeamPlayerCount >= limit.team_max_player!) {
            showTeamValidation("You can select only " +
                limit.team_max_player.toString() +
                " from each team.");
            return;
          }
        }

        if (selectedPlayer.bowl_selected < selectedPlayer.bowl_maxcount) {
          if (selectedPlayer.selectedPlayer <
              selectedPlayer.total_player_count) {
            if (selectedPlayer.bowl_selected < selectedPlayer.bowl_mincount ||
                selectedPlayer.extra_player > 0) {
              int extra = selectedPlayer.extra_player;
              if (selectedPlayer.bowl_selected >=
                  selectedPlayer.bowl_mincount) {
                extra = selectedPlayer.extra_player - 1;
              }

              player_credit = double.parse(bolList[position].credit);

              double total_credit = selectedPlayer.total_credit + player_credit;
              if (total_credit > limit.total_credits!) {
                exeedCredit = true;
                showTeamValidation("Not enough credits to select this player.");

                return;
              }
              int localTeamplayerCount = selectedPlayer.localTeamplayerCount;
              int visitorTeamPlayerCount =
                  selectedPlayer.visitorTeamPlayerCount;

              if (bolList[position].team == "team1")
                localTeamplayerCount = selectedPlayer.localTeamplayerCount + 1;
              else
                visitorTeamPlayerCount =
                    selectedPlayer.visitorTeamPlayerCount + 1;

              bolList[position].isSelected = isSelect;

              updateTeamData(
                  extra,
                  selectedPlayer.wk_selected,
                  selectedPlayer.bat_selected,
                  selectedPlayer.ar_selected,
                  selectedPlayer.bowl_selected + 1,
                  selectedPlayer.c_selected,
                  selectedPlayer.selectedPlayer + 1,
                  localTeamplayerCount,
                  visitorTeamPlayerCount,
                  total_credit);
            } else {
              minimumPlayerWarning();
            }
          }
        }
      } else {
        if (selectedPlayer.bowl_selected > 0) {
          if (selectedPlayer.bowl_selected < 2) {
            showTeamValidation("Pick " +
                selectedPlayer.bowl_mincount.toString() +
                "-" +
                selectedPlayer.bowl_maxcount.toString() +
                (widget.model.sportKey == AppConstants.TAG_CRICKET
                    ? ' Bowlers'
                    : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                        ? ' Power-Forward'
                        : ' State-Forward') +
                '.');
          }
          player_credit = double.parse(bolList[position].credit);

          double total_credit = selectedPlayer.total_credit - player_credit;

          int extra = selectedPlayer.extra_player;
          if (selectedPlayer.bowl_selected > selectedPlayer.bowl_mincount) {
            extra = selectedPlayer.extra_player + 1;
          }
          int localTeamplayerCount = selectedPlayer.localTeamplayerCount;
          int visitorTeamPlayerCount = selectedPlayer.visitorTeamPlayerCount;

          if (bolList[position].team == "team1")
            localTeamplayerCount = selectedPlayer.localTeamplayerCount - 1;
          else
            visitorTeamPlayerCount = selectedPlayer.visitorTeamPlayerCount - 1;

          bolList[position].isSelected = isSelect;
          updateTeamData(
              extra,
              selectedPlayer.wk_selected,
              selectedPlayer.bat_selected,
              selectedPlayer.ar_selected,
              selectedPlayer.bowl_selected - 1,
              selectedPlayer.c_selected,
              selectedPlayer.selectedPlayer - 1,
              localTeamplayerCount,
              visitorTeamPlayerCount,
              total_credit);
        }
      }
    } else if (type == C) {
      double player_credit = 0.0;

      if (isSelect) {
        if (selectedPlayer.selectedPlayer >=
            selectedPlayer.total_player_count) {
          showTeamValidation("You can choose maximum " +
              selectedPlayer.total_player_count.toString() +
              " players.");
          return;
        }

        if (selectedPlayer.c_selected >= 4) {
          showTeamValidation("You can select only 4 Centre");
          return;
        }

        if (cList[position].team == "team1") {
          if (selectedPlayer.localTeamplayerCount >= limit.team_max_player!) {
            showTeamValidation("You can select only " +
                limit.team_max_player.toString() +
                " from each team.");
            return;
          }
        } else {
          if (selectedPlayer.visitorTeamPlayerCount >= limit.team_max_player!) {
            showTeamValidation("You can select only " +
                limit.team_max_player.toString() +
                " from each team.");
            return;
          }
        }

        if (selectedPlayer.c_selected < selectedPlayer.c_max_count) {
          if (selectedPlayer.selectedPlayer <
              selectedPlayer.total_player_count) {
            if (selectedPlayer.c_selected < selectedPlayer.c_min_count ||
                selectedPlayer.extra_player > 0) {
              int extra = selectedPlayer.extra_player;
              if (selectedPlayer.c_selected >= selectedPlayer.c_min_count) {
                extra = selectedPlayer.extra_player - 1;
              }

              player_credit = double.parse(cList[position].credit);

              double total_credit = selectedPlayer.total_credit + player_credit;
              if (total_credit > limit.total_credits!) {
                exeedCredit = true;
                showTeamValidation("Not enough credits to select this player.");
                return;
              }
              int localTeamplayerCount = selectedPlayer.localTeamplayerCount;
              int visitorTeamPlayerCount =
                  selectedPlayer.visitorTeamPlayerCount;

              if (cList[position].team == "team1")
                localTeamplayerCount = selectedPlayer.localTeamplayerCount + 1;
              else
                visitorTeamPlayerCount =
                    selectedPlayer.visitorTeamPlayerCount + 1;

              cList[position].isSelected = isSelect;

              updateTeamData(
                  extra,
                  selectedPlayer.wk_selected,
                  selectedPlayer.bat_selected,
                  selectedPlayer.ar_selected,
                  selectedPlayer.bowl_selected,
                  selectedPlayer.c_selected + 1,
                  selectedPlayer.selectedPlayer + 1,
                  localTeamplayerCount,
                  visitorTeamPlayerCount,
                  total_credit);
            } else {
              minimumPlayerWarning();
            }
          }
        }
      } else {
        if (selectedPlayer.c_selected > 0) {
          // showTeamValidation("Pick 1-3 Forward");
          player_credit = double.parse(cList[position].credit);

          double total_credit = selectedPlayer.total_credit - player_credit;

          int extra = selectedPlayer.extra_player;
          if (selectedPlayer.c_selected > selectedPlayer.c_min_count) {
            extra = selectedPlayer.extra_player + 1;
          }
          int localTeamplayerCount = selectedPlayer.localTeamplayerCount;
          int visitorTeamPlayerCount = selectedPlayer.visitorTeamPlayerCount;

          if (cList[position].team == "team1")
            localTeamplayerCount = selectedPlayer.localTeamplayerCount - 1;
          else
            visitorTeamPlayerCount = selectedPlayer.visitorTeamPlayerCount - 1;

          cList[position].isSelected = isSelect;
          updateTeamData(
              extra,
              selectedPlayer.wk_selected,
              selectedPlayer.bat_selected,
              selectedPlayer.ar_selected,
              selectedPlayer.bowl_selected,
              selectedPlayer.c_selected - 1,
              selectedPlayer.selectedPlayer - 1,
              localTeamplayerCount,
              visitorTeamPlayerCount,
              total_credit);
        }
      }
    }
  }

  void continuePlayerSelectionProcessDemo(
      bool isSelect, int position, int type) {
    print(["palyerType==", position, type]);

    if (type == WK) {
      double player_credit;
      if (isSelect) {
        print("isSelect");
        if (selectedPlayer.selectedPlayer >=
            selectedPlayer.total_player_count) {
          showTeamValidation("You can choose maximum " +
              selectedPlayer.total_player_count.toString() +
              " players.");
          return;
        }
        if (selectedPlayer.wk_selected > selectedPlayer.wk_max_count) {
          showTeamValidation("You can select only " +
              selectedPlayer.wk_max_count.toString() +
              (widget.model.sportKey == AppConstants.TAG_CRICKET
                  ? ' Wicket-Keeper'
                  : widget.model.sportKey == AppConstants.TAG_KABADDI
                      ? ' Defender'
                      : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                          ? ' Point-Guard'
                          : ' Goal-Keeper') +
              '.');
          return;
        }
        print(["team1===", wkList[position].team]);
        if (wkList[position].team == "team1") {
          if (selectedPlayer.localTeamplayerCount >= limit.team_max_player!) {
            showTeamValidation("You can select only " +
                limit.team_max_player!.toString() +
                " from each team.");
            return;
          }
        } else {
          print("NonIsSelect");
          if (selectedPlayer.visitorTeamPlayerCount >= limit.team_max_player!) {
            showTeamValidation("You can select only " +
                limit.team_max_player!.toString() +
                " from each team.");
            return;
          }
        }
        print([
          "wk_selected",
          selectedPlayer.wk_selected,
          selectedPlayer.wk_max_count
        ]);
        if (selectedPlayer.wk_selected < selectedPlayer.wk_max_count) {
          if (selectedPlayer.selectedPlayer <
              selectedPlayer.total_player_count) {
            if (selectedPlayer.wk_selected < selectedPlayer.wk_min_count ||
                selectedPlayer.extra_player > 0) {
              int extra = selectedPlayer.extra_player;
              if (selectedPlayer.wk_selected >= selectedPlayer.wk_min_count) {
                extra = selectedPlayer.extra_player - 1;
              }

              player_credit = double.parse(wkList[position].credit);

              double total_credit = selectedPlayer.total_credit + player_credit;
              if (total_credit > limit.total_credits!) {
                exeedCredit = true;
                showTeamValidation("Not enough credits to select this player.");
                return;
              }
              int localTeamplayerCount = selectedPlayer.localTeamplayerCount;
              int visitorTeamPlayerCount =
                  selectedPlayer.visitorTeamPlayerCount;

              if (wkList[position].team == "team1")
                localTeamplayerCount = selectedPlayer.localTeamplayerCount + 1;
              else
                visitorTeamPlayerCount =
                    selectedPlayer.visitorTeamPlayerCount + 1;

              wkList[position].isSelected = isSelect;

              updateTeamData(
                  extra,
                  selectedPlayer.wk_selected + 1,
                  selectedPlayer.bat_selected,
                  selectedPlayer.ar_selected,
                  selectedPlayer.bowl_selected,
                  selectedPlayer.c_selected,
                  selectedPlayer.selectedPlayer + 1,
                  localTeamplayerCount,
                  visitorTeamPlayerCount,
                  total_credit);
            } else {
              minimumPlayerWarning();
            }
          }
        }
      } else {
        if (selectedPlayer.wk_selected > 0) {
          if (widget.model.fantasyType == 1) {
            showTeamValidation("Pick 0-6 Player");
          } else {
            showTeamValidation("Pick " +
                selectedPlayer.wk_min_count.toString() +
                (widget.model.sportKey == AppConstants.TAG_CRICKET
                    ? ' Wicket-Keeper'
                    : widget.model.sportKey == AppConstants.TAG_KABADDI
                        ? ' Defender'
                        : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                            ? ' Point-Guard'
                            : ' Goal-Keeper') +
                '.');
          }

          player_credit = double.parse(wkList[position].credit);

          double total_credit = selectedPlayer.total_credit - player_credit;

          int extra = selectedPlayer.extra_player;
          if (selectedPlayer.wk_selected > selectedPlayer.wk_min_count) {
            extra = selectedPlayer.extra_player + 1;
          }
          int localTeamplayerCount = selectedPlayer.localTeamplayerCount;
          int visitorTeamPlayerCount = selectedPlayer.visitorTeamPlayerCount;

          if (wkList[position].team == "team1")
            localTeamplayerCount = selectedPlayer.localTeamplayerCount - 1;
          else
            visitorTeamPlayerCount = selectedPlayer.visitorTeamPlayerCount - 1;

          wkList[position].isSelected = isSelect;

          updateTeamData(
              extra,
              selectedPlayer.wk_selected - 1,
              selectedPlayer.bat_selected,
              selectedPlayer.ar_selected,
              selectedPlayer.bowl_selected,
              selectedPlayer.c_selected,
              selectedPlayer.selectedPlayer - 1,
              localTeamplayerCount,
              visitorTeamPlayerCount,
              total_credit);
        }
      }
    } else if (type == AR) {
      double player_credit;
      if (isSelect) {
        if (selectedPlayer.selectedPlayer >=
            selectedPlayer.total_player_count) {
          showTeamValidation("You can choose maximum " +
              selectedPlayer.total_player_count.toString() +
              " players.");
          return;
        }
        if (selectedPlayer.ar_selected > selectedPlayer.ar_maxcount) {
          showTeamValidation("You can select only " +
              selectedPlayer.ar_maxcount.toString() +
              (widget.model.sportKey == AppConstants.TAG_CRICKET
                  ? ' All-Rounders'
                  : widget.model.sportKey == AppConstants.TAG_KABADDI
                      ? ' Raider'
                      : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                          ? ' Small-Forward'
                          : ' Midfielder') +
              '.');
          return;
        }

        if (arList[position].team == "team1") {
          if (selectedPlayer.localTeamplayerCount >= limit.team_max_player!) {
            showTeamValidation("You can select only " +
                limit.team_max_player!.toString() +
                " from each team.");
            return;
          }
        } else {
          if (selectedPlayer.visitorTeamPlayerCount >= limit.team_max_player!) {
            showTeamValidation("You can select only " +
                limit.team_max_player!.toString() +
                " from each team.");
            return;
          }
        }

        if (selectedPlayer.ar_selected < selectedPlayer.ar_maxcount) {
          if (selectedPlayer.selectedPlayer <
              selectedPlayer.total_player_count) {
            if (selectedPlayer.ar_selected < selectedPlayer.ar_mincount ||
                selectedPlayer.extra_player > 0) {
              int extra = selectedPlayer.extra_player;
              if (selectedPlayer.ar_selected >= selectedPlayer.ar_mincount) {
                extra = selectedPlayer.extra_player - 1;
              }

              player_credit = double.parse(arList[position].credit);

              double total_credit = selectedPlayer.total_credit + player_credit;
              if (total_credit > limit.total_credits!) {
                exeedCredit = true;
                showTeamValidation("Not enough credits to select this player.");
                return;
              }
              int localTeamplayerCount = selectedPlayer.localTeamplayerCount;
              int visitorTeamPlayerCount =
                  selectedPlayer.visitorTeamPlayerCount;

              if (arList[position].team == "team1")
                localTeamplayerCount = selectedPlayer.localTeamplayerCount + 1;
              else
                visitorTeamPlayerCount =
                    selectedPlayer.visitorTeamPlayerCount + 1;

              arList[position].isSelected = isSelect;
              updateTeamData(
                  extra,
                  selectedPlayer.wk_selected,
                  selectedPlayer.bat_selected,
                  selectedPlayer.ar_selected + 1,
                  selectedPlayer.bowl_selected,
                  selectedPlayer.c_selected,
                  selectedPlayer.selectedPlayer + 1,
                  localTeamplayerCount,
                  visitorTeamPlayerCount,
                  total_credit);
            } else {
              minimumPlayerWarning();
            }
          }
        }
      } else {
        if (selectedPlayer.ar_selected > 0) {
          if (widget.model.fantasyType == 1) {
            showTeamValidation("Pick 0-6 Player");
          } else {
            showTeamValidation("Pick " +
                selectedPlayer.ar_mincount.toString() +
                "-" +
                selectedPlayer.ar_maxcount.toString() +
                (widget.model.sportKey == AppConstants.TAG_CRICKET
                    ? ' All-Rounders'
                    : widget.model.sportKey == AppConstants.TAG_KABADDI
                        ? ' Raider'
                        : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                            ? ' Small-Forward'
                            : ' Midfielder') +
                '.');
          }
          player_credit = double.parse(arList[position].credit);

          double total_credit = selectedPlayer.total_credit - player_credit;

          int extra = selectedPlayer.extra_player;
          if (selectedPlayer.ar_selected > selectedPlayer.ar_mincount) {
            extra = selectedPlayer.extra_player + 1;
          }
          int localTeamplayerCount = selectedPlayer.localTeamplayerCount;
          int visitorTeamPlayerCount = selectedPlayer.visitorTeamPlayerCount;

          if (arList[position].team == "team1")
            localTeamplayerCount = selectedPlayer.localTeamplayerCount - 1;
          else
            visitorTeamPlayerCount = selectedPlayer.visitorTeamPlayerCount - 1;

          arList[position].isSelected = isSelect;

          updateTeamData(
              extra,
              selectedPlayer.wk_selected,
              selectedPlayer.bat_selected,
              selectedPlayer.ar_selected - 1,
              selectedPlayer.bowl_selected,
              selectedPlayer.c_selected,
              selectedPlayer.selectedPlayer - 1,
              localTeamplayerCount,
              visitorTeamPlayerCount,
              total_credit);
        }
      }
    } else if (type == BAT) {
      double player_credit;

      if (isSelect) {
        if (selectedPlayer.selectedPlayer >=
            selectedPlayer.total_player_count) {
          showTeamValidation("You can choose maximum " +
              selectedPlayer.total_player_count.toString() +
              " players");
          return;
        }

        if (selectedPlayer.bat_selected >= selectedPlayer.bat_maxcount) {
          showTeamValidation("You can select only " +
              selectedPlayer.bat_maxcount.toString() +
              (widget.model.sportKey == AppConstants.TAG_CRICKET
                  ? ' Batter'
                  : widget.model.sportKey == AppConstants.TAG_KABADDI
                      ? ' All-Rounder'
                      : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                          ? ' Shooting-Guard'
                          : ' Defender') +
              '.');
          return;
        }

        if (batList[position].team == "team1") {
          if (selectedPlayer.localTeamplayerCount >= limit.team_max_player!) {
            showTeamValidation("You can select only " +
                limit.team_max_player!.toString() +
                " from each team.");
            return;
          }
        } else {
          if (selectedPlayer.visitorTeamPlayerCount >= limit.team_max_player!) {
            showTeamValidation("You can select only " +
                limit.team_max_player!.toString() +
                " from each team.");
            return;
          }
        }

        if (selectedPlayer.bat_selected < selectedPlayer.bat_maxcount) {
          if (selectedPlayer.selectedPlayer <
              selectedPlayer.total_player_count) {
            if (selectedPlayer.bat_selected < selectedPlayer.bat_mincount ||
                selectedPlayer.extra_player > 0) {
              int extra = selectedPlayer.extra_player;
              if (selectedPlayer.bat_selected >= selectedPlayer.bat_mincount) {
                extra = selectedPlayer.extra_player - 1;
              }

              player_credit = double.parse(batList[position].credit);

              double total_credit = selectedPlayer.total_credit + player_credit;
              if (total_credit > limit.total_credits!) {
                exeedCredit = true;
                showTeamValidation("Not enough credits to select this player.");

                return;
              }
              int localTeamplayerCount = selectedPlayer.localTeamplayerCount;
              int visitorTeamPlayerCount =
                  selectedPlayer.visitorTeamPlayerCount;

              if (batList[position].team == "team1")
                localTeamplayerCount = selectedPlayer.localTeamplayerCount + 1;
              else
                visitorTeamPlayerCount =
                    selectedPlayer.visitorTeamPlayerCount + 1;

              batList[position].isSelected = isSelect;

              updateTeamData(
                  extra,
                  selectedPlayer.wk_selected,
                  selectedPlayer.bat_selected + 1,
                  selectedPlayer.ar_selected,
                  selectedPlayer.bowl_selected,
                  selectedPlayer.c_selected,
                  selectedPlayer.selectedPlayer + 1,
                  localTeamplayerCount,
                  visitorTeamPlayerCount,
                  total_credit);
            } else {
              minimumPlayerWarning();
            }
          }
        }
      } else {
        if (selectedPlayer.bat_selected > 0) {
          if (widget.model.fantasyType == 1) {
            showTeamValidation("Pick 0-6 Player");
          } else {
            showTeamValidation("Pick " +
                selectedPlayer.bat_mincount.toString() +
                "-" +
                selectedPlayer.bat_maxcount.toString() +
                (widget.model.sportKey == AppConstants.TAG_CRICKET
                    ? ' Batter'
                    : widget.model.sportKey == AppConstants.TAG_KABADDI
                        ? ' All-Rounder'
                        : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                            ? ' Shooting-Guard'
                            : ' Defender') +
                '.');
          }

          player_credit = double.parse(batList[position].credit);

          double total_credit = selectedPlayer.total_credit - player_credit;

          int extra = selectedPlayer.extra_player;
          if (selectedPlayer.bat_selected > selectedPlayer.bat_mincount) {
            extra = selectedPlayer.extra_player + 1;
          }
          int localTeamplayerCount = selectedPlayer.localTeamplayerCount;
          int visitorTeamPlayerCount = selectedPlayer.visitorTeamPlayerCount;

          if (batList[position].team == "team1")
            localTeamplayerCount = selectedPlayer.localTeamplayerCount - 1;
          else
            visitorTeamPlayerCount = selectedPlayer.visitorTeamPlayerCount - 1;

          batList[position].isSelected = isSelect;
          updateTeamData(
              extra,
              selectedPlayer.wk_selected,
              selectedPlayer.bat_selected - 1,
              selectedPlayer.ar_selected,
              selectedPlayer.bowl_selected,
              selectedPlayer.c_selected,
              selectedPlayer.selectedPlayer - 1,
              localTeamplayerCount,
              visitorTeamPlayerCount,
              total_credit);
        }
      }
    } else if (type == BOWLER) {
      double player_credit = 0.0;

      if (isSelect) {
        if (selectedPlayer.selectedPlayer >=
            selectedPlayer.total_player_count) {
          showTeamValidation("You can choose maximum " +
              selectedPlayer.total_player_count.toString() +
              " players.");

          return;
        }

        if (selectedPlayer.bowl_selected >= selectedPlayer.bowl_maxcount) {
          showTeamValidation("You can select only " +
              selectedPlayer.bowl_maxcount.toString() +
              (widget.model.sportKey == AppConstants.TAG_CRICKET
                  ? ' Bowlers'
                  : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                      ? ' Power-Forward'
                      : ' State-Forward') +
              '.');
          return;
        }

        if (bolList[position].team == "team1") {
          if (selectedPlayer.localTeamplayerCount >= limit.team_max_player!) {
            showTeamValidation("You can select only " +
                limit.team_max_player.toString() +
                " from each team.");
            return;
          }
        } else {
          if (selectedPlayer.visitorTeamPlayerCount >= limit.team_max_player!) {
            showTeamValidation("You can select only " +
                limit.team_max_player.toString() +
                " from each team.");
            return;
          }
        }

        if (selectedPlayer.bowl_selected < selectedPlayer.bowl_maxcount) {
          if (selectedPlayer.selectedPlayer <
              selectedPlayer.total_player_count) {
            if (selectedPlayer.bowl_selected < selectedPlayer.bowl_mincount ||
                selectedPlayer.extra_player > 0) {
              int extra = selectedPlayer.extra_player;
              if (selectedPlayer.bowl_selected >=
                  selectedPlayer.bowl_mincount) {
                extra = selectedPlayer.extra_player - 1;
              }

              player_credit = double.parse(bolList[position].credit);

              double total_credit = selectedPlayer.total_credit + player_credit;
              if (total_credit > limit.total_credits!) {
                exeedCredit = true;
                showTeamValidation("Not enough credits to select this player.");

                return;
              }
              int localTeamplayerCount = selectedPlayer.localTeamplayerCount;
              int visitorTeamPlayerCount =
                  selectedPlayer.visitorTeamPlayerCount;

              if (bolList[position].team == "team1")
                localTeamplayerCount = selectedPlayer.localTeamplayerCount + 1;
              else
                visitorTeamPlayerCount =
                    selectedPlayer.visitorTeamPlayerCount + 1;

              bolList[position].isSelected = isSelect;

              updateTeamData(
                  extra,
                  selectedPlayer.wk_selected,
                  selectedPlayer.bat_selected,
                  selectedPlayer.ar_selected,
                  selectedPlayer.bowl_selected + 1,
                  selectedPlayer.c_selected,
                  selectedPlayer.selectedPlayer + 1,
                  localTeamplayerCount,
                  visitorTeamPlayerCount,
                  total_credit);
            } else {
              minimumPlayerWarning();
            }
          }
        }
      } else {
        if (selectedPlayer.bowl_selected > 0) {
          if (widget.model.fantasyType == 1) {
            showTeamValidation("Pick 0-6 Player");
          } else {
            showTeamValidation("Pick " +
                selectedPlayer.bowl_mincount.toString() +
                "-" +
                selectedPlayer.bowl_maxcount.toString() +
                (widget.model.sportKey == AppConstants.TAG_CRICKET
                    ? ' Bowlers'
                    : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                        ? ' Power-Forward'
                        : ' State-Forward') +
                '.');
          }
          player_credit = double.parse(bolList[position].credit);

          double total_credit = selectedPlayer.total_credit - player_credit;

          int extra = selectedPlayer.extra_player;
          if (selectedPlayer.bowl_selected > selectedPlayer.bowl_mincount) {
            extra = selectedPlayer.extra_player + 1;
          }
          int localTeamplayerCount = selectedPlayer.localTeamplayerCount;
          int visitorTeamPlayerCount = selectedPlayer.visitorTeamPlayerCount;

          if (bolList[position].team == "team1")
            localTeamplayerCount = selectedPlayer.localTeamplayerCount - 1;
          else
            visitorTeamPlayerCount = selectedPlayer.visitorTeamPlayerCount - 1;

          bolList[position].isSelected = isSelect;
          updateTeamData(
              extra,
              selectedPlayer.wk_selected,
              selectedPlayer.bat_selected,
              selectedPlayer.ar_selected,
              selectedPlayer.bowl_selected - 1,
              selectedPlayer.c_selected,
              selectedPlayer.selectedPlayer - 1,
              localTeamplayerCount,
              visitorTeamPlayerCount,
              total_credit);
        }
      }
    } else if (type == C) {
      double player_credit = 0.0;

      if (isSelect) {
        if (selectedPlayer.selectedPlayer >=
            selectedPlayer.total_player_count) {
          showTeamValidation("You can choose maximum " +
              selectedPlayer.total_player_count.toString() +
              " players.");
          return;
        }

        if (selectedPlayer.c_selected >= 4) {
          showTeamValidation("You can select only 4 Centre");
          return;
        }

        if (cList[position].team == "team1") {
          if (selectedPlayer.localTeamplayerCount >= limit.team_max_player!) {
            showTeamValidation("You can select only " +
                limit.team_max_player.toString() +
                " from each team.");
            return;
          }
        } else {
          if (selectedPlayer.visitorTeamPlayerCount >= limit.team_max_player!) {
            showTeamValidation("You can select only " +
                limit.team_max_player.toString() +
                " from each team.");
            return;
          }
        }

        if (selectedPlayer.c_selected < selectedPlayer.c_max_count) {
          if (selectedPlayer.selectedPlayer <
              selectedPlayer.total_player_count) {
            if (selectedPlayer.c_selected < selectedPlayer.c_max_count ||
                selectedPlayer.extra_player > 0) {
              int extra = selectedPlayer.extra_player;
              if (selectedPlayer.c_selected >= selectedPlayer.c_min_count) {
                extra = selectedPlayer.extra_player - 1;
              }

              player_credit = double.parse(cList[position].credit);

              double total_credit = selectedPlayer.total_credit + player_credit;
              if (total_credit > limit.total_credits!) {
                exeedCredit = true;
                showTeamValidation("Not enough credits to select this player.");
                return;
              }
              int localTeamplayerCount = selectedPlayer.localTeamplayerCount;
              int visitorTeamPlayerCount =
                  selectedPlayer.visitorTeamPlayerCount;

              if (cList[position].team == "team1")
                localTeamplayerCount = selectedPlayer.localTeamplayerCount + 1;
              else
                visitorTeamPlayerCount =
                    selectedPlayer.localTeamplayerCount + 1;

              cList[position].isSelected = isSelect;

              updateTeamData(
                  extra,
                  selectedPlayer.wk_selected,
                  selectedPlayer.bat_selected,
                  selectedPlayer.ar_selected,
                  selectedPlayer.bowl_selected,
                  selectedPlayer.c_selected + 1,
                  selectedPlayer.selectedPlayer + 1,
                  localTeamplayerCount,
                  visitorTeamPlayerCount,
                  total_credit);
            } else {
              minimumPlayerWarning();
            }
          }
        }
      } else {
        if (selectedPlayer.c_selected > 0) {
          //     showTeamValidation("Pick 1-3 Forward");
          player_credit = double.parse(cList[position].credit);

          double total_credit = selectedPlayer.total_credit - player_credit;

          int extra = selectedPlayer.extra_player;
          if (selectedPlayer.c_selected > selectedPlayer.c_min_count) {
            extra = selectedPlayer.extra_player + 1;
          }
          int localTeamplayerCount = selectedPlayer.localTeamplayerCount;
          int visitorTeamPlayerCount = selectedPlayer.visitorTeamPlayerCount;

          if (cList[position].team == "team1")
            localTeamplayerCount = selectedPlayer.localTeamplayerCount - 1;
          else
            visitorTeamPlayerCount = selectedPlayer.visitorTeamPlayerCount - 1;

          cList[position].isSelected = isSelect;
          updateTeamData(
              extra,
              selectedPlayer.wk_selected,
              selectedPlayer.bat_selected,
              selectedPlayer.ar_selected,
              selectedPlayer.bowl_selected,
              selectedPlayer.c_selected - 1,
              selectedPlayer.selectedPlayer - 1,
              localTeamplayerCount,
              visitorTeamPlayerCount,
              total_credit);
        }
      }
    }
  }

  void createTeamData() {
    if (widget.model.battingFantasy == AppConstants.BATTING_FANTASY_TYPE ||
        widget.model.battingFantasy == AppConstants.BOWLING_FANTASY_TYPE ||
        (widget.model.battingFantasy == AppConstants.LIVE_FANTASY_TYPE &&
            limit.total_credits == 45)) {
      selectedPlayer.extra_player = 4;
      selectedPlayer.wk_min_count = 1;
      selectedPlayer.wk_max_count = 5;
      selectedPlayer.wk_selected = 0;
      selectedPlayer.bat_mincount = 1;
      selectedPlayer.bat_maxcount = 5;
      selectedPlayer.bat_selected = 0;
      selectedPlayer.bowl_mincount = 1;
      selectedPlayer.bowl_maxcount = 5;
      selectedPlayer.bowl_selected = 0;
      selectedPlayer.ar_mincount = 1;
      selectedPlayer.ar_maxcount = 5;
      selectedPlayer.ar_selected = 0;
      selectedPlayer.selectedPlayer = 0;
      selectedPlayer.c_min_count = 1;
      selectedPlayer.total_player_count = 5;
      if (widget.model.fantasyType == AppConstants.LIVE_FANTASY_TYPE) {
        selectedPlayer.localTeamMaxplayerCount = 5;
        selectedPlayer.visitorTeamMaxplayerCount = 5;
      } else {
        selectedPlayer.localTeamMaxplayerCount = 3;
        selectedPlayer.visitorTeamMaxplayerCount = 3;
      }
      selectedPlayer.localTeamplayerCount = 0;
      selectedPlayer.visitorTeamPlayerCount = 0;
      selectedPlayer.total_credit = 0.0;
    } else {
      selectedPlayer.extra_player = extraPlayer(
          widget.model.fantasyType.toString(),
          widget.model
              .sportKey) /*widget.model.fantasyType==2 ? 6 : widget.model.fantasyType==1?7: 3*/;

      selectedPlayer.wk_min_count =
          widget.model.sportKey == AppConstants.TAG_CRICKET
              ? minWicketKeeper(widget.model.fantasyType
                  .toString()) /*widget.model.fantasyType==2 ? 0 : 1*/
              : widget.model.sportKey == AppConstants.TAG_KABADDI
                  ? 1
                  : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                      ? 1
                      : 1;

      selectedPlayer.wk_max_count = widget.model.sportKey ==
              AppConstants.TAG_CRICKET
          ? maxWicketKeeper(widget.model.fantasyType.toString())
          /*widget.model.fantasyType==2?6: widget.model.fantasyType==1 ? 8 : 4*/
          : widget.model.sportKey == AppConstants.TAG_KABADDI
              ? 5
              : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                  ? 4
                  : 1;
      selectedPlayer.wk_selected = 0;
      selectedPlayer.bat_mincount =
          widget.model.sportKey == AppConstants.TAG_CRICKET
              ? minBatsman(widget.model.fantasyType.toString())
              : widget.model.sportKey == AppConstants.TAG_KABADDI
                  ? 1
                  : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                      ? 1
                      : 3;
      selectedPlayer.bat_maxcount = widget.model.sportKey ==
              AppConstants.TAG_CRICKET
          ? maxBatsman(widget.model.fantasyType.toString())
          /* widget.model.fantasyType==2?6: widget.model.fantasyType==1 ? 8 :
      6*/
          : widget.model.sportKey == AppConstants.TAG_KABADDI
              ? 5
              : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                  ? 4
                  : 5;
      selectedPlayer.bat_selected = 0;
      selectedPlayer.bowl_mincount = widget.model.sportKey ==
              AppConstants.TAG_CRICKET
          ? minBowler(widget.model.fantasyType.toString())
          /* widget.model.fantasyType==2?0:widget.model.fantasyType==1?1:
          3*/
          : widget.model.sportKey == AppConstants.TAG_BASKETBALL
              ? 1
              : 1;
      selectedPlayer.bowl_maxcount = widget.model.sportKey ==
              AppConstants.TAG_CRICKET
          ? maxBowler(widget.model.fantasyType.toString())
          /*widget.model.fantasyType==2?6: widget.model.fantasyType==1 ? 8 :
          6*/
          : widget.model.sportKey == AppConstants.TAG_BASKETBALL
              ? 4
              : 3;
      selectedPlayer.bowl_selected = 0;
      selectedPlayer.ar_mincount =
          widget.model.sportKey == AppConstants.TAG_CRICKET
              ? minAllRounder(widget.model.fantasyType.toString())
              /*widget.model.fantasyType==2 ?  0 : 1*/
              : widget.model.sportKey == AppConstants.TAG_KABADDI
                  ? 1
                  : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                      ? 1
                      : 3;
      selectedPlayer.ar_maxcount =
          widget.model.sportKey == AppConstants.TAG_CRICKET
              ? maxAllRounder(widget.model.fantasyType.toString())
              : widget.model.sportKey == AppConstants.TAG_KABADDI
                  ? 5
                  : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                      ? 4
                      : 5;
      selectedPlayer.ar_selected = 0;
      selectedPlayer.c_min_count = 1;
      selectedPlayer.c_max_count = 4;
      selectedPlayer.c_selected = 0;
      selectedPlayer.selectedPlayer = 0;
      selectedPlayer.total_player_count = limit.maxplayers!;
      selectedPlayer.localTeamMaxplayerCount = 6;
      selectedPlayer.visitorTeamMaxplayerCount = 6;
      selectedPlayer.localTeamplayerCount = 0;
      selectedPlayer.visitorTeamPlayerCount = 0;
      selectedPlayer.total_credit = 0.0;
      localTeamplayerCount = 0;
      visitorTeamPlayerCount = 0;
    }
  }

  void updateTeamData(
      int extra_player,
      int wk_selected,
      int bat_selected,
      int ar_selected,
      int bowl_selected,
      int c_selected,
      int selectPlayer,
      int localTeamplayerCount,
      int visitorTeamPlayerCount,
      double total_credit) {
    exeedCredit = false;
    selectedPlayer.extra_player = extra_player;
    selectedPlayer.wk_selected = wk_selected;
    selectedPlayer.bat_selected = bat_selected;
    selectedPlayer.ar_selected = ar_selected;
    selectedPlayer.bowl_selected = bowl_selected;
    selectedPlayer.c_selected = c_selected;
    selectedPlayer.selectedPlayer = selectPlayer;
    selectedPlayer.localTeamplayerCount = localTeamplayerCount;
    selectedPlayer.visitorTeamPlayerCount = visitorTeamPlayerCount;
    selectedPlayer.total_credit = total_credit;
    this.localTeamplayerCount = localTeamplayerCount;
    this.visitorTeamPlayerCount = visitorTeamPlayerCount;
    setState(() {});
  }

  void minimumPlayerWarning() {
    if (selectedPlayer.c_selected < selectedPlayer.c_min_count &&
        widget.model.sportKey == AppConstants.TAG_BASKETBALL) {
      showTeamValidation("You must select at least " +
          selectedPlayer.c_min_count.toString() +
          ' Center.');
    } else if (widget.model.sportKey != AppConstants.TAG_KABADDI &&
        selectedPlayer.bowl_selected < selectedPlayer.bowl_mincount) {
      showTeamValidation("You must select at least " +
          selectedPlayer.bowl_mincount.toString() +
          (widget.model.sportKey == AppConstants.TAG_CRICKET
              ? ' Bowlers'
              : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                  ? ' Power-Forward'
                  : ' Forward') +
          '.');
    } else if (selectedPlayer.bat_selected < selectedPlayer.bat_mincount) {
      showTeamValidation("You must select at least " +
          selectedPlayer.bat_mincount.toString() +
          (widget.model.sportKey == AppConstants.TAG_CRICKET
              ? ' Batter'
              : widget.model.sportKey == AppConstants.TAG_KABADDI
                  ? ' All-Rounder'
                  : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                      ? ' Shooting-Guard'
                      : ' Defenders') +
          '.');
    } else if (selectedPlayer.ar_selected < selectedPlayer.ar_mincount) {
      showTeamValidation("You must select at least " +
          selectedPlayer.ar_mincount.toString() +
          (widget.model.sportKey == AppConstants.TAG_CRICKET
              ? ' All-Rounders'
              : widget.model.sportKey == AppConstants.TAG_KABADDI
                  ? ' Raider'
                  : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                      ? ' Small-Forward'
                      : ' Mid-Fielder') +
          '.');
    } else if (selectedPlayer.wk_selected < selectedPlayer.wk_min_count) {
      showTeamValidation("You must select at least " +
          selectedPlayer.wk_min_count.toString() +
          (widget.model.sportKey == AppConstants.TAG_CRICKET
              ? ' Wicket-Keeper'
              : widget.model.sportKey == AppConstants.TAG_KABADDI
                  ? ' Defender'
                  : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                      ? ' Point-Guard'
                      : ' Goal-Keeper') +
          '.');
    }
  }

  void showTeamValidation(String mesg) {
    MethodUtils.showError(context, mesg);
  }

  void getPlayerList() async {
    AppLoaderProgress.showLoader(context);
    ContestRequest contestRequest = new ContestRequest(
        // credittype: credittype,
        user_id: userId,
        matchkey: widget.model.matchKey,
        sport_key: widget.model.sportKey,
        fantasy_type_id: CricketTypeFantasy.getCricketType(
            widget.model.fantasyType.toString(),
            sportsKey: widget.model
                .sportKey) /*widget.model.fantasyType==1?"7":widget.model.fantasyType==2?"6":"0"*/,
        fantasy_type: widget.model.fantasyType.toString(),
        slotes_id: widget.model.fantasySlots.toString());
    final client = ApiClient(AppRepository.dio);
    PlayerListResponse response = await client.getPlayerList(contestRequest);
    if (response.status == 1) {
      allPlayerList = response.result!;
      limit = response.limit!;
      maxPlayerString = limit.team_max_player.toString();
      islineUp = response.is_visible_lineup!;
      islineUpOut = response.is_lineup_out!;
      allPlayerList.sort((a, b) => b.getCredits().compareTo(a.getCredits()));

      createTeamData();
      for (Player player in allPlayerList) {
        if (player.role.toString().toLowerCase() ==
            (widget.model.sportKey == AppConstants.TAG_CRICKET
                    ? AppConstants.KEY_PLAYER_ROLE_KEEP
                    : widget.model.sportKey == AppConstants.TAG_KABADDI
                        ? AppConstants.KEY_PLAYER_ROLE_DEF
                        : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                            ? AppConstants.KEY_PLAYER_ROLE_PG
                            : AppConstants.KEY_PLAYER_ROLE_GK)
                .toString()
                .toLowerCase()) {
          wkList.add(player);
          wkListTemp.add(player);
          if (player.team == "team1") {
            team1wkList.add(player);
          } else {
            team2wkList.add(player);
          }
        } else if (player.role.toString().toLowerCase() ==
            (widget.model.sportKey == AppConstants.TAG_CRICKET
                    ? AppConstants.KEY_PLAYER_ROLE_BAT
                    : widget.model.sportKey == AppConstants.TAG_KABADDI
                        ? AppConstants.KEY_PLAYER_ROLE_ALL_R
                        : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                            ? AppConstants.KEY_PLAYER_ROLE_SG
                            : AppConstants.KEY_PLAYER_ROLE_DEF)
                .toString()
                .toLowerCase()) {
          batList.add(player);
          batListTemp.add(player);
          if (player.team == "team1") {
            team1batList.add(player);
          } else {
            team2batList.add(player);
          }
        } else if (player.role.toString().toLowerCase() ==
            (widget.model.sportKey == AppConstants.TAG_CRICKET
                    ? AppConstants.KEY_PLAYER_ROLE_ALL_R
                    : widget.model.sportKey == AppConstants.TAG_KABADDI
                        ? AppConstants.KEY_PLAYER_ROLE_RD
                        : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                            ? AppConstants.KEY_PLAYER_ROLE_SF
                            : AppConstants.KEY_PLAYER_ROLE_MID)
                .toString()
                .toLowerCase()) {
          arList.add(player);
          arListTemp.add(player);
          if (player.team == "team1") {
            team1arList.add(player);
          } else {
            team2arList.add(player);
          }
        } else if (player.role.toString().toLowerCase() ==
            (widget.model.sportKey == AppConstants.TAG_CRICKET
                    ? AppConstants.KEY_PLAYER_ROLE_BOL
                    : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                        ? AppConstants.KEY_PLAYER_ROLE_PF
                        : AppConstants.KEY_PLAYER_ROLE_ST)
                .toString()
                .toLowerCase()) {
          bolList.add(player);
          bolListTemp.add(player);
          if (player.team == "team1") {
            team1bolList.add(player);
          } else {
            team2bolList.add(player);
          }
        } else if (player.role.toString().toLowerCase() ==
            AppConstants.KEY_PLAYER_ROLE_C.toString().toLowerCase()) {
          cList.add(player);
          cListTemp.add(player);
          if (player.team == "team1") {
            team1cList.add(player);
          } else {
            team2cList.add(player);
          }
        }
      }
    }
    if (selectedList.length > 0) {
      for (int i = 0; i < allPlayerList.length; i++) {
        for (Player player in selectedList) {
          if (player.id == allPlayerList[i].id) {
            allPlayerList[i].isSelected = true;
            if (player.captain == 1) allPlayerList[i].isCaptain = true;
            if (player.vicecaptain == 1) allPlayerList[i].isVcCaptain = true;
          }
        }
      }
      setSelectedCountForEditCloneOrUpload(
          selectedPlayer.total_player_count, 0);
    }
    setState(() {
      AppLoaderProgress.hideLoader(context);
    });
  }

  void setSelectedCountForEditCloneOrUpload(
      int totalPlayerSelected, int extraPlayer) {
    int countWK = 0;
    int countBAT = 0;
    int countBALL = 0;
    int countALL = 0;
    int countC = 0;
    int totalCount = 0;
    int team1Count = 0;
    int team2Count = 0;
    double usedCredit = 0;

    for (Player player in allPlayerList) {
      if (player.isSelected ?? false) {
        if (player.role.toString().toLowerCase() ==
            (widget.model.sportKey == AppConstants.TAG_CRICKET
                    ? AppConstants.KEY_PLAYER_ROLE_KEEP
                    : widget.model.sportKey == AppConstants.TAG_KABADDI
                        ? AppConstants.KEY_PLAYER_ROLE_DEF
                        : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                            ? AppConstants.KEY_PLAYER_ROLE_PG
                            : AppConstants.KEY_PLAYER_ROLE_GK)
                .toString()
                .toLowerCase()) {
          countWK++;
        }
        if (player.role.toString().toLowerCase() ==
            (widget.model.sportKey == AppConstants.TAG_CRICKET
                    ? AppConstants.KEY_PLAYER_ROLE_BAT
                    : widget.model.sportKey == AppConstants.TAG_KABADDI
                        ? AppConstants.KEY_PLAYER_ROLE_ALL_R
                        : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                            ? AppConstants.KEY_PLAYER_ROLE_SG
                            : AppConstants.KEY_PLAYER_ROLE_DEF)
                .toString()
                .toLowerCase()) {
          countBAT++;
        }
        if (player.role.toString().toLowerCase() ==
            (widget.model.sportKey == AppConstants.TAG_CRICKET
                    ? AppConstants.KEY_PLAYER_ROLE_ALL_R
                    : widget.model.sportKey == AppConstants.TAG_KABADDI
                        ? AppConstants.KEY_PLAYER_ROLE_RD
                        : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                            ? AppConstants.KEY_PLAYER_ROLE_SF
                            : AppConstants.KEY_PLAYER_ROLE_MID)
                .toString()
                .toLowerCase()) {
          countALL++;
        }
        if (player.role.toString().toLowerCase() ==
            (widget.model.sportKey == AppConstants.TAG_CRICKET
                    ? AppConstants.KEY_PLAYER_ROLE_BOL
                    : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                        ? AppConstants.KEY_PLAYER_ROLE_PF
                        : AppConstants.KEY_PLAYER_ROLE_ST)
                .toString()
                .toLowerCase()) {
          countBALL++;
        }
        if (player.role.toString().toLowerCase() ==
            AppConstants.KEY_PLAYER_ROLE_C.toString().toLowerCase()) {
          countC++;
        }

        if (player.team == "team1") {
          team1Count++;
        }

        if (player.team == "team2") {
          team2Count++;
        }

        totalCount++;
        usedCredit += double.parse(player.credit);
      }
    }

    selectedPlayer.wk_selected = countWK;
    selectedPlayer.bat_selected = countBAT;
    selectedPlayer.ar_selected = countALL;
    selectedPlayer.bowl_selected = countBALL;
    selectedPlayer.c_selected = countC;
    selectedPlayer.selectedPlayer = totalPlayerSelected;
    selectedPlayer.localTeamplayerCount = team1Count;
    selectedPlayer.visitorTeamPlayerCount = team2Count;
    selectedPlayer.total_credit = usedCredit;

    updateTeamData(
        extraPlayer,
        selectedPlayer.wk_selected,
        selectedPlayer.bat_selected,
        selectedPlayer.ar_selected,
        selectedPlayer.bowl_selected,
        selectedPlayer.c_selected,
        selectedPlayer.selectedPlayer,
        selectedPlayer.localTeamplayerCount,
        selectedPlayer.visitorTeamPlayerCount,
        selectedPlayer.total_credit);
  }

  creditpopup() {
    return creditPopup == true
        ? Container(
            color: Colors.black12,
            child: Dialog(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Wrap(
                  children: [
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                  ),
                                )),
                            SizedBox(
                              width: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Container(
                                  height: 40,
                                  child: Text(
                                    "Choose Your Credits",
                                    style: TextStyle(
                                        // fontFamily: "Roboto",
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  key: btnKey,
                                  onTap: () {
                                    setState(() {
                                      credittype = 0;

                                      widget.model.unlimited_credit_match = 0;

                                      creditPopup = false;
                                    });
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: primaryColor),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Normal Match Credits',
                                        style: TextStyle(
                                            //   fontFamily: "Roboto",
                                            color: primaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      credittype = 1;
                                      widget.model.unlimited_credit_match = 1;
                                      limit.total_credits = 1000;
                                      creditPopup = false;
                                    });
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: primaryColor),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Center(
                                      child: Text(
                                        'Unlimited Credits',
                                        style: TextStyle(
                                            //   fontFamily: "Roboto",
                                            color: primaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container();
  }

  lineupoutpopup() {
    return lineupPopup == true
        ? Container(
            color: Colors.black12,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0)),
                      color: primaryColor,
                    ),
                    // alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.close,
                          color: Colors.transparent,
                        ),
                        Container(
                            child: Text(
                          "Announced Lineups",
                          style: TextStyle(
                              //  fontFamily: "Roboto",
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                        GestureDetector(
                            onTap: () {
                              lineupPopup = false;
                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text("${widget.model.team1Name}",
                                style: TextStyle(
                                    //  fontFamily: "Roboto",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12)),
                            Row(
                              children: [
                                new Container(
                                  height: 35,
                                  width: 35,
                                  margin: EdgeInsets.only(bottom: 0),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.model.team1Logo!,
                                    placeholder: (context, url) =>
                                        new Image.asset(
                                            AppImages.logoPlaceholderURL),
                                    errorWidget: (context, url, error) =>
                                        new Image.asset(
                                            AppImages.logoPlaceholderURL),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${widget.model.teamVs!.split(' VS ')[0]}",
                                  style: TextStyle(
                                      // fontFamily: "Roboto",
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // CustomTimer(
                        //   controller: timeController,
                        //   from: Duration(
                        //       milliseconds: DateFormat.getFormattedDateObj(
                        //                   widget.model.headerText!)!
                        //               .millisecondsSinceEpoch -
                        //           MethodUtils.getDateTime()
                        //               .millisecondsSinceEpoch),
                        //   to: Duration(milliseconds: 0),
                        //   onBuildAction: CustomTimerAction.auto_start,
                        //   builder: (CustomTimerRemainingTime remaining) {
                        //     if (remaining.hours == '00' &&
                        //         remaining.minutes == '00' &&
                        //         remaining.seconds == '00') {
                        //       navigateToHomePage(context);
                        //     }
                        //     return new GestureDetector(
                        //       behavior: HitTestBehavior.translucent,
                        //       child: Text(
                        //         int.parse(remaining.days) >= 1
                        //             ? int.parse(remaining.days) > 1
                        //                 ? "${remaining.days} Days "
                        //                 : "${remaining.days} Day "
                        //             : int.parse(remaining.hours) >= 1
                        //                 ? "${remaining.hours}H : ${remaining.minutes}M "
                        //                 : " ${remaining.minutes} M :${remaining.seconds}S " +
                        //                     "",
                        //         style: TextStyle(
                        //             fontFamily: "Roboto",
                        //             color: primaryColor,
                        //             decoration: TextDecoration.none,
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: 11),
                        //       ),
                        //       onTap: () {},
                        //     );
                        //   },
                        // ),
                        Column(
                          children: [
                            Text("${widget.model.team2Name}",
                                style: TextStyle(
                                    // fontFamily: "Roboto",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                            Row(
                              children: [
                                Text(
                                  "${widget.model.teamVs!.split(' VS ')[1]}",
                                  style: TextStyle(
                                      //  fontFamily: "Roboto",
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                new Container(
                                  height: 35,
                                  width: 35,
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.model.team2Logo!,
                                    placeholder: (context, url) =>
                                        new Image.asset(
                                            AppImages.logoPlaceholderURL),
                                    errorWidget: (context, url, error) =>
                                        new Image.asset(
                                            AppImages.logoPlaceholderURL),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      lineUppLayer1List(isPlayingPlayers1),
                      lineUppLayerList(isPlayingPlayers2),
                    ],
                  ),
                ],
              ),
              insetPadding:
                  EdgeInsets.only(bottom: 15, left: 15, right: 15, top: 40),
            ),
          )
        : Container();
  }

  playerLineUpUi(
      String imageUi,
      String imageUi2,
      String playerName,
      String playerName2,
      String playerRole,
      String playerRole2,
      int index,
      int index2) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    child: CachedNetworkImage(
                      imageUrl: imageUi,
                      placeholder: (context, url) =>
                          new Image.asset(AppImages.defaultAvatarIcon),
                      errorWidget: (context, url, error) =>
                          new Image.asset(AppImages.defaultAvatarIcon),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${playerName.length > 14 ? playerName.substring(0, 13) + ".." : playerName}",
                        style: TextStyle(
                            //  fontFamily: "Roboto",
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                      Text(
                        "$playerRole",
                        style: TextStyle(
                            //  fontFamily: "Roboto",
                            fontWeight: FontWeight.w400,
                            fontSize: 10),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.grey,
                padding: EdgeInsets.zero,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${playerName2.length > 14 ? playerName2.substring(0, 13) + ".." : playerName2}",
                        style: TextStyle(
                            //  fontFamily: "Roboto",
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                      Text(
                        "$playerRole2",
                        style: TextStyle(
                            //  fontFamily: "Roboto",
                            fontWeight: FontWeight.w400,
                            fontSize: 10),
                      ),
                    ],
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    child: CachedNetworkImage(
                      imageUrl: imageUi2,
                      placeholder: (context, url) =>
                          new Image.asset(AppImages.defaultAvatarIcon),
                      errorWidget: (context, url, error) =>
                          new Image.asset(AppImages.defaultAvatarIcon),
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
        )
      ],
    );
  }

  /*playerList(List<Player> isPlayingPlayers1, List<Player> isPlayingPlayers2, int index, List<Player> allPlayerList) {
    int i =0 ;
    print(["playerlist====++++++++++++++",wkList.length]);
    allPlayerList.forEach((element) {
      if(element.is_playing==1){
        print(["playerlist====",i++]);
      }
    });

    return  Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 10,right: 10),
          child: Row(
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    child: CachedNetworkImage(
                      imageUrl: allPlayerList.image!,
                      placeholder: (context,
                          url) =>
                      new Image.asset(AppImages.defaultAvatarIcon),
                      errorWidget: (context,
                          url, error) =>
                      new Image.asset(AppImages.defaultAvatarIcon),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${allPlayerList.name!.length>14 ? allPlayerList.name!.substring(0,13)+".." : allPlayerList.name! }",style: TextStyle( fontFamily: "Roboto",fontWeight: FontWeight.bold,fontSize: 12),)   ,
                      Text("${allPlayerList.name!}",style: TextStyle( fontFamily: "Roboto",fontWeight: FontWeight.w400,fontSize: 10),)   ,
                    ],
                  )
                ],
              ),
              Container(height: 40,width: 1,color: Colors.grey,padding: EdgeInsets.zero,),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("${allPlayerList.name!.length>14 ? allPlayerList.name!.substring(0,13)+".." : allPlayerList.name! }",style: TextStyle( fontFamily: "Roboto",fontWeight: FontWeight.bold,fontSize: 12),)   ,
                        Text("${allPlayerList.role}",style: TextStyle( fontFamily: "Roboto",fontWeight: FontWeight.w400,fontSize: 10),)   ,

                      ],
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      child: CachedNetworkImage(
                        imageUrl: allPlayerList.name!,
                        placeholder: (context,
                            url) =>
                        new Image.asset(AppImages.defaultAvatarIcon),
                        errorWidget: (context,
                            url, error) =>
                        new Image.asset(AppImages.defaultAvatarIcon),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(color: Colors.grey,)
      ],
    );
  }
*/

  lineUppLayerList(List<Player> isPlayingPlayers2) {
    return Flexible(
      child: ListView.builder(
          padding: EdgeInsets.only(right: 10),
          itemCount: isPlayingPlayers2.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${isPlayingPlayers2[index].name!.length > 14 ? isPlayingPlayers2[index].name!.substring(0, 13) + ".." : isPlayingPlayers2[index].name!}",
                          style: TextStyle(
                              // fontFamily: "Roboto",
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                        Text(
                          "${isPlayingPlayers2[index].role}",
                          style: TextStyle(
                              //  fontFamily: "Roboto",
                              fontWeight: FontWeight.w400,
                              fontSize: 10),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      height: 40,
                      width: 40,
                      child: CachedNetworkImage(
                        imageUrl: isPlayingPlayers2[index].image!,
                        placeholder: (context, url) =>
                            new Image.asset(AppImages.defaultAvatarIcon),
                        errorWidget: (context, url, error) =>
                            new Image.asset(AppImages.defaultAvatarIcon),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                  height: 5,
                )
              ],
            );
          }),
    );
  }

  lineUppLayer1List(
    List<Player> isPlayingPlayers1,
  ) {
    return Flexible(
      child: ListView.builder(
          padding: EdgeInsets.only(
            left: 10,
          ),
          itemCount: isPlayingPlayers1.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      child: CachedNetworkImage(
                        imageUrl: isPlayingPlayers1[index].image!,
                        placeholder: (context, url) =>
                            Image.asset(AppImages.defaultAvatarIcon),
                        errorWidget: (context, url, error) =>
                            Image.asset(AppImages.defaultAvatarIcon),
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${isPlayingPlayers1[index].name!.length > 14 ? isPlayingPlayers1[index].name!.substring(0, 13) + ".." : isPlayingPlayers1[index].name!}",
                          style: TextStyle(
                              //  fontFamily: "Roboto",
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                        Text(
                          "${isPlayingPlayers1[index].role!}",
                          style: TextStyle(
                              // fontFamily: "Roboto",
                              fontWeight: FontWeight.w400,
                              fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                  height: 5,
                )
              ],
            );
          }),
    );

    /*return Expanded(
      child: ListView.builder(
          itemCount: isPlayingPlayers2.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context , int index){
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("${isPlayingPlayers2[index].name!.length>14 ? isPlayingPlayers2[index].name!.substring(0,13)+".." : isPlayingPlayers2[index].name! }",style: TextStyle( fontFamily: "Roboto",fontWeight: FontWeight.bold,fontSize: 12),)   ,
                    Text("${isPlayingPlayers2[index].role}",style: TextStyle( fontFamily: "Roboto",fontWeight: FontWeight.w400,fontSize: 10),)   ,

                  ],
                ),
                Container(
                  height: 40,
                  width: 40,
                  child: CachedNetworkImage(
                    imageUrl: isPlayingPlayers2[index].name!,
                    placeholder: (context,
                        url) =>
                    new Image.asset(AppImages.defaultAvatarIcon),
                    errorWidget: (context,
                        url, error) =>
                    new Image.asset(AppImages.defaultAvatarIcon),
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            );
          }),
    );*/
  }
}
