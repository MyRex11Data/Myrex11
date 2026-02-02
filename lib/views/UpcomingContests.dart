import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myrex11/adapter/ContestItemAdapter.dart';
import 'package:myrex11/adapter/ShimmerContestItemAdapter.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/app_navigator.dart';
import 'package:flutter/services.dart';
import 'package:myrex11/appUtilities/defaultbutton.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/buildType/buildType.dart';
import 'package:myrex11/customWidgets/CustomWidget.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/dataModels/JoinChallengeDataModel.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/banner_response.dart';
import 'package:myrex11/repository/model/category_contest_response.dart';
import 'package:myrex11/repository/model/contest_request.dart';
import 'package:myrex11/repository/model/contest_response.dart';
import 'package:myrex11/repository/model/score_card_response.dart';
import 'package:myrex11/repository/model/team_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';
import 'package:myrex11/views/CreateTeam.dart';
import 'package:myrex11/views/InviteContestCode.dart';
import 'package:myrex11/views/MyJoinedContests.dart';
import 'package:myrex11/views/MyTeams.dart';
import 'package:myrex11/views/NoMatchesListFound.dart';
import 'package:get/get.dart';
import 'package:myrex11/views/cart/contestcart.dart';
import 'package:need_resume/need_resume.dart';
import 'package:myrex11/views/PrivateContest.dart';
import 'package:myrex11/views/Wallet.dart';
import '../customWidgets/MatchHeader.dart';
import '../customWidgets/VisionCustomTimerController.dart';
import '../repository/model/invite_contest_response.dart';
import 'AllContests.dart';
import 'NoTeamsFound.dart';
import 'package:http/http.dart' as http;

class UpcomingContests extends StatefulWidget {
  GeneralModel model;
  MatchDetails? matchDetails;
  double? scrollPosition;
  String? sports_key;
  bool? isDynamicLink;
  Result? result;
  List? matchKeyID;
  bool? isTeamShare;
  UpcomingContests(this.model,
      {this.scrollPosition,
      this.sports_key,
      this.isDynamicLink,
      this.result,
      this.matchKeyID,
      this.isTeamShare});
  @override
  _UpcomingContestsState createState() => _UpcomingContestsState();
}

