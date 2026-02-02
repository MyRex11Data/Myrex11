import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myrex11/buildType/buildType.dart';
import 'package:myrex11/repository/model/team_response.dart';
import 'package:intl/intl.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/app_navigator.dart';
import 'package:flutter/services.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/customWidgets/MatchHeader.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/dataModels/JoinChallengeDataModel.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/base_request.dart';
import 'package:myrex11/repository/model/base_response.dart';
import 'package:myrex11/repository/model/category_contest_response.dart';
import 'package:myrex11/repository/model/contest_details_response.dart';
import 'package:myrex11/repository/model/contest_request.dart';
import 'package:myrex11/repository/model/score_card_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';
import 'package:progress_indicator/progress_indicator.dart';
import 'package:myrex11/views/CreateTeam.dart';
import 'package:myrex11/views/MyJoinTeams.dart';
import 'package:myrex11/views/Wallet.dart';
import '../dataModels/get_offer_response.dart';
import 'Leaderboard.dart';
import 'WinningBreakups.dart';

class UpcomingContestDetails extends StatefulWidget {
  GeneralModel model;
  Contest contest;
  Function? onTeamCreated;
  Function? onResume;
  List<Team>? teamsList;
  bool? isMyContest;
  int currentContestIndex;
  String? sceenCheck;
  int? joinSimilar;
  UpcomingContestDetails(this.currentContestIndex, this.model, this.contest,
      {this.onResume,
      this.onTeamCreated,
      this.teamsList,
      this.isMyContest,
      this.sceenCheck,
      this.joinSimilar});

  @override
  _UpcomingContestDetailsState createState() => _UpcomingContestDetailsState();
}

class _UpcomingContestDetailsState extends State<UpcomingContestDetails> {
  String title = 'Home';
  bool back_dialog = false;
  int _currentMatchIndex = 0;
  String balance = '0';
  String userId = '0';
  List<Widget> tabs = <Widget>[];
  List<WinnerScoreCardItem> breakupList = [];
  List<JoinedContestTeam> leaderboardList = [];
  GetOfferResponse? offerResponse;
  int page = 0;
  dynamic isLeaderboardCall = 1;
  dynamic totalIcon = 0;
  String joinplus = '';
  late LocationPermission permission;

  @override
  void initState() {
    super.initState();
    AppPrefrence.getString(AppConstants.KEY_USER_BALANCE).then((value) => {
          setState(() {
            balance = value;
          })
        });

    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
        .then((value) => {
              setState(() {
                userId = value;
                getWinnerPriceCard();
                // getLeaderboardList();
              })
            });

    widget.contest.isjoined = widget.contest.isjoined ?? false;
    widget.contest.pdf = widget.contest.pdf ?? '';
    widget.model.onSwitchTeam = onSwitchTeam;
    widget.model.onSwitchTeamResult = onSwitchTeamResult;
  }

  Widget btnJoinText() {
    return Text(
      (widget.contest.maximum_user! - widget.contest.joinedusers!) == 0
          ? widget.contest.entryfee.toString()
          : widget.contest.is_free == 1 ||
                  widget.contest.is_first_time_free == 1
              ? 'FREE'
              : widget.contest.isjoined != null && widget.contest.isjoined!
                  ? widget.contest.multi_entry == 1 &&
                          (widget.contest.max_team_limit_exceeded_count ?? 0) <
                              (widget.contest.max_multi_entry_user ?? 0)
                      ? 'Join Contest Now' //+ widget.contest.entryfee.toString()
                      : (widget.contest.max_team_limit_exceeded_count ?? 0) >=
                              (widget.contest.max_multi_entry_user ?? 0)
                          ? 'INVITE'
                          : 'INVITE'
                  : 'Join Contest Now', // + widget.contest.entryfee.toString(),
      // (widget.contest.maximum_user! - widget.contest.joinedusers!) == 0
      //     ? ""
      //     : /*widget.contest.isjoined!*/ widget
      //                     .contest.max_team_limit_exceeded_count !=
      //                 null &&
      //             widget.contest.max_team_limit_exceeded_count! > 0
      //         ? widget.contest.multi_entry == 1
      //             ? 'JOIN+'
      //             : 'INVITE'
      //         : 'Join Contest Now',
      style: TextStyle(
          fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600),
    );
  }

  Widget btnJoinTextFor() {
    return Text(
      (widget.contest.maximum_user! - widget.contest.joinedusers!) == 0
          ? widget.contest.entryfee.toString()
          : widget.contest.is_free == 1 ||
                  widget.contest.is_first_time_free == 1
              ? 'FREE'
              : widget.contest.isjoined != null && widget.contest.isjoined!
                  ? widget.contest.multi_entry == 1 &&
                          (widget.contest.max_team_limit_exceeded_count ?? 0) <
                              (widget.contest.max_multi_entry_user ?? 0)
                      ? 'JOIN' + widget.contest.entryfee.toString()
                      : (widget.contest.max_team_limit_exceeded_count ?? 0) >=
                              (widget.contest.max_multi_entry_user ?? 0)
                          ? 'INVITE'
                          : 'INVITE'
                  : 'JOIN' + widget.contest.entryfee.toString(),
      // (widget.contest.maximum_user! - widget.contest.joinedusers!) == 0
      //     ? ""
      //     : /*widget.contest.isjoined!*/ widget
      //                     .contest.max_team_limit_exceeded_count !=
      //                 null &&
      //             widget.contest.max_team_limit_exceeded_count! > 0
      //         ? widget.contest.multi_entry == 1
      //             ? 'JOIN+'
      //             : 'INVITE'
      //         : 'Join Contest Now',
      style: TextStyle(fontSize: 15, color: Colors.white),
    );
  }

