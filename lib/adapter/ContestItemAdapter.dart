import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myrex11/dataModels/get_offer_response.dart';
import 'package:myrex11/main.dart';
import 'package:myrex11/repository/model/base_request.dart';
import 'package:myrex11/repository/model/base_response.dart';
import 'package:myrex11/views/CreateTeam.dart';
import 'package:myrex11/views/MyJoinTeams.dart';
import 'package:myrex11/views/UpcomingContestDetails.dart';
import 'package:myrex11/views/flexible/flexible_ui.dart';
import 'package:intl/intl.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/app_navigator.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/dataModels/JoinChallengeDataModel.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/category_contest_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';
import 'package:need_resume/need_resume.dart';
import 'package:progress_indicator/progress_indicator.dart';
import '../appUtilities/app_constants.dart';

class ContestItemAdapter extends StatefulWidget {
  Contest contest;
  GeneralModel model;
  Function onJoinContestResult;
  String userId;
  Function getWinnerPriceCard;
  Function onTeamCreated;
  Function? onResume;
  bool? isMyContest;
  int? challengeId;
  double? scrollPotion;
  int? _contestItemIndex;
  String? screenCheck;

  ContestItemAdapter(
      this._contestItemIndex,
      this.model,
      this.contest,
      this.onJoinContestResult,
      this.userId,
      this.getWinnerPriceCard,
      this.onTeamCreated,
      {this.onResume,
      this.isMyContest,
      this.challengeId,
      this.scrollPotion,
      this.screenCheck});

  @override
  _ContestItemAdapterState createState() => new _ContestItemAdapterState();
}

class _ContestItemAdapterState extends ResumableState<ContestItemAdapter> {
  GetOfferResponse? offerResponse;
  GlobalKey btnKey = GlobalKey();
  GlobalKey btnKey1 = GlobalKey();
  GlobalKey btnKey2 = GlobalKey();
  GlobalKey btnKey3 = GlobalKey();
  late LocationPermission permission;

