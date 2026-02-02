import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_indicator/progress_indicator.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/dataModels/JoinChallengeDataModel.dart';
import 'package:myrex11/repository/model/category_contest_response.dart';
import 'package:myrex11/util/customWidgets/customText.dart';
import 'package:myrex11/views/CreateTeam.dart';
import 'package:myrex11/views/Leaderboard.dart';
import 'package:myrex11/views/MyJoinTeams.dart';
import 'package:myrex11/views/Wallet.dart';
import 'package:myrex11/views/flexible/WinningBreakUpTab.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../customWidgets/MatchHeader.dart';
import '../../customWidgets/app_circular_loader.dart';
import '../../repository/app_repository.dart';
import '../../repository/model/base_request.dart';
import '../../repository/model/base_response.dart';
import '../../repository/retrofit/api_client.dart';
import 'flexibleControler.dart';

class FlexibleUi extends StatefulWidget {
  GeneralModel model;
  String? userId;
  String? teams;
  Contest? contest;
  Function? onTeamCreated;
  bool? isMyContest;
  Function? isFevContest;
  int currentContestIndex;
  String? sceenCheck;
  int? joinSimilar;
  FlexibleUi(this.currentContestIndex, this.model, this.userId, this.teams,
      this.contest, this.onTeamCreated,
      {Key? key,
      this.isMyContest,
      this.isFevContest,
      this.sceenCheck,
      this.joinSimilar})
      : super(key: key);

  @override
  State<FlexibleUi> createState() => _FlexibleUiState();
}

class _FlexibleUiState extends State<FlexibleUi> {
  late LocationPermission permission;
  String joinplus = '';
  dynamic totalIcon = 0;
  Future<bool> _onWillPop() async {
    if (widget.onTeamCreated != null) {
      widget.onTeamCreated!;
    }
    Navigator.pop(context);
    return Future.value(false);
  }