class _UpcomingContestsState extends ResumableState<UpcomingContests>
    with SingleTickerProviderStateMixin {
  VisionCustomTimerController controller = VisionCustomTimerController();
  int _currentSportIndex = 0;
  // int _currentIndexForClassic = 0;
  // int _currentIndexForFivePlusOne = 0;
  bool isExtend = true;
  var title = 'Home';
  String balance = '0';
  String userId = '0';
  String inningText = '';
  bool back_dialog = false;
  int _currentMatchIndex = 0;
  // int _currentContestMatchIndex = 0;
  int _currentIndex = 0;
  String indexOfSelectedContest = "0";
  int selectedFantasyType = 0;
  int selectedSlotId = 0;
  int teamCount = 0;
  int joinedContestCount = 0;
  int totalContest = 0;
  int teamId = 0;
  bool contestLoading = false;
  List<int> fantasyTypes = [];
  List<Widget> tabs = <Widget>[];
  List<Widget> inningTabs = <Widget>[];
  List<CategoriesItem> categoriesList = [];
  List<Contest> joinedContestList = [];
  List<Team> teamsList = [];
  List<Widget> contestTabs = <Widget>[];
  List<dynamic> maxMinList = [];

  int isAccountDisable = 0;

  ScrollController _scrollController = ScrollController();

  late TabController _tabController;
  final _pageViewController = PageController();

  late DateTime endTime;
  bool scrollValue = false;

  int Max_Team_Limit = 0;
  String showPrivateContest = '';

  Widget getClassicTab() {
    return new ClipRRect(
      borderRadius: BorderRadius.horizontal(
          left: Radius.circular(10),
          right: Radius.circular(_currentIndex == 1 ? 0 : 10)),
      child: new Container(
        height: 35,
        alignment: Alignment.center,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: _currentMatchIndex == 2 ? primaryColor : Colors.grey[200],
        ),
        child: Text(
          '7+4',
          style: TextStyle(
              fontFamily: "Roboto",
              color: _currentMatchIndex == 2 ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 14),
        ),
      ),
    );
  }

  List<Widget> getContestTabs() {
    if (widget.model.sportKey == 'CRICKET') {
      contestTabs.clear();
      fantasyTypes.clear();
      fantasyTypes.add(0);
      fantasyTypes.add(1);
      fantasyTypes.add(2);

      contestTabs.add(getClassicTab());
    }
    return contestTabs;
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);

    if (widget.isDynamicLink != null && widget.isDynamicLink!) {
      MethodUtils.checkBalance(
          0,
          JoinChallengeDataModel(
              Get.context!,
              0,
              int.parse(userId),
              widget.result!.contest![0].id!,
              int.parse(
                  widget.matchKeyID != null ? widget.matchKeyID!.last : "0"),
              // widget.model.slotId!,
              1,
              widget.result!.contest![0].is_bonus!,
              widget.result!.contest![0].win_amount!,
              widget.result!.contest![0].maximum_user!,
              widget.result!.user_team_id![0].toString(),
              widget.result!.contest![0].entryfee.toString(),
              widget.result!.users_matches![0].matchkey.toString(),
              widget.result!.sport_key.toString(),
              //widget.model.joinedSwitchTeamId.toString(),
              "1111",
              false,
              0,
              0,
              onJoinContestResult,
              widget.result!.contest![0] as Contest,
              bonusPercentage: widget.result!.contest![0].bonus_percent));
    }

    if (widget.sports_key != null) {
      widget.model.sportKey = widget.sports_key;
    }
    widget.model.fantasyType = 0;

    // TODO: implement initState
    super.initState();

    // if (!_scrollController.hasClients) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     _scrollController.jumpTo(widget.scrollPosition ?? 0.0);
    //     _scrollController.addListener(() {
    //       widget.scrollPosition = _scrollController.offset;
    //       setState(() {});
    //     });
    //   });
    // }

    AppPrefrence.getString(AppConstants.KEY_USER_BALANCE).then((value) => {
          setState(() {
            AppConstants.onteamUpdate = onTeamCreated;
            balance = value;
          })
        });

    AppPrefrence.getString(AppConstants.IS_VISIBLE_PRIVATE_CONTEST)
        .then((value) => {
              setState(() {
                showPrivateContest = value;
              })
            });

    AppPrefrence.getInt(AppConstants.IS_ACCOUNT_WALLET_DISABLE, 0)
        .then((value) => {
              setState(() {
                isAccountDisable = value;
              })
            });

    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
        .then((value) => {
              setState(() {
                userId = value;
                getContestByCategory();
              })
            });

    AppPrefrence.getInt(AppConstants.MAX_TEAM_LIMIT, 0).then((value) => {
          setState(() {
            Max_Team_Limit = value;
          })
        });
    startTimeCount();
    // if (widget.model.bannerImage != null &&
    //     widget.model.bannerImage!.isNotEmpty) {
    //   _showPopImage(widget.model.bannerImage);
    // }
    widget.model.fantasyType = 0;
    widget.model.slotId = 0;
    if (widget.model.liveFantasy == 1) {
      selectedFantasyType = 1;
      widget.model.fantasyType = selectedFantasyType;
      selectedSlotId = widget.model.fantasySlots![0].id!;
      widget.model.slotId = selectedSlotId;
      inningText = "'Live Fantasy - " +
          widget.model.fantasySlots![0].inning.toString() +
          "st  Inning " +
          widget.model.fantasySlots![0].min_over.toString() +
          "-" +
          widget.model.fantasySlots![0].max_over.toString() +
          " Overs' Contest";
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageViewController.dispose();
    super.dispose();
  }

  startTimeCount() async {
    var _duration = const Duration(seconds: 2);
    return Timer(_duration, navigateInside);
  }

  void navigateInside() => {
        setState(() {
          isExtend = false;
        })
      };

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            /* set Status bar color in Android devices. */
            statusBarIconBrightness: Brightness.light,
            /* set Status bar icons color in Android devices.*/
            statusBarBrightness:
                Brightness.light) /* set Status bar icon color in iOS. */
        );
    // TODO: implement build
    return SafeArea(
      top: false,
      child: Scaffold(
          body: WillPopScope(
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(75), // Set this height
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: primaryColor
                        // image: DecorationImage(
                        //   image: AssetImage("assets/images/ic_black.png"),
                        //   fit: BoxFit.cover,
                        // ),
                        ),
                    padding: EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex:
                              1, // Adjust flex values for proper space distribution
                          child: GestureDetector(
                            onTap: () {
                              Platform.isIOS ? Navigator.pop(context) : null;
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () => {
                                    if (widget.isTeamShare == true &&
                                        AppConstants.onContestScreen == true)
                                      {
                                        Navigator.popUntil(
                                            context,
                                            (route) =>
                                                route.settings.name == "home"),
                                        Navigator.pop(context)
                                      }
                                    else
                                      {Navigator.pop(context)},
                                    if (widget.model.isTeamShare == true)
                                      {
                                        AppConstants.updateMysport(
                                            widget.model.sportKey)
                                      }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: new Container(
                                      height: 30,
                                      child: Image(
                                        image:
                                            AssetImage(AppImages.backImageURL),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: MatchHeader(
                                    widget.model.teamVs!,
                                    widget.model.headerText!,
                                    widget.model.isFromLive ?? false,
                                    widget.model.isFromLiveFinish ?? false,
                                    teamColor: Colors.white,
                                    timerColor: Colors.white,
                                    screenType: "contest",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: GestureDetector(
                                    onTap: () => showBottomInviteSheet(context),
                                    child: Image.asset(
                                      AppImages.privateContestimg,
                                      height: 30,
                                      // width: 70,
                                    ),
                                  ),
                                ),
                                if (AppConstants.cart_feature_enable == '1')
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        getCartTeams();
                                      },
                                      child: Image.asset(
                                        AppImages.cartIcon,
                                        height: 30,
                                        // width: 70,
                                      ),
                                    ),
                                  ),
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    setState(
                                        () => AppConstants.movetowallet = true);
                                    final route = Platform.isAndroid
                                        ? MaterialPageRoute(
                                            builder: (_) => Wallet())
                                        : CupertinoPageRoute(
                                            builder: (_) => Wallet());
                                    Navigator.push(context, route).then(
                                      (_) => setState(() =>
                                          AppConstants.movetowallet = false),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Image.asset(
                                      AppImages.wallet_icon,
                                      height: 32,
                                      // width: 28,
                                    ),
                                  ),
                                ),
                              ],
                            )
                            // : Container(),
                            ),
                      ],
                    ),
                  ),
                ),
                body: Container(
                  color: Colors.white,
                  child: DefaultTabController(
                    initialIndex: 0,
                    length: contestTabs.length,
                    child: Column(
                      children: [
                        Expanded(child: contestBody())
                        // _currentContestMatchIndex == 0 ? Expanded(child: contestBody()) : Expanded(child: contestBody())
                      ],
                    ),
                  ),
                ),
              ),
              onWillPop: _onWillPop)),
    );
  }

  Future<Map<String, String>> getCartTeams() async {
    Map<String, String> teamsMap = {};

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${AppRepository.dio.options.baseUrl}api/auth/get-cart-teams',
        ),
      );

      request.headers['Authorization'] = AppConstants.token;
      request.headers['Devicetype'] = Platform.isIOS
          ? 'IOS'
          : Platform.isAndroid
              ? 'ANDROID'
              : 'WEB';
      request.headers['Versioncode'] = AppConstants.versionCode;
      request.headers['Accept'] = 'application/json';

      // 🔹 Request fields
      request.fields['user_id'] = userId;
      request.fields['matchkey'] = widget.model.matchKey ?? '';

      print('=== REQUEST DETAILS ===');
      print('URL: ${request.url}');
      print('Method: ${request.method}');
      print('Headers: ${request.headers}');
      print('Fields: ${request.fields}');
      print('=======================');

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      print('=== RESPONSE DETAILS ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: $jsonResponse');
      print('========================');

      if (jsonResponse['status'] == 1) {
        Map<String, dynamic> result =
            Map<String, dynamic>.from(jsonResponse['result']);

        // Convert dynamic map → String map
        result.forEach((key, value) {
          teamsMap[key] = value.toString();
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SelectionOfCartScreen(
                    widget.model,
                    teamsMap,
                    userId,
                    widget.model.matchKey ?? ''))).then((value) {
          onTeamCreated();

          if (Platform.isIOS) {
            AppConstants.callTimer();
          }
        });
      } else {
        MethodUtils.showError(
            context, jsonResponse['msg'] ?? 'Failed to fetch teams');
        // Fluttertoast.showToast(
        //   msg: jsonResponse['msg'] ?? 'Failed to fetch teams',
        // );
      }
    } catch (e) {
      print('Error fetching cart teams: $e');
      Fluttertoast.showToast(msg: 'Oops something went wrong...');
    }

    return teamsMap;
  }

  Widget contestBody() {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.zero,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1), // 👈 Divider line
                    ),
                  ),
                  child: DefaultTabController(
                    length: 3,
                    child: TabBar(
                      labelPadding: EdgeInsets.zero,
                      onTap: (int index) {
                        setState(() {
                          _currentIndex = index;

                          // Update the PageView based on the selected tab
                          _pageViewController.jumpToPage(index);

                          // Trigger actions based on selected tab
                          if (index == 0) {
                            getContestByCategory();
                          } else if (index == 1) {
                            getJoinedContests();
                          } else {
                            widget.model.contest = null;
                            getMyTeams();
                          }
                        });
                      },
                      controller: _tabController,
                      labelColor: primaryColor,
                      indicatorColor: primaryColor,
                      indicatorWeight: 3,
                      isScrollable: false,
                      tabs: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.horizontal(left: Radius.circular(5)),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              'Contests',
                              style: TextStyle(
                                fontFamily: "Roboto",
                                color: _currentIndex == 0
                                    ? primaryColor
                                    : Color(0xff747474),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'My Contests ($joinedContestCount)',
                            style: TextStyle(
                              fontFamily: "Roboto",
                              color: _currentIndex == 1
                                  ? primaryColor
                                  : Color(0xff747474),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(5)),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              'My Teams ($teamCount)',
                              style: TextStyle(
                                fontFamily: "Roboto",
                                color: _currentIndex == 2
                                    ? primaryColor
                                    : Color(0xff747474),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            preferredSize: Size.fromHeight(45),
          ),
          body: PageView(
            controller: _pageViewController,
            pageSnapping: contestLoading == false,
            physics: PageScrollPhysics(),
            children: <Widget>[
              contestView(),
              joinedContestView(),
              myTeamView(),
            ],
            onPageChanged: (index) {
              _tabController.animateTo(index);
              onTabTapped(index);
            },
          ),
        ),
        back_dialog
            ? AlertDialog(
                title: Text("Exit"),
                content: Text("Do you want to Exit?"),
                actions: [
                  cancelButton(context),
                  continueButton(context),
                ],
              )
            : Container(),
        _currentIndex == 0 && teamCount != Max_Team_Limit
            ? widget.model.fantasyType != 1
                ? Container(
                    alignment: Alignment.bottomCenter,
                    // padding: EdgeInsets.only(bottom: 10, right: 10),
                    child: GestureDetector(
                      onTap: () {
                        widget.model.onTeamCreated = onTeamCreated;
                        widget.model.teamId = teamId = 0;
                        Platform.isAndroid
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateTeam(
                                        widget.model,
                                        scrollPosition: widget
                                            .scrollPosition))).then((value) {
                                setState(() {
                                  onTeamCreated();
                                  if (Platform.isIOS) {
                                    AppConstants.callTimer();
                                  }
                                });
                              })
                            : Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => CreateTeam(
                                        widget.model,
                                        scrollPosition: widget
                                            .scrollPosition))).then((value) {
                                setState(() {
                                  onTeamCreated();
                                  if (Platform.isIOS) {
                                    AppConstants.callTimer();
                                  }
                                });
                              });
                        // navigateToCreateTeam(context, widget.model,
                        //     scrollPotion: widget.scrollPosition);
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.only(
                            left: 100, right: 100, top: 30, bottom: 20),
                        decoration: BoxDecoration(
                          color: buttonGreenColor,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          border: Border.all(
                            color: Color(0xFF6A0BF8),
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Center(
                            child: Text(
                              'CREATE TEAM',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontFamily: AppConstants.textBold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ))
                : categoriesList.isNotEmpty
                    ? Container(
                        alignment: Alignment.bottomCenter,
                        // padding: EdgeInsets.only(bottom: 10, right: 10),
                        child: GestureDetector(
                          onTap: () {
                            widget.model.onTeamCreated = onTeamCreated;
                            widget.model.teamId = teamId = 0;
                            navigateToCreateTeam(context, widget.model,
                                scrollPotion: widget.scrollPosition);
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 20),
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'Create Team',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppConstants.textBold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ))
                    : SizedBox.shrink()
            : SizedBox.shrink(),
      ],
    );
  }

  Widget contestView() {
    return RefreshIndicator(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Container(
                // color: Color(0xFFFF),
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            //TODO: all contest tap
                            openAllContests(0, '');
                          },
                          child: Text(
                            'All Contests (${totalContest.toString()})',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                // fontFamily: AppConstants.textBold,
                                fontSize: 14),
                          ),
                        ),
                        isAccountDisable == 1
                            ? new GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      height: 25,
                                      child:
                                          // Icon(Icons.filter_alt)
                                          Image(
                                        image: AssetImage(
                                          AppImages.filterIcon,
                                        ),
                                        // color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('Filters',
                                        style: TextStyle(
                                            // fontFamily: AppConstants.textBold,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  AppConstants.isFilter = true;
                                  //TODO: all filter tap click
                                  openAllContests(0, 'all_filters');
                                },
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              !contestLoading
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 0, right: 0, top: 12, bottom: 4),
                        child: Column(
                          children: [
                            for (var index = 0;
                                index < categoriesList.length;
                                index++) ...[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                      // image: DecorationImage(
                                      //   image: AssetImage(
                                      //       "assets/images/category_bg.png"),
                                      //   fit: BoxFit.cover,
                                      // ),
                                      ),
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 8, bottom: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 10),
                                        height: 40,
                                        width: 40,
                                        child: CachedNetworkImage(
                                          imageUrl: categoriesList[index]
                                                  .contest_image_url ??
                                              '',
                                          placeholder: (context, url) =>
                                              Image.asset(
                                                  AppImages.contestIcon),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  AppImages.contestIcon),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            categoriesList[index].name ?? '',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 0),
                                            child: Text(
                                              categoriesList[index]
                                                  .contest_sub_text!,
                                              style: TextStyle(
                                                  color: Color(0xFF747474),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                // controller: _scrollController,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,

                                itemCount:
                                    categoriesList[index].leagues!.length > 3
                                        ? 3
                                        : categoriesList[index].leagues!.length,
                                itemBuilder:
                                    (BuildContext context, int position) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: 8, right: 8, bottom: 8),
                                    child: ContestItemAdapter(
                                      _currentIndex,
                                      widget.model,
                                      categoriesList[index].leagues![position],
                                      onJoinContestResult,
                                      userId,
                                      getWinnerPriceCard,
                                      onTeamCreated,
                                      scrollPotion: widget.scrollPosition,
                                      onResume: onResume,
                                      screenCheck: 'detailsContest',
                                    ),
                                  );
                                },
                              ),
                              categoriesList[index].is_view_more == 1
                                  ? GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 5, bottom: 10, right: 5),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'View More',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontFamily: AppConstants
                                                            .textBold,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 15),
                                              height: 10,
                                              width: 10,
                                              child: Image.asset(
                                                  AppImages.moreForwardIcon),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () => {
                                        openAllContests(
                                            categoriesList[index].id!, '')
                                      },
                                    )
                                  : Container(),
                            ],
                          ],
                        ),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.all(8),
                      child: Column(
                        children: List.generate(
                          7,
                          (index) => new Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    left: 5, right: 10, top: 10, bottom: 10),
                                child: new Row(
                                  children: [
                                    new Container(
                                      margin: EdgeInsets.only(right: 10),
                                      height: 30,
                                      width: 30,
                                      child: CustomWidget.circular(
                                        height: 30,
                                        width: 30,
                                      ),
                                    ),
                                    new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomWidget.rectangular(
                                          height: 15,
                                          width: 50,
                                        ),
                                        CustomWidget.rectangular(
                                          height: 15,
                                          width: 100,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              new Container(
                                child: new ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: 2,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return new ShimmerContestItemAdapter();
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              new GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: new Container(
                  margin: EdgeInsets.only(left: 5, bottom: 50),
                  alignment: Alignment.center,
                  child: new Card(
                    elevation: .5,
                    child: new Container(
                      height: 30,
                      width: 150,
                      alignment: Alignment.center,
                      child: new Text(
                        'View All ' + totalContest.toString() + ' Contests',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppConstants.textBold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                onTap: () => {
                  //TODO: view all contest title tap
                  openAllContests(0, '')
                },
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        onRefresh: _pullRefresh);
  }

  Widget joinedContestView() {
    return RefreshIndicator(
        child: joinedContestList.length > 0 || contestLoading
            ? new MyJoinedContests(
                _currentIndex,
                widget.model,
                joinedContestList,
                contestLoading,
                onJoinContestResult,
                userId,
                getWinnerPriceCard,
                onTeamCreated)
            : new Container(
                child: new Column(
                  children: [
                    NoMatchesListFound(
                      sportKey: widget.model.sportKey!,
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            _tabController.index = 0;
                          });
                          _pageViewController.jumpToPage(0);

                          onTabTapped(0);
                        },
                        child: Container(
                            height: 50,
                            margin: EdgeInsets.only(
                                left: 80, right: 80, top: 30, bottom: 20),
                            decoration: BoxDecoration(
                              color: buttonGreenColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              border: Border.all(
                                color: Color(0xFF6A0BF8),
                                width: 2,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Center(
                                child: Text("Join A Contest".toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: AppConstants.textBold,
                                    )),
                              ),
                            )))
                  ],
                ),
              ),
        onRefresh: _pullRefresh2);
  }

  Widget myTeamView() {
    return RefreshIndicator(
        child: teamsList.length > 0
            ? MyTeams(widget.model, teamsList, onTeamCreated)
            : new Container(
                child: new Column(
                  children: [
                    NoTeamsFound(widget.model.sportKey!),
                    widget.model.fantasyType == 1 && categoriesList.isEmpty
                        ? SizedBox.shrink()
                        : GestureDetector(
                            onTap: () {
                              widget.model.onTeamCreated = onTeamCreated;
                              widget.model.teamId = teamId = 0;
                              navigateToCreateTeam(context, widget.model,
                                  onTeamCreated: onTeamCreated,
                                  scrollPotion: widget.scrollPosition);
                            },
                            child: Container(
                                height: 50,
                                margin: EdgeInsets.only(
                                    left: 80, right: 80, top: 30, bottom: 20),
                                decoration: BoxDecoration(
                                  color: buttonGreenColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  border: Border.all(
                                    color: Color(0xFF6A0BF8),
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Center(
                                    child: Text("CREATE A TEAM".toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: AppConstants.textBold,
                                        )),
                                  ),
                                )),
                          )

                    // DefaultButton(
                    //     width: 160,
                    //     height: 40,
                    //     margin: EdgeInsets.only(top: 30, left: 10),
                    //     text: 'CREATE A TEAM',
                    //     textcolor: Colors.white,
                    //     color: greenColor,
                    //     borderRadius: 30,
                    //     onpress: () {
                    //       widget.model.onTeamCreated = onTeamCreated;
                    //       widget.model.teamId = teamId = 0;
                    //       navigateToCreateTeam(context, widget.model,
                    //           onTeamCreated: onTeamCreated,
                    //           scrollPotion: widget.scrollPosition);
                    //     },
                    //   )
                  ],
                ),
              ),
        onRefresh: _pullRefresh3);
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      //  _currentIndexForClassic = index;
      if (_currentIndex == 0) {
        getContestByCategory();
      } else if (_currentIndex == 1) {
        getJoinedContests();
      } else {
        getMyTeams();
      }
    });
  }

  // void onTabTappedFivePlusOne(int index) {
  //   print(["index=====",index]);
  //   setState(() {
  //     _currentIndexForFivePlusOne = index;
  //     if (_currentIndexForFivePlusOne == 0) {
  //       getContestByCategory();
  //     } else if (_currentIndexForFivePlusOne == 1) {
  //       getJoinedContests();
  //     } else {
  //       getMyTeams();
  //     }
  //   });
  // }

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
        Navigator.pop(context);
      },
    );
  }

  Future<bool> _onWillPop() async {
    if (widget.isTeamShare == true && AppConstants.onContestScreen == true) {
      Navigator.popUntil(context, (route) => route.settings.name == "home");
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
    ;

    if (widget.model.isTeamShare == true) {
      AppConstants.updateMysport(widget.model.sportKey);
    }
    return Future.value(false);
  }

  List<Widget> getSlotTabs() {
    inningTabs.clear();
    for (int i = 0; i < widget.model.fantasySlots!.length; i++) {
      inningTabs.add(getInningsTab(widget.model.fantasySlots![i]));
    }
    return inningTabs;
  }

  List<Widget> getTabs() {
    tabs.clear();
    fantasyTypes.clear();
    tabs.add(getFullMatchTab());
    fantasyTypes.add(0);
    if (widget.model.battingFantasy == 1) {
      tabs.add(getBattingTab());
      fantasyTypes.add(2);
    }
    if (widget.model.bowlingFantasy == 1) {
      tabs.add(getBowlingTab());
      fantasyTypes.add(3);
    }
    if (widget.model.reverseFantasy == 1) {
      tabs.add(getReverseTab());
      fantasyTypes.add(5);
    }
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
    return count;
  }

  Widget getFullMatchTab() {
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
          'Full Match',
          style: TextStyle(
              fontFamily: "Roboto",
              color: _currentMatchIndex == 0 ? primaryColor : Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 14),
        ),
      ),
    );
  }

  Widget getInningsTab(Slots slots) {
    return new ClipRRect(
      borderRadius: BorderRadius.horizontal(left: Radius.circular(0)),
      child: new Container(
        height: 45,
        alignment: Alignment.center,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 2),
              child: Text(
                slots.inning.toString() + 'st inning',
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w400,
                    fontSize: 12),
              ),
            ),
            Text(
              slots.min_over.toString() +
                  '-' +
                  slots.max_over.toString() +
                  ' Overs',
              style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                  fontSize: 12),
            )
          ],
        ),
      ),
    );
  }

  Widget getBattingTab() {
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
          'Batting',
          style: TextStyle(
              fontFamily: "Roboto",
              color: _currentMatchIndex == 1 ? primaryColor : Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 14),
        ),
      ),
    );
  }

  Widget getBowlingTab() {
    return ClipRRect(
      borderRadius: BorderRadius.horizontal(left: Radius.circular(0)),
      child: Container(
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
              color: _currentMatchIndex == 2 ? primaryColor : Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 14),
        ),
      ),
    );
  }

  Widget getReverseTab() {
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
          'Reverse',
          style: TextStyle(
              fontFamily: "Roboto",
              color: _currentMatchIndex == 3 ? primaryColor : Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 14),
        ),
      ),
    );
  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        builder: (builder) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.add_circle_outline),
                title: Text('Create a Contest'),
                onTap: () {
                  Navigator.pop(context);
                  navigateToPrivateContest(_currentIndex, context, widget.model,
                      onTeamCreated, maxMinList, _currentIndex);
                },
              ),
              new Divider(
                height: 2,
                thickness: 1,
              ),
              ListTile(
                leading: Icon(Icons.confirmation_num_outlined),
                title: Text('Enter Contest Code'),
                onTap: () {
                  Navigator.pop(context);
                  widget.model.onJoinContestResult = onJoinContestResult;
                  navigateToInviteContestCode(
                      _currentIndex, context, widget.model);
                },
              ),
            ],
          );
        });
  }

  void _showPopImage(String? popup_image) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            alignment: Alignment.center,
            height: 450,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Card(
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          height: 450,
                          width: 300,
                          imageUrl: popup_image!,
                          placeholder: (context, url) => Image.asset(
                            AppImages.popupPlaceholderIcon,
                            fit: BoxFit.fill,
                          ),
                          errorWidget: (context, url, error) =>
                              Image.asset(AppImages.userAvatarIcon),
                        ),
                      )),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black),
                    child: Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<void> _pullRefresh() async {
    getContestByCategory();
  }

  Future<void> _pullRefresh2() async {
    getJoinedContests();
  }

  Future<void> _pullRefresh3() async {
    getMyTeams();
  }

  void getContestByCategory({int? dontshowLoading}) async {
    if (dontshowLoading != 1) {
      setState(() {
        contestLoading = true;
      });
    }

    ContestRequest contestRequest = new ContestRequest(
        user_id: userId,
        matchkey: widget.model.matchKey,
        sport_key: widget.model.sportKey,
        fantasy_type_id: CricketTypeFantasy.getCricketType(
            selectedFantasyType.toString(),
            sportsKey: widget.model
                .sportKey) /*selectedFantasyType==1?"7":selectedFantasyType==2?"6":"0"*/,
        fantasy_type: selectedFantasyType.toString(),
        slotes_id: selectedSlotId.toString());
    final client = ApiClient(AppRepository.dio);
    CategoryByContestResponse response =
        await client.getContestByCategory(contestRequest);
    if (response.status == 1) {
      maxMinList.add(response.result?.private_contest_size_text ?? "");
      maxMinList.add(response.result?.private_contest_winning_size_text ?? "");
      categoriesList = response.result!.categories!;

      totalContest = response.result!.total_contest!;
      widget.model.teamCount = teamCount = response.result!.user_teams!;
      joinedContestCount = response.result!.joined_leagues!;
      widget.model.teamId = teamId = response.result!.team_id!;
    }
    setState(() {
      contestLoading = false;
    });
  }

  void getJoinedContests({int? dontshowLoading}) async {
    if (dontshowLoading != 1) {
      setState(() {
        contestLoading = true;
      });
    }
    ContestRequest contestRequest = new ContestRequest(
        user_id: userId,
        matchkey: widget.model.matchKey,
        sport_key: widget.model.sportKey,
        fantasy_type: selectedFantasyType.toString(),
        fantasy_type_id: CricketTypeFantasy.getCricketType(
            selectedFantasyType.toString(),
            sportsKey: widget.model
                .sportKey) /*selectedFantasyType==1?"7":selectedFantasyType==2?"6":"0"*/,
        slotes_id: selectedSlotId.toString());
    final client = ApiClient(AppRepository.dio);
    ContestResponse response = await client.getJoinedContests(contestRequest);
    if (response.status == 1) {
      joinedContestList = response.result!.contest!;
      widget.model.teamCount = teamCount = response.result!.user_teams!;
      joinedContestCount = response.result!.joined_leagues!;
    }
    setState(() {
      contestLoading = false;
    });
  }

  void getMyTeams() async {
    AppLoaderProgress.showLoader(context);
    ContestRequest contestRequest = new ContestRequest(
        user_id: userId,
        matchkey: widget.model.matchKey,
        sport_key: widget.model.sportKey,
        fantasy_type: selectedFantasyType.toString(),
        fantasy_type_id: CricketTypeFantasy.getCricketType(
            selectedFantasyType.toString(),
            sportsKey: widget.model
                .sportKey) /*selectedFantasyType==1?"7":selectedFantasyType==2?"6":"0"*/,
        slotes_id: selectedSlotId.toString());
    final client = ApiClient(AppRepository.dio);
    MyTeamResponse response = await client.getMyTeams(contestRequest);
    if (response.status == 1) {
      teamsList = response.result!.teams!;
      widget.model.teamCount = teamCount = response.result!.user_teams!;
      joinedContestCount = response.result!.joined_leagues!;

      setState(() {});
    }
    setState(() {
      AppLoaderProgress.hideLoader(context);
    });
  }

  void openAllContests(int catId, String filterType) {
    GeneralModel model = widget.model;
    model.teamCount = teamCount;
    model.teamId = teamId;
    model.categoryId = catId;
    model.filterType = filterType;
    model.fantasyType = selectedFantasyType;
    model.slotId = selectedSlotId;
    push(
            context,
            MaterialPageRoute(
                builder: (context) => AllContests(model, _currentIndex)))
        .then((value) {
      setState(() {
        onTeamCreated();
        if (Platform.isIOS) {
          AppConstants.callTimer();
        }
      });
    });
    // navigateToAllContests(context, model);
  }

  void onJoinContestResult(int isJoined, String referCode) {
    if (_currentIndex == 0) {
      if (isJoined == 1) {
        getContestByCategory(dontshowLoading: 1);
      }
    } else if (_currentIndex == 1) {
      getJoinedContests();
    }
  }

  void onTeamCreated() {
    if (_currentIndex == 0) {
      setState(() {
        scrollValue = true;
      });
      getContestByCategory(dontshowLoading: 1);
    } else if (_currentIndex == 1) {
      getJoinedContests(dontshowLoading: 1);
    } else if (_currentIndex == 2) {
      getMyTeams();
    }
  }

  void showBottomInviteSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              showPrivateContest == "1"
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: GestureDetector(
                        onTap: () {
                          Platform.isAndroid
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PrivateContest(
                                          _currentIndex,
                                          widget.model,
                                          onTeamCreated,
                                          maxMinList,
                                          _currentIndex))).then((value) {
                                  setState(() {
                                    Navigator.pop(context);
                                    onTeamCreated();

                                    if (Platform.isIOS) {
                                      AppConstants.callTimer();
                                    }
                                  });
                                })
                              : Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => PrivateContest(
                                          _currentIndex,
                                          widget.model,
                                          onTeamCreated,
                                          maxMinList,
                                          _currentIndex))).then((value) {
                                  setState(() {
                                    // if (AppConstants
                                    //         .createTimeUp ==
                                    //     true) {
                                    Navigator.pop(context);
                                    onTeamCreated();

                                    if (Platform.isIOS) {
                                      AppConstants.callTimer();
                                    }
                                    // }
                                    //widget.onTeamCreated();
                                    // Navigator.pop(context);
                                  });
                                });
                          // navigateToPrivateContest(_currentIndex, context,
                          //     widget.model, onTeamCreated, maxMinList);
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              child: Image(
                                image: AssetImage(AppImages.privatecontesti),
                                // fit: BoxFit.fill,
                                // color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Create a Contest',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xff858585),
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              showPrivateContest == "1" ? Divider() : Container(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    widget.model.onJoinContestResult = onJoinContestResult;
                    Platform.isAndroid
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InviteContestCode(
                                      _currentIndex,
                                      widget.model,
                                    ))).then((value) {
                            setState(() {
                              Navigator.pop(context);
                              onTeamCreated();

                              if (Platform.isIOS) {
                                AppConstants.callTimer();
                              }
                            });
                          })
                        : Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => InviteContestCode(
                                      _currentIndex,
                                      widget.model,
                                    ))).then((value) {
                            setState(() {
                              // if (AppConstants
                              //         .createTimeUp ==
                              //     true) {
                              Navigator.pop(context);
                              onTeamCreated();
                              if (Platform.isIOS) {
                                AppConstants.callTimer();
                              }

                              // }

                              //widget.onTeamCreated();
                              // Navigator.pop(context);
                            });
                          });

                    // navigateToInviteContestCode(
                    //     _currentIndex, context, widget.model,
                    //     onTeamCreated: onTeamCreated);
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 20,
                        child: Image(
                          image: AssetImage(AppImages.invitecontesti),
                          // fit: BoxFit.fill,
                          // color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Enter Contest Code',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff858585),
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void getWinnerPriceCard(int id, String winAmount) async {
    AppLoaderProgress.showLoader(context);
    ContestRequest request = new ContestRequest(
      user_id: userId,
      challenge_id: id.toString(),
      matchkey: widget.model.matchKey,
    );
    final client = ApiClient(AppRepository.dio);
    ScoreCardResponse response = await client.getWinnersPriceCard(request);
    setState(() {
      AppLoaderProgress.hideLoader(context);
    });
    if (response.status == 1) {
      MethodUtils.showWinningPopup(context, response.result!, winAmount);
    }
  }
}