  String joinplus = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget btnEntryText() {
    return new Text(
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
      // (widget.contest.maximum_user! - widget.contest.joinedusers!) == 0
      //     ? '₹' + "${widget.contest.entryfee}"
      //     : widget.contest.is_free == 1 ||
      //             widget.contest.is_first_time_free == 1
      //         ? 'FREE'
      //         : widget.contest.max_team_limit_exceeded_count != null &&
      //                 widget.contest.max_team_limit_exceeded_count! >
      //                     0 /*&& widget.contest.isjoined != null
      //     && widget.contest.isjoined!*/
      //             ? widget.contest.multi_entry == 1
      //                 ? 'JOIN+'
      //                 : 'INVITE'
      //             : '₹' + "${widget.contest.entryfee}",
      style: TextStyle(
        // fontFamily: "Roboto",
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
        fontFamily: "Roboto",
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
      // (widget.contest.maximum_user! - widget.contest.joinedusers!) == 0
      //     ? '₹' + widget.contest.entryfee.toString()
      //     : widget.contest.is_free == 1 ||
      //             widget.contest.is_first_time_free == 1
      //         ? 'FREE'
      //         : widget.contest.isjoined != null && widget.contest.isjoined!
      //             ? widget.contest.multi_entry == 1
      //                 ? 'JOIN+'
      //                 : 'INVITE'
      //             : '₹' + widget.contest.entryfee.toString(),
      style: TextStyle(
        // fontFamily: 'noway',
        fontSize: 12, color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    if ((widget.model.teamCount ?? 0) > 0) {
      if (widget.contest.multi_entry == 1 &&
          (widget.contest.max_team_limit_exceeded_count ?? 0) <
              (widget.contest.max_multi_entry_user ?? 0)) {
        setState(() {
          joinplus = 'JOIN+';
        });
      }
    }

    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Container(
          padding: EdgeInsets.only(left: 0, right: 0, top: 0),
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 2,
            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Circular radius
              side: BorderSide(
                  color: Color(0xffE1E1E1),
                  width: 0.7), // Border color and width
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 5, left: 5),
                      child: Column(
                        children: [
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Current Prize Pool',
                                              style: TextStyle(
                                                  //fontFamily: "Roboto",
                                                  color: Color(0xff3a3a3a),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            widget.contest.is_offer_team == 1
                                                ? GestureDetector(
                                                    onTap: () {
                                                      getOffer(
                                                          "${widget.contest.id}");
                                                    },
                                                    child: Image.asset(
                                                      AppImages.offer,
                                                      scale: 3,
                                                    ))
                                                : Container()
                                          ],
                                        ),
                                      ],
                                    ),
                                    widget.contest.is_gadget == 1
                                        ? Container(
                                            height: 48,
                                            width: 48,
                                            child: Image.network(
                                              widget.contest.gadget_image ?? '',
                                              fit: BoxFit.contain,
                                            ))
                                        : Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6),
                                                child: Container(
                                                  height: 18,
                                                  width: 18,
                                                  child: Image.asset(
                                                      AppImages.goldcoin),
                                                ),
                                              ),
                                              new Container(
                                                height: 30,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  (widget.contest
                                                              .is_giveaway_visible_text ==
                                                          0
                                                      ? "${widget.contest.win_amount}"
                                                      : widget.contest
                                                          .is_giveaway_text!),
                                                  style: TextStyle(
                                                      fontFamily: "Roboto",
                                                      color: widget.contest
                                                                  .is_giveaway_visible_text ==
                                                              0
                                                          ? Colors.black
                                                          : MethodUtils
                                                              .hexToColor(widget
                                                                  .contest
                                                                  .giveaway_color!),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ],
                                          )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 5, top: 10),
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      children: [
                                        new Container(
                                          margin: EdgeInsets.only(right: 5),
                                          child: Text(
                                            'Entry Fee',
                                            style: TextStyle(
                                                // fontFamily: "Roboto",
                                                color: Color(0xff414141),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12),
                                          ),
                                        ),
                                        widget.contest.is_free_for_referrer ==
                                                    1 &&
                                                widget.contest.is_free_for_me ==
                                                    1
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 2),
                                                child: Text(
                                                  // '₹' +
                                                  widget.contest.real_entry_fees
                                                      .toString(),
                                                  style: TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    // fontFamily: "Roboto",
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: greenColor,
                                                    //  fontFamily: "Roboto",
                                                  ),
                                                ),
                                              )
                                            : Container()
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          child: new Container(
                                            alignment: Alignment.centerRight,
                                            child: new Card(
                                              color: /*widget.contest.real_entry_fees!=null && widget.contest.real_entry_fees!=0 ? primaryColor :*/
                                                  Color(0xff076e39),
                                              child: new Container(
                                                height: 28,
                                                width: 70,
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 5),
                                                      child: Container(
                                                        height: 14,
                                                        width: 14,
                                                        child: Image.asset(
                                                            AppImages.goldcoin),
                                                      ),
                                                    ),
                                                    btnEntryText(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: ((widget.contest
                                                          .joinedusers!) -
                                                      (widget.contest
                                                          .maximum_user!)) ==
                                                  0
                                              ? null
                                              : () async {
                                                  joinFunction();

                                                  /* if (widget.model.isaccountverified == true) {
                                     if ((btnEntryText() as Text).data ==
                                         'INVITE') {
                                       MethodUtils.onShare(context,
                                           widget.contest, widget.model);
                                     } else if ((btnEntryText() as Text)
                                             .data ==
                                         'JOIN+') {
                                       navigateToMyJoinTeams(
                                           context,
                                           widget.model,
                                           widget.contest,
                                           widget.onJoinContestResult);
                                     } else {
                                       if (widget.model.teamCount == 1) {
                                         MethodUtils.checkBalance(
                                             new JoinChallengeDataModel(
                                                 context,
                                                 0,
                                                 int.parse(widget.userId),
                                                 widget.contest.id!,
                                                 widget.model.fantasyType!,
                                                 widget.model.slotId!,
                                                 1,
                                                 widget.contest.is_bonus!,
                                                 widget.contest.win_amount!,
                                                 widget
                                                     .contest.maximum_user!,
                                                 widget.model.teamId
                                                     .toString(),
                                                 widget.contest.entryfee
                                                     .toString(),
                                                 widget.model.matchKey!,
                                                 widget.model.sportKey!,
                                                 .joinedSwitchTeamId
                                                   .toString(),
                                                 false,
                                                 0,
                                                 0,
                                                 widget
                                                     .onJoinContestResult));
                                       } else if (widget.model.teamCount! >
                                           0) {
                                         navigateToMyJoinTeams(
                                             context,
                                             widget.model,
                                             widget.contest,
                                             widget.onJoinContestResult);
                                       } else {
                                         widget.model.onJoinContestResult =
                                             widget.onJoinContestResult;
                                         widget.model.contest =
                                             widget.contest;
                                         navigateToCreateTeam(
                                           context,
                                           widget.model,
                                           onTeamCreated:
                                               widget.onTeamCreated,
                                         );
                                       }
                                     }
                                   } else {
                                     Fluttertoast.showToast(
                                         msg:
                                             'Please verify your account to join contests',
                                         toastLength: Toast.LENGTH_SHORT,
                                         timeInSecForIosWeb: 1);
                                     navigateToVerifyAccountDetail(context);
                                   }*/
                                                },
                                        ),
                                      ],
                                    ),
                                    /* widget.contest.real_entry_fees!=null && widget.contest.real_entry_fees!=0 ?
                                  Container(
                                      margin: EdgeInsets.only(right: 85,bottom: 0),
                                      alignment: Alignment.topRight,
                                      child: Text("Discount",style: TextStyle(color: Color(0xffe6ad00),fontWeight: FontWeight.bold,fontSize: 16),)): SizedBox.shrink(),
*/
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    widget.contest.bonus_percent != null &&
                            widget.contest.is_bonus != 0
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Container(
                                  // width: MediaQuery.of(context).size.width * 0.32,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                      color: greenColorBonusShadow,
                                      borderRadius: BorderRadius.circular(14)),
                                  alignment: Alignment.centerRight,
                                  margin: EdgeInsets.only(top: 5, right: 5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    // mainAxisAlignment: MainAxisAlignment.center,
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
                                          color: greenIconColor,
                                          fontSize: 12,
                                          fontFamily: "Roboto",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
                  ],
                ),
                // widget.contest.multi_entry != 1 &&
                //         widget.contest.is_join_similar_contest == 1
                //     ? Container(
                //         margin: EdgeInsets.only(right: 20),
                //         alignment: Alignment.centerRight,
                //         child: Icon(
                //           Icons.currency_exchange,
                //           size: 16,
                //         ))
                //     : SizedBox.shrink(),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: BarProgress(
                    percentage: double.parse((widget.contest.joinedusers! /
                                widget.contest.maximum_user!)
                            .toString()) *
                        100,
                    backColor: Color(0xffF1E7FF),
                    gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.centerRight,
                        colors: [Color(0xffA66DFB), Color(0xffA66DFB)]),
                    showPercentage: false,

                    //textStyle: TextStyle(color: Colors.orange, fontSize: 70),
                    stroke: 4.5,
                    round: true,
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.only(left: 10, right: 10),
                //   child: new CustomProgressIndicator(
                //       widget.contest.challenge_type == 'percentage'
                //           ? 0.5
                //           : double.parse((widget.contest.joinedusers! /
                //                   widget.contest.maximum_user!)
                //               .toString())),
                // ),
                Container(
                  height: 20,
                  margin: EdgeInsets.only(top: 0, left: 10, right: 10),
                  child: ((widget.contest.joinedusers!) -
                              (widget.contest.maximum_user!)) ==
                          0
                      ? Container(
                          margin: EdgeInsets.only(left: 2),
                          child: Text(
                            "Challenge Closed",
                            style: TextStyle(
                                // fontFamily: "Roboto",
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          ))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 2),
                              child: Text(
                                // widget.contest.challenge_type == 'percentage'
                                //     ? widget.contest.joinedusers!.toString() +
                                //         '/'
                                //     // :
                                //     //  widget.contest.is_flexible == 1
                                //     //     ? widget.contest.joinedusers!.toString() +
                                //     //         '/' +
                                //     //         widget.contest.maximum_user!.toString()
                                //     :
                                widget.contest.maximum_user! -
                                            widget.contest.joinedusers! >
                                        0
                                    ? NumberFormat.decimalPattern('hi').format(
                                            widget.contest.maximum_user! -
                                                widget.contest.joinedusers!) +
                                        ' Spots Left'
                                    : 'Challenge Closed',
                                style: TextStyle(
                                    // fontFamily: "Roboto",
                                    color: Color(0xff3F8F54),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 5),
                              child: Text(
                                // widget.contest.is_flexible == 1
                                //     ? ''
                                //     :
                                NumberFormat.decimalPattern('hi')
                                        .format(widget.contest.maximum_user!) +
                                    ' Spots',
                                style: TextStyle(
                                    // fontFamily: "Roboto",
                                    color: Color(0xFF414141),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                ),
                Container(
                  padding: widget.contest.is_gadget == 1
                      ? const EdgeInsets.only(
                          right: 10, left: 5, top: 5, bottom: 5)
                      : const EdgeInsets.only(
                          right: 10, left: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                      color: Color(0xFFF1E7FF),
                      border:
                          Border(top: BorderSide(color: Color(0xffF1E7FF)))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // widget.contest.challenge_type != 'percentage'
                      //     ?
                      widget.contest.is_gadget == 1
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(
                                  right: 10, top: 8, bottom: 8),
                              child: Row(
                                children: [
                                  Image(
                                    image:
                                        AssetImage(AppImages.winnerMedalIcon),
                                    height: 14,
                                    color: Color(0XFF666666),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Container(
                                    height: 14,
                                    width: 14,
                                    child: Image.asset(AppImages.goldcoin),
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                      // ' ₹' +
                                      widget.contest.first_rank_prize!
                                          .toString(),
                                      style: TextStyle(
                                          // fontFamily: "Roboto",
                                          color: textCol,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                      // : Container(),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      widget.contest.multi_entry == 1
                          ? Row(
                              children: [
                                Image(
                                  image: AssetImage(
                                    AppImages.multiEntry,
                                  ),
                                  color: Color(0XFF666666),
                                  height: 14,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                new Text(
                                    'Upto ' +
                                        widget.contest.max_multi_entry_user!
                                            .toString(),
                                    style: TextStyle(
                                        // fontFamily: "Roboto",
                                        color: textCol,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12)),
                              ],
                            )
                          : Container(),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage(
                                AppImages.winnersIcon,
                              ),
                              color: Color(0XFF666666),
                              height: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              widget.contest.challenge_type == 'percentage'
                                  ? widget.contest.winning_percentage
                                          .toString() +
                                      '% Win'
                                  : widget.contest.totalwinners.toString() +
                                      ' Winner',
                              style: TextStyle(
                                  // fontFamily: "Roboto",
                                  color: textCol,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        onTap: () {
                          widget.getWinnerPriceCard(
                              widget.contest.id, widget.contest.win_amount);
                        },
                      ),
                      Spacer(),
                      widget.contest.confirmed_challenge == 1
                          ? Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  new Container(
                                    margin: EdgeInsets.only(left: 7, right: 5),
                                    height: 14,
                                    width: 14,
                                    alignment: Alignment.center,
                                    // decoration: BoxDecoration(
                                    //     color: Color(0XFFf7f7f7),
                                    //     border:
                                    //         Border.all(color: Color(0xFF969696)),
                                    //     borderRadius: BorderRadius.circular(20)),
                                    child: Image(
                                      image: AssetImage(
                                        AppImages.confirmIcon,
                                      ),
                                      color: Color(0XFF666666),
                                    ),
                                  ),
                                  Text('Guaranteed',
                                      style: TextStyle(
                                          // fontFamily: "Roboto",
                                          color: textCol,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12)),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                      widget.contest.is_flexible == 1
                          ? Container(
                              margin: EdgeInsets.only(right: 5),
                              child: Row(
                                children: [
                                  new Container(
                                    margin: EdgeInsets.only(left: 0, right: 5),
                                    height: 14,
                                    width: 14,
                                    alignment: Alignment.center,
                                    // decoration: BoxDecoration(
                                    //     color: Color(0XFFf7f7f7),
                                    //     border:
                                    //         Border.all(color: Color(0xFF969696)),
                                    //     borderRadius: BorderRadius.circular(20)),
                                    child: Image(
                                      image: AssetImage(
                                        AppImages.flexibleIcon,
                                      ),
                                      color: Color(0XFF666666),
                                    ),
                                  ),
                                  Text(
                                    'Flexible',
                                    style: TextStyle(
                                        // fontFamily: "Roboto",
                                        color: textCol,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),

                /*  new Container(
                color: Color(0xFFf7f7f7),
                // height: 35,
                // margin: EdgeInsets.only(top: 10),
                child: new Container(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: new Row(
                      children: [
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.contest.challenge_type != 'percentage' ? new Row(
                                    children: [
                                      new Container(
                                      margin: EdgeInsets.only(left: 5,),
                                        height: 22,
                                        width: 14,
                                        child: Image(
                                            image: AssetImage(AppImages
                                                .winnerMedalIcon)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: new Text(
                                            ' ₹' +
                                                widget.contest
                                                    .first_rank_prize!
                                                    .toString(),
                                            style: TextStyle(
                                                fontFamily: "Roboto",
                                                color: textcolor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12)),
                                      ),
                                    ],
                                  ) : new Container(),
                            new GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              child: new Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 7, right: 4),
                                    height: 20,
                                    width: 14,
                                    child: Image(
                                      image: AssetImage(
                                        AppImages.winnersIcon,
                                      ),
                                    ),
                                  ),
                                  Text(
                                      widget.contest.challenge_type == 'percentage'
                                          ? widget.contest.winning_percentage.toString() + '% Win'
                                          : widget.contest.totalwinners.toString() + ' Winner',
                                      style: TextStyle(
                                          fontFamily: "Roboto",
                                          color: textcolor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10)),
                                  Row(
                                    children: [
                                      widget.contest.is_bonus == 1 ?
                                      Row(
                                        children: [
                                          new Container(
                                            margin: EdgeInsets.only(left: 7, right: 2),
                                            height: 20,
                                            child: Image(image: AssetImage(AppImages.bonusIcon),
                                              //color: Color(0xFF969696),
                                            ),
                                          ),
                                          new Text(widget.contest.bonus_percent!,
                                              style: TextStyle(
                                                  fontFamily: "Roboto",
                                                  color: Color(0XFF969696),
                                                  fontWeight: FontWeight.w500, fontSize: 10)),
                                        ],
                                      ) : SizedBox.shrink(),
                                      widget.contest.multi_entry == 1 ?
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 7, right: 2),
                                            height: 14,
                                            width: 14,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color:
                                                Color(0XFFf7f7f7),
                                                border: Border.all(
                                                    color: Color(
                                                        0xFF969696)),
                                                borderRadius:
                                                BorderRadius
                                                    .circular(20)),
                                            child: new Text('M',
                                                style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    color: textcolor,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    fontSize: 10)),
                                          ),
                                          new Text(
                                              'Up to ' +
                                                  widget.contest
                                                      .max_multi_entry_user!
                                                      .toString(),
                                              style: TextStyle(
                                                  fontFamily: "Roboto",
                                                  color: Colors.grey,
                                                  fontWeight:
                                                  FontWeight.w500,
                                                  fontSize: 10)),
                                        ],
                                      ) : SizedBox.shrink(),

                                    ],
                                  )
                                ],
                              ),
                              onTap: () {
                                widget.getWinnerPriceCard(
                                    widget.contest.id,
                                    widget.contest.win_amount.toString());
                              },
                            ),
                          ],
                        ),
                        */ /*new Row(
                          children: [
                            // new Container(
                            //   margin: EdgeInsets.only(left: 7,right: 2),
                            //   height: 14,
                            //   padding: EdgeInsets.only(left: 2,right: 2),
                            //   alignment: Alignment.center,
                            //   decoration: BoxDecoration(
                            //       border: Border.all(color: Colors.grey),
                            //       borderRadius: BorderRadius.circular(2)
                            //   ),
                            //   child: new Text('WD',
                            //       style: TextStyle(
                            //           fontFamily: "Roboto",
                            //           color: Colors.grey,
                            //           fontWeight: FontWeight.w500,
                            //           fontSize: 10)),
                            // ),

                            widget.contest.confirmed_challenge == 1
                                ?
                            new Container(
                                    margin: EdgeInsets.only(
                                        left: 7, right: 5),
                                    height: 14,
                                    width: 14,
                                    alignment: Alignment.center,
                                    */ /**/ /*decoration: BoxDecoration(
                                        color: Color(0XFFf7f7f7),
                                        border: Border.all(
                                            color: Color(0xFF969696)),
                                        borderRadius:
                                            BorderRadius.circular(20)),*/ /**/ /*
                              child: Image(
                                      image: AssetImage(
                                        AppImages.confirmIcon,
                                      ),))
                                   */ /**/ /* new Text('C',
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            color: Color(0xFF969696),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10)),*/ /**/ /*

                                : new Container(),
                            */ /**/ /* widget.contest.multi_entry==1?new Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 7,right: 5),
                                     height: 14,
                                     width: 24,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Color(0xFFc61d24)),
                                        borderRadius: BorderRadius.circular(2)
                                    ),
                                    child: new Text('WD',
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            color: Color(0xFFc61d24),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10)),
                                  ),

                                  // new Text('Up to '+widget.contest.max_multi_entry_user!.toString(),
                                  //     style: TextStyle(
                                  //         fontFamily: "Roboto",
                                  //         color: Colors.grey,
                                  //         fontWeight: FontWeight.w500,
                                  //         fontSize: 10)),

                                ],
                              ):new Container(),*/ /**/ /*
                          ],
                        )
*/ /*                        ],
                    ),
                  ),
                ),
              ),*/
              ],
            ),
          ),
        ),
        onTap: () => {
              if (widget.contest.is_flexible == 1)
                {
                  widget.model.challengeId = widget.contest.id,
                  widget.model.onJoinContestResult = widget.onJoinContestResult,
                  Platform.isAndroid
                      ? Navigator.push(context,
                              MaterialPageRoute(builder: (context) => FlexibleUi(widget._contestItemIndex!, widget.model, widget.userId, widget.model.teamVs!, widget.contest, widget.onTeamCreated, isMyContest: widget.isMyContest, isFevContest: favouriteContest, sceenCheck: widget.screenCheck, joinSimilar: widget.contest.is_join_similar_contest)))
                          .then((value) {
                          setState(() {
                            widget.onTeamCreated();
                            if (Platform.isIOS) {
                              AppConstants.callTimer();
                            }

                            // Future.delayed(Duration(milliseconds: 200), () {
                            // });
                          });
                        })
                      : Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => FlexibleUi(
                                  widget._contestItemIndex!,
                                  widget.model,
                                  widget.userId,
                                  widget.model.teamVs!,
                                  widget.contest,
                                  widget.onTeamCreated,
                                  isMyContest: widget.isMyContest,
                                  isFevContest: favouriteContest,
                                  sceenCheck: widget.screenCheck,
                                  joinSimilar: widget.contest
                                      .is_join_similar_contest))).then((value) {
                          setState(() {
                            widget.onTeamCreated();
                            if (Platform.isIOS) {
                              AppConstants.callTimer();
                            }
                          });
                        })
                  // Get.to(() => FlexibleUi(
                  //       widget._contestItemIndex!,
                  //       widget.model,
                  //       widget.userId,
                  //       widget.model.teamVs!,
                  //       widget.contest,
                  //       widget.onTeamCreated,
                  //       isMyContest: widget.isMyContest,
                  //       isFevContest: favouriteContest,
                  //       sceenCheck: widget.screenCheck,
                  //     ))
                  // !
                  //     .then((value) {
                  //   setState(() {
                  //     Future.delayed(Duration(milliseconds: 200), () {
                  //       widget.onTeamCreated();
                  //     });
                  //   });
                  // })
                }
              else
                {
                  widget.model.onJoinContestResult = widget.onJoinContestResult,
                  Platform.isAndroid
                      ? Navigator.push(context,
                              MaterialPageRoute(builder: (context) => UpcomingContestDetails(widget._contestItemIndex!, widget.model, widget.contest, isMyContest: widget.isMyContest, onResume: widget.onResume, sceenCheck: widget.screenCheck, onTeamCreated: onTeamCreated(), joinSimilar: widget.contest.is_join_similar_contest)))
                          .then((value) {
                          setState(() {
                            widget.onTeamCreated();
                            if (Platform.isIOS) {
                              AppConstants.callTimer();
                            }
                          });
                        })
                      : Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => UpcomingContestDetails(
                                  widget._contestItemIndex!,
                                  widget.model,
                                  widget.contest,
                                  isMyContest: widget.isMyContest,
                                  onResume: widget.onResume,
                                  sceenCheck: widget.screenCheck,
                                  onTeamCreated: onTeamCreated(),
                                  joinSimilar: widget.contest
                                      .is_join_similar_contest))).then((value) {
                          setState(() {
                            widget.onTeamCreated();
                            if (Platform.isIOS) {
                              AppConstants.callTimer();
                            }
                            // Future.delayed(Duration(milliseconds: 00), () {
                            //   widget.onTeamCreated();
                            // });
                          });
                        })
                  // navigateToUpcomingContestDetails(widget._contestItemIndex!, context,
                  //     widget.model, widget.contest,
                  //     isMyContest: widget.isMyContest, onResume: widget.onResume)

                  /*  if (widget.model.isaccountverified == true)
          {
            navigateToUpcomingContestDetails(
              context,
              widget.model,
              widget.contest,
            )
          }
        else
          {
            Fluttertoast.showToast(
                msg: 'Please verify your account to join contests',
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1),
            navigateToVerifyAccountDetail(context)
          }*/
                },
            });
  }

  void favouriteContest() async {
    AppLoaderProgress.showLoader(context);

    GeneralRequest request = new GeneralRequest(
      user_id: widget.userId,
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

    AppLoaderProgress.hideLoader(context);
    setState(() {});
  }

  bottomSheet(GetOfferResponse response) {
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
                        Stack(
                          children: [
                            Image.asset(
                              AppImages.offerPopup,
                              scale: 3,
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 50, top: 10),
                                child: Text(
                                  "Offer Usage Division",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Container(
                              color: primaryColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Team No.',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                    Text(
                                      'Entry Fee',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                    Text(
                                      'Offer Entry',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(8.0),
                                itemCount: offerResponse!.result!.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          response.result![index].team!,
                                          style: TextStyle(
                                              color: lightBlack1,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            "${response.result![index].entryfee}",
                                            style: TextStyle(
                                                color: lightBlack1,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Container(
                                            margin: EdgeInsets.only(left: 30),
                                            child: Text(
                                              "${response.result![index].offer}",
                                              style: TextStyle(
                                                  color: lightBlack1,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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

  joinFunction() {
    if ((btnEntryTextforJoin() as Text).data == 'INVITE') {
      MethodUtils.onShare(context, widget.contest, widget.model);
    } else if ((btnEntryTextforJoin() as Text).data == 'JOIN+') {
      Platform.isAndroid
          ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyJoinTeams(
                          widget._contestItemIndex!,
                          widget.model,
                          widget.contest,
                          widget.onJoinContestResult,
                          //multiple_contest: _dropDownValue ?? '1',
                          joinSimilar: widget.contest.is_join_similar_contest)))
              .then((value) {
              setState(() {
                widget.onTeamCreated();
                AppConstants.callTimer();
              });
            })
          : Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => MyJoinTeams(
                          widget._contestItemIndex!,
                          widget.model,
                          widget.contest,
                          widget.onJoinContestResult,
                          // multiple_contest: _dropDownValue ?? '1',
                          joinSimilar: widget.contest.is_join_similar_contest)))
              .then((value) {
              setState(() {
                widget.onTeamCreated();
                AppConstants.callTimer();
              });
            });

      // navigateToMyJoinTeams(
      //     widget._contestItemIndex!,
      //     context,
      //     widget.model,
      //     widget.contest,
      //     widget.onJoinContestResult);
    } else {
      if (widget.model.teamCount == 1) {
        widget.model.onJoinContestResult = widget.onJoinContestResult;
        MethodUtils.checkBalance(
            widget._contestItemIndex!,
            JoinChallengeDataModel(
                context,
                0,
                int.parse(widget.userId),
                widget.contest.id!,
                widget.model.fantasyType!,
                /*widget.model.slotId!,*/
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
                widget.onJoinContestResult,
                widget.contest,
                bonusPercentage: widget.contest.bonus_percent),
            scrollPosition: widget.scrollPotion,
            joinSimilar: widget.contest.is_join_similar_contest);
      } else if (widget.model.teamCount! > 0) {
        Platform.isAndroid
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyJoinTeams(
                        widget._contestItemIndex!,
                        widget.model,
                        widget.contest,
                        widget.onJoinContestResult,
                        // multiple_contest: _dropDownValue ?? '1',
                        joinSimilar: widget
                            .contest.is_join_similar_contest))).then((value) {
                setState(() {
                  widget.onTeamCreated();
                  AppConstants.callTimer();
                });
              })
            : Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => MyJoinTeams(
                        widget._contestItemIndex!,
                        widget.model,
                        widget.contest,
                        widget.onJoinContestResult,
                        // multiple_contest: _dropDownValue ?? '1',
                        joinSimilar: widget
                            .contest.is_join_similar_contest))).then((value) {
                setState(() {
                  widget.onTeamCreated();
                  AppConstants.callTimer();
                });
              });
      } else {
        widget.model.onJoinContestResult = widget.onJoinContestResult;
        widget.model.contest = widget.contest;
        widget.model.onTeamCreated = widget.onTeamCreated;

        Platform.isAndroid
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateTeam(widget.model,
                        onTeamCreated: widget.onTeamCreated,
                        scrollPosition: widget.scrollPotion,
                        contestFrom: widget.screenCheck,
                        // multiple_contest: _dropDownValue ?? '1',
                        joinSimilar: widget
                            .contest.is_join_similar_contest))).then((value) {
                setState(() {
                  widget.onTeamCreated();
                  AppConstants.callTimer();
                });
              })
            : Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => CreateTeam(widget.model,
                        onTeamCreated: widget.onTeamCreated,
                        scrollPosition: widget.scrollPotion,
                        contestFrom: widget.screenCheck,
                        // multiple_contest: _dropDownValue ?? '1',
                        joinSimilar: widget
                            .contest.is_join_similar_contest))).then((value) {
                setState(() {
                  widget.onTeamCreated();
                  AppConstants.callTimer();
                });
              });
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

  void getOffer(String challengeId) async {
    AppLoaderProgress.showLoader(context);
    final client = ApiClient(AppRepository.dio);
    GeneralRequest request =
        GeneralRequest(user_id: widget.userId, challenge_id: challengeId);
    final response = await client.getOffer(request);
    if (response.status == 1) {
      AppLoaderProgress.hideLoader(context);
      offerResponse = response;
      bottomSheet(offerResponse!);
    } else {
      AppLoaderProgress.hideLoader(context);
      Fluttertoast.showToast(msg: response.message!);
    }
    //AppLoaderProgress.hideLoader(context);
  }

  void onSwitchTeam(int id) {
    widget.model.isSwitchTeam = true;
    widget.model.joinedSwitchTeamId = id;
    navigateToMyJoinTeams(widget._contestItemIndex!, context, widget.model,
        widget.contest, widget.onJoinContestResult);
  }
}
