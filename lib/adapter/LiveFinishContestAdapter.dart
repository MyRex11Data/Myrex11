import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myrex11/appUtilities/app_images.dart';

import '../appUtilities/app_colors.dart';
import '../appUtilities/app_navigator.dart';
import '../appUtilities/method_utils.dart';
import '../dataModels/GeneralModel.dart';
import '../repository/model/refresh_score_response.dart';

class LiveFinishContestAdapter extends StatefulWidget {
  GeneralModel model;
  LiveFinishedContestData contest;
  String? match_status;
  LiveFinishContestAdapter(this.model, this.contest, {this.match_status});
  @override
  _LiveFinishContestAdapterState createState() =>
      new _LiveFinishContestAdapterState();
}

class _LiveFinishContestAdapterState extends State<LiveFinishContestAdapter> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Opacity(
        opacity: widget.contest.challenge_status == 'canceled' ? 0.4 : 1.0,
        child: new Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              // elevation: 5,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: LightprimaryColor),
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 0,
                  bottom:
                      widget.contest.challenge_status == 'canceled' ? 28 : 8),
              child: Container(
                padding: EdgeInsets.all(0),
                child: new Container(
                  child: new Column(
                    children: [
                      // new Container(
                      //   margin: EdgeInsets.only(top: 5),
                      //   child: new Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       // new Container(
                      //       //   height: 20,
                      //       //   padding: EdgeInsets.only(left: 5,right: 15),
                      //       //   decoration: BoxDecoration(
                      //       //       image: DecorationImage(
                      //       //           image: AssetImage(AppImages.winnersBgIcon),
                      //       //           fit: BoxFit.fill)),
                      //       //   child: new Row(
                      //       //     children: [
                      //       //       new Container(
                      //       //         margin: EdgeInsets.only(right: 5),
                      //       //         height: 15,
                      //       //         width: 15,
                      //       //         child: new Image.asset(AppImages.winnersIcon,
                      //       //           fit: BoxFit.fill,color: orangeColor,),
                      //       //       ),
                      //       //       new Container(
                      //       //         height: 30,
                      //       //         alignment: Alignment.centerLeft,
                      //       //         child: Text(
                      //       //           widget.contest.totalwinners.toString(),
                      //       //           style: TextStyle( fontFamily: "Trim",
                      //       //               color: orangeColor,
                      //       //               fontWeight: FontWeight.w800,
                      //       //               fontSize: 13),
                      //       //         ),
                      //       //       ),
                      //       //       new Container(
                      //       //         height: 30,
                      //       //         alignment: Alignment.centerLeft,
                      //       //         child: Text(
                      //       //           ' Winners',
                      //       //           style: TextStyle( fontFamily: "Trim",
                      //       //               color: Colors.black,
                      //       //               fontWeight: FontWeight.w400,
                      //       //               fontSize: 11),
                      //       //         ),
                      //       //       )
                      //       //     ],
                      //       //   ),
                      //       //
                      //       // ),
                      //       new Container(
                      //         margin: EdgeInsets.only(right: 10),
                      //         child:new Row(
                      //           children: [
                      //             new Row(
                      //               children: [
                      //                 new Container(
                      //                   margin: EdgeInsets.only(left: 7,right: 5),
                      //                   height: 12,
                      //                   width: 12,
                      //                   child: Image(
                      //                     image: AssetImage(
                      //                       AppImages.winnerMedalIcon,),color: Colors.grey,),
                      //                 ),
                      //                 new Text('₹'+widget.contest.first_rank_prize.toString(),
                      //                     style: TextStyle( fontFamily: "Trim",
                      //                         fontFamily: "Trim",
                      //                         color: Colors.grey,
                      //                         fontWeight: FontWeight.w500,
                      //                         fontSize: 12)),
                      //               ],
                      //             ),
                      //             widget.contest.multi_entry==1?new Row(
                      //               children: [
                      //                 new Container(
                      //                   margin: EdgeInsets.only(left: 7,right: 2),
                      //                   height: 14,
                      //                   width: 14,
                      //                   alignment: Alignment.center,
                      //                   decoration: BoxDecoration(
                      //                       border: Border.all(color: Colors.grey),
                      //                       borderRadius: BorderRadius.circular(2)
                      //                   ),
                      //                   child: new Text('M',
                      //                       style: TextStyle( fontFamily: "Trim",
                      //                           fontFamily: "Trim",
                      //                           color: Colors.grey,
                      //                           fontWeight: FontWeight.w500,
                      //                           fontSize: 10)),
                      //                 ),
                      //                 new Text('Up to '+widget.contest.max_multi_entry_user.toString(),
                      //                     style: TextStyle( fontFamily: "Trim",
                      //                         fontFamily: "Trim",
                      //                         color: Colors.grey,
                      //                         fontWeight: FontWeight.w500,
                      //                         fontSize: 10)),
                      //
                      //               ],
                      //             ):new Container(),
                      //             widget.contest.confirmed_challenge==1?new Container(
                      //               margin: EdgeInsets.only(left: 5,right: 0),
                      //               height: 13,
                      //               width: 13,
                      //               child: Image(
                      //                 image: AssetImage(
                      //                   AppImages.confirmIcon,),color: Colors.grey,),
                      //             ):new Container(),
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      new Container(
                        height: 35,
                        padding: EdgeInsets.only(left: 8, right: 8),
                        decoration: BoxDecoration(
                          color: LightprimaryColor,
                          // border:Border.all(color: Colors.grey.shade300)
                        ),
                        margin: EdgeInsets.only(
                            top: widget.contest.is_champion == 1 ? 0 : 0),
                        child: new Container(
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              new GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                child: new Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    new Container(
                                      margin:
                                          EdgeInsets.only(left: 4, right: 7),
                                      height: 16,
                                      // width: 15,
                                      child: Image(
                                        image: AssetImage(
                                          AppImages.winnerMedalIcon,
                                        ),
                                        color: Color(0xff686869),
                                      ),
                                    ),
                                    new Text(
                                        widget.contest.challenge_type ==
                                                'percentage'
                                            ? widget.contest.winning_percentage
                                                    .toString() +
                                                '% Win'
                                            : widget.contest.totalwinners
                                                    .toString() +
                                                ' Team Win',
                                        style: TextStyle(
                                            fontFamily: 'Trim',
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13)),
                                  ],
                                ),
                                onTap: () {
                                  // widget.getWinnerPriceCard(widget.contest.id,widget.contest.win_amount.toString());
                                },
                              ),
                              Spacer(),
                              widget.contest.challenge_type != 'percentage'
                                  ? new Row(
                                      children: [
                                        new Container(
                                          margin: EdgeInsets.only(
                                              left: 7, right: 7),
                                          height: 16,
                                          width: 16,
                                          child: Image(
                                              image: AssetImage(
                                            "assets/images/ic_trophy_PriceCard.png",
                                          )),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 4),
                                              child: Container(
                                                height: 18,
                                                width: 18,
                                                child: Image.asset(
                                                    AppImages.goldcoin),
                                              ),
                                            ),
                                            new Text(
                                                widget.contest.first_rank_prize!
                                                    .toString(),
                                                style: TextStyle(
                                                    fontFamily: 'Trim',
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13)),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    )
                                  : new Container(),

                              /* widget.contest.is_bonus==1?new Row(
                                children: [
                                  new Container(
                                    margin: EdgeInsets.only(left: 7,right: 2),
                                    height: 12,
                                    width: 14,
                                    child: Image(
                                      image: AssetImage(
                                        AppImages.bonusIcon,),color: Colors.black,),
                                  ),
                                  new Text(widget.contest.bonus_percent!,
                                      style: TextStyle(
                                          fontFamily: 'Trim',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10)),

                                ],
                              ):new Container(),*/
                              Visibility(
                                visible: widget.contest.is_champion == 1
                                    ? false
                                    : true,
                                child: new Row(
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
                                    //           fontFamily: 'Trim',
                                    //           color: Colors.grey,
                                    //           fontWeight: FontWeight.w500,
                                    //           fontSize: 10)),
                                    // ),

                                    widget.contest.confirmed_challenge == 1
                                        ? new Container(
                                            margin: EdgeInsets.only(
                                                left: 7, right: 4),
                                            height: 14,
                                            width: 14,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(2)),
                                            child: new Text('c',
                                                style: TextStyle(
                                                    fontFamily: 'Trim',
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 11)),
                                          )
                                        : new Container(),

                                    widget.contest.multi_entry == 1
                                        ? new Row(
                                            children: [
                                              new Container(
                                                margin: EdgeInsets.only(
                                                    left: 7, right: 4),
                                                height: 13,
                                                // width: 14,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2)),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          // border: Border(
                                                          //     right: BorderSide(color: Colors.grey)
                                                          // )
                                                          ),
                                                      child: new Text(' M ',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Trim',
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 10)),
                                                    ),
                                                    // new Text(' '+widget.contest.max_multi_entry_user!.toString()+" ",
                                                    //     style: TextStyle(
                                                    //         fontFamily: 'Trim',
                                                    //         color: Colors.grey,
                                                    //         fontWeight: FontWeight.w500,
                                                    //         fontSize: 9)
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : new Container(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      widget.contest.is_champion == 1
                          ? Container(
                              margin:
                                  EdgeInsets.only(left: 8, right: 8, top: 8),
                              child: Column(
                                children: [
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      new Row(
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
                                          //       style: TextStyle( fontFamily: "Trim",
                                          //           fontFamily: "Trim",
                                          //           color: Colors.grey,
                                          //           fontWeight: FontWeight.w500,
                                          //           fontSize: 10)),
                                          // ),

                                          widget.contest.confirmed_challenge ==
                                                  1
                                              ? new Container(
                                                  margin: EdgeInsets.only(
                                                      left: 7, right: 2),
                                                  height: 14,
                                                  width: 14,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2)),
                                                  child: new Text('c',
                                                      style: TextStyle(
                                                          fontFamily: "Trim",
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 11)),
                                                )
                                              : new Container(),

                                          widget.contest.multi_entry == 1
                                              ? new Container(
                                                  margin: EdgeInsets.only(
                                                      left: 7, right: 0),
                                                  height: 13,
                                                  // width: 14,
                                                  // alignment:
                                                  //     Alignment.center,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2)),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            // border: Border(
                                                            //     right: BorderSide(color: Colors.grey)
                                                            // )
                                                            ),
                                                        child: new Text(' M ',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Trim",
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 10)),
                                                      ),
                                                      // new Text(' '+widget.contest.max_multi_entry_user!.toString()+" ",
                                                      //     style: TextStyle( fontFamily: "Trim",
                                                      //         fontFamily: "Trim",
                                                      //         color: Colors.grey,
                                                      //         fontWeight: FontWeight.w500,
                                                      //         fontSize: 9)
                                                      // ),
                                                    ],
                                                  ),
                                                )
                                              : new Container(),
                                        ],
                                      ),
                                      //SizedBox(width: 5,),
                                      Text(
                                        'Joined Teams: ',
                                        style: TextStyle(
                                            fontFamily: "Trim",
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13),
                                      ),
                                      new Container(
                                        height: 22,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          widget.contest.maximum_user
                                              .toString(),
                                          style: TextStyle(
                                              fontFamily: "Trim",
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.network(
                                        widget.contest.champion_player!,
                                        fit: BoxFit.contain,
                                        scale: 4,
                                      ),
                                      SizedBox(
                                        width: 40,
                                      ),
                                      Expanded(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          new Container(
                                            child: new Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                widget.contest.is_gadget == 1
                                                    ? Image.network(
                                                        widget.contest
                                                            .gadget_image!,
                                                        fit: BoxFit.contain,
                                                        scale: 5,
                                                      )
                                                    : Container(
                                                        height: 22,
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
                                                              fontFamily:
                                                                  "Trim",
                                                              color: widget
                                                                          .contest
                                                                          .is_giveaway_visible_text ==
                                                                      0
                                                                  ? Colors.black
                                                                  : MethodUtils
                                                                      .hexToColor(
                                                                          widget
                                                                              .contest
                                                                              .giveaway_color!),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14),
                                                        ),
                                                      ),
                                                // SizedBox(height: 10,),
                                                Text(
                                                  'Prize Pool',
                                                  style: TextStyle(
                                                      fontFamily: "Trim",
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 11),
                                                ),
                                              ],
                                            ),
                                          ),
                                          new Container(
                                            child: new Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                new Container(
                                                  height: 22,
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    // '₹' +
                                                    widget.contest.entryfee
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontFamily: "Trim",
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                                widget.contest.is_gadget == 1
                                                    ? SizedBox(
                                                        height: 10,
                                                      )
                                                    : Container(),
                                                Text(
                                                  'Entry Fee',
                                                  style: TextStyle(
                                                      fontFamily: "Trim",
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 11),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ))
                                    ],
                                  )
                                ],
                              ),
                            )
                          : new Container(
                              margin: EdgeInsets.only(
                                  left: 10, right: 5, top: 5, bottom: 10),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  new Container(
                                    child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 4),
                                          child: Text(
                                            'Prize Pool',
                                            style: TextStyle(
                                                fontFamily: "Trim",
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12),
                                          ),
                                        ),
                                        widget.contest.is_gadget == 1
                                            ? Image.network(
                                                widget.contest.gadget_image!,
                                                fit: BoxFit.contain,
                                                scale: 5,
                                              )
                                            : Container(
                                                //height: 22,
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 6),
                                                      child: Container(
                                                        height: 18,
                                                        width: 18,
                                                        child: Image.asset(
                                                            AppImages.goldcoin),
                                                      ),
                                                    ),
                                                    Text(
                                                      // '₹' +
                                                      (widget.contest
                                                                  .is_giveaway_visible_text ==
                                                              0
                                                          ? widget.contest
                                                              .win_amount
                                                              .toString()
                                                          : widget.contest
                                                              .is_giveaway_text!),
                                                      style: TextStyle(
                                                          fontFamily: "Trim",
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
                                                          fontSize: 15),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        // SizedBox(height: 10,),
                                      ],
                                    ),
                                  ),
                                  new Container(
                                    child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // widget.contest.is_gadget == 1
                                        //     ? SizedBox(
                                        //         height: 10,
                                        //       )
                                        //     : Container(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 4),
                                          child: Text(
                                            'Spots',
                                            style: TextStyle(
                                                fontFamily: "Trim",
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12),
                                          ),
                                        ),
                                        new Container(
                                          // height: 22,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            widget.contest.maximum_user
                                                .toString(),
                                            style: TextStyle(
                                                fontFamily: "Trim",
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  new Container(
                                    child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 4),
                                          child: Text(
                                            'Entry Fee  ',
                                            style: TextStyle(
                                                fontFamily: "Trim",
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12),
                                          ),
                                        ),
                                        // widget.contest.is_gadget == 1
                                        //     ? SizedBox(
                                        //         height: 10,
                                        //       )
                                        //     : Container(),
                                        new Container(
                                          //height: 22,
                                          // width: 60,
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 6),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 6),
                                                  child: Container(
                                                    height: 18,
                                                    width: 18,
                                                    child: Image.asset(
                                                        AppImages.goldcoin),
                                                  ),
                                                ),
                                                Text(
                                                  // '₹' +
                                                  widget.contest.entryfee
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontFamily: "Trim",
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      /*  Container(
                        padding: const EdgeInsets.only(
                            right: 10, left: 10, top: 5, bottom: 5),
                        color: Color(0xFF0c000000),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            widget.contest.challenge_type != 'percentage'
                                ? Row(
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            AppImages.winnerMedalIcon),
                                        height: 14,
                                      ),
                                      Text(
                                          ' ₹' +
                                              widget.contest.first_rank_prize!
                                                  .toString(),
                                          style: TextStyle(
                                              fontFamily: "Trim",
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12)),
                                    ],
                                  )
                                : Container(),
                            SizedBox(
                              width: 10,
                            ),
                            widget.contest.multi_entry == 1
                                ? Row(
                                    children: [
                                      Image(
                                        image: AssetImage(
                                          AppImages.multiEntry,
                                        ),
                                        height: 14,
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      new Text(
                                          'Upto ' +
                                              widget
                                                  .contest.max_multi_entry_user!
                                                  .toString(),
                                          style: TextStyle(
                                              fontFamily: "Trim",
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
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
                                    height: 14,
                                  ),
                                  SizedBox(width: 4),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3.0),
                                    child: Text(
                                        widget.contest.challenge_type ==
                                                'percentage'
                                            ? widget.contest.winning_percentage
                                                    .toString() +
                                                '% Win'
                                            : widget.contest.totalwinners
                                                    .toString() +
                                                ' Winner',
                                        style: TextStyle(
                                            fontFamily: "Trim",
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12)),
                                  ),
                                ],
                              ),
                              // onTap: () {
                              //   widget.getWinnerPriceCard(
                              //       widget.contest.id, widget.contest.win_amount);
                              // },
                            ),
                            Spacer(),
                            widget.contest.confirmed_challenge == 1
                                ? Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        new Container(
                                          margin: EdgeInsets.only(
                                              left: 7, right: 5),
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
                                          ),
                                        ),
                                        Text('Guaranteed',
                                            style: TextStyle(
                                                fontFamily: "Trim",
                                                color: Colors.grey,
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
                                          margin: EdgeInsets.only(
                                              left: 0, right: 5),
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
                                          ),
                                        ),
                                        Text(
                                          'Flexible',
                                          style: TextStyle(
                                              fontFamily: "Trim",
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                      ),*/

                      //     SizedBox(height: 15,),
                      /*   new Container(
                      color: Color(0xFFf7f7f7),
                      // height: 35,
                      // margin: EdgeInsets.only(top: 10),
                      child: new Container(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children: [
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  new Row(
                                    children: [
                                      widget.contest.challenge_type!='percentage'?new Row(
                                        children: [
                                          new Container(
                                            // margin: EdgeInsets.only(left: 7,right: 5),
                                            height: 16,
                                            width: 16,
                                            child: Image(
                                                image: AssetImage(
                                                    AppImages.winnerMedalIcon)),
                                          ),
                                          new Text(' ₹'+widget.contest.first_rank_prize!.toString(),
                                              style: TextStyle( fontFamily: "Trim",
                                                  fontFamily: "Trim",
                                                  color: textcolor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12)),

                                        ],
                                      ):new Container(),
                                      new GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        child: new Row(
                                          children: [
                                            new Container(
                                              margin: EdgeInsets.only(left: 7,right: 4),
                                              height: 15,
                                              width: 12,
                                              child: Image(
                                                image: AssetImage(
                                                  AppImages.winnersIcon,),),
                                            ),
                                            new Text(widget.contest.challenge_type=='percentage'?widget.contest.winning_percentage.toString()+'% Win':widget.contest.totalwinners.toString()+' Team Win',
                                                style: TextStyle( fontFamily: "Trim",
                                                    fontFamily: "Trim",
                                                    color: textcolor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 10)),
                                            widget.contest.is_bonus==1?new Row(
                                              children: [
                                                new Container(
                                                  margin: EdgeInsets.only(left: 7,right: 2),
                                                  height: 12,
                                                  width: 14,
                                                  child: Image(
                                                    image: AssetImage(
                                                      AppImages.bonusIcon,),color: Color(0xFF969696),),
                                                ),
                                                new Text(widget.contest.bonus_percent!,
                                                    style: TextStyle( fontFamily: "Trim",
                                                        fontFamily: "Trim",
                                                        color: Color(0XFF969696),
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 10)),

                                              ],
                                            ):new Container(),
                                            widget.contest.multi_entry==1?new Row(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(left: 7,right: 2),
                                                  height: 14,
                                                  width: 14,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Color(0XFFf7f7f7),
                                                      border: Border.all(color: Color(0xFF969696)),
                                                      borderRadius: BorderRadius.circular(20)
                                                  ),
                                                  child: new Text('M',
                                                      style: TextStyle( fontFamily: "Trim",
                                                          fontFamily: "Trim",
                                                          color: textcolor,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 10)),
                                                ),

                                                new Text('Up to '+widget.contest.max_multi_entry_user!.toString(),
                                                    style: TextStyle( fontFamily: "Trim",
                                                        fontFamily: "Trim",
                                                        color: Colors.grey,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 10)),

                                              ],
                                            ):new Container(),
                                          ],
                                        ),
                                        onTap: (){
                                          //widget.getWinnerPriceCard(widget.contest.id,widget.contest.win_amount.toString());
                                        },
                                      ),
                                    ],
                                  ),

                                  new Row(
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
                                      //       style: TextStyle( fontFamily: "Trim",
                                      //           fontFamily: "Trim",
                                      //           color: Colors.grey,
                                      //           fontWeight: FontWeight.w500,
                                      //           fontSize: 10)),
                                      // ),



                                      widget.contest.confirmed_challenge==1?new  Container(
                                        margin: EdgeInsets.only(left: 7,right: 5),
                                        height: 14,
                                        width: 14,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Color(0XFFf7f7f7),
                                            border: Border.all(color: Color(0xFF969696)),
                                            borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: new Text('C',
                                            style: TextStyle( fontFamily: "Trim",
                                                fontFamily: "Trim",
                                                color: Color(0xFF969696),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10)),
                                      ):new Container(),
                                      */
                      /* widget.contest.multi_entry==1?new Row(
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
                                              style: TextStyle( fontFamily: "Trim",
                                                  fontFamily: "Trim",
                                                  color: Color(0xFFc61d24),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 10)),
                                        ),

                                        // new Text('Up to '+widget.contest.max_multi_entry_user!.toString(),
                                        //     style: TextStyle( fontFamily: "Trim",
                                        //         fontFamily: "Trim",
                                        //         color: Colors.grey,
                                        //         fontWeight: FontWeight.w500,
                                        //         fontSize: 10)),

                                      ],
                                    ):new Container(),*/ /*
                                    ],
                                  )
                                ],
                              ),





                            ],
                          ),
                        ),
                      ),
                    ),*/
                      //Divider(color: Colors.yellow,thickness: 2,),
                      // Container(
                      //   color: Colors.yellow,
                      //   height: 2,
                      // ),
                      /*   widget.contest.winners_zone!.length>0?new Container(
                      color: Color(0xFFfefaef),
                      padding: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                      child: new Container(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            new Flexible(child: new Container(
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  new Row(
                                    children: [
                                      Flexible(child: new Text(widget.contest.winners_zone![0].team_name!,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle( fontFamily: "Trim",
                                            color: Colors.black,

                                            fontSize: 12,
                                          ))),
                                      new Text('(T'+widget.contest.winners_zone![0].team_number.toString()+')',
                                          style: TextStyle( fontFamily: "Trim",
                                              color: Colors.black,
                                              // fontWeight: FontWeight.w500,
                                              fontSize: 12)),

                                    ],
                                  ),
                                  widget.contest.winners_zone![0].is_winningzone==1&&widget.model.isFromLive!?new Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: new Text('WINNING ZONE',
                                      style: TextStyle( fontFamily: "Trim",

                                          color: primaryColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ):new Container(),
                                  double.parse(widget.contest.winners_zone![0].amount??'0')>0&&!widget.model.isFromLive!?new Container(
                                    margin: EdgeInsets.only(top: 3),
                                    child: new Text(
                                      'YOU WON: ₹'+widget.contest.winners_zone![0].amount.toString(),
                                      style: TextStyle( fontFamily: "Trim",
                                          fontFamily: "Trim",
                                          color: greenColor,
                                          fontSize: 11,
                                          fontWeight:
                                          FontWeight.normal),
                                    ),
                                  ):new Container(),
                                ],
                              ),
                            ),flex: 1,),
                            new Flexible(child: new Container(
                              child: new Text(widget.contest.winners_zone![0].points!,
                                  style: TextStyle( fontFamily: "Trim",
                                      fontFamily: "Trim",
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13)),
                            ),flex: 1,),
                            new Flexible(child: new Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                new Text('#'+widget.contest.winners_zone![0].rank.toString(),
                                    style: TextStyle( fontFamily: "Trim",
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13)),
                                new Container(
                                  alignment: Alignment.center,
                                  child:Icon(Icons.remove,size: 15,),
                                )

                              ],
                            ),flex: 1,),
                          ],
                        ),
                      ),
                    ):new Container(),*/

                      Divider(
                        height: 0,
                        color: borderColor,
                        thickness: 1,
                      ),
                      Container(
                        height: 30,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(color: LightprimaryColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Teams",
                              style: TextStyle(
                                  color: Color(0xff414141),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                            // Text("Rank1",style: TextStyle(
                            //     color: Color(0xff414141),fontSize: 10,fontWeight: FontWeight.w400
                            // ),),
                            Text(
                              "Points",
                              style: TextStyle(
                                  color: Color(0xff414141),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "Rank",
                              style: TextStyle(
                                  color: Color(0xff414141),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 0,
                        color: borderColor,
                        thickness: 1,
                      ),

                      widget.contest.winners_zone!.length > 0
                          ? ListView.builder(
                              itemCount: widget.contest.winners_zone!.length,
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, winIndex) {
                                print("amount" +
                                    widget
                                        .contest.winners_zone![winIndex].amount
                                        .toString());
                                return Column(
                                  children: [
                                    Container(
                                      // color: lightYellowColor,
                                      decoration: BoxDecoration(
                                          color: null,
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors
                                                  .white, // Transparent start color
                                              Colors
                                                  .white, // Gradient end color
                                            ],
                                            begin: Alignment.bottomRight,
                                            end: Alignment.topLeft,
                                          )),

                                      child: new Container(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  left: 10,
                                                  right: 10),
                                              child: new Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    height: 22,
                                                    width: 22,
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.only(
                                                        right: 10, bottom: 0),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            LightprimaryColor,
                                                        border: Border.all(
                                                            color: primaryColor
                                                                .withOpacity(
                                                                    0.4))),
                                                    child: new Text(
                                                        'T' +
                                                            widget
                                                                .contest
                                                                .winners_zone![
                                                                    winIndex]
                                                                .team_number
                                                                .toString() +
                                                            '',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 8)),
                                                  ),
                                                  new Flexible(
                                                    child: new Container(
                                                      child: new Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          new Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Flexible(
                                                                  child: new Text(
                                                                      widget
                                                                          .contest
                                                                          .winners_zone![
                                                                              winIndex]
                                                                          .team_name!,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            12,
                                                                      ))),
                                                            ],
                                                          ),
                                                          widget
                                                                          .contest
                                                                          .winners_zone![
                                                                              winIndex]
                                                                          .is_winningzone ==
                                                                      1 &&
                                                                  (widget.model
                                                                          .isFromLive ??
                                                                      false)
                                                              ? new Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              5),
                                                                  child:
                                                                      new Text(
                                                                    'WINNING ZONE',
                                                                    style: TextStyle(
                                                                        //fontFamily: "Trim",
                                                                        color: Color(0xFF076e39),
                                                                        fontSize: 10,
                                                                        fontWeight: FontWeight.w500),
                                                                  ),
                                                                )
                                                              : new Container(),
                                                          double.parse(widget
                                                                              .contest
                                                                              .winners_zone![
                                                                                  winIndex]
                                                                              .amount ??
                                                                          '0') >
                                                                      0 &&
                                                                  !widget.model
                                                                      .isFromLive!
                                                              ? new Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              3),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      new Text(
                                                                        'YOU WON: ',
                                                                        style: TextStyle(
                                                                            color: Color(
                                                                                0xFF076e39),
                                                                            fontSize:
                                                                                10,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(right: 2),
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              12,
                                                                          width:
                                                                              12,
                                                                          child:
                                                                              Image.asset(AppImages.goldcoin),
                                                                        ),
                                                                      ),
                                                                      new Text(
                                                                        widget
                                                                            .contest
                                                                            .winners_zone![winIndex]
                                                                            .amount
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            color: Color(
                                                                                0xFF076e39),
                                                                            fontSize:
                                                                                10,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              : new Container(),
                                                        ],
                                                      ),
                                                    ),
                                                    flex: 1,
                                                  ),
                                                  // new Container(
                                                  //   margin: EdgeInsets.only(right: 40,left: 10),
                                                  //   child: new Text(widget.contest.winners_zone![winIndex].points!,
                                                  //       style: TextStyle(
                                                  //           fontFamily: 'Trim',
                                                  //           color: Colors.black,
                                                  //           fontWeight: FontWeight.w500,
                                                  //           fontSize: 13)),
                                                  // ),

                                                  // new Container(
                                                  //   margin: EdgeInsets.only(
                                                  //       left: 0),
                                                  //   child: Text('Points',
                                                  //       style: TextStyle(
                                                  //           fontFamily:
                                                  //               "Trim",
                                                  //           color: textCol,
                                                  //           //fontWeight: FontWeight.w500,
                                                  //           fontSize: 10)),
                                                  // ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 14),
                                                    child: Text(
                                                        widget
                                                            .contest
                                                            .winners_zone![
                                                                winIndex]
                                                            .points!,
                                                        style: TextStyle(
                                                            fontFamily: "Trim",
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 13)),
                                                  ),
                                                  new Flexible(
                                                    child: new Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        new Text(
                                                            '#' +
                                                                widget
                                                                    .contest
                                                                    .winners_zone![
                                                                        winIndex]
                                                                    .rank
                                                                    .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 13)),
                                                        widget.model.isFromLive!
                                                            ? Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left: 2,
                                                                        bottom:
                                                                            2),
                                                                child:
                                                                    Image.asset(
                                                                  widget.contest.winners_zone![winIndex].arrowname
                                                                              .toString()
                                                                              .toLowerCase() ==
                                                                          "up-arrow"
                                                                      ? "assets/images/arrowUp.png"
                                                                      : widget.contest.winners_zone![winIndex].arrowname.toString().toLowerCase() ==
                                                                              "equal-arrow"
                                                                          ? "assets/images/arrowEqual.png"
                                                                          : "assets/images/arrowDown.png",
                                                                  scale: 1.8,
                                                                ),
                                                              )
                                                            : new Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Icon(
                                                                  Icons.remove,
                                                                  size: 15,
                                                                ),
                                                              )
                                                      ],
                                                    ),
                                                    flex: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            widget.contest.winners_zone!
                                                            .length -
                                                        1 ==
                                                    winIndex
                                                ? Container()
                                                : Divider(
                                                    height: 1,
                                                    thickness: 2,
                                                    color: Colors.white),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      color: borderColor,
                                      height: 1,
                                    )
                                  ],
                                );
                              })
                          : new Container(),
                      widget.contest.challenge_status == 'canceled'
                          ? new Container(
                              color: lightYellow,
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Canceled due to clash',
                                  style: TextStyle(
                                      fontFamily: 'Trim',
                                      color: primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12),
                                ),
                              ),
                            )
                          : new Container(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () => {
        if (widget.contest.challenge_status != 'canceled')
          {
            navigateToLiveFinishContestDetails(
                context, widget.contest, widget.model,
                match_status: widget.match_status)
          }
      },
    );
  }
}
