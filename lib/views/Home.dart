// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';
import 'package:app_installer/app_installer.dart';
import 'package:app_links/app_links.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:myrex11/repository/model/team_preview_point_response.dart';
import 'package:myrex11/repository/model/team_response.dart';
import 'package:myrex11/views/TeamPreview.dart';
import 'package:myrex11/views/newUI/registerNew.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myrex11/GetXController/HomeMatchesGetController.dart';
import 'package:myrex11/GetXController/UpcomingMyMatchesGetController.dart';
import 'package:myrex11/adapter/MatchItemAdapter.dart';
import 'package:myrex11/adapter/ShimmerMatchItemAdapter.dart';
import 'package:myrex11/adapter/UserMyMatchesItemAdapter.dart';
import 'package:myrex11/appUtilities/CustomTabIndicator.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/app_navigator.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/customWidgets/VisionCustomTimerController.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/banner_response.dart';
import 'package:myrex11/repository/model/base_request.dart';
import 'package:myrex11/repository/model/finish_matchlist_response.dart';
import 'package:myrex11/repository/model/live_data_response.dart';
import 'package:myrex11/repository/model/matchlist_response.dart';
import 'package:myrex11/repository/model/my_balance_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';
import 'package:myrex11/views/More.dart';
import 'package:myrex11/views/MyMatches.dart';
import 'package:myrex11/views/UpcomingContests.dart';
import 'package:myrex11/views/Wallet.dart';
import 'package:myrex11/views/account/Account.dart';
import 'package:myrex11/views/newUI/drawer.dart';

class HomePage extends StatefulWidget {
  int? index;
  bool? isDynamicT;
  String? screenCheck;