  void favouriteContest() async {
    AppLoaderProgress.showLoader(context);
    GeneralRequest request = new GeneralRequest(
      user_id: widget.userId,
      challenge_id:
          "${widget.contest!.real_challenge_id ?? widget.contest!.challenge_id}",
      my_fav_contest: (widget.contest!.is_fav_contest == 1 ? 0 : 1).toString(),
    );

    final client = ApiClient(AppRepository.dio);
    GeneralResponse response = await client.getFavouriteContest(request);

    if (response.status == 1) {
      widget.contest!.is_fav_contest =
          widget.contest!.is_fav_contest == 1 ? 0 : 1;
    }

    Fluttertoast.showToast(
        msg: response.message!,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1);
    setState(() {
      AppLoaderProgress.hideLoader(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('widget.sceenCheck${widget.sceenCheck}');
    if ((widget.model.teamCount ?? 0) > 0) {
      if (widget.contest!.multi_entry == 1 &&
          (widget.contest!.max_team_limit_exceeded_count ?? 0) <
              (widget.contest!.max_multi_entry_user ?? 0)) {
        setState(() {
          joinplus = 'JOIN+';
        });
      }
    }
    //   FlexibleController myController = Get.put(FlexibleController());
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          // appBar: _appBar(),
          body: GetBuilder<FlexibleController>(
        init: FlexibleController(
            widget.currentContestIndex, widget.contest, widget.model,
            challenge_id: "${widget.model.challengeId}",
            userId: widget.userId!,
            matchKey: "${widget.model.matchKey}"),
        builder: (_controller) => _body(_controller, context),
      )),
    );
  }

  // _appBar() {
  //   return PreferredSize(
  //     preferredSize: Size.fromHeight(75), // Set this height
  //     child:
  //   );
  // }
  Widget _body(FlexibleController _controller, BuildContext context) {
    double getvalue = double.parse(
            (widget.contest!.joinedusers! / widget.contest!.maximum_user!)
                .toString()) *
        100;
    return Obx(() => RefreshIndicator(
          onRefresh: _controller.onRefresh,
          child: Column(
            children: [
              // Header section - FIXED (non-scrollable)
              Container(
                color: primaryColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: primaryColor,
                      padding: EdgeInsets.only(top: 45),
                      child: Container(
                        child: GestureDetector(
                          onTap: () {
                            Platform.isIOS ? Navigator.pop(context) : null;
                          },
                          child: Row(
                            children: [
                              SizedBox(width: 15),
                              AppConstants.backButtonFunction(),
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
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: primaryColor,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 12, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      title: 'Current Prize Pool',
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 6),
                                          child: Container(
                                            height: 18,
                                            width: 18,
                                            child:
                                                Image.asset(AppImages.goldcoin),
                                          ),
                                        ),
                                        CustomText(
                                          title: _controller.isLoadingFi.value
                                              ? ""
                                              : '${_controller.dataModel.value.current_price_pool ?? ''}',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                widget.contest!.is_bonus == 1
                                    ? Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: greenColorBonusShadow,
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        alignment: Alignment.centerRight,
                                        margin:
                                            EdgeInsets.only(top: 5, right: 5),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              AppImages.bonus_icon,
                                              height: 16,
                                              color: greenIconColor,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              "${widget.contest!.bonus_percent} Bonus",
                                              style: TextStyle(
                                                color: greenIconColor,
                                                fontSize: 12,
                                                fontFamily: "Roboto",
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : SizedBox.shrink(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CustomText(
                                      title: 'Max Prize Pool',
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: Container(
                                            height: 18,
                                            width: 18,
                                            child:
                                                Image.asset(AppImages.goldcoin),
                                          ),
                                        ),
                                        CustomText(
                                          title: _controller.isLoadingFi.value
                                              ? ""
                                              : '${_controller.dataModel.value.max_price_pool ?? ''}',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 8),
                                  child: BarProgress(
                                    percentage: getvalue,
                                    backColor: Color(0xffF1E7FF),
                                    gradient: LinearGradient(
                                      begin: Alignment.center,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xffA66DFB),
                                        Color(0xffA66DFB)
                                      ],
                                    ),
                                    showPercentage: false,
                                    stroke: 5,
                                    round: true,
                                  ),
                                ),
                                !(widget.model.isFromLiveFinish ?? false)
                                    ? Container(
                                        height: 20,
                                        margin: EdgeInsets.only(
                                            top: 5, left: 10, right: 5),
                                        child: ((widget.contest!.joinedusers!) -
                                                    (widget.contest!
                                                        .maximum_user!)) ==
                                                0
                                            ? Container(
                                                margin:
                                                    EdgeInsets.only(left: 2),
                                                child: Text(
                                                  "Challenge Closed",
                                                  style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    color: primaryColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 6),
                                                    child: Text(
                                                      // widget.contest!
                                                      //             .challenge_type ==
                                                      //         'percentage'
                                                      //     ? widget.contest!
                                                      //             .joinedusers!
                                                      //             .toString() +
                                                      //         '/'
                                                      //     :
                                                      widget.contest!.maximum_user! -
                                                                  widget
                                                                      .contest!
                                                                      .joinedusers! >
                                                              0
                                                          ? NumberFormat
                                                                      .decimalPattern(
                                                                          'hi')
                                                                  .format(widget
                                                                          .contest!
                                                                          .maximum_user! -
                                                                      widget
                                                                          .contest!
                                                                          .joinedusers!)
                                                                  .toString() +
                                                              ' Spots Left'
                                                          : 'Challenge Closed',
                                                      style: TextStyle(
                                                        fontFamily: "Roboto",
                                                        color: greenColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 8),
                                                    child: Text(
                                                      NumberFormat.decimalPattern(
                                                                  'hi')
                                                              .format(widget
                                                                  .contest!
                                                                  .maximum_user!)
                                                              .toString() +
                                                          ' Spots',
                                                      style: TextStyle(
                                                        fontFamily: "Roboto",
                                                        color: textCol,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 2),
                                            child: Text(
                                              // widget.contest!.challenge_type ==
                                              //         'percentage'
                                              //     ? widget.contest!.joinedusers!
                                              //             .toString() +
                                              //         '/'
                                              //     :
                                              widget.contest!.maximum_user! -
                                                          widget.contest!
                                                              .joinedusers! >
                                                      0
                                                  ? NumberFormat.decimalPattern(
                                                              'hi')
                                                          .format(widget
                                                                  .contest!
                                                                  .maximum_user! -
                                                              widget.contest!
                                                                  .joinedusers!) +
                                                      ' Spots Left'
                                                  : 'Challenge Closed',
                                              style: TextStyle(
                                                color: primaryColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 5),
                                            child: Text(
                                              NumberFormat.decimalPattern('hi')
                                                      .format(widget.contest!
                                                          .maximum_user!) +
                                                  ' Spots',
                                              style: TextStyle(
                                                color: Color(0xFF414141),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                SizedBox(height: 4),
                                Container(height: 1, color: primaryColor),
                                Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  padding: widget.contest!.is_gadget == 1
                                      ? const EdgeInsets.only(
                                          right: 14,
                                          left: 10,
                                          top: 8,
                                          bottom: 8)
                                      : const EdgeInsets.only(
                                          right: 14,
                                          left: 10,
                                          top: 8,
                                          bottom: 8),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF1E7FF),
                                    border: Border(
                                        top: BorderSide(
                                            color: Color(0xFFF1E7FF))),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // widget.contest!.challenge_type !=
                                      //         'percentage'
                                      //     ?
                                      widget.contest!.is_gadget == 1
                                          ? Container()
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: Row(
                                                children: [
                                                  Image(
                                                    image: AssetImage(AppImages
                                                        .winnerMedalIcon),
                                                    height: 14,
                                                    color: Color(0XFF666666),
                                                  ),
                                                  SizedBox(width: 4),
                                                  Container(
                                                    height: 14,
                                                    width: 14,
                                                    child: Image.asset(
                                                        AppImages.goldcoin),
                                                  ),
                                                  SizedBox(width: 3),
                                                  Text(
                                                    widget.contest!
                                                        .first_rank_prize!
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: textCol,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      // : Container(),
                                      widget.contest!.multi_entry == 1
                                          ? Row(
                                              children: [
                                                Image(
                                                  image: AssetImage(
                                                      AppImages.multiEntry),
                                                  height: 14,
                                                  color: Color(0XFF666666),
                                                ),
                                                SizedBox(width: 3),
                                                Text(
                                                  'Upto ' +
                                                      widget.contest!
                                                          .max_multi_entry_user!
                                                          .toString(),
                                                  style: TextStyle(
                                                    color: textCol,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image(
                                              image: AssetImage(
                                                  AppImages.winnersIcon),
                                              height: 14,
                                              color: Color(0XFF666666),
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              widget.contest!.challenge_type ==
                                                      'percentage'
                                                  ? widget.contest!
                                                          .winning_percentage
                                                          .toString() +
                                                      '% Win'
                                                  : widget.contest!.totalwinners
                                                          .toString() +
                                                      ' Winner',
                                              style: TextStyle(
                                                color: textCol,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      widget.contest!.confirmed_challenge == 1
                                          ? Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 7, right: 5),
                                                    height: 14,
                                                    width: 14,
                                                    alignment: Alignment.center,
                                                    child: Image(
                                                      image: AssetImage(
                                                          AppImages
                                                              .confirmIcon),
                                                      color: Color(0XFF666666),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Guaranteed',
                                                    style: TextStyle(
                                                      color: textCol,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : SizedBox.shrink(),
                                      widget.contest!.is_flexible == 1
                                          ? Container(
                                              margin: EdgeInsets.only(right: 5),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 0, right: 5),
                                                    height: 14,
                                                    width: 14,
                                                    alignment: Alignment.center,
                                                    child: Image(
                                                      image: AssetImage(
                                                          AppImages
                                                              .flexibleIcon),
                                                      color: Color(0XFF666666),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Flexible',
                                                    style: TextStyle(
                                                      color: textCol,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // JOIN Button - FIXED (non-scrollable)
              (widget.contest!.maximum_user! - widget.contest!.joinedusers! >
                          0) &&
                      !(widget.model.isFromLiveFinish ?? false)
                  ? Visibility(
                      visible: !(widget.model.isFromLive ?? false),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 0, right: 0, bottom: 5, top: 0),
                        child: GestureDetector(
                          onTap: ((widget.contest!.joinedusers!) -
                                      (widget.contest!.maximum_user!)) ==
                                  0
                              ? null
                              : () async {
                                  print([
                                    'btnEntryText',
                                    (btnEntryText() as Text).data
                                  ]);

                                  if ((btnEntryText() as Text).data ==
                                      'INVITE') {
                                    MethodUtils.onShare(
                                        context, widget.contest!, widget.model);
                                  } else if ((btnEntryTextforJoin() as Text)
                                          .data ==
                                      'JOIN+') {
                                    Platform.isAndroid
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyJoinTeams(
                                                      widget
                                                          .currentContestIndex,
                                                      widget.model,
                                                      widget.contest,
                                                      _controller
                                                          .onJoinContestResult,
                                                      joinSimilar:
                                                          widget.joinSimilar,
                                                    ))).then((value) {
                                            setState(() {
                                              _controller.leaderboardList
                                                  .clear();
                                              _controller.getLeaderboardList();
                                              // Future.delayed(
                                              //     Duration(
                                              //         milliseconds:
                                              //             200), () {
                                              //   if (widget
                                              //           .onTeamCreated !=
                                              //       null) {
                                              //     widget
                                              //         .onTeamCreated!();
                                              //   }
                                              // });
                                            });
                                            // setState(() {

                                            // });
                                          })
                                        : Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    MyJoinTeams(
                                                      widget
                                                          .currentContestIndex,
                                                      widget.model,
                                                      widget.contest,
                                                      _controller
                                                          .onJoinContestResult,
                                                      joinSimilar:
                                                          widget.joinSimilar,
                                                    ))).then((value) {
                                            // _controller
                                            //     .leaderboardList
                                            //     .clear();
                                            // _controller
                                            //     .getLeaderboardList();
                                            setState(() {
                                              _controller.leaderboardList
                                                  .clear();
                                              _controller.getLeaderboardList();
                                            });
                                          });
                                    // navigateToMyJoinTeams(
                                    //     widget.currentContestIndex,
                                    //     context,
                                    //     widget.model,
                                    //     widget.contest,
                                    //     _controller
                                    //         .onJoinContestResult);
                                  } else {
                                    if (widget.model.teamCount == 1) {
                                      widget.model.onJoinContestResult =
                                          _controller.onJoinContestResult;
                                      widget.model.contest = widget.contest;

                                      MethodUtils.checkBalance(
                                        widget.currentContestIndex,
                                        JoinChallengeDataModel(
                                            context,
                                            0,
                                            int.parse(widget.userId!),
                                            widget.contest!.id!,
                                            widget.model.fantasyType!,
                                            //  widget.model.slotId!,
                                            1,
                                            widget.contest!.is_bonus!,
                                            widget.contest!.win_amount!,
                                            widget.contest!.maximum_user!,
                                            widget.model.teamId.toString(),
                                            widget.contest!.entryfee.toString(),
                                            widget.model.matchKey!,
                                            widget.model.sportKey!,
                                            widget.model.joinedSwitchTeamId
                                                .toString(),
                                            false,
                                            0,
                                            0,
                                            _controller.onJoinContestResult,
                                            widget.contest!,
                                            bonusPercentage:
                                                widget.contest!.bonus_percent,
                                            leaderboardApi:
                                                _controller.getLeaderboardList),
                                        joinSimilar: widget.joinSimilar,
                                      );
                                    } else if (widget.model.teamCount != null &&
                                        widget.model.teamCount! > 0) {
                                      Platform.isAndroid
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyJoinTeams(
                                                        widget
                                                            .currentContestIndex,
                                                        widget.model,
                                                        widget.contest,
                                                        _controller
                                                            .onJoinContestResult,
                                                        joinSimilar:
                                                            widget.joinSimilar,
                                                      ))).then((value) {
                                              setState(() {
                                                _controller.leaderboardList
                                                    .clear();
                                                _controller
                                                    .getLeaderboardList();
                                              });
                                              // setState(() {

                                              // });
                                            })
                                          : Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      MyJoinTeams(
                                                        widget
                                                            .currentContestIndex,
                                                        widget.model,
                                                        widget.contest,
                                                        _controller
                                                            .onJoinContestResult,
                                                        joinSimilar:
                                                            widget.joinSimilar,
                                                      ))).then((value) {
                                              // _controller
                                              //     .leaderboardList
                                              //     .clear();
                                              // _controller
                                              //     .getLeaderboardList();
                                              setState(() {
                                                _controller.leaderboardList
                                                    .clear();
                                                _controller
                                                    .getLeaderboardList();
                                              });
                                            });
                                      // navigateToMyJoinTeams(
                                      //     widget.currentContestIndex,
                                      //     context,
                                      //     widget.model,
                                      //     widget.contest,
                                      //     _controller
                                      //         .onJoinContestResult);
                                    } else {
                                      widget.model.onJoinContestResult =
                                          _controller.onJoinContestResult;
                                      widget.model.contest = widget.contest;

                                      Platform.isAndroid
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreateTeam(
                                                        widget.model,
                                                        onTeamCreated: widget
                                                            .onTeamCreated,
                                                        checkScreen: 'flxible',
                                                        joinSimilar:
                                                            widget.joinSimilar,
                                                      ))).then((value) {
                                              // _controller
                                              //     .leaderboardList
                                              //     .clear();
                                              // _controller
                                              //     .getLeaderboardList();
                                              setState(() {
                                                _controller.leaderboardList
                                                    .clear();
                                                _controller
                                                    .getLeaderboardList();
                                                if (Platform.isIOS) {
                                                  AppConstants.callTimer();
                                                }
                                              });
                                              // setState(() {

                                              // });
                                            })
                                          : Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      CreateTeam(
                                                        widget.model,
                                                        onTeamCreated: widget
                                                            .onTeamCreated,
                                                        checkScreen: 'flxible',
                                                        joinSimilar:
                                                            widget.joinSimilar,
                                                      ))).then((value) {
                                              // _controller
                                              //     .leaderboardList
                                              //     .clear();
                                              // _controller
                                              //     .getLeaderboardList();
                                              setState(() {
                                                _controller.leaderboardList
                                                    .clear();
                                                _controller
                                                    .getLeaderboardList();
                                                if (Platform.isIOS) {
                                                  AppConstants.callTimer();
                                                }
                                              });
                                            });
                                      // navigateToCreateTeam(
                                      //   context,
                                      //   widget.model,
                                      //   onTeamCreated:
                                      //       widget.onTeamCreated,
                                      // );
                                    }
                                  }
                                }

                          /*  if(widget.contest!.is_join_similar_contest==1 && widget.contest!.multi_entry!=1){
                                      Get.bottomSheet(
                                        MultipleContestScreen(widget.currentContestIndex,
                                            widget.contest!,
                                            JoinChallengeDataModel(
                                                context,
                                                0,
                                                int.parse(
                                                    widget.userId!),
                                                widget.contest!.id!,
                                                widget.model.fantasyType!,
                                                //widget.model.slotId!,
                                                1,
                                                widget.contest!.is_bonus!,
                                                widget.contest!.win_amount!,
                                                widget.contest!.maximum_user!,
                                                widget.model.teamId.toString(),
                                                widget.contest!.entryfee.toString(),
                                                widget.model.matchKey!,
                                                widget.model.sportKey!,
                                                widget.model.joinedSwitchTeamId.toString(),
                                                false,
                                                0,
                                                0,
                                                _controller.onJoinContestResult,
                                            widget.contest!,
                                            bonusPercentage: widget.contest!.bonus_percent),
                                            widget.model.teamCount,widget.onTeamCreated,model: widget.model,onJoinContestResult: _controller.onJoinContestResult),
                                        isScrollControlled: true,
                                      );
                                    }
                                    else{
                                      if (widget.model.teamCount == 1) {
                                        if (widget.contest!.multi_entry == 1) {
                                          MethodUtils.checkBalance(widget.currentContestIndex,JoinChallengeDataModel(
                                              context,
                                              0,
                                              int.parse(widget.userId!),
                                              widget.contest!.id!,
                                              widget.model.fantasyType!,
                                            //  widget.model.slotId!,
                                              1,
                                              widget.contest!.is_bonus!,
                                              widget.contest!.win_amount!,
                                              widget.contest!.maximum_user!,
                                              widget.model.teamId.toString(),
                                              widget.contest!.entryfee.toString(),
                                              widget.model.matchKey!,
                                              widget.model.sportKey!,
                                              widget.model.joinedSwitchTeamId.toString(),
                                              false,
                                              0,
                                              0, _controller.onJoinContestResult,
                                          widget.contest!,
                                          bonusPercentage: widget.contest!.bonus_percent));
                                        } else {
                                          MethodUtils.checkBalance(widget.currentContestIndex,JoinChallengeDataModel(
                                              context,
                                              0,
                                              int.parse(widget.userId!),
                                              widget.contest!.id!,
                                              widget.model.fantasyType!,
                                            //  widget.model.slotId!,
                                              1,
                                              widget.contest!.is_bonus!,
                                              widget.contest!.win_amount!,
                                              widget.contest!.maximum_user!,
                                              widget.model.teamId.toString(),
                                              widget.contest!.entryfee.toString(),
                                              widget.model.matchKey!,
                                              widget.model.sportKey!,
                                              widget.model.joinedSwitchTeamId.toString(),
                                              false,
                                              0,
                                              0,
                                              _controller.onJoinContestResult,
                                          widget.contest!,
                                          bonusPercentage: widget.contest!.bonus_percent));
                                        }
                                      }
                                      else if (widget.model.teamCount! > 0) {
                                        navigateToMyJoinTeams(
                                          widget.currentContestIndex,
                                          context,
                                          widget.model,
                                          widget.contest!,
                                          _controller.onJoinContestResult,
                                        );
                                      }
                                      else {
                                        widget.model.onJoinContestResult = _controller.onJoinContestResult;
                                        widget.model.contest = widget.contest;
                                         navigateToCreateTeam(
                                           context,
                                           widget.model,
                                           onTeamCreated: widget.onTeamCreated,
                                         );

                                      }
                                    }*/
                          ,
                          child: Container(
                            color: greenColor,
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            child: Center(child: btnJoinText()),
                          ),
                        ),
                      ),
                    )
                  : Container(),

              // Tabs section - EXPANDED (will be scrollable internally)
              Expanded(
                child: getTabs(_controller),
              ),
            ],
          ),
        ));
  }

  getTabs(FlexibleController _controller) {
    return Container(
      height:
          MediaQuery.of(context).size.height * 0.6, // Adjust height as needed
      child: new DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(55),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: new Container(
                color: const Color.fromRGBO(255, 255, 255, 1),
                child: TabBar(
                  labelPadding: EdgeInsets.all(0),
                  onTap: (int index) {
                    _controller.currentMatchIndex.value = index;
                    if (_controller.currentMatchIndex.value == 0) {
                      _controller.getFlexibleData(context);
                    } else {
                      _controller.getLeaderboardList();
                    }
                    _controller.update();
                  },
                  indicatorWeight: 2,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: primaryColor,
                  isScrollable: false,
                  tabs: [
                    _controller.getWinningTab(),
                    _controller.getLeaderboardTab(),
                  ],
                ),
              ),
            ),
          ),
          body: GetBuilder<FlexibleController>(builder: (newController) {
            return newController.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(
                    color: primaryColor,
                  ))
                : newController.currentMatchIndex.value == 0
                    ? Center(child: Winning(newController))
                    : Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Leaderboard(
                          _controller.totalUser,
                          _controller.leaderboardList,
                          widget.userId ?? '',
                          true,
                          widget.contest!.pdf == null
                              ? ""
                              : widget.contest!.pdf!,
                          widget.model,
                          isLeaderboardCall: _controller.isLeaderboardCall,
                        ),
                      );
          }),
        ),
      ),
    );
  }

  winningBreakupsContest(FlexibleController _controller) {
    return Obx(() => DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: bgColorDark,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(55),
            child: new Container(
              color: Colors.white,
              child: TabBar(
                labelPadding: EdgeInsets.all(0),
                indicatorPadding: EdgeInsets.symmetric(horizontal: 40),
                onTap: (int index) {
                  _controller.currentMatchIndex.value = index;
                  if (_controller.currentMatchIndex.value == 0) {
                    //  _controller.getFlexibleData();
                    _controller.update();
                  } else {
                    // _controller.getFlexibleData();
                  }
                  _controller.update();
                },
                indicatorWeight: 2,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Colors.black,
                // indicator: ShapeDecoration(
                //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
                //     color: Colors.black
                // ),
                isScrollable: false,
                tabs: [
                  _controller.getMaxFill(),
                  _controller.getCurrentFill(),
                ],
              ),
            ),
          ),
          body: GetBuilder<FlexibleController>(
            builder: (newController) => newController.isLoading.value
                ? CircularProgressIndicator()
                : _controller.currentMatchIndex.value == 0
                    ? _controller
                        .getMaxFill() /* WinningBreakups(_controller.breakupList)*/
                    : _controller
                        .getCurrentFill() /*new Leaderboard(
              _controller.leaderboardList,
              userId!,
              true,
              contest!.pdf==null?"":contest!.pdf!,
              model,
            )*/
            ,
          ),
        )));
  }

  Widget btnJoinText() {
    return Text(
      (widget.contest!.maximum_user! - widget.contest!.joinedusers!) == 0
          ?
          // '₹' +
          widget.contest!.entryfee.toString()
          : widget.contest!.is_free == 1 ||
                  widget.contest!.is_first_time_free == 1
              ? 'FREE'
              : widget.contest!.isjoined != null && widget.contest!.isjoined!
                  ? widget.contest!.multi_entry == 1 &&
                          (widget.contest!.max_team_limit_exceeded_count ?? 0) <
                              (widget.contest!.max_multi_entry_user ?? 0)
                      ? 'JOIN Contest Now' //+ widget.contest!.entryfee.toString()
                      : (widget.contest!.max_team_limit_exceeded_count ?? 0) >=
                              (widget.contest!.max_multi_entry_user ?? 0)
                          ? 'INVITE'
                          : 'INVITE'
                  : 'JOIN Contest Now', //+ widget.contest!.entryfee.toString(),
      // (widget.contest!.maximum_user! - widget.contest!.joinedusers!) == 0
      //     ? ""
      //     : /*widget.contest.isjoined!*/ widget
      //                     .contest!.max_team_limit_exceeded_count !=
      //                 null &&
      //             widget.contest!.max_team_limit_exceeded_count! > 0
      //         ? widget.contest!.multi_entry == 1
      //             ? 'Join+'
      //             : 'Invite Contest'
      //         : 'Join Contest Now',
      style: TextStyle(fontSize: 15, color: Colors.white),
    );
  }

  Widget btnEntryTextforJoin() {
    return new Text(
      (widget.contest!.maximum_user! - widget.contest!.joinedusers!) == 0
          ? widget.contest!.entryfee.toString()
          : widget.contest!.is_free == 1 ||
                  widget.contest!.is_first_time_free == 1
              ? 'FREE'
              : widget.contest!.isjoined != null && widget.contest!.isjoined!
                  ? widget.contest!.multi_entry == 1 &&
                          (widget.contest!.max_team_limit_exceeded_count ?? 0) <
                              (widget.contest!.max_multi_entry_user ?? 0)
                      ? 'JOIN+'
                      : (widget.contest!.max_team_limit_exceeded_count ?? 0) >=
                              (widget.contest!.max_multi_entry_user ?? 0)
                          ? 'INVITE'
                          : 'INVITE'
                  : widget.contest!.entryfee.toString(),
      style: TextStyle(
        // fontFamily: 'noway',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget btnEntryText() {
    print([
      widget.contest!.max_team_limit_exceeded_count,
      widget.contest!.isjoined
    ]);
    return Text(
      (widget.contest!.maximum_user! - widget.contest!.joinedusers!) == 0
          ? widget.contest!.entryfee.toString()
          : widget.contest!.is_free == 1 ||
                  widget.contest!.is_first_time_free == 1
              ? 'FREE'
              : widget.contest!.isjoined != null && widget.contest!.isjoined!
                  ? widget.contest!.multi_entry == 1 &&
                          (widget.contest!.max_team_limit_exceeded_count ?? 0) <
                              (widget.contest!.max_multi_entry_user ?? 0)
                      ? widget.contest!.entryfee.toString()
                      : (widget.contest!.max_team_limit_exceeded_count ?? 0) >=
                              (widget.contest!.max_multi_entry_user ?? 0)
                          ? 'INVITE'
                          : 'INVITE'
                  : widget.contest!.entryfee.toString(),
      // widget.contest!.is_free == 1 || widget.contest!.is_first_time_free == 1
      //     ? 'FREE'
      //     : widget.contest!.max_team_limit_exceeded_count != null &&
      //             widget.contest!.max_team_limit_exceeded_count! > 0 &&
      //             widget.contest!.isjoined != null &&
      //             widget.contest!.isjoined!
      //         ? widget.contest!.multi_entry == 1
      //             ? 'JOIN+'
      //             : 'INVITE'
      //         : '₹' + widget.contest!.entryfee.toString(),
      style: TextStyle(
        fontFamily: "Roboto",
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }

  static void showRestrictedStateBottomSheet(
      BuildContext context, String state) {
    showModalBottomSheet(
      context: context ?? AppConstants.context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Color(0xffd9d9d9)),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Important',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: 50,
                height: 50,
                child: Image.asset(AppImages.address),
              ),
              // Icon(

              //   size: 60,
              //   color: Colors.grey[700],
              // ),
              SizedBox(height: 8),
              Text(
                'Oh! You\'re from a restricted state',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'As per your state laws, you\'re not allowed to play on this app from $state.',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Roboto",
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenColor,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text(
                  'PLAY FREE CONTEST INSTEAD',
                  style: TextStyle(
                    fontFamily: "Roboto",
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