  Widget btnEntryText() {
    return Text(
      (widget.contest.maximum_user! - widget.contest.joinedusers!) == 0
          ?
          // '₹' +
          widget.contest.entryfee.toString()
          : widget.contest.is_free == 1 ||
                  widget.contest.is_first_time_free == 1
              ? 'FREE'
              : widget.contest.isjoined != null && widget.contest.isjoined!
                  ? widget.contest.multi_entry == 1 &&
                          (widget.contest.max_team_limit_exceeded_count ?? 0) <
                              (widget.contest.max_multi_entry_user ?? 0)
                      ?
                      // '₹' +
                      widget.contest.entryfee.toString()
                      : (widget.contest.max_team_limit_exceeded_count ?? 0) >=
                              (widget.contest.max_multi_entry_user ?? 0)
                          ? 'INVITE'
                          : 'INVITE'
                  :
                  // '₹' +
                  widget.contest.entryfee.toString(),
      // widget.contest.is_free == 1 || widget.contest.is_first_time_free == 1
      //     ? 'FREE'
      //     : widget.contest.max_team_limit_exceeded_count != null &&
      //             widget.contest.max_team_limit_exceeded_count! > 0 &&
      //             widget.contest.isjoined != null &&
      //             widget.contest.isjoined!
      //         ? widget.contest.multi_entry == 1
      //             ? 'JOIN+'
      //             : 'INVITE'
      //         : '₹' + widget.contest.entryfee.toString(),
      style: TextStyle(
        // fontFamily: "Roboto",
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.white,
        //  fontFamily: "Roboto",
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget btnEntryTextforJoin() {
    return new Text(
      (widget.contest.maximum_user! - widget.contest.joinedusers!) == 0
          ? widget.contest.entryfee.toString()
          : widget.contest.is_free == 1 ||
                  widget.contest.is_first_time_free == 1
              ? 'FREE'
              : widget.contest.isjoined != null && widget.contest.isjoined!
                  ? widget.contest.multi_entry == 1 &&
                          (widget.contest.max_team_limit_exceeded_count ?? 0) <
                              (widget.contest.max_multi_entry_user ?? 0)
                      ? 'JOIN+'
                      : (widget.contest.max_team_limit_exceeded_count ?? 0) >=
                              (widget.contest.max_multi_entry_user ?? 0)
                          ? 'INVITE'
                          : 'INVITE'
                  : widget.contest.entryfee.toString(),
      // widget.contest.is_free == 1 || widget.contest.is_first_time_free == 1
      //     ? 'FREE'
      //     : widget.contest.max_team_limit_exceeded_count != null &&
      //             widget.contest.max_team_limit_exceeded_count! > 0 &&
      //             widget.contest.isjoined != null &&
      //             widget.contest.isjoined!
      //         ? widget.contest.multi_entry == 1
      //             ? 'JOIN+'
      //             : 'INVITE'
      //         : '₹' + widget.contest.entryfee.toString(),
      style: TextStyle(
        // fontFamily: "Roboto",
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: "Roboto",
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget btnEntryTextNew() {
    return Text(
      widget.contest.is_free == 1 || widget.contest.is_first_time_free == 1
          ? 'FREE'
          : widget.contest.max_team_limit_exceeded_count != null &&
                  widget.contest.max_team_limit_exceeded_count! > 0 &&
                  widget.contest.isjoined != null &&
                  widget.contest.isjoined!
              ? widget.contest.multi_entry == 1
                  ? 'JOIN+'
                  : 'INVITE'
              : widget.contest.real_entry_fees.toString(),
      style: TextStyle(
        fontFamily: "Roboto",
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.grey,
      ),
      textAlign: TextAlign.center,
    );
  }

  void getOffer(String challengeId) async {
    AppLoaderProgress.showLoader(context);
    final client = ApiClient(AppRepository.dio);
    GeneralRequest request =
        GeneralRequest(user_id: userId, challenge_id: challengeId.toString());
    final response = await client.getOffer(request);
    if (response.status == 1) {
      AppLoaderProgress.hideLoader(context);
      offerResponse = response;
      bottomSheet(offerResponse!);
    } else {
      AppLoaderProgress.hideLoader(context);
      Fluttertoast.showToast(msg: response.message!);
    }
    // AppLoaderProgress.hideLoader(context);
  }

  bottomSheet(GetOfferResponse Response) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      builder: (context) {
        return DraggableScrollableSheet(
            // expand: true,
            initialChildSize: 0.30,
            minChildSize: 0.15,
            maxChildSize: 1,
            builder: (context, controller) {
              return Container(
                //height: MediaQuery.of(context).size.height*0.5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10)),
                            width: 60,
                            height: 8,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Image.asset(
                          AppImages.offerPopup,
                          scale: 3,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Container(
                              color: lightBlack,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Team NO.',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Entry Fee',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Offer Entry',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: offerResponse!.result!.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            Response.result![index].team!,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              Response.result![index].entryfee
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 30),
                                              child: Text(
                                                Response.result![index].offer
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                })
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
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
    if ((widget.model.teamCount ?? 0) > 0) {
      if (widget.contest.multi_entry == 1 &&
          (widget.contest.max_team_limit_exceeded_count ?? 0) <
              (widget.contest.max_multi_entry_user ?? 0)) {
        setState(() {
          joinplus = 'JOIN+';
        });
      }
    }
    return Container(
      // color: primaryColor,
      child: new Scaffold(
          body: new WillPopScope(
              child: new Stack(
                children: [
                  new Scaffold(
                    backgroundColor: bgColorDark,
                    // appBar: PreferredSize(
                    //     preferredSize: Size.fromHeight(60), // Set this height
                    //     child:

                    //  Container(
                    //   color: Colors.white,
                    //   padding: Platform.isAndroid
                    //       ? EdgeInsets.only(top: 28)
                    //       : EdgeInsets.zero,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       new Row(
                    //         children: [
                    //           new GestureDetector(
                    //             behavior: HitTestBehavior.translucent,
                    //             onTap: () => {
                    //               /* Navigator.pop(context),*/
                    //               _onWillPop()
                    //               /* Navigator.pushReplacement(
                    //                   context,
                    //                   MaterialPageRoute(
                    //                     builder: (context) =>
                    //                         UpcomingContests(widget.model),
                    //                   ))*/
                    //             },
                    //             child: new Container(
                    //               padding:
                    //                   EdgeInsets.fromLTRB(15, 0, 15, 0),
                    //               child: new Container(
                    //                 width: 16,
                    //                 height: 16,
                    //                 child: Image(
                    //                     image: AssetImage(
                    //                         AppImages.backImageURL),
                    //                     fit: BoxFit.fill,
                    //                     color: Colors.black),
                    //               ),
                    //             ),
                    //           ),
                    //           new Column(
                    //             crossAxisAlignment:
                    //                 CrossAxisAlignment.start,
                    //             mainAxisSize: MainAxisSize.min,
                    //             children: [
                    //               new Text("Contests",
                    //                   style: TextStyle(
                    //                       fontFamily: "Roboto",
                    //                       color: Colors.black,
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 18)),
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    //       new Container(
                    //         width: 150,
                    //         margin: EdgeInsets.only(top: 0, left: 10),
                    //         alignment: Alignment.center,
                    //         child: new Row(
                    //           crossAxisAlignment: CrossAxisAlignment.center,
                    //           mainAxisAlignment: MainAxisAlignment.end,
                    //           mainAxisSize: MainAxisSize.max,
                    //           children: [
                    //             widget.isMyContest != null &&
                    //                     widget.isMyContest!
                    //                 ? SizedBox.shrink()
                    //                 : GestureDetector(
                    //                     behavior:
                    //                         HitTestBehavior.translucent,
                    //                     child: new Container(
                    //                       height: 20,
                    //                       width: 20,
                    //                       child: Image(
                    //                         image: AssetImage(widget.contest
                    //                                     .is_fav_contest ==
                    //                                 1
                    //                             ? AppImages.starFillIcon
                    //                             : AppImages.starIcon),
                    //                       ),
                    //                     ),
                    //                     onTap: () => {favouriteContest()},
                    //                   ),
                    //             SizedBox(width: 10),
                    //             new GestureDetector(
                    //               behavior: HitTestBehavior.translucent,
                    //               child: new Container(
                    //                 child: new Row(
                    //                   children: [
                    //                     // new Text('₹'+balance,
                    //                     //     style: TextStyle(
                    //                     //         fontFamily: "Roboto",
                    //                     //         color: primaryColor,
                    //                     //         fontWeight: FontWeight.normal,
                    //                     //         fontSize: 15)),
                    //                     new Container(
                    //                       margin:
                    //                           EdgeInsets.only(right: 10),
                    //                       height: 20,
                    //                       width: 20,
                    //                       child: Image(
                    //                         image: AssetImage(
                    //                             AppImages.walletImageURL),
                    //                         color: primaryColor,
                    //                       ),
                    //                     )
                    //                   ],
                    //                 ),
                    //               ),
                    //               onTap: () => {navigateToWallet(context)},
                    //             ),
                    //           ],
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),

                    body: new Stack(
                      children: [
                        new Container(
                          height: MediaQuery.of(context).size.height,
                          color: Colors.white,
                          child: new Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // new MatchHeader(
                              //     widget.model.teamVs!,
                              //     widget.model.headerText!,
                              //     widget.model.isFromLive ?? false,
                              //     widget.model.isFromLiveFinish ?? false),
                              new Container(
                                color: primaryColor,
                                child: new Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Container(
                                        color: primaryColor,
                                        // decoration: BoxDecoration(
                                        //   // image: DecorationImage(
                                        //   //   image: AssetImage("assets/images/ic_black.png"),
                                        //   //   fit: BoxFit.cover,
                                        //   // ),
                                        // ),
                                        padding: Platform.isAndroid
                                            ? EdgeInsets.only(top: 30)
                                            : EdgeInsets.zero,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Platform.isIOS
                                                    ? Navigator.pop(context)
                                                    : null;
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  AppConstants
                                                      .backButtonFunction(),
                                                  Container(
                                                    // width: 150,
                                                    // color: primaryColor,
                                                    margin: EdgeInsets.only(
                                                        right: 0),
                                                    child: MatchHeader(
                                                      widget.model.teamVs!,
                                                      widget.model.headerText!,
                                                      widget.model.isFromLive ??
                                                          false,
                                                      widget.model
                                                              .isFromLiveFinish ??
                                                          false,
                                                      teamColor: Colors.white,
                                                      timerColor: Colors.white,
                                                      screenType: "contest",
                                                      checkScreen:
                                                          widget.sceenCheck,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              //width: 150,
                                              alignment: Alignment.center,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  /*new GestureDetector(
                                                                         behavior: HitTestBehavior.translucent,
                                                                        child: new Container(
                                      height: 20,
                                      width: 20,
                                      child: Image(
                                        image: AssetImage(
                                            AppImages.createContestIcon),
                                      ),
                                                                        ),
                                                                        onTap: ()=>{
                                      _modalBottomSheetMenu()
                                                                        },
                                                                      ),*/
                                                  // Padding(
                                                  //   padding:
                                                  //       const EdgeInsets.only(right: 12),
                                                  //   child: GestureDetector(
                                                  //     onTap: () {
                                                  //       navigateToPrivateContest(
                                                  //           _currentIndex,
                                                  //           context,
                                                  //           widget.model,
                                                  //           onTeamCreated,
                                                  //           maxMinList);
                                                  //     },
                                                  //     child: new Container(
                                                  //       height: 25,
                                                  //       width: 70,
                                                  //       alignment: Alignment.center,
                                                  //       // decoration: BoxDecoration(
                                                  //       //     color: Color(0XFFf7f7f7),
                                                  //       //     border:
                                                  //       //         Border.all(color: Color(0xFF969696)),
                                                  //       //     borderRadius: BorderRadius.circular(20)),
                                                  //       child: Image(
                                                  //         image: AssetImage(
                                                  //           AppImages.privateContestimg,
                                                  //         ),
                                                  //       ),
                                                  //     ),
                                                  //   ),
                                                  // ),

                                                  //Future use
                                                  /* GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        child: new Container(
                                          height: 28,
                                          width: 28,
                                          child: Image(
                                            image: AssetImage(
                                                widget.contest.is_fav_contest ==
                                                        1
                                                    ? AppImages.starFillIcon
                                                    : AppImages.starIcon),
                                          ),
                                        ),
                                        onTap: () => {favouriteContest()},
                                      ),*/
                                                  GestureDetector(
                                                    behavior: HitTestBehavior
                                                        .translucent,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 15),
                                                      child: Container(
                                                        // margin:
                                                        //     EdgeInsets.only(
                                                        //         right: 10,
                                                        //         left: 10),
                                                        height: 32,
                                                        // width: 28,
                                                        child: Image(
                                                            image: AssetImage(
                                                                AppImages
                                                                    .wallet_icon)),
                                                      ),
                                                    ),
                                                    onTap: () => {
                                                      setState(() {
                                                        AppConstants
                                                                .movetowallet =
                                                            true;
                                                      }),
                                                      Platform.isAndroid
                                                          ? Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      Wallet(

                                                                          // multiple_contest: _dropDownValue ?? '1', joinSimilar: widget.contest.is_join_similar_contest
                                                                          ))).then(
                                                              (value) {
                                                              setState(() {
                                                                AppConstants
                                                                        .movetowallet =
                                                                    false;
                                                              });
                                                            })
                                                          : Navigator.push(
                                                              context,
                                                              CupertinoPageRoute(
                                                                  builder: (context) =>
                                                                      Wallet(

                                                                          // multiple_contest: _dropDownValue ?? '1',
                                                                          // joinSimilar: widget.contest.is_join_similar_contest
                                                                          ))).then(
                                                              (value) {
                                                              setState(() {
                                                                AppConstants
                                                                        .movetowallet =
                                                                    false;
                                                              });
                                                            })
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10,
                                          right: 8,
                                          left: 8,
                                          bottom: 8),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          new Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'Prize Pool',
                                                      style: TextStyle(
                                                          //  fontFamily: "Roboto",
                                                          color: Colors.white,
                                                          // fontWeight: FontWeight.w400,
                                                          fontSize: 12),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    widget.contest
                                                                .is_offer_team ==
                                                            1
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              getOffer(widget
                                                                  .contest.id
                                                                  .toString());
                                                            },
                                                            child: Image.asset(
                                                              AppImages.offer,
                                                              scale: 3,
                                                            ))
                                                        : Container()
                                                  ],
                                                ),
                                              ),

                                              /* Text(
                                                'Prize Pool',
                                                style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12),
                                              ),*/
                                              widget.contest.is_gadget == 1
                                                  ? Container(
                                                      height: 48,
                                                      width: 48,
                                                      child: Image.network(
                                                        widget.contest
                                                            .gadget_image!,
                                                        fit: BoxFit.contain,
                                                      ))
                                                  : Row(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      6),
                                                          child: Container(
                                                            height: 18,
                                                            width: 18,
                                                            child: Image.asset(
                                                                AppImages
                                                                    .goldcoin),
                                                          ),
                                                        ),
                                                        new Container(
                                                          height: 30,
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            (widget.contest
                                                                        .is_giveaway_visible_text ==
                                                                    0
                                                                ? widget.contest
                                                                    .win_amount
                                                                    .toString()
                                                                : widget.contest
                                                                    .is_giveaway_text!),
                                                            style: TextStyle(
                                                                // fontFamily: "Roboto",
                                                                color: widget
                                                                            .contest
                                                                            .is_giveaway_visible_text ==
                                                                        0
                                                                    ? Colors
                                                                        .white
                                                                    : MethodUtils.hexToColor(widget
                                                                        .contest
                                                                        .giveaway_color!),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                              /* new Container(
                                                height: 30,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '₹'+((widget.contest.is_giveaway_visible_text??0)==0?widget.contest.win_amount.toString():widget.contest.is_giveaway_text!),
                                                  style: TextStyle(
                                                      fontFamily: "Roboto",
                                                      color: (widget.contest.is_giveaway_visible_text??0)==0?Colors.black:MethodUtils.hexToColor(widget.contest.giveaway_color!),
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 18),
                                                ),
                                              )*/
                                            ],
                                          ),
                                          widget.contest.bonus_percent !=
                                                      null &&
                                                  widget.contest.is_bonus != 0
                                              ? Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          greenColorBonusShadow,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14)),
                                                  alignment:
                                                      Alignment.centerRight,
                                                  margin: EdgeInsets.only(
                                                      top: 5, right: 5),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                        AppImages.bonus_icon,
                                                        height: 16,
                                                        color: greenIconColor,
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        "${widget.contest.bonus_percent} Bonus",
                                                        style: TextStyle(
                                                            color:
                                                                greenIconColor,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : SizedBox.shrink(),
                                          new Container(
                                            margin: EdgeInsets.only(right: 5),
                                            child: new Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    new Container(
                                                      margin: EdgeInsets.only(
                                                          right: 5),
                                                      child: Text(
                                                        'Entry Fee',
                                                        style: TextStyle(
                                                            //   fontFamily: "Roboto",
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    widget.contest.is_free_for_referrer ==
                                                                1 &&
                                                            widget.contest
                                                                    .is_free_for_me ==
                                                                1
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 2),
                                                            child: Text(
                                                              // '₹' +
                                                              widget.contest
                                                                  .real_entry_fees
                                                                  .toString(),
                                                              style: TextStyle(
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough,
                                                                // fontFamily: "Roboto",
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color:
                                                                    greenColor,
                                                                //  fontFamily: "Roboto",
                                                              ),
                                                            ),
                                                          )
                                                        : Container()
                                                  ],
                                                ),
                                                new GestureDetector(
                                                  behavior: HitTestBehavior
                                                      .translucent,
                                                  child: new Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: new Card(
                                                      color: buttonGreenColor,
                                                      child: new Container(
                                                        height: 30,
                                                        width: 75,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          4),
                                                              child: Container(
                                                                height: 14,
                                                                width: 14,
                                                                child: Image.asset(
                                                                    AppImages
                                                                        .goldcoin),
                                                              ),
                                                            ),
                                                            btnEntryText(),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // onTap: () {
                                                  //   if ((btnEntryText()
                                                  //               as Text)
                                                  //           .data ==
                                                  //       'INVITE') {
                                                  //     MethodUtils.onShare(
                                                  //         context,
                                                  //         widget
                                                  //             .contest,
                                                  //         widget.model);
                                                  //   } else {
                                                  //     if (widget.model
                                                  //             .teamCount ==
                                                  //         1) {
                                                  //       /*if(widget.contest.multi_entry==0){*/
                                                  //       // if (widget.contest.multi_entry ==
                                                  //       //     1) {
                                                  //       widget.model
                                                  //               .onJoinContestResult =
                                                  //           onJoinContestResult;
                                                  //       widget.model
                                                  //               .contest =
                                                  //           widget
                                                  //               .contest;
                                                  //       MethodUtils.checkBalance(
                                                  //           widget.currentContestIndex,
                                                  //           new JoinChallengeDataModel(
                                                  //               context,
                                                  //               0,
                                                  //               int.parse(userId),
                                                  //               widget.contest.id!,
                                                  //               widget.model.fantasyType!,
                                                  //               //   widget.model.slotId!,
                                                  //               1,
                                                  //               widget.contest.is_bonus!,
                                                  //               widget.contest.win_amount!,
                                                  //               widget.contest.maximum_user!,
                                                  //               widget.model.teamId.toString(),
                                                  //               widget.contest.entryfee.toString(),
                                                  //               widget.model.matchKey!,
                                                  //               widget.model.sportKey!,
                                                  //               widget.model.joinedSwitchTeamId.toString(),
                                                  //               false,
                                                  //               0,
                                                  //               0,
                                                  //               onJoinContestResult,
                                                  //               widget.contest));
                                                  //       // } else {
                                                  //       //   widget.model
                                                  //       //           .onJoinContestResult =
                                                  //       //       onJoinContestResult;
                                                  //       //   widget.model
                                                  //       //           .contest =
                                                  //       //       widget
                                                  //       //           .contest;
                                                  //       //   Get.bottomSheet(
                                                  //       //       MultipleContestScreen(
                                                  //       //         widget
                                                  //       //             .currentContestIndex,
                                                  //       //         widget
                                                  //       //             .contest,
                                                  //       //         JoinChallengeDataModel(
                                                  //       //             context,
                                                  //       //             0,
                                                  //       //             int.parse(userId),
                                                  //       //             widget.contest.id!,
                                                  //       //             widget.model.fantasyType!,
                                                  //       //             // widget.model.slotId!,
                                                  //       //             1,
                                                  //       //             widget.contest.is_bonus!,
                                                  //       //             widget.contest.win_amount!,
                                                  //       //             widget.contest.maximum_user!,
                                                  //       //             widget.model.teamId.toString(),
                                                  //       //             widget.contest.entryfee.toString(),
                                                  //       //             widget.model.matchKey!,
                                                  //       //             widget.model.sportKey!,
                                                  //       //             widget.model.joinedSwitchTeamId.toString(),
                                                  //       //             false,
                                                  //       //             0,
                                                  //       //             0,
                                                  //       //             onJoinContestResult,
                                                  //       //             widget.contest),
                                                  //       //         widget
                                                  //       //             .model
                                                  //       //             .teamCount,
                                                  //       //         widget
                                                  //       //             .onTeamCreated,
                                                  //       //         onJoinContestResult:
                                                  //       //             onJoinContestResult,
                                                  //       //       ),
                                                  //       //       isScrollControlled: true);
                                                  //       // }
                                                  //     } else if (widget
                                                  //             .model
                                                  //             .teamCount! >
                                                  //         0)
                                                  //       navigateToMyJoinTeams(
                                                  //           widget
                                                  //               .currentContestIndex,
                                                  //           context,
                                                  //           widget
                                                  //               .model,
                                                  //           widget
                                                  //               .contest,
                                                  //           onJoinContestResult);
                                                  //     else if (joinplus ==
                                                  //             'JOIN+' &&
                                                  //         widget.model
                                                  //                 .teamCount! >
                                                  //             0) {
                                                  //       widget.model
                                                  //               .isSwitchTeam =
                                                  //           false;
                                                  //       navigateToMyJoinTeams(
                                                  //           widget
                                                  //               .currentContestIndex,
                                                  //           context,
                                                  //           widget
                                                  //               .model,
                                                  //           widget
                                                  //               .contest,
                                                  //           onJoinContestResult);
                                                  //     } else {
                                                  //       widget.model
                                                  //               .onJoinContestResult =
                                                  //           onJoinContestResult;
                                                  //       widget.model
                                                  //               .contest =
                                                  //           widget
                                                  //               .contest;
                                                  //       widget.model
                                                  //               .onTeamCreated =
                                                  //           onTeamCreated;
                                                  //       Platform.isAndroid
                                                  //           ? Navigator.push(
                                                  //               context,
                                                  //               MaterialPageRoute(
                                                  //                   builder: (context) => CreateTeam(
                                                  //                         widget.model,
                                                  //                         onTeamCreated: widget.onTeamCreated,
                                                  //                       ))).then((value) {
                                                  //               setState(
                                                  //                   () {
                                                  //                 if (widget.onTeamCreated !=
                                                  //                     null) {
                                                  //                   widget.onTeamCreated!();
                                                  //                 }
                                                  //               });
                                                  //             })
                                                  //           : Navigator.push(
                                                  //               context,
                                                  //               CupertinoPageRoute(
                                                  //                   builder: (context) => CreateTeam(
                                                  //                         widget.model,
                                                  //                         onTeamCreated: widget.onTeamCreated,
                                                  //                       ))).then((value) {
                                                  //               setState(
                                                  //                   () {
                                                  //                 if (widget.onTeamCreated !=
                                                  //                     null) {
                                                  //                   widget.onTeamCreated!();
                                                  //                 }
                                                  //               });
                                                  //             });
                                                  //       // navigateToCreateTeam(
                                                  //       //   context,
                                                  //       //   widget.model,
                                                  //       //   onTeamCreated:
                                                  //       //       widget
                                                  //       //           .onTeamCreated,
                                                  //       // );
                                                  //     }
                                                  //   }
                                                  // },
                                                  onTap: () async {
                                                    joinContestgreen();
                                                  },
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18, vertical: 8),
                                            child: BarProgress(
                                              percentage:
                                                  // widget.contest
                                                  //             .challenge_type ==
                                                  //         'percentage'
                                                  //     ? 0.5
                                                  //     :
                                                  double.parse((widget.contest
                                                                  .joinedusers! /
                                                              widget.contest
                                                                  .maximum_user!)
                                                          .toString()) *
                                                      100,
                                              backColor: Color(0xffF1E7FF),
                                              gradient: LinearGradient(
                                                  begin: Alignment.center,
                                                  end: Alignment.centerRight,
                                                  colors: [
                                                    Color(0xffA66DFB),
                                                    Color(0xffA66DFB)
                                                  ]),
                                              showPercentage: false,
                                              //textStyle: TextStyle(color: Colors.orange, fontSize: 70),
                                              stroke: 4.5,
                                              round: true,
                                            ),
                                          ),

                                          // new Container(
                                          //   margin: EdgeInsets.only(
                                          //       left: 10, right: 5),
                                          //   child: new CustomProgressIndicator(
                                          //       widget.contest.challenge_type ==
                                          //               'percentage'
                                          //           ? 0.5
                                          //           : double.parse((widget.contest
                                          //                       .joinedusers! /
                                          //                   widget.contest
                                          //                       .maximum_user!)
                                          //               .toString())),
                                          // ),

                                          !(widget.model.isFromLiveFinish ??
                                                  false)
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0,
                                                          right: 8,
                                                          left: 8),
                                                  child: new Container(
                                                    height: 20,
                                                    margin: EdgeInsets.only(
                                                        top: 0,
                                                        bottom: 5,
                                                        left: 10,
                                                        right: 5),
                                                    child: ((widget.contest
                                                                    .joinedusers!) -
                                                                (widget.contest
                                                                    .maximum_user!)) ==
                                                            0
                                                        ? Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 2),
                                                            child: Text(
                                                              "Challange Closed",
                                                              style: TextStyle(
                                                                  //fontFamily: "Roboto",
                                                                  color: widget
                                                                              .contest
                                                                              .is_flexible ==
                                                                          1
                                                                      ? Colors
                                                                          .grey
                                                                      : primaryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12),
                                                            ))
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              new Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            2),
                                                                child: Text(
                                                                  // widget.contest
                                                                  //             .challenge_type ==
                                                                  //         'percentage'
                                                                  //     ? widget.contest
                                                                  //             .joinedusers!
                                                                  //             .toString() +
                                                                  //         '/'
                                                                  //     :
                                                                  widget.contest
                                                                              .is_flexible ==
                                                                          1
                                                                      ? widget.contest
                                                                              .joinedusers!
                                                                              .toString() +
                                                                          '/' +
                                                                          widget
                                                                              .contest
                                                                              .maximum_user!
                                                                              .toString()
                                                                      : widget.contest.maximum_user! - widget.contest.joinedusers! >
                                                                              0
                                                                          ? NumberFormat.decimalPattern('hi').format(widget.contest.maximum_user! - widget.contest.joinedusers!).toString() +
                                                                              ' Spots Left'
                                                                          : 'Challenge Closed',
                                                                  style: TextStyle(
                                                                      // fontFamily: "Roboto",
                                                                      color: greenColor,
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 12),
                                                                ),
                                                              ),
                                                              new Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            5),
                                                                child: Text(
                                                                  widget.contest
                                                                              .is_flexible ==
                                                                          1
                                                                      ? ''
                                                                      : NumberFormat.decimalPattern('hi')
                                                                              .format(widget.contest.maximum_user!)
                                                                              .toString() +
                                                                          ' Spots',
                                                                  style: TextStyle(
                                                                      //fontFamily: "Roboto",
                                                                      color: Color(0xff333333),
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 12),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                  ),
                                                )
                                              : Container(),

                                          //divider
                                          Container(
                                            height: 1,
                                            color: primaryColor,
                                          ),
                                          Container(
                                            width: MediaQuery.sizeOf(context)
                                                .width,
                                            padding:
                                                widget.contest.is_gadget == 1
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
                                                        color: Color(
                                                            0xFFF1E7FF)))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                // widget.contest.challenge_type !=
                                                //         'percentage'
                                                //     ?
                                                widget.contest.is_gadget == 1
                                                    ? Container()
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 10),
                                                        child: Row(
                                                          children: [
                                                            Image(
                                                              image: AssetImage(
                                                                  AppImages
                                                                      .winnerMedalIcon),
                                                              height: 14,
                                                              color: Color(
                                                                  0XFF666666),
                                                            ),
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Container(
                                                              height: 14,
                                                              width: 14,
                                                              child: Image.asset(
                                                                  AppImages
                                                                      .goldcoin),
                                                            ),
                                                            SizedBox(
                                                              width: 3,
                                                            ),
                                                            Text(
                                                                // ' ₹' +
                                                                widget.contest
                                                                    .first_rank_prize!
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    //fontFamily: "Roboto",
                                                                    color: textCol,
                                                                    fontWeight: FontWeight.normal,
                                                                    fontSize: 12)),
                                                          ],
                                                        ),
                                                      ),
                                                // : Container(),/
                                                // SizedBox(
                                                //   width: 10,
                                                // ),
                                                widget.contest.multi_entry == 1
                                                    ? Row(
                                                        children: [
                                                          Image(
                                                            image: AssetImage(
                                                              AppImages
                                                                  .multiEntry,
                                                            ),
                                                            height: 14,
                                                            color: Color(
                                                                0XFF666666),
                                                          ),
                                                          SizedBox(
                                                            width: 3,
                                                          ),
                                                          new Text(
                                                              'Upto ' +
                                                                  widget.contest
                                                                      .max_multi_entry_user!
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  // fontFamily: "Roboto",
                                                                  color:
                                                                      textCol,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize:
                                                                      12)),
                                                        ],
                                                      )
                                                    : Container(),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                GestureDetector(
                                                  behavior: HitTestBehavior
                                                      .translucent,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image(
                                                        image: AssetImage(
                                                          AppImages.winnersIcon,
                                                        ),
                                                        height: 14,
                                                        color:
                                                            Color(0XFF666666),
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                          widget.contest
                                                                      .challenge_type ==
                                                                  'percentage'
                                                              ? widget.contest
                                                                      .winning_percentage
                                                                      .toString() +
                                                                  '% Win'
                                                              : widget.contest
                                                                      .totalwinners
                                                                      .toString() +
                                                                  ' Winner',
                                                          style: TextStyle(
                                                              //  fontFamily: "Roboto",
                                                              color: textCol,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 12)),
                                                    ],
                                                  ),
                                                  // onTap: () {
                                                  //   widget.getWinnerPriceCard(
                                                  //       widget.contest.id,
                                                  //       widget
                                                  //           .contest.win_amount);
                                                  // },
                                                ),
                                                Spacer(),
                                                widget.contest
                                                            .confirmed_challenge ==
                                                        1
                                                    ? Container(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            new Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 7,
                                                                      right: 5),
                                                              height: 14,
                                                              width: 14,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              // decoration: BoxDecoration(
                                                              //     color: Color(0XFFf7f7f7),
                                                              //     border:
                                                              //         Border.all(color: Color(0xFF969696)),
                                                              //     borderRadius: BorderRadius.circular(20)),
                                                              child: Image(
                                                                image:
                                                                    AssetImage(
                                                                  AppImages
                                                                      .confirmIcon,
                                                                ),
                                                                color: Color(
                                                                    0XFF666666),
                                                              ),
                                                            ),
                                                            Text('Guaranteed',
                                                                style: TextStyle(
                                                                    //fontFamily: "Roboto",
                                                                    color: textCol,
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: 12)),
                                                          ],
                                                        ),
                                                      )
                                                    : SizedBox.shrink(),
                                                widget.contest.is_flexible == 1
                                                    ? Container(
                                                        margin: EdgeInsets.only(
                                                            right: 5),
                                                        child: Text(
                                                          'Flexible',
                                                          style: TextStyle(
                                                              // fontFamily: "Roboto",
                                                              color: textCol,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 12),
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
                              (widget.contest.maximum_user! -
                                              widget.contest.joinedusers! >
                                          0) &&
                                      !(widget.model.isFromLiveFinish ?? false)
                                  ? Visibility(
                                      visible:
                                          !(widget.model.isFromLive ?? false),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 0),
                                        child: GestureDetector(
                                          onTap: ((widget.contest
                                                          .joinedusers!) -
                                                      (widget.contest
                                                          .maximum_user!)) ==
                                                  0
                                              ? null
                                              : () async {
                                                  joinContestRed();
                                                },
                                          child: new Container(
                                              color: buttonGreenColor,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 45,
                                              child:
                                                  Center(child: btnJoinText())),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: DefaultTabController(
                                    length: 2,
                                    child: Scaffold(
                                      backgroundColor: Colors.white,
                                      appBar: PreferredSize(
                                        preferredSize: Size.fromHeight(55),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 1), // 👈 Divider line
                                            ),
                                          ),
                                          child: TabBar(
                                            labelPadding: EdgeInsets.all(0),
                                            onTap: (int index) {
                                              setState(() {
                                                _currentMatchIndex = index;
                                                if (_currentMatchIndex == 0) {
                                                  getWinnerPriceCard();
                                                } else {
                                                  getLeaderboardList();
                                                }
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
                                            tabs: getTabs(),
                                          ),
                                        ),
                                      ),
                                      body: _currentMatchIndex == 0
                                          ? new WinningBreakups(breakupList)
                                          : new Leaderboard(
                                              totalIcon,
                                              leaderboardList,
                                              userId,
                                              true,
                                              widget.contest.pdf!,
                                              widget.model,
                                              currentContestIndex:
                                                  widget.currentContestIndex,
                                              isLeaderboardCall:
                                                  isLeaderboardCall,
                                              getLeaderboardList:
                                                  getLeaderboardList),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              onWillPop: _onWillPop)),
    );
  }

  Future<bool> _onWillPop() async {
    setState(() {
      if (widget.onResume != null) {
        widget.onResume!();
      }
      Navigator.pop(context);
    });
    return Future.value(false);
  }

  List<Widget> getTabs() {
    tabs.clear();
    tabs.add(getWinningTab());
    tabs.add(getLeaderboardTab());

    return tabs;
  }

  Widget getWinningTab() {
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
          'Winning Breakup',
          style: TextStyle(
              // fontFamily: "Roboto",
              color: _currentMatchIndex == 0 ? primaryColor : Colors.grey,
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
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Text(
          'Leaderboard',
          style: TextStyle(
              // fontFamily: "Roboto",
              color: _currentMatchIndex == 1 ? primaryColor : Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 14),
        ),
      ),
    );
  }

  void favouriteContest() async {
    AppLoaderProgress.showLoader(context);
    GeneralRequest request = new GeneralRequest(
      user_id: userId,
      challenge_id:
          "${widget.contest.real_challenge_id ?? widget.contest.challenge_id}",
      my_fav_contest: (widget.contest.is_fav_contest == 1 ? 0 : 1).toString(),
    );

    final client = ApiClient(AppRepository.dio);
    GeneralResponse response = await client.getFavouriteContest(request);

    if (response.status == 1) {
      widget.contest.is_fav_contest =
          widget.contest.is_fav_contest == 1 ? 0 : 1;
    }

    Fluttertoast.showToast(
        msg: response.message!,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1);
    setState(() {
      AppLoaderProgress.hideLoader(context);
    });
  }

  void getWinnerPriceCard() async {
    AppLoaderProgress.showLoader(context);

    ContestRequest request = new ContestRequest(
      user_id: userId,
      fantasy_type_id: CricketTypeFantasy.getCricketType(
          widget.model.fantasyType.toString(),
          sportsKey: widget.model
              .sportKey) /*widget.model.fantasyType==1?"7":widget.model.fantasyType==2 ?"6":"0"*/,
      challenge_id: widget.contest.id.toString(),
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
      totalIcon = response.result!.totaljoin;
      if (response.pages_status == "0" || response.pages_status == 0) {
        leaderboardList = response.result!.contest!;
        page = 0;
      } else {
        isLeaderboardCall = response.pages_status;
        leaderboardList.addAll(response.result!.contest!);
      }
    }

    // Fluttertoast.showToast(msg: response.message, toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 1);
    setState(() {
      AppLoaderProgress.hideLoader(context);
    });
  }

  void onJoinContestResult(int isJoined, String referCode, {String? check}) {
    widget.contest.isjoined = true;
    widget.contest.refercode = referCode;
    widget.contest.joinedusers = widget.contest.joinedusers! + 1;
    getLeaderboardList();

    if (widget.contest.multi_entry == 1) {
      Navigator.pop(context);
    }
    if (Platform.isIOS) {
      AppConstants.callTimer();
    }
    // widget.model.onJoinContestResult!(widget.contest.joinedusers,widget.contest.refercode);
    // Navigator.pop(context);
    setState(() {});
  }

  void onTeamCreated() {
    widget.model.teamCount = widget.model.teamCount! + 1;
    if (Platform.isIOS) {
      AppConstants.callTimer();
    }
    setState(() {});
  }

  void onSwitchTeam(int id) {
    widget.model.isSwitchTeam = true;
    widget.model.joinedSwitchTeamId = id;
    Platform.isAndroid
        ? Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyJoinTeams(
                    widget.currentContestIndex,
                    widget.model,
                    widget.contest,
                    onJoinContestResult))).then((value) {
            setState(() {
              widget.model.isSwitchTeam = false;
              // leaderboardList.clear();
              // getLeaderboardList(currentPage);
            });
          })
        : Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => MyJoinTeams(
                    widget.currentContestIndex,
                    widget.model,
                    widget.contest,
                    onJoinContestResult))).then((value) {
            setState(() {
              widget.model.isSwitchTeam = false;
              // leaderboardList.clear();
              // getLeaderboardList(currentPage);
            });
          });
    // navigateToMyJoinTeams(widget.currentContestIndex, context, widget.model,
    //     widget.contest, onJoinContestResult);
  }

  void onSwitchTeamResult() {
    getLeaderboardList();
    if (Platform.isIOS) {
      AppConstants.callTimer();
    }
  }

  void getWinnerPriceCardSheet(int id, String winAmount) async {
    AppLoaderProgress.showLoader(context);
    ContestRequest request = new ContestRequest(
      user_id: userId,
      challenge_id: id.toString(),
      matchkey: widget.model.matchKey,
    );

    final client = ApiClient(AppRepository.dio);
    ScoreCardResponse response = await client.getWinnersPriceCard(request);

    if (response.status == 1) {
      breakupList = response.result!;
      MethodUtils.showWinningPopup(context, breakupList, winAmount);
    }

    setState(() {
      AppLoaderProgress.hideLoader(context);
    });
  }

  joinContestgreen() {
    if ((btnEntryText() as Text).data == 'INVITE') {
      MethodUtils.onShare(context, widget.contest, widget.model);
    } else if ((btnEntryTextforJoin() as Text).data == 'JOIN+') {
      navigateToMyJoinTeams(widget.currentContestIndex, context, widget.model,
          widget.contest, onJoinContestResult,
          joinSimilar: widget.joinSimilar);
    } else {
      if (widget.model.teamCount == 1) {
        widget.model.onJoinContestResult = onJoinContestResult;
        widget.model.contest = widget.contest;
        MethodUtils.checkBalance(
          widget.currentContestIndex,
          new JoinChallengeDataModel(
              context,
              0,
              int.parse(userId),
              widget.contest.id!,
              widget.model.fantasyType!,
              //   widget.model.slotId!,
              1,
              widget.contest.is_bonus!,
              widget.contest.win_amount!,
              widget.contest.maximum_user!,
              widget.model.teamId.toString(),
              widget.contest.entryfee.toString(),
              widget.model.matchKey!,
              widget.model.sportKey!,
              widget.model.joinedSwitchTeamId.toString(),
              false,
              0,
              0,
              onJoinContestResult,
              widget.contest),
          joinSimilar: widget.joinSimilar,
        );
      } else if (widget.model.teamCount! > 0) {
        navigateToMyJoinTeams(
          widget.currentContestIndex,
          context,
          widget.model,
          widget.contest,
          onJoinContestResult,
          joinSimilar: widget.joinSimilar,
        );
      } else {
        widget.model.onJoinContestResult = onJoinContestResult;
        widget.model.contest = widget.contest;
        widget.model.onTeamCreated = onTeamCreated;
        Platform.isAndroid
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateTeam(
                          widget.model,
                          onTeamCreated: widget.onTeamCreated,
                          joinSimilar: widget.joinSimilar,
                        ))).then((value) {
                setState(() {
                  if (widget.onTeamCreated != null) {
                    widget.onTeamCreated!();
                  }
                  leaderboardList.clear();
                  getLeaderboardList();
                });
              })
            : Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => CreateTeam(
                          widget.model,
                          onTeamCreated: widget.onTeamCreated,
                          joinSimilar: widget.joinSimilar,
                        ))).then((value) {
                setState(() {
                  if (widget.onTeamCreated != null) {
                    widget.onTeamCreated!();
                  }
                  leaderboardList.clear();
                  getLeaderboardList();
                });
              });
        // navigateToCreateTeam(
        //   context,
        //   widget.model,
        //   onTeamCreated:
        //       widget
        //           .onTeamCreated,
        // );
      }
    }
  }

  joinContestRed() {
    if ((btnEntryText() as Text).data == 'INVITE') {
      MethodUtils.onShare(context, widget.contest, widget.model);
    } else if ((btnEntryTextforJoin() as Text).data == 'JOIN+') {
      Platform.isAndroid
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyJoinTeams(
                      widget.currentContestIndex,
                      widget.model,
                      widget.contest,
                      onJoinContestResult))).then((value) {
              setState(() {
                // if (widget.onTeamCreated != null) {
                //   widget.onTeamCreated!();
                // }
              });
            })
          : Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => MyJoinTeams(
                      widget.currentContestIndex,
                      widget.model,
                      widget.contest,
                      onJoinContestResult))).then((value) {
              setState(() {});
            });
      // navigateToMyJoinTeams(widget.currentContestIndex, context, widget.model,
      //     widget.contest, onJoinContestResult);
    } else {
      if (widget.model.teamCount == 1) {
        widget.model.onJoinContestResult = onJoinContestResult;
        widget.model.contest = widget.contest;
        MethodUtils.checkBalance(
            widget.currentContestIndex,
            new JoinChallengeDataModel(
              context,
              0,
              int.parse(userId),
              widget.contest.id!,
              widget.model.fantasyType!,
              //   widget.model.slotId!,
              1,
              widget.contest.is_bonus!,
              widget.contest.win_amount!,
              widget.contest.maximum_user!,
              widget.model.teamId.toString(),
              widget.contest.entryfee.toString(),
              widget.model.matchKey!,
              widget.model.sportKey!,
              widget.model.joinedSwitchTeamId.toString(),
              false,
              0,
              0,
              onJoinContestResult,
              widget.contest,
            ),
            joinSimilar: widget.joinSimilar);
      } else if (widget.model.teamCount! > 0) {
        navigateToMyJoinTeams(
          widget.currentContestIndex,
          context,
          widget.model,
          widget.contest,
          onJoinContestResult,
          joinSimilar: widget.joinSimilar,
        );
      } else {
        widget.model.onJoinContestResult = onJoinContestResult;
        widget.model.contest = widget.contest;
        widget.model.onTeamCreated = onTeamCreated;
        Platform.isAndroid
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateTeam(
                          widget.model,
                          onTeamCreated: widget.onTeamCreated,
                          joinSimilar: widget.joinSimilar,
                        ))).then((value) {
                setState(() {
                  if (widget.onTeamCreated != null) {
                    widget.onTeamCreated!();
                  }
                });
              })
            : Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => CreateTeam(
                          widget.model,
                          onTeamCreated: widget.onTeamCreated,
                          joinSimilar: widget.joinSimilar,
                        ))).then((value) {
                setState(() {
                  if (widget.onTeamCreated != null) {
                    widget.onTeamCreated!();
                  }
                });
              });
        // navigateToCreateTeam(
        //   context,
        //   widget.model,
        //   onTeamCreated:
        //       widget
        //           .onTeamCreated,
        // );
      }
    }
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

                  // Handle button action here
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