  HomePage({this.index, this.isDynamicT, this.screenCheck});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> with TickerProviderStateMixin {
  final homeMatchesGetController = Get.put(HomeMatchesGetController());
  late List<MatchDetails> userMatchList = [];
  late List<MatchDetails> matchList = [];

  late List<BannerListItem> bannerList = [];
  int? isSeriesShow = 0;
  late List<SportType> sportsList = [];
  late List<LeaderBoardSport> sport_leaderboard = [];
  double radiusX = 0;
  double radiusY = 0;
  late List<Slide> seriesSlide = [];
  late MatchListResponse matchListResponsee = MatchListResponse();
  late FinishMatchListResponse finishMatchListResponse =
      FinishMatchListResponse();
  LevelDataResponse levelDataResponse = LevelDataResponse();
  late TabController controller;
  int _currentSportIndex = 0;
  int _currentIndex = 0;
  int bannersliderIndex = 0;
  int myMatchListIndex = 0;
  int _currentMatchIndex = 0;
  var title = 'Home';
  bool back_dialog = false;
  int backSwipe = 0;
  bool logout_dialog = false;
  bool isDownloading = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;
  bool isMatchLoading = false;
  bool isMyMatchLoading = false;
  bool isAccountLoading = false;
  int notification = 0;
  int onlineVersion = 0;
  late String userId = '0';
  late String balance = '0';
  late String level = '0';
  String userName = '';
  String mobile = '';
  String email = '';
  String teamName = '';
  String userPic = '';
  BannerListResponse bannerListResponse = BannerListResponse();
  String userReferCode = '';
  String fullPath = '';

  // String progress = '0';
  bool firstTimeAppOpen = false;
  late int previousTime;
  bool accountVerified = false;
  late Object addressDocType;

  double _fabBottom = 200;
  double _fabRight = 16.0;
  String check = 'home';
  static String myrefer = '';
  ScrollController buttonsController = ScrollController();
  final upcomingMyMatchesGetController =
      Get.put(UpcomingMyMatchesGetController());
  ValueNotifier<String> progress = ValueNotifier('0');

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  final List<VisionCustomTimerController> _controller = [];
  var dio = Dio.Dio();

  int? isLeaderBoardSelected;
  int forced_update = 0;
  int? show_update_popuop = 0;
  String version_message = '';
  final List<Map<String, dynamic>> usersMatches = [];
  int iosAppVersion = 0;
  ExternalPages external_pages = ExternalPages();
  late AppLinks _appLinks;
  @override
  void initState() {
    super.initState();
    initDeepLinks();
    _initPackageInfo();
    AppConstants.context = context;
    AppConstants.loderContext = context;
    AppConstants.notificationContext = context;
    AppPrefrence.getString(AppConstants.AUTHTOKEN).then((value) {
      print(value);
      AppConstants.token = value;
    });
    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
        .then((value) => {
              setState(() {
                userId = value;
                getBannerList();
                getUserBalance();
              })
            });
    getData(0);

    Timer.periodic(Duration(minutes: 1), (timer) {});
  }

  Future<void> initDeepLinks() async {
    // await _precacheNetworkImage(imageUrl??"");
    _appLinks = AppLinks();

    // Check initial link if app was in cold state (terminated)
    var appLink = await _appLinks.getInitialAppLink();

    if (appLink != null && appLink.pathSegments.isNotEmpty) {
      handleDeepLink(appLink);
    } else {
      // startTimeCount();
    }

    // Listen for deep links when the app is in background or minimized state
    _appLinks.uriLinkStream.listen((Uri? appLink) {
      if (appLink != null && appLink.pathSegments.isNotEmpty) {
        handleDeepLink(appLink);
      }
    }, onError: (err) {
      // Handle any errors that occur while listening to deep links
      print('Failed to receive deep link: $err');
    });
  }

  void handleDeepLink(Uri appLink) {
    print("userId" + userId.toString());
    if (appLink.pathSegments.isNotEmpty) {
      if (appLink.path.contains('contest')) {
        // getContestDetails(appLink.pathSegments.last);
      } else if (appLink.path.contains('teamshare')) {
        getTeamDetails(appLink.pathSegments.last);
      } else if (appLink.path.contains('refercode')) {
        var link = appLink.pathSegments.last;
        if (link != null) {
          // inviteReferLink(userId, link);
        }
      } else {
        // getMatchDetails(appLink.pathSegments.last);
      }
    }
  }

  Future<void> getTeamDetails(String teamId) async {
    final client = ApiClient(AppRepository.dio);
    TeamPointPreviewResponse response = await client.getTeamDetailsByLink(
        GeneralRequest(
            user_id: await AppPrefrence.getString(
                AppConstants.SHARED_PREFERENCE_USER_ID),
            teamid: teamId));
    if (response.status == 1) {
      AppConstants.isTeamShare = true;
      print('Akshat0');

      MatchDetails? matchDetails =
          response.result!.match_details ?? MatchDetails();

      // GlobalTimerManager globalTimerManager = GlobalTimerManager();
      // final matchStartTime =
      //     DateFormat.getFormattedDateObj(matchDetails.time_start!);
      // final currentTime = DateTime.now();
      // final remainingMilliseconds = matchStartTime!.millisecondsSinceEpoch -
      //     currentTime.millisecondsSinceEpoch;
      // AppConstants.remainingTime = Duration(milliseconds: remainingMilliseconds);
      // AppConstants.lineup = matchDetails.lineup!;

      // sportsList = response.result!.sports_arr!;
      // AppConstants.sportsName = matchDetails.sport_key!;
      // if(matchDetails.secondinning==1){
      //   AppConstants.sportKey = matchDetails.sport_key!;
      // }else{
      //   AppConstants.sportKey = "2 Star";
      // }
      // globalTimerManager.startTimer(AppConstants.remainingTime);
      // TimerSocketManager().startListening((data) {
      //   print("Got socket data: $data");
      //   if (matchDetails.matchkey == data['matchkey']) {
      //     matchDetails.time_start = data['time'];
      //     final matchStartTime = DateFormat.getFormattedDateObj(matchDetails.time_start!);
      //     final currentTime = DateTime.now();
      //     final remainingMilliseconds = matchStartTime!.millisecondsSinceEpoch - currentTime.millisecondsSinceEpoch;
      //     AppConstants.remainingTime = Duration(milliseconds: remainingMilliseconds);
      //     // Stop iterating once the match is found
      //     globalTimerManager.reset();
      //     globalTimerManager.startTimer( AppConstants.remainingTime!);
      //   }
      // });
      GeneralModel model = GeneralModel(
        // matchFantasy: matchDetails.match_fantasy,
        // globalTimerManager: globalTimerManager,
        fantasyType: 0, // response.result!.fantasy_type
        result: response.result ?? TeamPointResponseItem(),

        isFromLive:
            matchDetails.match_status_key == AppConstants.KEY_LIVE_MATCH,

        isFromLiveFinish: matchDetails.match_status_key ==
                AppConstants.KEY_LIVE_MATCH ||
            matchDetails.match_status_key == AppConstants.KEY_FINISHED_MATCH,

        teamId: matchDetails.team_id ?? 0,
        teamCount: matchDetails.user_teams ?? 0,

        matchKey: matchDetails.matchkey,
        sportKey: matchDetails.sport_key,

        teamVs:
            '${matchDetails.team1display!} VS ${matchDetails.team2display!}',

        headerText: matchDetails.time_start,

        firstUrl: matchDetails.team1logo,
        secondUrl: matchDetails.team2logo,

        team1Name: matchDetails.team1name,
        team2Name: matchDetails.team2name,
        team1Logo: matchDetails.team1logo,
        team2Logo: matchDetails.team2logo,

        bannerImage: matchDetails.banner_image,
        seriesName: matchDetails.seriesname,
        toss: matchDetails.toss,

        battingFantasy: matchDetails.battingfantasy,
        bowlingFantasy: matchDetails.bowlingfantasy,
        liveFantasy: matchDetails.livefantasy,
        secondInningFantasy: matchDetails.secondinning,
        reverseFantasy: matchDetails.reversefantasy,

        fantasySlots: matchDetails.slotes,

        unlimited_credit_match: matchDetails.unlimited_credit_match,
        unlimited_credit_text: matchDetails.unlimited_credit_text,
      );

      List<Player>? nonplayinglist = [];
      model.selectedList = [];
      model.teamNumber = response.result!.teamnumber ?? 0;
      if (model.sportKey == AppConstants.TAG_CRICKET) {
        model.selectedWkList = response.result!.keeper ?? [];
        model.selectedBatLiSt = response.result!.batsman ?? [];
        model.selectedArList = response.result!.allrounder ?? [];
        model.selectedBowlList = response.result!.bowler ?? [];
      } else if (model.sportKey == AppConstants.TAG_FOOTBALL) {
        model.selectedWkList = response.result!.Goalkeeper;
        model.selectedBatLiSt = response.result!.Defender;
        model.selectedArList = response.result!.Midfielder;
        model.selectedBowlList = response.result!.Forward;
      }
      // else if (widget.model.sportKey == AppConstants.TAG_KhoKho) {
      //   widget.model.selectedWkList = response.result!.Defender;
      //   widget.model.selectedBatLiSt = response.result!.Attacker;
      //   widget.model.selectedArList = response.result!.allrounder!;
      //   // widget.model.selectedBowlList = response.result!.Forward!;
      // }

      else if (model.sportKey == AppConstants.TAG_BASKETBALL) {
        model.selectedWkList = response.result!.pgList;
        model.selectedBatLiSt = response.result!.sgList;
        model.selectedArList = response.result!.smallForwardList;
        model.selectedBowlList = response.result!.powerForwardList;
        model.selectedcList = response.result!.centreList;
      } else if (model.sportKey == AppConstants.TAG_BASEBALL) {
        model.selectedWkList = response.result!.Outfielder;
        model.selectedBatLiSt = response.result!.Infielder;
        model.selectedArList = response.result!.Pitcher;
        model.selectedBowlList = response.result!.Catcher;
      } else if (model.sportKey == AppConstants.TAG_HANDBALL) {
        model.selectedWkList = response.result!.Goalkeeper;
        model.selectedBatLiSt = response.result!.Defender;
        model.selectedArList = response.result!.Forward;
      } else if (model.sportKey == AppConstants.TAG_HOCKEY) {
        model.selectedWkList = response.result!.Goalkeeper;
        model.selectedBatLiSt = response.result!.Defender;
        model.selectedArList = response.result!.Midfielder;
        model.selectedBowlList = response.result!.Forward ?? [];
      } else {
        //kabbadi
        //DEF,ALL,RAIDERS

        model.selectedWkList = response.result!.Goalkeeper!;
        model.selectedBatLiSt = response.result!.Defender!;
        model.selectedArList = response.result!.Forward!;
      }

      if (model.sportKey == AppConstants.TAG_BASKETBALL) {
        for (int i = 0;
            i < (model.selectedcList == null ? 0 : model.selectedcList!.length);
            i++) {
          model.selectedList!.add(model.selectedcList![i]);
          if (model.selectedcList![i].is_playing == 0 &&
              model.selectedcList![i].is_substitute == 0) {
            nonplayinglist!.add(model.selectedcList![i]);
          }
        }
      }

      for (int i = 0;
          i < (model.selectedWkList == null ? 0 : model.selectedWkList!.length);
          i++) {
        model.selectedList!.add(model.selectedWkList![i]);
        if (model.selectedWkList![i].is_playing == 0 &&
            model.selectedWkList![i].is_substitute == 0) {
          nonplayinglist!.add(model.selectedWkList![i]);
        }
      }

      for (int i = 0;
          i <
              (model.selectedBatLiSt == null
                  ? 0
                  : model.selectedBatLiSt!.length);
          i++) {
        model.selectedList!.add(model.selectedBatLiSt![i]);
        if (model.selectedBatLiSt![i].is_playing == 0 &&
            model.selectedBatLiSt![i].is_substitute == 0) {
          nonplayinglist!.add(model.selectedBatLiSt![i]);
        }
      }

      for (int i = 0;
          i < (model.selectedArList == null ? 0 : model.selectedArList!.length);
          i++) {
        model.selectedList!.add(model.selectedArList![i]);
        if (model.selectedArList![i].is_playing == 0 &&
            model.selectedArList![i].is_substitute == 0) {
          nonplayinglist!.add(model.selectedArList![i]);
        }
      }

      for (int i = 0;
          i <
              (model.selectedBowlList == null
                  ? 0
                  : model.selectedBowlList!.length);
          i++) {
        model.selectedList!.add(model.selectedBowlList![i]);
        if (model.selectedBowlList![i].is_playing == 0 &&
            model.selectedBowlList![i].is_substitute == 0) {
          nonplayinglist!.add(model.selectedBowlList![i]);
        }
      }

      // Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => DeepLinkingPreview(model,response.result!.is_same_user,nonplayinglist)),
      //       );
      // model.isForLeaderBoard= true;
      // WidgetsBinding.instance!.addPostFrameCallback((_) {
      //   Navigator.push(
      //     NavigationService.navigatorKey.currentState?.context ?? context,
      //     MaterialPageRoute(builder: (context) => UpcomingContests(model)),
      //   );// executes after build
      // });

      // model.globalSportsList = sportsList;
      // int index = sportsList.indexWhere((_element) {
      //   return model.secondInningFantasy == 1
      //       ? _element.sport_key == "LIVE"
      //       : _element.sport_key == AppConstants.sportsName;
      // });
      // if ((model.isFromLive ?? false) || (model.isFromLiveFinish ?? false)) {
      // await navigateToHomePage(
      //   NavigationService.navigatorKey.currentState?.context ?? context,
      // );
      // } else {
      // await navigateToUpcomingContests(
      //     NavigationService.navigatorKey.currentState?.context ?? context,
      //     model);
      // }

      Future.delayed(Duration(milliseconds: 200), () {
        print('Akshat1');

        print('Akshat2');

        navigateToUpcomingContests(context, model, isTeamShare: true);
        print('Akshat3');

        Future.delayed(Duration(milliseconds: 200), () {
          Navigator.of(
            context,
          )
              .push(
            MaterialPageRoute(
              builder: (_) => TeamPreview(
                model,
                check: "Leaderboard",
                isTeamShare: true,
              ),
            ),
          )
              .then(
            (value) {
              AppConstants.onteamUpdate();
            },
          );
        });
      });

      // Navigate to UpcomingContest in the background
      // showModalBottomSheet(
      //   context: NavigationService.navigatorKey.currentState?.context ?? context,
      //   // backgroundColor: Colors.white,
      //   backgroundColor: Colors.black,
      //   shape: const RoundedRectangleBorder(
      //     borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      //   ),
      //   isScrollControlled: true,
      //   useSafeArea: true,
      //   builder: (BuildContext context) {
      //     return TeamPreview(model, nonplayinglist: nonplayinglist, check:"Leaderboard",isTeamShare: true,isSameUser: response.result!.is_same_user,);
      //   },
      // );
      // navig\ateToUpcomingContestDetails(
      //   NavigationService.navigatorKey.currentState?.context ?? context,
      //
      //
      //
      //   matchDetails.contest_details!,flag: "DEEPLINK",  myBalances: myBalances,)
      //     .then((value) => {});
    } else {
      if (response.message != null && response.message!.isNotEmpty) {
        Fluttertoast.showToast(msg: response.message ?? '');
      }

      // navigateToHomePage(
      //     NavigationService.navigatorKey.currentState?.context ?? context);
    }
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void getData(int runmatchlist) {
    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_NAME)
        .then((value) => {
              userName = value,
              AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_MOBILE)
                  .then((value) => {
                        mobile = value,
                        AppPrefrence.getString(
                                AppConstants.SHARED_PREFERENCE_USER_EMAIL)
                            .then((value) => {
                                  setState(() {
                                    email = value;
                                  })
                                })
                      })
            });

    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_TEAM_NAME)
        .then((value) => {
              setState(() {
                teamName = value;
              })
            });
    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_PIC)
        .then((value) => {
              setState(() {
                userPic = value;
              })
            });
    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_REFER_CODE)
        .then((value) => {
              setState(() {
                userReferCode = value;
              })
            });
    AppPrefrence.getPreviousDate(AppConstants.PREVIOUS_DATE).then((value) => {
          setState(() {
            previousTime = value;
          })
        });
    if (runmatchlist == 1) {}

    AppPrefrence.getInt(AppConstants.PREVIOUS_SPOTS_DATA, 0).then((value) => {
          setState(() {
            _currentSportIndex = value;
            controller.index = value;

            // previouscontroller = value as TabController;
          })
        });
    AppConstants.updateMysport = updateMySport;
  }

  void updateMySport(String sportKey) {
    final int value = sportsList.indexWhere(
      (sport) => sport.sport_key == sportKey,
    );

    if (value != -1) {
      _currentSportIndex = value;
      controller.index = value;

      getMatchList();
    }
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
      AppConstants.versionCode = _packageInfo.buildNumber;
    });
  }

  Future<void> _myMatchPullRefresh(int index) async {
    _currentMatchIndex = index;
    getMyUpcomingMatchList(index);
  }

  @override
  Widget build(BuildContext context) {
    // userMatchList.sort((a, b) => a['sort_key'].compareTo(b['sort_key']));
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        onTap: () {
          setState(() {
            AppConstants.showLeaderboardSpots = false;
          });
        },
        child: Stack(
          children: [
            Container(
              //color: primaryColor,
              child: Scaffold(
                drawer: CustomDrawer(),
                drawerScrimColor: Colors.black.withOpacity(0.5),
                drawerEdgeDragWidth: 60,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat,
                floatingActionButton: Padding(
                  padding: EdgeInsets.only(
                    bottom: 0, // space from bottom
                    right: 0, // space from right
                    top: Platform.isIOS ? 28 : 0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (AppConstants.show_telegram_support == '1' &&
                          _currentIndex == 0)
                        GestureDetector(
                          onTap: () {
                            _launchURL(AppConstants.telegram_url ?? '');
                          },
                          child: Container(
                            height: 65,
                            // width: 55,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Image.asset(AppImages.telegramHome),
                          ),
                        ),
                      if (AppConstants.show_whatsapp_support == '1' &&
                          _currentIndex == 0)
                        Padding(
                          padding: EdgeInsets.only(
                              top: AppConstants.show_telegram_support == '1'
                                  ? 5
                                  : 0),
                          child: GestureDetector(
                            onTap: () {
                              _launchURL(AppConstants.whatsapp_url ?? '');
                            },
                            child: Container(
                              height: 65,
                              // width: 55,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                // borderRadius: BorderRadius.circular(30),
                              ),
                              child: Image.asset(AppImages.whatsappHome),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  onTap: onTabTapped,
                  selectedLabelStyle:
                      TextStyle(fontSize: 11.8, fontFamily: 'Roboto'),
                  unselectedLabelStyle:
                      TextStyle(fontSize: 11.8, fontFamily: 'Roboto'),
                  currentIndex: _currentIndex,
                  selectedItemColor: primaryColor,
                  unselectedItemColor: Color(0xffA4A4A4),
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                      icon: Stack(
                        alignment: Alignment.topCenter,
                        clipBehavior: Clip.none,
                        // This allows positioning elements outside the stack bounds
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Container(
                                  height: 24,
                                  width: 24,
                                  child: Image(
                                    image: AssetImage(_currentIndex == 0
                                        ? AppImages.homeActiveIcon
                                        : AppImages.homeInActiveIcon),
                                    color: _currentIndex == 0
                                        ? null
                                        : Color(0xffA4A4A4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_currentIndex == 0)
                            Positioned(
                              top: -8,
                              // Adjust the top position to place it above the icon
                              child: Container(
                                height: 8,
                                width: 75,
                                child:
                                    Image.asset(AppImages.HomeBottomIndicator),
                              ),
                            ),
                        ],
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Stack(
                        alignment: Alignment.topCenter,
                        clipBehavior: Clip.none,
                        // This allows positioning elements outside the stack bounds
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Container(
                              height: 20,
                              width: 20,
                              child: Image(
                                image: AssetImage(
                                  _currentIndex == 1
                                      ? AppImages.matchActiveIcon
                                      : AppImages.matchInActiveIcon,
                                ),
                                color: _currentIndex == 1
                                    ? null
                                    : Color(0xffA4A4A4),
                              ),
                            ),
                          ),
                          if (_currentIndex == 1)
                            Positioned(
                              top: -8,
                              // Adjust the top position to place it above the icon
                              child: Container(
                                height: 8,
                                width: 75,
                                child:
                                    Image.asset(AppImages.HomeBottomIndicator),
                              ),
                            ),
                        ],
                      ),
                      label: 'My Contest',
                    ),
                    // BottomNavigationBarItem(
                    //   icon: new Container(),
                    //   label: '',
                    // ),
                    if (bannerListResponse.is_myaccount_enabled == 1)
                      BottomNavigationBarItem(
                        icon: Stack(
                          alignment: Alignment.topCenter,
                          clipBehavior: Clip.none,
                          // This allows positioning elements outside the stack bounds
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                height: 20,
                                width: 20,
                                child: Image(
                                  image: AssetImage(_currentIndex == 2
                                      ? AppImages.accountActiveIcon
                                      : AppImages.accountInActiveIcon),
                                  color: _currentIndex == 2
                                      ? null
                                      : Color(0xffA4A4A4),
                                ),
                              ),
                            ),
                            if (_currentIndex == 2)
                              Positioned(
                                top: -8,
                                // Adjust the top position to place it above the icon
                                child: Container(
                                  height: 8,
                                  width: 75,
                                  child: Image.asset(
                                      AppImages.HomeBottomIndicator),
                                ),
                              ),
                          ],
                        ),
                        label: 'Account',
                      ),

                    BottomNavigationBarItem(
                      icon: Stack(
                        alignment: Alignment.topCenter,
                        clipBehavior: Clip.none,
                        // This allows positioning elements outside the stack bounds
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Container(
                              height: 20,
                              width: 20,
                              child: Image(
                                image:
                                    bannerListResponse.is_myaccount_enabled == 0
                                        ? AssetImage(_currentIndex == 2
                                            ? AppImages.moreActiveIcon
                                            : AppImages.moreInActiveIcon)
                                        : AssetImage(_currentIndex == 3
                                            ? AppImages.moreActiveIcon
                                            : AppImages.moreInActiveIcon),
                                color: _currentIndex == 3
                                    ? null
                                    : Color(0xffA4A4A4),
                              ),
                            ),
                          ),
                          if ((bannerListResponse.is_myaccount_enabled == 0 &&
                                  _currentIndex == 2) ||
                              (bannerListResponse.is_myaccount_enabled == 1 &&
                                  _currentIndex == 3))
                            Positioned(
                              top: -8,
                              // Adjust the top position to place it above the icon
                              child: Container(
                                height: 8,
                                width: 75,
                                child:
                                    Image.asset(AppImages.HomeBottomIndicator),
                              ),
                            ),
                        ],
                      ),
                      label: 'More',
                    ),
                  ],
                ),
                appBar: _currentIndex == 2 || _currentIndex == 3
                    ? null
                    : PreferredSize(
                        child: Container(
                          decoration: BoxDecoration(
                              // image: DecorationImage(
                              //   image: AssetImage(_currentIndex == 1
                              //       ? AppImages.commanBgImage2
                              //       : AppImages
                              //           .commanBgImage), // Use NetworkImage for network images
                              //   fit: BoxFit
                              //       .cover, // Adjust this to control how the image is fitted
                              // ),
                              color: primaryColor
                              //  borderRadius: BorderRadius.circular(12), // Add border radius if needed
                              // border: Border.all(color: Colors.grey, width: 2), // Optional border
                              ),
                          // color: primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 31),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 55,
                                  child: new Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      _currentIndex == 0
                                          ? Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15),
                                                  child: Builder(
                                                    builder: (context) =>
                                                        GestureDetector(
                                                      onTap: () {
                                                        Scaffold.of(context)
                                                            .openDrawer();
                                                      },
                                                      child: Container(
                                                        // width: 100,
                                                        height: 35,
                                                        // margin: EdgeInsets.only(top: 35,),
                                                        child: new Image(
                                                          image: AssetImage(
                                                            AppImages.menu_icon,
                                                          ),
                                                          // fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15),
                                                  child: Container(
                                                    // width: 120,
                                                    height: 35,
                                                    // margin: EdgeInsets.only(top: 35,),
                                                    child: new Image(
                                                      image: AssetImage(
                                                        AppImages
                                                            .horizontalLogo,
                                                      ),
                                                      // fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : _currentIndex == 1
                                              ?
                                              /*   Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15),
                                                  child: Container(
                                                    // padding: EdgeInsets.only(top: 28, left: 10),
                                                    padding:
                                                        Platform.isAndroid
                                                            ? EdgeInsets.only(
                                                                top: 0,
                                                                left: 0)
                                                            : EdgeInsets.only(
                                                                left: 10),
                                                    child: Text(
                                                      'My Contest',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                )*/

                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15),
                                                  child: Container(
                                                    // width: 100,
                                                    height: 35,
                                                    // margin: EdgeInsets.only(top: 35,),
                                                    child: new Image(
                                                      image: AssetImage(
                                                        AppImages
                                                            .horizontalLogo,
                                                      ),
                                                      // fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                      bannerListResponse.is_myaccount_enabled ==
                                              1
                                          ? Row(
                                              children: [
                                                new GestureDetector(
                                                  behavior: HitTestBehavior
                                                      .translucent,
                                                  child: new Container(
                                                    margin: EdgeInsets.only(
                                                        right: 5, left: 5),
                                                    child: new Row(
                                                      children: [
                                                        // Text(
                                                        //   "₹$balance",
                                                        //   style: TextStyle(
                                                        //       color:
                                                        //           Colors.white,
                                                        //       fontWeight:
                                                        //           FontWeight
                                                        //               .normal,
                                                        //       fontFamily:
                                                        //           "Roboto",
                                                        //       fontSize: 15),
                                                        // ),
                                                        // Text("₹"+myBalanceResultItem.totalamount.toString(),style: TextStyle(color: Colors.white),),
                                                        new Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 5,
                                                                  right: 5),
                                                          height: 28,
                                                          width: 28,
                                                          child: Image(
                                                              image: AssetImage(
                                                                  AppImages
                                                                      .wallet_icon)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: () => {
                                                    setState(() {
                                                      AppConstants
                                                          .movetowallet = true;
                                                      hideSpotsIcon();
                                                    }),
                                                    Platform.isAndroid
                                                        ? Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => Wallet(
                                                                    getUserBalance:
                                                                        getUserBalance

                                                                    // multiple_contest: _dropDownValue ?? '1', joinSimilar: widget.contest.is_join_similar_contest
                                                                    ))).then(
                                                            (value) {
                                                            setState(() {
                                                              AppConstants
                                                                      .movetowallet =
                                                                  false;
                                                              getUserBalance();
                                                            });
                                                          })
                                                        : Navigator.push(
                                                            context,
                                                            CupertinoPageRoute(
                                                                builder: (context) => Wallet(
                                                                    getUserBalance:
                                                                        getUserBalance

                                                                    // multiple_contest: _dropDownValue ?? '1',
                                                                    // joinSimilar: widget.contest.is_join_similar_contest
                                                                    ))).then(
                                                            (value) {
                                                            setState(() {
                                                              AppConstants
                                                                      .movetowallet =
                                                                  false;
                                                              getUserBalance();
                                                            });
                                                          })
                                                  },
                                                ),
                                                new GestureDetector(
                                                  behavior: HitTestBehavior
                                                      .translucent,
                                                  child: new Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10, left: 0),
                                                    height: 28,
                                                    width: 28,
                                                    child: Image(
                                                        image: AssetImage(
                                                      AppImages
                                                          .notification_bell_icon,
                                                    )
                                                        //notification==0?AppImages.notificationImageURL:AppImages.notificationDotIcon),
                                                        ),
                                                  ),
                                                  onTap: () => {
                                                    hideSpotsIcon(),
                                                    navigateToUserNotifications(
                                                        context)
                                                  },
                                                )
                                              ],
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                !isLoading
                                    ? (_currentIndex == 0 ||
                                                _currentIndex == 1) &&
                                            sportsList.length > 1
                                        ? Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 62,
                                            child: IgnorePointer(
                                              ignoring: !isMatchLoading &&
                                                      !isMyMatchLoading
                                                  ? false
                                                  : true,
                                              child: TabBar(
                                                indicator: CustomTabIndicator(),
                                                labelPadding: EdgeInsets.zero,
                                                // indicatorWeight:
                                                //     .0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001,
                                                // indicatorSize:
                                                //     TabBarIndicatorSize.label,
                                                // indicatorColor:
                                                //     Color(0xfff5dede),
                                                controller: controller,
                                                onTap: (int index) {
                                                  hideSpotsIcon();
                                                  setState(() {
                                                    AppConstants.sportKey =
                                                        sportsList[index]
                                                            .sport_key
                                                            .toString();
                                                    _currentSportIndex = index;
                                                    AppPrefrence.putInt(
                                                        AppConstants
                                                            .PREVIOUS_SPOTS_DATA,
                                                        _currentSportIndex);
                                                  });

                                                  _currentIndex == 0
                                                      ? getMatchList()
                                                      : _currentMatchIndex < 2
                                                          ? getMyUpcomingMatchList(
                                                              _currentMatchIndex)
                                                          : getMyMatchFinishList(
                                                              _currentMatchIndex,
                                                            );
                                                },
                                                isScrollable: false,
                                                tabs: List.generate(
                                                  sportsList.length,
                                                  (index) => Tab(
                                                    iconMargin: EdgeInsets.only(
                                                        bottom: index ==
                                                                _currentSportIndex
                                                            ? 4
                                                            : 7),
                                                    icon: Container(
                                                      decoration: BoxDecoration(
                                                          // shape: BoxShape.circle,
                                                          // color: index ==
                                                          //         _currentSportIndex
                                                          //     ? Colors.white
                                                          //     : Color(0xffF1E7FF),
                                                          ),
                                                      height: index ==
                                                              _currentSportIndex
                                                          ? 35
                                                          : 28,
                                                      width: index ==
                                                              _currentSportIndex
                                                          ? 35
                                                          : 28,
                                                      child: Image(
                                                          // color: index ==
                                                          //     _currentSportIndex
                                                          //     ?Colors.grey: Colors.green,
                                                          image: AssetImage(index ==
                                                                  _currentSportIndex
                                                              ? sportsList[index]
                                                                          .sport_key ==
                                                                      'CRICKET'
                                                                  ? AppImages
                                                                      .cricActiveIcon
                                                                  : sportsList[index]
                                                                              .sport_key ==
                                                                          'FOOTBALL'
                                                                      ? AppImages
                                                                          .footActiveIcon
                                                                      : sportsList[index].sport_key ==
                                                                              'BASKETBALL'
                                                                          ? AppImages
                                                                              .baskActiveIcon
                                                                          : ''
                                                              : sportsList[index]
                                                                          .sport_key ==
                                                                      'CRICKET'
                                                                  ? AppImages
                                                                      .cricInActiveIcon
                                                                  : sportsList[index]
                                                                              .sport_key ==
                                                                          'FOOTBALL'
                                                                      ? AppImages
                                                                          .footInActiveIcon
                                                                      : sportsList[index].sport_key ==
                                                                              'BASKETBALL'
                                                                          ? AppImages
                                                                              .baskInActiveIcon
                                                                          : '')),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 3),
                                                      child: Text(
                                                        index ==
                                                                _currentSportIndex
                                                            ? sportsList[index]
                                                                .sport_name!
                                                                .toUpperCase()
                                                            : sportsList[index]
                                                                .sport_name!,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                AppConstants
                                                                    .textBold,
                                                            color: index ==
                                                                    _currentSportIndex
                                                                ? Colors.white
                                                                : Color(
                                                                    0XFFf0d1d3),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container()
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                        preferredSize: Size.fromHeight(
                            !isLoading && sportsList.length > 1 ? 114 : 60),
                      ),
                key: scaffoldKey,
                body: new Stack(
                  children: [
                    Scaffold(
                      body: !isLoading
                          ? _currentIndex == 0 || _currentIndex == 1
                              ? sportsList.length > 0
                                  ? Scaffold(
                                      backgroundColor: bgColor,
                                      body: _currentIndex == 0
                                          ? Stack(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      // image: DecorationImage(
                                                      //     image: AssetImage(
                                                      //         AppImages
                                                      //             .commanBackground),
                                                      //     fit: BoxFit.cover),
                                                      // color: secondaryColorBg

                                                      ),
                                                  child: new RefreshIndicator(
                                                    child:
                                                        new SingleChildScrollView(
                                                      physics:
                                                          AlwaysScrollableScrollPhysics(),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        child: new Column(
                                                          children: [
                                                            userMatchList
                                                                        .length >
                                                                    0
                                                                ? Stack(
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            136,
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius: BorderRadius.only(
                                                                              topRight: Radius.circular(14),
                                                                              topLeft: Radius.circular(14)),
                                                                          // gradient:
                                                                          //     LinearGradient(
                                                                          //   colors: [
                                                                          //     Color(0xfff5dede),
                                                                          //     Color(0xfff5dede),
                                                                          //     Color(0xffeeeeee)
                                                                          //   ],
                                                                          //   begin:
                                                                          //       Alignment.topCenter,
                                                                          //   end:
                                                                          //       Alignment.bottomCenter,
                                                                          //   // stops: [0, 0.2, 0.8, 1],
                                                                          // ),
                                                                        ),
                                                                        // child: Image(
                                                                        //     image:
                                                                        //         AssetImage(AppImages.bgMyMatchesIcon,),f),
                                                                      ),
                                                                      Column(
                                                                        children: [
                                                                          Container(
                                                                            // height: 25,
                                                                            child:
                                                                                Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Container(
                                                                                  margin: EdgeInsets.only(left: 15, top: 10),
                                                                                  child: Text(
                                                                                    'My Matches',
                                                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15),
                                                                                  ),
                                                                                ),
                                                                                GestureDetector(
                                                                                  behavior: HitTestBehavior.translucent,
                                                                                  child: Container(
                                                                                    margin: EdgeInsets.only(top: 0, right: 15),
                                                                                    alignment: Alignment.center,
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Container(
                                                                                          child: Text('View All', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12)),
                                                                                        ),
                                                                                        Container(
                                                                                          margin: EdgeInsets.only(left: 5, right: 0),
                                                                                          height: 10,
                                                                                          width: 10,
                                                                                          child: Image(
                                                                                            image: AssetImage(AppImages.moreForwardIcon),
                                                                                            color: Colors.black,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  onTap: () {
                                                                                    onTabTapped(1);
                                                                                    hideSpotsIcon();
                                                                                  },
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          userMatchList.length > 0 && !isMatchLoading
                                                                              ? Container(
                                                                                  width: MediaQuery.of(context).size.width,
                                                                                  height: 142,
                                                                                  child: PageView.builder(
                                                                                    onPageChanged: (index) {
                                                                                      setState(() {
                                                                                        myMatchListIndex = index;
                                                                                      });
                                                                                    },
                                                                                    itemCount: userMatchList.length,
                                                                                    controller: PageController(
                                                                                      initialPage: 0,
                                                                                    ),
                                                                                    itemBuilder: (BuildContext context, int itemIndex) {
                                                                                      return UserMyMatchesItemAdapter(
                                                                                        userMatchList[itemIndex],
                                                                                        _pullRefresh,
                                                                                        getBannerList,
                                                                                        sportsList[_currentSportIndex].sport_key,
                                                                                        check: check,
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                )
                                                                              : Padding(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                                                                  child: Container(
                                                                                    // margin: EdgeInsets.all(8),
                                                                                    child: ListView.builder(
                                                                                        physics: NeverScrollableScrollPhysics(),
                                                                                        shrinkWrap: true,
                                                                                        scrollDirection: Axis.vertical,
                                                                                        itemCount: 1,
                                                                                        itemBuilder: (BuildContext context, int index) {
                                                                                          return new ShimmerMatchItemAdapter();
                                                                                        }),
                                                                                  ),
                                                                                ),
                                                                          if (userMatchList.length > 1 &&
                                                                              !isMatchLoading)
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 10),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: List.generate(userMatchList.length, (index) {
                                                                                  return AnimatedContainer(
                                                                                    duration: Duration(milliseconds: 300),
                                                                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                                                                    height: 6,
                                                                                    width: myMatchListIndex == index ? 12 : 6,
                                                                                    decoration: BoxDecoration(
                                                                                      color: myMatchListIndex == index ? primaryColor : Colors.grey,
                                                                                      borderRadius: BorderRadius.circular(4),
                                                                                    ),
                                                                                  );
                                                                                }),
                                                                              ),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Container(),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  getBannerWidget(),
                                                            ),
                                                            !isMatchLoading
                                                                ? matchList.length >
                                                                        0
                                                                    ? Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            margin: EdgeInsets.only(
                                                                                left: 15,
                                                                                top: 6,
                                                                                bottom: 6),
                                                                            child:
                                                                                Text(
                                                                              'Upcoming Matches',
                                                                              textAlign: TextAlign.start,
                                                                              style: TextStyle(color: Color(0xFF202b3d), fontWeight: FontWeight.w500, fontSize: 15),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(
                                                                              left: 12,
                                                                              right: 12,
                                                                            ),
                                                                            child:
                                                                                Container(
                                                                              color: Colors.transparent,
                                                                              // margin: EdgeInsets.all(8),
                                                                              child: GetBuilder<HomeMatchesGetController>(builder: (controller) {
                                                                                return ListView.builder(
                                                                                    padding: EdgeInsets.zero,
                                                                                    physics: NeverScrollableScrollPhysics(),
                                                                                    shrinkWrap: true,
                                                                                    scrollDirection: Axis.vertical,
                                                                                    itemCount: matchList.length,
                                                                                    itemBuilder: (BuildContext context, int index) {
                                                                                      controller.HomeMinuteTestTimingVariable.add('');
                                                                                      controller.HomeSecTestTimingVariable.add('');
                                                                                      _controller.add(VisionCustomTimerController());
                                                                                      return Visibility(
                                                                                        visible: _currentIndex == 0 ? ("${controller.HomeMinuteTestTimingVariable[index]}:${controller.HomeSecTestTimingVariable[index]}" == "00:-1" ? false : true) : true,
                                                                                        child: GestureDetector(
                                                                                          child: Padding(
                                                                                            padding: EdgeInsets.only(
                                                                                              bottom: (matchList.indexOf(matchList[index]) == matchList.length - 1) ? 12 : 0,
                                                                                            ),
                                                                                            child: new MatchItemAdapter(accountVerified, matchList, matchList[index], onMatchTimeUp, index, _controller[index], controller, getMatchList, _pullRefresh, getUserBalance, check: check, balanceUpdate: getUserBalance),
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                    });
                                                                              }),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                30),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            Container(
                                                                              padding: EdgeInsets.all(20),
                                                                              child: ConstrainedBox(
                                                                                constraints: BoxConstraints(
                                                                                  maxHeight: 280.0,
                                                                                  maxWidth: 300.0,
                                                                                ),
                                                                                child: Image(
                                                                                  image: AssetImage(sportsList[_currentSportIndex].sport_key == 'CRICKET'
                                                                                      ? AppImages.cricPlayerIcon
                                                                                      : sportsList[_currentSportIndex].sport_key == 'LIVE'
                                                                                          ? AppImages.cricPlayerIcon
                                                                                          : sportsList[_currentSportIndex].sport_key == 'FOOTBALL'
                                                                                              ? AppImages.footPlayerIcon
                                                                                              : sportsList[_currentSportIndex].sport_key == 'BASKETBALL'
                                                                                                  ? AppImages.baskPlayerIcon
                                                                                                  : ''),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              margin: EdgeInsets.only(top: 5),
                                                                              child: Text(
                                                                                'There are no upcoming matches as of now',
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(color: darkGrayColor, fontSize: 14, fontWeight: FontWeight.w400),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                : Container(
                                                                    margin: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            12,
                                                                        vertical:
                                                                            8),
                                                                    child: ListView.builder(
                                                                        physics: NeverScrollableScrollPhysics(),
                                                                        shrinkWrap: true,
                                                                        scrollDirection: Axis.vertical,
                                                                        itemCount: 7,
                                                                        itemBuilder: (BuildContext context, int index) {
                                                                          return ShimmerMatchItemAdapter();
                                                                        }),
                                                                  )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    onRefresh: _pullRefresh,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : MyMatches(
                                              pullRefresh: _myMatchPullRefresh,
                                              matchListResponse:
                                                  matchListResponsee,
                                              finishMatchListResponse:
                                                  finishMatchListResponse,
                                              isMyMatchLoading:
                                                  isMyMatchLoading,
                                              getMyMatchFinishList:
                                                  getMyMatchFinishList,
                                            ),
                                    )
                                  : Container()
                              : bannerListResponse.is_myaccount_enabled == 1 &&
                                      _currentIndex == 2
                                  ? !isAccountLoading
                                      // ? new AccountNNew(userId)
                                      ? Account()
                                      : Container()
                                  : bannerListResponse.is_myaccount_enabled ==
                                                  1 &&
                                              _currentIndex == 3 ||
                                          bannerListResponse
                                                      .is_myaccount_enabled ==
                                                  0 &&
                                              _currentIndex == 2
                                      ? More(
                                          _packageInfo,
                                          //logout_dialog,
                                        )
                                      : Container()
                          : Container(),
                    ),
                    back_dialog
                        ? Container(
                            color: Colors.transparent,
                            child: AlertDialog(
                              title: Text("Exit"),
                              content: Text("Do you want to Exit?"),
                              actions: [
                                cancelButton(context),
                                continueButton(context),
                              ],
                            ),
                          )
                        : Container(),
                    _currentIndex == 0 && logout_dialog
                        ? Container(
                            color: Colors.black38,
                            child: AlertDialog(
                              title: Text("Logout"),
                              content: Text("Do you want to logout?"),
                              actions: [
                                cancelLogButton(context),
                                continueLogButton(context),
                              ],
                            ),
                          )
                        : Container(),
                    isLoading ? AppLoaderProgress() : Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      AppConstants.showLeaderboardSpots = false;
    });
    if (index == 0 && _currentIndex != 0) {
      title = '';
      setState(() {
        check = 'home';
      });

      getData(0);
      getUserBalance();

      getMatchList();
      // getBannerList();
    } else if (index == 1 && _currentIndex != 1) {
      setState(() {
        check = '';
      });
      title = 'My Contest';
      getMyUpcomingMatchList(0);
    }
    /* else if (index == 2) {
      return;
    } */
    else if (index == 2 && _currentIndex != 2) {
      setState(() {
        check = '';
      });
      isLoading = false;
      title = 'Account';
      // getLevelData();
    } else if (index == 3 && _currentIndex != 3) {
      setState(() {
        check = '';
      });
      isLoading = false;
      title = 'More';
    }
    setState(() {
      _currentIndex = index;
    });
  }

  Widget cancelButton(context) {
    return ElevatedButton(
      child: Text("NO"),
      onPressed: () {
        setState(() {
          back_dialog = false;
        });
      },
    );
  }

  Widget continueButton(context) {
    return ElevatedButton(
      child: Text("YES"),
      onPressed: () {
        SystemNavigator.pop();
      },
    );
  }

  Widget cancelLogButton(context) {
    return ElevatedButton(
      child: Text("NO"),
      onPressed: () {
        setState(() {
          logout_dialog = false;
        });
      },
    );
  }

  Widget continueLogButton(context) {
    return ElevatedButton(
      child: Text("YES"),
      onPressed: () {
        AppPrefrence.clearPrefrence();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => new RegisterNew()),
            ModalRoute.withName("/main"));
      },
    );
  }

  Future<bool> _onWillPop() async {
    backSwipe++;
    if (backSwipe == 2) {
      SystemNavigator.pop();
    }
    return Future.value(false);
  }

  Widget getBannerWidget() {
    return bannerList.isNotEmpty
        ? Column(
            children: [
              Container(
                  // margin: EdgeInsets.only(top: 8),
                  child: CarouselSlider.builder(
                options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    setState(() {
                      bannersliderIndex = index;
                    });
                  },
                  height: 70,
                  viewportFraction: 1,
                  autoPlay: true,
                ),
                itemCount: bannerList.length,
                itemBuilder: (context, itemIndex, realIndex) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  color: bannerList[itemIndex].image == null
                                      ? primaryColor
                                      : null,
                                  child: CachedNetworkImage(
                                    imageUrl: bannerList[itemIndex].image!,
                                    height: 70,
                                    width: MediaQuery.of(context).size.width,
                                    placeholder: (context, url) => Container(
                                      child: Image.asset(
                                        AppImages.BannerPlaceholderURL,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    // placeholder: (context, url) => Center(
                                    //   child: CircularProgressIndicator(
                                    //     color: primaryColor,
                                    //   ),
                                    // ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      AppImages.BannerPlaceholderURL,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.fill,
                                    ),
                                    fit: BoxFit.fill,
                                  ),

                                  /* Image.network(
                              bannerList[itemIndex].image!,
                              fit: BoxFit.fill,
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                            ),*/
                                ),
                              ),
                              onTap: () {
                                hideSpotsIcon();
                                if (bannerList[itemIndex].type == 'addcash') {
                                  if (accountVerified == true) {
                                    navigateToAddBalance(context,
                                        bannerList[itemIndex].offer_code ?? '');
                                  } else {}
                                } else if (bannerList[itemIndex].type ==
                                    'match') {
                                  final matchingItems = matchList
                                      .where((element) =>
                                          bannerList[itemIndex].link ==
                                          element.matchkey)
                                      .toList();

                                  if (matchingItems.isNotEmpty) {
                                    // Use the first matching item
                                    final matchItem = matchingItems.first;

                                    Platform.isAndroid
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpcomingContests(
                                                        GeneralModel(
                                                      toss: matchItem.toss,
                                                      seriesName:
                                                          matchItem.seriesname,
                                                      bannerImage: matchItem
                                                          .banner_image,
                                                      matchKey:
                                                          matchItem.matchkey,
                                                      teamVs:
                                                          "${matchItem.team1display!} VS ${matchItem.team2display!}",
                                                      firstUrl:
                                                          matchItem.team1logo,
                                                      secondUrl:
                                                          matchItem.team2logo,
                                                      headerText:
                                                          matchItem.time_start,
                                                      sportKey:
                                                          matchItem.sport_key,
                                                      battingFantasy: matchItem
                                                          .battingfantasy,
                                                      bowlingFantasy: matchItem
                                                          .bowlingfantasy,
                                                      liveFantasy:
                                                          matchItem.livefantasy,
                                                      secondInningFantasy:
                                                          matchItem
                                                              .secondinning,
                                                      reverseFantasy: matchItem
                                                          .reversefantasy,
                                                      fantasySlots:
                                                          matchItem.slotes,
                                                      team1Name:
                                                          matchItem.team1name,
                                                      team2Name:
                                                          matchItem.team2name,
                                                      team1Logo:
                                                          matchItem.team1logo,
                                                      team2Logo:
                                                          matchItem.team2logo,
                                                      unlimited_credit_match:
                                                          matchItem
                                                              .unlimited_credit_match,
                                                      unlimited_credit_text:
                                                          matchItem
                                                              .unlimited_credit_text,
                                                    )))).then((value) {
                                            check = 'home';
                                            getUserBalance();
                                            print(check);
                                          })
                                        : Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    UpcomingContests(
                                                        GeneralModel(
                                                      toss: matchItem.toss,
                                                      seriesName:
                                                          matchItem.seriesname,
                                                      bannerImage: matchItem
                                                          .banner_image,
                                                      matchKey:
                                                          matchItem.matchkey,
                                                      teamVs:
                                                          "${matchItem.team1display!} VS ${matchItem.team2display!}",
                                                      firstUrl:
                                                          matchItem.team1logo,
                                                      secondUrl:
                                                          matchItem.team2logo,
                                                      headerText:
                                                          matchItem.time_start,
                                                      sportKey:
                                                          matchItem.sport_key,
                                                      battingFantasy: matchItem
                                                          .battingfantasy,
                                                      bowlingFantasy: matchItem
                                                          .bowlingfantasy,
                                                      liveFantasy:
                                                          matchItem.livefantasy,
                                                      secondInningFantasy:
                                                          matchItem
                                                              .secondinning,
                                                      reverseFantasy: matchItem
                                                          .reversefantasy,
                                                      fantasySlots:
                                                          matchItem.slotes,
                                                      team1Name:
                                                          matchItem.team1name,
                                                      team2Name:
                                                          matchItem.team2name,
                                                      team1Logo:
                                                          matchItem.team1logo,
                                                      team2Logo:
                                                          matchItem.team2logo,
                                                      unlimited_credit_match:
                                                          matchItem
                                                              .unlimited_credit_match,
                                                      unlimited_credit_text:
                                                          matchItem
                                                              .unlimited_credit_text,
                                                    )))).then((value) {
                                            getMatchList(showloading: true);
                                            getUserBalance();
                                            check = 'home';
                                            print(check);
                                          });
                                  } else {
                                    // If no match found, handle it appropriately
                                    print("No match found.");
                                  }
                                } else if (bannerList[itemIndex].type ==
                                    'tnc') {
                                  navigateToVisionWebView(
                                      context,
                                      'Terms & Conditions',
                                      AppConstants.terms_url);
                                } else if (bannerList[itemIndex].type ==
                                    "how_to_play") {
                                  navigateToVisionWebView(
                                      context,
                                      'How to Play',
                                      AppConstants.how_to_play_url);
                                } else if (bannerList[itemIndex].type ==
                                    "responsible") {
                                  navigateToVisionWebView(
                                      context,
                                      'Responsible play',
                                      AppConstants.respnsible_play);
                                } else if (bannerList[itemIndex].type ==
                                    "point") {
                                  navigateToVisionWebView(
                                      context,
                                      'Fantasy Point System',
                                      AppConstants.fantasy_point_url);
                                } else if (bannerList[itemIndex].type ==
                                    "Legality") {
                                  navigateToVisionWebView(context, 'Legality',
                                      AppConstants.legality_url);
                                } else if (bannerList[itemIndex].type ==
                                    'help') {
                                  navigateToContactUs(context);
                                } else if (bannerList[itemIndex].type ==
                                    'home') {
                                  // navigateToWithdrawCash(context, type: 'paytm_instant');
                                } else if (bannerList[itemIndex].type ==
                                    "refer_earn") {
                                  navigateToReferAndEarn(context);
                                } else {
                                  _launchURL(bannerList[itemIndex].link ?? '');
                                }
                              }));
                    },
                  );
                },
              )),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(bannerList.length, (index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      height: 6,
                      width: bannersliderIndex == index ? 12 : 6,
                      decoration: BoxDecoration(
                        color: bannersliderIndex == index
                            ? primaryColor
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),
            ],
          )
        : SizedBox.shrink();
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void hideSpotsIcon() {
    setState(() {
      AppConstants.showLeaderboardSpots = false;
    });
  }

  void getUserBalance() async {
    try {
      GeneralRequest loginRequest =
          GeneralRequest(user_id: userId, fcmToken: '');

      final client = ApiClient(AppRepository.dio);
      MyBalanceResponse myBalanceResponse =
          await client.getUserBalance(loginRequest);

      if (myBalanceResponse.status == 1 &&
          myBalanceResponse.result != null &&
          myBalanceResponse.result!.isNotEmpty) {
        MyBalanceResultItem myBalanceResultItem =
            myBalanceResponse.result!.first;

        AppPrefrence.putString(
          AppConstants.SHARED_PREFERENCES_SHOW_WEB_PAYEMNT,
          myBalanceResultItem.show_web_payment ?? '',
        );
        AppPrefrence.putString(
          AppConstants.KEY_SHOW_ADMIN_UPI,
          myBalanceResultItem.show_admin_upi ?? '',
        );
        AppPrefrence.putObjectList(
          AppConstants.KEY_ADMIN_UPI_LIST,
          myBalanceResultItem.admin_upi_list ?? [],
        );
        AppPrefrence.putString(
          AppConstants.KEY_SHOW_ADMIN_BANK,
          myBalanceResultItem.show_admin_bank ?? '',
        );
        AppPrefrence.putString(
          AppConstants.KEY_ADMIN_BANK_NAME,
          myBalanceResultItem.admin_bank_name ?? '',
        );
        AppPrefrence.putString(
          AppConstants.KEY_ADMIN_BANK_IFSC,
          myBalanceResultItem.admin_bank_ifsc ?? '',
        );
        AppPrefrence.putString(
          AppConstants.KEY_ADMIN_BANK_CUSTOMER_NAME,
          myBalanceResultItem.admin_bank_customer_name ?? '',
        );
        AppPrefrence.putString(
          AppConstants.KEY_ADMIN_BANK_ACCOUNT,
          myBalanceResultItem.admin_bank_account ?? '',
        );
        AppPrefrence.putString(
          AppConstants.KYC_VERIFIED,
          myBalanceResultItem.kyc_verified.toString(),
        );
        AppPrefrence.putString(
          AppConstants.KEY_USER_BALANCE,
          myBalanceResultItem.balance.toString(),
        );
        AppPrefrence.putString(
          AppConstants.signup_refer_statement,
          myBalanceResultItem.signup_refer_statement.toString(),
        );
        AppPrefrence.putString(
          AppConstants.refer_statement,
          myBalanceResultItem.refer_statement.toString(),
        );
        AppPrefrence.putString(
          AppConstants.Refer_code,
          myBalanceResultItem.Refer_code.toString(),
        );
        AppPrefrence.putString(
          AppConstants.Both_earn,
          myBalanceResultItem.Both_earn.toString(),
        );
        AppPrefrence.putString(
          AppConstants.lifetime_commission,
          myBalanceResultItem.lifetime_commission.toString(),
        );
        AppPrefrence.putString(
          AppConstants.Both_earn_stmt,
          myBalanceResultItem.Both_earn_stmt.toString(),
        );
        AppPrefrence.putString(
          AppConstants.lifetime_commission_stmt,
          myBalanceResultItem.lifetime_commission_stmt.toString(),
        );
        AppPrefrence.putString(
          AppConstants.is_lifetime_commission,
          myBalanceResultItem.is_lifetime_commission.toString(),
        );
        AppPrefrence.putString(
          AppConstants.KEY_USER_WINING_AMOUNT,
          myBalanceResultItem.winning.toString(),
        );
        AppPrefrence.putString(
          AppConstants.KEY_USER_BONUS_BALANCE,
          myBalanceResultItem.bonus.toString(),
        );
        AppPrefrence.putString(
          AppConstants.KEY_USER_TOTAL_BALANCE,
          myBalanceResultItem.total.toString(),
        );

        balance = myBalanceResultItem.total.toString();
        level = myBalanceResultItem.level.toString();
      }
    } catch (e, stackTrace) {
      debugPrint('getUserBalance error: $e');
      debugPrintStack(stackTrace: stackTrace);

      // Optional: show error to user
      // Fluttertoast.showToast(msg: 'Something went wrong');
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  void getBannerList() async {
    setState(() {
      isLoading = true;
      AppConstants.createTimeUp = false;
      AppConstants.candvcTimeUp = false;
      AppConstants.matchHeaderTimeUp = false;
    });
    GeneralRequest loginRequest = GeneralRequest(
      user_id: userId,
      fcmToken: '',
      is_skiped_update: AppConstants.is_skiped_update,
      is_skiped_popup: AppConstants.is_skiped_popup,
      is_playstore_build: AppConstants.Is_PlayStoreBuild,
      sport_key: sportsList.isEmpty
          ? 'CRICKET'
          : sportsList[_currentSportIndex].sport_key,
    );
    final client = ApiClient(AppRepository.dio);
    bannerListResponse = await client.getBannerList(loginRequest);
    if (bannerListResponse.status == 1) {
      bannerList = bannerListResponse.result!;
      sportsList = bannerListResponse.visible_sports!;
      seriesSlide = bannerListResponse.slide ?? [];
      notification = bannerListResponse.notification!;
      onlineVersion = bannerListResponse.version!;
      isSeriesShow = bannerListResponse.is_series_matches_slides;
      version_message = bannerListResponse.version_changes ?? '';
      forced_update = bannerListResponse.forced_update ?? 0;
      show_update_popuop = bannerListResponse.show_update_popuop ?? 0;
      iosAppVersion = bannerListResponse.version_android_ios ?? 0;

      external_pages = bannerListResponse.external_pages ?? external_pages;
      AppConstants.terms_url = external_pages.terms ?? "";
      AppConstants.fantasy_point_url = external_pages.fantasy_points ?? "";
      AppConstants.privacy_url = external_pages.privacy ?? "";
      AppConstants.about_us_url = external_pages.about_us ?? "";
      AppConstants.how_to_play_url = external_pages.how_to_play ?? "";
      AppConstants.legality_url = external_pages.legalities ?? "";
      AppConstants.respnsible_play = external_pages.responsible_play ?? "";
      AppConstants.fair_play = external_pages.fair_play ?? "";
      AppConstants.refund_policy = external_pages.refund_policy ?? "";
      // AppConstants.help_desk = external_pages.help_desk ?? "";

      AppConstants.whatsapp_url = bannerListResponse.whatsapp_url ?? "";
      AppConstants.telegram_url = bannerListResponse.telegram_url ?? "";
      AppConstants.show_whatsapp_support =
          bannerListResponse.show_whatsapp_support ?? "";
      AppConstants.show_telegram_support =
          bannerListResponse.show_telegram_support ?? "";

      AppConstants.cart_feature_enable =
          bannerListResponse.cart_feature_enable ?? '0';

      AppConstants.app_store_url = bannerListResponse.app_store_url ??
          'https://apps.apple.com/in/app/myrex11-fantasy-cricket/id6479639836';
      AppConstants.apk_refer_url = bannerListResponse.refer_url!;
      AppConstants.apk_url = bannerListResponse.app_download_url!;
      AppPrefrence.putInt(AppConstants.IS_VISIBLE_AFFILIATE,
          bannerListResponse.is_visible_affiliate!);
      AppPrefrence.putInt(AppConstants.IS_VISIBLE_PROMOTE,
          bannerListResponse.is_visible_promote);
      AppPrefrence.putInt(AppConstants.IS_ACCOUNT_WALLET_DISABLE,
          bannerListResponse.is_myaccount_enabled);

      AppPrefrence.putInt(AppConstants.TOTAL_REFERAL_COUNT,
          bannerListResponse.total_referal_all ?? 0);

      if (bannerListResponse.contact_us != null) {
        await AppPrefrence.putContactInfo(bannerListResponse.contact_us!);
      }

      AppPrefrence.putInt(AppConstants.IS_VISIBLE_PROMOTER_LEADERBOARD,
          bannerListResponse.is_visible_promoter_leaderboard);

      AppPrefrence.putString(
          AppConstants.SHOW_REFER_EARN, bannerListResponse.show_refer_earn);
      AppPrefrence.putString(
          AppConstants.SHOW_REFER_LIST, bannerListResponse.show_refer_list);

      AppPrefrence.putString(
          AppConstants.IS_VISIBLE_PHONEPE, bannerListResponse.show_phonepe);
      AppPrefrence.putString(
          AppConstants.IS_VISIBLE_NTTPAY, bannerListResponse.show_nttpay);
      AppPrefrence.putString(
          AppConstants.IS_VISIBLE_RAZORPAY, bannerListResponse.show_razorpay);

      AppPrefrence.putString(
          AppConstants.IS_VISIBLE_CASHFREE, bannerListResponse.cashfree);
      AppPrefrence.putInt(
          AppConstants.CASHFREE_MODE, bannerListResponse.cashfree_mode);

      AppConstants.banned_states = bannerListResponse.banned_state ?? [];
      AppPrefrence.putInt(AppConstants.IS_VISIBLE_ADDRESS,
          bannerListResponse.address_verify_show);

      AppPrefrence.putString(AppConstants.IS_VISIBLE_UPI,
          bannerListResponse.show_upi_verification);

      AppPrefrence.putString(AppConstants.IS_VISIBLE_PRIVATE_CONTEST,
          bannerListResponse.private_contest);

      AppPrefrence.putInt(
          AppConstants.IS_ADDRESS_VERIFIED, bannerListResponse.address_verify);

      // addressDocType = bannerListResponse.address_doc_type!;
      AppConstants.addressDocType = bannerListResponse.address_doc_type!;

      // print(addressDocType);
      AppPrefrence.putString(
          AppConstants.PHONE_PAY_TEXT, bannerListResponse.show_phonepe_text);
      AppPrefrence.putString(
          AppConstants.NTT_PAY_TEXT, bannerListResponse.show_nttpay_text);

      AppPrefrence.putString(
          AppConstants.CASH_FREE_TEXT, bannerListResponse.show_cashfree_text);

      AppPrefrence.putString(
          AppConstants.IS_WITHDRAW, bannerListResponse.is_withdraw);
      AppPrefrence.putString(
          AppConstants.IS_INST_WITHDRAW, bannerListResponse.is_inst_withdraw);
      AppPrefrence.putString(AppConstants.IS_PROMOTER_WITHDRAW,
          bannerListResponse.is_promotor_withdraw);
      AppPrefrence.putString(AppConstants.IS_PROMOTER_INST_WITHDRAW,
          bannerListResponse.is_promotor_inst_withdraw);

      AppPrefrence.putString(
          AppConstants.MIN_DEPOSITE, bannerListResponse.min_deposit);
      AppPrefrence.putString(
          AppConstants.MAX_DEPOSITE, bannerListResponse.max_deposit);
      AppPrefrence.putString(
          AppConstants.MIN_INST_WITHDRAW, bannerListResponse.min_inst_withdraw);
      AppPrefrence.putString(
          AppConstants.MAX_INST_WITHDRAW, bannerListResponse.max_inst_withdraw);
      AppPrefrence.putString(
          AppConstants.MIN_BANK_WITHDRAW, bannerListResponse.min_withdraw);
      AppPrefrence.putString(
          AppConstants.MAX_BANK_WITHDRAW, bannerListResponse.max_withdraw);

      AppPrefrence.putString(AppConstants.MIN_WINNING_TRANSFER,
          bannerListResponse.winning_to_transfer_min);
      AppPrefrence.putString(AppConstants.MAX_WINNING_TRANSFER,
          bannerListResponse.winning_to_transfer_max);

      AppPrefrence.putString(
          AppConstants.GST_PERCENT, bannerListResponse.gst_deduct.toString());
      AppPrefrence.putString(AppConstants.WINNING_PERCENT,
          bannerListResponse.winning_commission.toString());
      AppPrefrence.putString(
          AppConstants.REBATE_PERCENT, bannerListResponse.gst_rebat.toString());
      AppPrefrence.putInt(AppConstants.IS_VISIBLE_PROMOTER_REQUEST,
          bannerListResponse.is_visible_promoter_requested);
      AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_TEAM_NAME,
          bannerListResponse.team);
      AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_STATE_NAME,
          bannerListResponse.state);

      AppPrefrence.putInt(AppConstants.SHOW_AFF_WALLET,
          bannerListResponse.show_affiliate_wallet);

      AppPrefrence.putInt(
          AppConstants.MAX_TEAM_LIMIT, bannerListResponse.max_team_limit);

      AppPrefrence.putInt(AppConstants.SHOW_AFF_WALLET_WITHDRAW,
          bannerListResponse.show_affiliate_wallet_withdraw);

      AppPrefrence.putStringList(AppConstants.contestJoinCountList.toString(),
          bannerListResponse.similer_join_contest_list ?? []);

      AppConstants.contestJoinCountList =
          bannerListResponse.similer_join_contest_list ?? [];
      print(AppConstants.contestJoinCountList);
      AppPrefrence.putString(AppConstants.Max_Team_Add_Limit,
          bannerListResponse.max_team_add_limit.toString());
      controller = TabController(vsync: this, length: sportsList.length);
      // AppPrefrence.putStringList(AppConstants.sport_leaderboard.toString(),
      //     bannerListResponse.sport_leaderboard ?? []);

      sport_leaderboard = bannerListResponse.sport_leaderboard ?? [];
      radiusX = bannerListResponse.sport_radious!.radiusX ?? 0;
      radiusY = bannerListResponse.sport_radious!.radiusY ?? 0;

      AppPrefrence.getInt(AppConstants.PREVIOUS_SPOTS_DATA, 0).then((value) => {
            setState(() {
              _currentSportIndex = value;
              controller.index = value;

              // previouscontroller = value as TabController;
            })
          });
      AppConstants.invite_bonus =
          bannerListResponse.sign_up_bonus_amount ?? '0';
      if (bannerListResponse.mobile_verify == 1 &&
          AppConstants.Is_PlayStoreBuild == 0) {
        setState(() {
          accountVerified = true;
          AppPrefrence.putBoolean(AppConstants.USER_VERIFIED, accountVerified);
        });
      } else if (bannerListResponse.mobile_verify == 1 &&
          AppConstants.Is_PlayStoreBuild == 1 &&
          bannerListResponse.address_verify_show == 1 &&
          bannerListResponse.address_verify == 1) {
        setState(() {
          accountVerified = false;
          AppPrefrence.putBoolean(AppConstants.USER_VERIFIED, accountVerified);
        });
      }
      AppPrefrence.putBoolean(AppConstants.USER_VERIFIED, false);

      if (bannerListResponse.show_popup == 1 &&
          AppConstants.isTeamShare != true) {
        // if (isBannerShow(bannerListResponse.poup_time ?? 0) == 1) {
        _showPopImage(
          bannerListResponse.popup_image ?? '',
          bannerListResponse.popup_url ?? '',
          bannerListResponse.popup_type ?? '',
        );
        // }
      }

      // if (!BuildType.isForPlayStore) {
      if (Platform.isAndroid) {
        if (int.parse(AppConstants.versionCode) <
            bannerListResponse.version_code!) {
          if (show_update_popuop == 1) {
            if (await Permission.mediaLibrary.request().isGranted) {
              updateDialog(bannerListResponse.version_code!);
            }
          }
        }
      } else if (Platform.isIOS) {
        // print( bannerListResponse.version_android_ios);
        if (double.parse(_packageInfo.buildNumber) < iosAppVersion) {
          if (show_update_popuop == 1) {
            // updateBottomSheet(iosAppVersion);
            // _UpdateDialogIOS(iosAppVersion);
          }
        }
      }
      AppConstants.sportKey =
          sportsList[_currentSportIndex].sport_key.toString();

      getMatchList();
    }

    // Fluttertoast.showToast(msg: myBalanceResponse.message!, toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 1);
    setState(() {
      isLoading = false;
    });
  }

  int isBannerShow(int? poup_time) {
    if (previousTime != 0) {
      DateTime previous = DateTime.fromMillisecondsSinceEpoch(previousTime);
      if (MethodUtils.getDateTime().difference(previous).inHours > poup_time!) {
        AppPrefrence.putInt(AppConstants.PREVIOUS_DATE,
            MethodUtils.getDateTime().millisecondsSinceEpoch);
        return 1;
      }
      return 0;
    }
    AppPrefrence.putInt(AppConstants.PREVIOUS_DATE,
        MethodUtils.getDateTime().millisecondsSinceEpoch);
    return 1;
  }

  getMatchList({bool? showloading}) async {
    setState(() {
      if (showloading == true) {
        isMatchLoading = false;
        AppConstants.createTimeUp = false;
        AppConstants.candvcTimeUp = false;
        AppConstants.matchHeaderTimeUp = false;
      } else {
        isMatchLoading = true;
        AppConstants.createTimeUp = false;
        AppConstants.candvcTimeUp = false;
        AppConstants.matchHeaderTimeUp = false;
      }
    });

    homeMatchesGetController.HomeMinuteTestTimingVariable.clear();
    homeMatchesGetController.HomeSecTestTimingVariable.clear();
    if (sportsList.isNotEmpty) {
      GeneralRequest loginRequest = new GeneralRequest(
          user_id: userId, sport_key: sportsList[_currentSportIndex].sport_key);
      final client = ApiClient(AppRepository.dio);
      MatchListResponse matchListResponse =
          await client.getMatchList(loginRequest);

      matchListResponse = swapPinnedData(matchListResponse);

      if (matchListResponse.status == 1) {
        matchList = matchListResponse.result ?? [];

        userMatchList = matchListResponse.users_matches!;
        userMatchList.sort(
          (a, b) => a.time_start!.compareTo(b.time_start!),
        );

        userMatchList.sort((a, b) => a.sort_key!.compareTo(b.sort_key!));

        userMatchList.sort((a, b) {
          if (a.sort_key == 3 && b.sort_key == 3) {
            return 1; // b goes after
          } else {
            return a.sort_key!.compareTo(b.sort_key!); // Default comparison
          }
        });
      }

      setState(() {
        isLoading = false;
        isMatchLoading = false;
        myMatchListIndex = 0;
        AppConstants.fromHomeScreen = false;
      });
    }
  }

  Future<void> _pullRefresh() async {
    getMatchList();
  }

  void _showPopImage(
    String popup_image,
    String popup_url,
    String popup_type,
  ) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          bool _isImageLoaded = false;
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  // color: Colors.yellow,
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  5), // Optional: Rounded corners
                            ),
                            child: CachedNetworkImage(
                              fit: BoxFit.fill,
                              height: MediaQuery.of(context).size.height * 0.65,
                              imageUrl: popup_image ?? '',
                              placeholder: (context, url) => Center(
                                child: Image.asset(
                                  AppImages.popupPlaceholderURL,
                                  scale: 2, // Your placeholder asset
                                  // color: Colors.grey,
                                ), // Show loader while the image loads
                              ),
                              errorWidget: (context, url, error) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                    AppImages.popupPlaceholderURL,
                                    scale: 2 // Your placeholder asset
                                    // color: Colors.grey,
                                    ),
                              ),
                              imageBuilder: (context, imageProvider) {
                                // Once the image is loaded, update the state
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (!_isImageLoaded) {
                                    setState(() {
                                      _isImageLoaded = true;
                                    });
                                  }
                                });
                                return Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        onTap: () {
                          if (popup_type == 'addcash') {
                            Navigator.pop(context);
                            if (accountVerified == true) {
                              navigateToAddBalance(context, popup_url ?? '');
                            } else {
                              // navigateToVerifyAccountDetail(context);
                              // Fluttertoast.showToast(
                              //     msg: 'Please verify your account',
                              //     toastLength: Toast.LENGTH_SHORT,
                              //     timeInSecForIosWeb: 1);
                            }
                          } else if (popup_type == 'match') {
                            contestNavigation(popup_url);
                          } else if (popup_type == 'tnc') {
                            Navigator.pop(context);
                            navigateToVisionWebView(context,
                                'Terms & Conditions', AppConstants.terms_url);
                          } else if (popup_type == "how_to_play") {
                            Navigator.pop(context);
                            navigateToVisionWebView(context, 'How to Play',
                                AppConstants.how_to_play_url);
                          } else if (popup_type == "responsible") {
                            Navigator.pop(context);
                            navigateToVisionWebView(context, 'Responsible play',
                                AppConstants.respnsible_play);
                          } else if (popup_type == "point") {
                            Navigator.pop(context);
                            navigateToVisionWebView(
                                context,
                                'Fantasy Point System',
                                AppConstants.fantasy_point_url);
                          } else if (popup_type == "legality") {
                            Navigator.pop(context);
                            navigateToVisionWebView(
                                context, 'Legality', AppConstants.legality_url);
                          } else if (popup_type == 'help') {
                            Navigator.pop(context);
                            navigateToContactUs(context);
                          } else if (popup_type == 'home') {
                            Navigator.pop(context);
                            // navigateToWithdrawCash(context, type: 'paytm_instant');
                          } else if (popup_type == "refer_earn") {
                            Navigator.pop(context);
                            navigateToReferAndEarn(context);
                          } else {
                            // if (is_internal == 1) {
                            //   navigateToVisionWebView(
                            //       context, title ?? '', popup_url);
                            // } else {
                            Navigator.pop(context);
                            _launchURL(popup_url ?? '');
                            // }
                          }
                        },
                      ),

                      ////not

                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(color: primaryColor, width: 2),
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white),
                          child: Icon(
                            Icons.clear,
                            color: primaryColor,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).then((value) => {
          //  Navigator.pop(context);
        });
  }

  void getMyMatchFinishList(
    int index,
  ) async {
    _currentMatchIndex = index;
    setState(() {
      isMyMatchLoading = true;
    });

    GeneralRequest loginRequest = GeneralRequest(
        user_id: userId,
        sport_key: sportsList[_currentSportIndex].sport_key,
        page: "0");
    final client = ApiClient(AppRepository.dio);

    finishMatchListResponse = await client.getMyMatchFinishList(loginRequest);
    matchListResponsee.total_live_match =
        finishMatchListResponse.total_live_match;
    matchListResponsee.result = finishMatchListResponse.result!.data;
    setState(() {
      isMyMatchLoading = false;
    });
  }

  void getMyUpcomingMatchList(int index) async {
    _currentMatchIndex = index;
    setState(() {
      isMyMatchLoading = true;
    });

    upcomingMyMatchesGetController.SecTestTimingVariable.clear();
    upcomingMyMatchesGetController.MinuteTestTimingVariable.clear();
    GeneralRequest loginRequest = GeneralRequest(
        user_id: userId, sport_key: sportsList[_currentSportIndex].sport_key);
    final client = ApiClient(AppRepository.dio);
    MatchListResponse matchListResponse =
        await client.getMyMatchLiveList(loginRequest);
    matchListResponsee = transform(matchListResponse, index);
    // Fluttertoast.showToast(msg: myBalanceResponse.message!, toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 1);
    setState(() {
      isMyMatchLoading = false;
    });
  }

  MatchListResponse transform(MatchListResponse response, int index) {
    int liveMatchCount = 0;
    MatchListResponse matchListResponse = MatchListResponse();
    matchListResponse.status = response.status;
    matchListResponse.message = response.message;
    List<MatchDetails> matches = [];
    for (int i = 0; i < response.result!.length; i++) {
      if (index == 0
          ? response.result![i].match_status_key ==
              AppConstants.KEY_UPCOMING_MATCH
          : response.result![i].match_status_key ==
              AppConstants.KEY_LIVE_MATCH) {
        matches.add(response.result![i]);
      }
      if (response.result![i].match_status_key == AppConstants.KEY_LIVE_MATCH) {
        liveMatchCount++;
      }
    }
    matchListResponse.total_live_match = liveMatchCount;
    matchListResponse.result = matches;
    return matchListResponse;
  }

  void onMatchTimeUp() {
    setState(() {});
  }

  Future download2(Dio.Dio dio, String url, String savePath) async {
    try {
      Dio.Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Dio.Options(
            responseType: Dio.ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return (status ?? 0) < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      // File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(
    received,
    total,
  ) async {
    if (total != -1) {
      setState(() {
        progress.value = (received / total * 100).toStringAsFixed(0);
        if (double.parse(progress.value) >= 100) {
          isDownloading = false;
        }
      });
      if (!isDownloading) {
        if (await Permission.mediaLibrary.request().isGranted) {
          AppInstaller.installApk(fullPath);
        }
      }
    }
  }

  dynamic swapPinnedData(MatchListResponse matchListResponse) {
    int subListLength = 0;
    for (int i = 0; i < matchListResponse.result!.length; i++) {
      if (matchListResponse.result![i].is_fav_pin_contest == 1) {
        var tempData = matchListResponse.result![i];
        matchListResponse.result!.remove(matchListResponse.result![i]);
        matchListResponse.result!.insert(0, tempData);
        subListLength++;
      }
    }
    var subList = matchListResponse.result!.sublist(0, subListLength);
    subList.sort((a, b) => DateFormat('yyyy-MM-dd HH:mm:ss')
        .parse(a.time_start!)
        .compareTo(DateFormat('yyyy-MM-dd HH:mm:ss').parse(b.time_start!)));
    matchListResponse.result!.replaceRange(0, subListLength, subList);
    return matchListResponse;
  }

  Widget teamLogo(String? url) {
    return CachedNetworkImage(
      imageUrl: url ?? "",
      height: 45,
      width: 45,
      placeholder: (context, url) => Image.asset(AppImages.contestIcon),
      errorWidget: (context, url, error) => Image.asset(AppImages.contestIcon),
      fit: BoxFit.fill,
    );
  }

  Widget teamPlayerLogo(String? url) {
    return CachedNetworkImage(
      imageUrl: url ?? "",
      height: 95,
      width: 95,
      placeholder: (context, url) => Image.asset(AppImages.placeHoldervk),
      errorWidget: (context, url, error) =>
          Image.asset(AppImages.placeHoldervk),
      fit: BoxFit.fill,
    );
  }

  Widget timerContainer(String startDate) {
    return Positioned(
      child: Container(
        alignment: Alignment.center,
        child: Stack(
          children: [
            Image.asset(AppImages.series_center,
                height: 30, width: 105, fit: BoxFit.fill),
            Positioned(
              left: 26,
              top: 10,
              child: Text(
                "${timerApp(startDate)}",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget giveawayBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 34,
      decoration: BoxDecoration(
        color: Colors.red,
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Image.asset(AppImages.series_home_cup, height: 16),
          Text(
            "Giveaway".toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 10, color: Colors.white),
          ),
        ],
      ),
    );
  }

  timerApp(String? start_date) {
    DateTime startDate =
        DateTime.parse(start_date ?? DateTime.now().toString());
    DateTime currentDate = DateTime.now();
    Duration difference = startDate.difference(currentDate);
    int hours = difference.inHours;
    int minutes = difference.inMinutes % 60;
    int seconds = difference.inSeconds % 60;

    return '$hours H:$minutes M';
  }

  updateDialog(int versionCode) {
    return showDialog(
      context: context,
      barrierDismissible: false, // tap outside disabled
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return WillPopScope(
              onWillPop: () async => false, // back button disabled
              child: Dialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 15,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 15,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: Image.asset(
                            AppImages.updateImage,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'App update available',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: "Roboto",
                          ),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Html(
                                data: version_message,
                                style: {
                                  'html': Style(
                                    fontFamily: "Roboto",
                                    color: const Color(0xff4e4e4e),
                                    fontWeight: FontWeight.normal,
                                    fontSize: FontSize(12),
                                  ),
                                },
                              ),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 226, 234, 243),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'If you face any issue please download it from-',
                                      style: TextStyle(
                                        color: Color(0xff4e4e4e),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Platform.isAndroid
                                            ? _launchURL(AppConstants.apk_url)
                                            : _launchURL(
                                                AppConstants.app_store_url);
                                      },
                                      child: Text(
                                        Platform.isAndroid
                                            ? AppConstants.apk_url
                                            : AppConstants.app_store_url,
                                        style: const TextStyle(
                                          fontFamily: "Roboto",
                                          color: Color(0xff076e39),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: forced_update == 1
                                    ? MainAxisAlignment.center
                                    : MainAxisAlignment.spaceBetween,
                                children: [
                                  if (forced_update != 1)
                                    Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: const Color(0xff076e39),
                                        ),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          AppConstants.is_skiped_update = 1;
                                          Navigator.pop(context);
                                          getBannerList();
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 11),
                                          child: Center(
                                            child: Text(
                                              "Skip",
                                              style: TextStyle(
                                                fontFamily: "Roboto",
                                                color: Color(0xff076e39),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (forced_update != 1)
                                    const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () async {
                                      if (Platform.isAndroid) {
                                        setState(() {
                                          isDownloading = true;
                                        });

                                        var tempDir =
                                            await getTemporaryDirectory();
                                        fullPath =
                                            "${tempDir.path}/myrex11.apk";

                                        download2(
                                          dio,
                                          AppConstants.apk_url,
                                          fullPath,
                                        );

                                        Navigator.pop(context);
                                        downloadDialog();
                                      } else {
                                        _launchURL(AppConstants.app_store_url);
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                AppImages.Btngradient),
                                            fit: BoxFit.fill),
                                        border: Border.all(
                                          color: Color(0xFF6A0BF8),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 11,
                                      ),
                                      child: Text(
                                        'Update Now'.toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: "Roboto",
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (Platform.isIOS) const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  downloadDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false, // same as enableDrag: false + WillPopScope
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            insetPadding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                      top: 0,
                      bottom: 0,
                      left: 15,
                      right: 15,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: progress,
                        builder: (BuildContext context, String value,
                            Widget? child) {
                          final progressValue = double.parse(value) < 10
                              ? double.parse('.0$value')
                              : double.parse('.$value');

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 100,
                                width: double.infinity,
                                child: Image.asset(
                                  AppImages.updateImage,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                'Downloading file. Please wait...',
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 30),
                              LinearProgressIndicator(
                                value: progressValue,
                                backgroundColor: mediumGrayColor,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  primaryColor,
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$value%',
                                    style: TextStyle(
                                      fontFamily: "Roboto",
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '$value/100',
                                    style: TextStyle(
                                      fontFamily: "Roboto",
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Html(
                          data: version_message,
                          style: {
                            'html': Style(
                              fontFamily: "Roboto",
                              color: Color(0xff4e4e4e),
                              fontSize: FontSize(12),
                            ),
                          },
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 226, 234, 243),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'If you face any issue please download it from.',
                                style: TextStyle(
                                  color: Color(0xff4e4e4e),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _launchURL(AppConstants.apk_url);
                                },
                                child: Text(
                                  AppConstants.apk_url,
                                  style: TextStyle(
                                    color: Color(0xff076e39),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // downloadBottomSheet() {
  //   return showModalBottomSheet<void>(
  //     context: context,
  //     enableDrag: false,
  //     backgroundColor: Colors.white,
  //     isScrollControlled: true,
  //     // Allows the bottom sheet to expand based on content
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(20),
  //       ),
  //     ),
  //     builder: (BuildContext context) {
  //       return WillPopScope(
  //         onWillPop: () async {
  //           return false;
  //         },
  //         child: SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               Container(
  //                 // height: 200,
  //                 // height: MediaQuery.of(context).size.height,
  //                 width: MediaQuery.of(context).size.width,
  //                 // color: Colors.pink,
  //                 padding:
  //                     EdgeInsets.only(top: 20, bottom: 0, left: 15, right: 15),
  //                 alignment: Alignment.center,
  //                 child: Container(
  //                   // height: 110,
  //                   padding: EdgeInsets.all(15),
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(5),
  //                     color: Colors.white,
  //                   ),
  //                   child: ValueListenableBuilder(
  //                       valueListenable: progress,
  //                       builder: (BuildContext context, String value,
  //                           Widget? child) {
  //                         return Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             Container(
  //                               alignment: Alignment.centerLeft,
  //                               margin: EdgeInsets.only(bottom: 30),
  //                               child: Text(
  //                                 'Downloading file. Please wait...',
  //                                 style: TextStyle(
  //                                     fontFamily: "Roboto",
  //                                     color: Colors.black,
  //                                     fontWeight: FontWeight.w400,
  //                                     fontSize: 16),
  //                               ),
  //                             ),
  //                             LinearProgressIndicator(
  //                               value: double.parse(value) < 10
  //                                   ? double.parse('.0' + value)
  //                                   : double.parse('.' + value),
  //                               backgroundColor: mediumGrayColor,
  //                               valueColor: AlwaysStoppedAnimation<Color>(
  //                                 primaryColor,
  //                               ),
  //                             ),
  //                             Container(
  //                               margin: EdgeInsets.only(top: 5),
  //                               child: Row(
  //                                 mainAxisAlignment:
  //                                     MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   Container(
  //                                     child: Text(
  //                                       value + '%',
  //                                       style: TextStyle(
  //                                           fontFamily: "Roboto",
  //                                           color: Colors.black,
  //                                           fontWeight: FontWeight.w400,
  //                                           fontSize: 16),
  //                                     ),
  //                                   ),
  //                                   Container(
  //                                     child: Text(
  //                                       value + '/100',
  //                                       style: TextStyle(
  //                                           fontFamily: "Roboto",
  //                                           color: Colors.black,
  //                                           fontWeight: FontWeight.w400,
  //                                           fontSize: 16),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             )
  //                           ],
  //                         );
  //                       },
  //                       child: null),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(
  //                   right: 20,
  //                   left: 20,
  //                 ),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Container(
  //                       // alignment: Alignment.center,
  //                       // margin: EdgeInsets.only(top: 0),
  //                       child: Html(
  //                         data: version_message,
  //                         style: {
  //                           'html': Style(
  //                             fontFamily: "Roboto",
  //                             color: Color(0xff4e4e4e),
  //                             fontWeight: FontWeight.normal,
  //                             fontSize: FontSize(12),
  //                           ),
  //                         },
  //                       ),
  //                     ),
  //                     SizedBox(height: 10),
  //                     Container(
  //                       decoration: BoxDecoration(
  //                           color: Color(0xffE7F1EC),
  //                           borderRadius: BorderRadius.all(Radius.circular(5))),
  //                       child: Padding(
  //                         padding: const EdgeInsets.symmetric(horizontal: 7),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               'If you face any issue please download it from.',
  //                               style: TextStyle(
  //                                 color: Color(0xff4e4e4e),
  //                                 fontSize: 12,
  //                                 fontWeight: FontWeight.w500,
  //                               ),
  //                             ),
  //                             GestureDetector(
  //                               onTap: () {
  //                                 _launchURL(AppConstants.apk_url);
  //                               },
  //                               child: Text(
  //                                 AppConstants.apk_url,
  //                                 style: TextStyle(
  //                                   fontFamily: "Roboto",
  //                                   color: Color(0xff076e39),
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.w500,
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(height: 20),
  //                   ],
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void contestNavigation(String popup_url) {
    final matchingItems =
        matchList.where((element) => popup_url == element.matchkey).toList();

    if (matchingItems.isNotEmpty) {
      // Use the first matching item
      final matchItem = matchingItems.first;

      Platform.isAndroid
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UpcomingContests(GeneralModel(
                        toss: matchItem.toss,
                        seriesName: matchItem.seriesname,
                        bannerImage: matchItem.banner_image,
                        matchKey: matchItem.matchkey,
                        teamVs:
                            "${matchItem.team1display!} VS ${matchItem.team2display!}",
                        firstUrl: matchItem.team1logo,
                        secondUrl: matchItem.team2logo,
                        headerText: matchItem.time_start,
                        sportKey: matchItem.sport_key,
                        battingFantasy: matchItem.battingfantasy,
                        bowlingFantasy: matchItem.bowlingfantasy,
                        liveFantasy: matchItem.livefantasy,
                        secondInningFantasy: matchItem.secondinning,
                        reverseFantasy: matchItem.reversefantasy,
                        fantasySlots: matchItem.slotes,
                        team1Name: matchItem.team1name,
                        team2Name: matchItem.team2name,
                        team1Logo: matchItem.team1logo,
                        team2Logo: matchItem.team2logo,
                        unlimited_credit_match:
                            matchItem.unlimited_credit_match,
                        unlimited_credit_text: matchItem.unlimited_credit_text,
                      )))).then((value) {
              check = 'home';
              getUserBalance();
              print(check);
              Navigator.pop(context);
            })
          : Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => UpcomingContests(GeneralModel(
                        toss: matchItem.toss,
                        seriesName: matchItem.seriesname,
                        bannerImage: matchItem.banner_image,
                        matchKey: matchItem.matchkey,
                        teamVs:
                            "${matchItem.team1display!} VS ${matchItem.team2display!}",
                        firstUrl: matchItem.team1logo,
                        secondUrl: matchItem.team2logo,
                        headerText: matchItem.time_start,
                        sportKey: matchItem.sport_key,
                        battingFantasy: matchItem.battingfantasy,
                        bowlingFantasy: matchItem.bowlingfantasy,
                        liveFantasy: matchItem.livefantasy,
                        secondInningFantasy: matchItem.secondinning,
                        reverseFantasy: matchItem.reversefantasy,
                        fantasySlots: matchItem.slotes,
                        team1Name: matchItem.team1name,
                        team2Name: matchItem.team2name,
                        team1Logo: matchItem.team1logo,
                        team2Logo: matchItem.team2logo,
                        unlimited_credit_match:
                            matchItem.unlimited_credit_match,
                        unlimited_credit_text: matchItem.unlimited_credit_text,
                      )))).then((value) {
              getMatchList(showloading: true);
              getUserBalance();
              check = 'home';
              print(check);
              Navigator.pop(context);
            });
    } else {
      // If no match found, handle it appropriately
      print("No match found.");
    }
  }
}
