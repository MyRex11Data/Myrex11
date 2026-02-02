import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/app_navigator.dart';
import 'package:myrex11/dataModels/SelectedPlayer.dart';
import 'package:myrex11/repository/model/player_list_response.dart';
import 'package:myrex11/repository/model/team_response.dart';
import 'package:myrex11/views/PlayerInfo.dart';

class CreateTeamPager extends StatefulWidget {
  List<Player> list;
  Function onPlayerClick;
  int type;
  SelectedPlayer selectedPlayer;
  Limit limit;
  int fantasyType;
  // int slotId;
  bool exeedCredit;
  String? matchKey;
  String? sportKey;
  Function? uiUpdate;
  CreateTeamPager(
      this.list,
      this.onPlayerClick,
      this.type,
      this.selectedPlayer,
      this.limit,
      this.fantasyType,
      /* this.slotId,*/
      this.exeedCredit,
      this.matchKey,
      this.sportKey,
      {this.uiUpdate});

  @override
  _CreateTeamPagerState createState() => _CreateTeamPagerState();
}

class _CreateTeamPagerState extends State<CreateTeamPager> {
  bool isAnnounced = true;
  bool isLastPlayed = false;
  double alpha = 1.0;
  int isSubstitudeIndex = 0;
  int isNonPlayingIndex = 0;
  int isPlayingIndex = 0;

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
    // widget.list
    //     .sort((a, b) => a.is_substitute!.compareTo(b.is_substitute!.toInt()));

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(bottom: 80),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: widget.list.length,
                itemBuilder: (BuildContext context, int index) {
                  bool isSelected = widget.list[index].isSelected ?? false;

                  if (widget.list[index].team == "team1") {
                    if (widget.selectedPlayer.localTeamplayerCount ==
                        widget.limit.team_max_player) {
                      if (!isSelected)
                        alpha = 0.3;
                      else
                        alpha = 1.0;
                    } else {
                      checkList(index);
                    }
                  } else if (widget.list[index].team == "team2") {
                    if (widget.selectedPlayer.visitorTeamPlayerCount ==
                        widget.limit.team_max_player) {
                      if (!isSelected)
                        alpha = 0.3;
                      else
                        alpha = 1.0;
                    } else {
                      checkList(index);
                    }
                  }

                  // for (int i = 0; i < widget.list.length - 1; i++) {
                  //   if (widget.list[i].is_substitute == 1) {
                  //     isSubstitudeIndex = i;
                  //     break;
                  //   }
                  // }

                  // for (int i = 0; i < widget.list.length; i++) {
                  //   if (widget.list[i].is_substitute == 1) {
                  //     isSubstitudeIndex = i;
                  //     break;
                  //   }
                  // }

                  // for (int i = 0; i < widget.list.length; i++) {
                  //   if (widget.list[i].is_substitute == 2 &&
                  //       widget.list[i].is_playing == 0) {
                  //     isNonPlayingIndex = i;
                  //     break;
                  //   }
                  // }

                  return Column(
                    children: [
                      // widget.list[index].is_playing_show == 1 && index == 0
                      //     ? Image.asset(AppImages.isPlayingLabel)
                      //     : SizedBox.shrink(),
                      // widget.list[index].is_playing_show == 1 &&
                      //         isSubstitudeIndex != 0 &&
                      //         isSubstitudeIndex == index
                      //     ? Image.asset(AppImages.subtituteLabel)
                      //     : SizedBox.shrink(),
                      // widget.list[index].is_playing_show == 1 &&
                      //         isNonPlayingIndex != 0 &&
                      //         isNonPlayingIndex == index
                      //     ? Image.asset(AppImages.nonPlayerLabel)
                      //     : SizedBox.shrink(),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Opacity(
                          opacity: alpha,
                          child: Container(
                            color: widget.list[index].isSelected ?? false
                                ? teamSelected.withOpacity(0.18)
                                : Color(0xFFf3f3f3),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 0, right: 0, top: 10, bottom: 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            child: Container(
                                              width: 80,
                                              margin: EdgeInsets.only(left: 0),
                                              child: Stack(
                                                alignment: Alignment.bottomLeft,
                                                children: [
                                                  // Container(
                                                  //   width: 65,
                                                  //   child: Container(
                                                  //     margin: EdgeInsets.only(
                                                  //         bottom: 0, left: 10),
                                                  //     child: CachedNetworkImage(
                                                  //       width: 60,
                                                  //       height: 60,
                                                  //       imageUrl: widget
                                                  //           .list[index].image!,
                                                  //       placeholder: (context,
                                                  //               url) =>
                                                  //           Image.asset(AppImages
                                                  //               .player_avatar),
                                                  //       errorWidget: (context,
                                                  //               url, error) =>
                                                  //           Image.asset(AppImages
                                                  //               .player_avatar),
                                                  //       fit: BoxFit.fill,
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  new Container(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    // width: 70,

                                                    child: new Container(
                                                      child: new Container(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        height: 55,
                                                        width: 55,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: widget
                                                              .list[index]
                                                              .image!,
                                                          placeholder: (context,
                                                                  url) =>
                                                              new Image.asset(
                                                                  AppImages
                                                                      .player_avatar),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              new Image.asset(
                                                                  AppImages
                                                                      .player_avatar),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8),
                                                    child: Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 40),
                                                        child: Image.asset(
                                                          AppImages
                                                              .profile_info,
                                                          height: 20,
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 0),
                                                    child: Card(
                                                      elevation: 1.5,
                                                      margin: EdgeInsets.only(
                                                        left: 4,
                                                        bottom: 0,
                                                      ),
                                                      color: widget.list[index]
                                                                  .team ==
                                                              'team1'
                                                          ? Colors.white
                                                          : Colors.black,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        3),
                                                            border: Border.all(
                                                                color: widget
                                                                            .list[
                                                                                index]
                                                                            .team ==
                                                                        'team1'
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black)),
                                                        // height: 17,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 3,
                                                                vertical: 2),
                                                        child: new Text(
                                                          widget.list[index]
                                                              .teamcode!,
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: widget
                                                                        .list[
                                                                            index]
                                                                        .team ==
                                                                    'team1'
                                                                ? Colors.black
                                                                : Colors.white,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onTap: () {
                                              if (Platform.isAndroid) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PlayerInfo(
                                                                widget.matchKey,
                                                                widget
                                                                    .list[index]
                                                                    .id,
                                                                widget
                                                                    .list[index]
                                                                    .name,
                                                                widget
                                                                    .list[index]
                                                                    .team,
                                                                widget
                                                                    .list[index]
                                                                    .image,
                                                                widget
                                                                    .list[index]
                                                                    .isSelected,
                                                                index,
                                                                widget.type,
                                                                widget.sportKey,
                                                                widget
                                                                    .fantasyType,
                                                                // widget.slotId,
                                                                '0',
                                                                widget
                                                                    .onPlayerClick,
                                                                widget
                                                                    .list[index]
                                                                    .short_role!,
                                                                widget
                                                                    .list[index]
                                                                    .selected_by,
                                                                widget
                                                                    .list[index]
                                                                    .points,
                                                                widget
                                                                    .list[index]
                                                                    .count,
                                                                widget
                                                                    .list[index]
                                                                    .teamcode))).then(
                                                    (value) {
                                                  widget.uiUpdate!();
                                                });
                                              } else {
                                                Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                        builder: (context) =>
                                                            PlayerInfo(
                                                                widget.matchKey,
                                                                widget
                                                                    .list[index]
                                                                    .id,
                                                                widget
                                                                    .list[index]
                                                                    .name,
                                                                widget
                                                                    .list[index]
                                                                    .team,
                                                                widget
                                                                    .list[index]
                                                                    .image,
                                                                widget
                                                                    .list[index]
                                                                    .isSelected,
                                                                index,
                                                                widget.type,
                                                                widget.sportKey,
                                                                widget
                                                                    .fantasyType,
                                                                // widget.slotId,
                                                                '0',
                                                                widget
                                                                    .onPlayerClick,
                                                                widget
                                                                    .list[index]
                                                                    .short_role!,
                                                                widget
                                                                    .list[index]
                                                                    .selected_by,
                                                                widget
                                                                    .list[index]
                                                                    .points,
                                                                widget
                                                                    .list[index]
                                                                    .count,
                                                                widget
                                                                    .list[index]
                                                                    .teamcode))).then(
                                                    (value) {
                                                  widget.uiUpdate!();
                                                });
                                              }

                                              // navigateToPlayerInfo(
                                              //     context,
                                              //     widget.matchKey,
                                              //     widget.list[index].id,
                                              //     widget.list[index].name,
                                              //     widget.list[index].team,
                                              //     widget.list[index].image,
                                              //     widget.list[index].isSelected,
                                              //     index,
                                              //     widget.type,
                                              //     widget.sportKey,
                                              //     widget.fantasyType,
                                              //     // widget.slotId,
                                              //     '0',
                                              //     widget.onPlayerClick,
                                              //     widget
                                              //         .list[index].short_role!,
                                              //     widget
                                              //         .list[index].selected_by,
                                              //     widget.list[index].points,
                                              //     widget.list[index].count,
                                              //     widget.list[index].teamcode);
                                            },
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 4),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.list[index]
                                                      .getShortName(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 2),
                                                  child: Text(
                                                    'Sel by ' +
                                                        widget.list[index]
                                                            .selected_by! +
                                                        '%',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                                widget.list[index]
                                                            .is_playing_show ==
                                                        1
                                                    ? Row(
                                                        children: [
                                                          Container(
                                                            child: Container(
                                                              height: 8,
                                                              width: 8,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 3,
                                                                      right: 3),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: widget.list[index].is_playing == 1 &&
                                                                          widget.list[index].is_playing ==
                                                                              1 &&
                                                                          widget.list[index].is_substitute !=
                                                                              1
                                                                      ? Color(
                                                                          0xff076e39)
                                                                      : widget.list[index].is_playing_show == 1 &&
                                                                              widget.list[index].is_substitute ==
                                                                                  1
                                                                          ? Color(
                                                                              0xff102881)
                                                                          : Colors
                                                                              .red,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: widget.list[index].is_playing ==
                                                                            1 &&
                                                                        widget.list[index].is_substitute !=
                                                                            1
                                                                    ? Color(
                                                                        0xff076e39)
                                                                    : widget.list[index].is_playing_show ==
                                                                                1 &&
                                                                            widget.list[index].is_substitute ==
                                                                                1
                                                                        ? Color(
                                                                            0xff102881)
                                                                        : Colors
                                                                            .red,
                                                              ),
                                                              child:
                                                                  Container(),
                                                            ),
                                                          ),
                                                          widget.list[index]
                                                                      .is_playing ==
                                                                  1
                                                              ? Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              3),
                                                                  child: Text(
                                                                    '',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .green,
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                )
                                                              : widget.list[index]
                                                                          .is_substitute ==
                                                                      1
                                                                  ? Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                              top: 3),
                                                                      child:
                                                                          Text(
                                                                        '',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .blue,
                                                                            fontSize:
                                                                                11,
                                                                            fontWeight:
                                                                                FontWeight.w400),
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                              top: 3),
                                                                      child:
                                                                          Text(
                                                                        '',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .red,
                                                                            fontSize:
                                                                                11,
                                                                            fontWeight:
                                                                                FontWeight.w400),
                                                                      ),
                                                                    ),
                                                        ],
                                                      )
                                                    : Container(),
                                                widget.list[index].last_match ==
                                                        1
                                                    ? Row(
                                                        children: [
                                                          Container(
                                                            child: Container(
                                                              height: 6,
                                                              width: 6,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right: 3),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration: BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                          color:
                                                                              darkBlue),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              3),
                                                                  color:
                                                                      darkBlue),
                                                              child:
                                                                  Container(),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 2),
                                                            child: Text(
                                                              widget.list[index]
                                                                  .last_match_text!,
                                                              style: TextStyle(
                                                                  color:
                                                                      darkBlue,
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 50,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              widget.list[index].series_points,
                                              style: TextStyle(
                                                  color: Color(0xff666666),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                width: 50,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  double.parse(widget
                                                          .list[index].credit)
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 0, right: 10),
                                                child: new Container(
                                                  child: new Container(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    height: 20,
                                                    width: 20,
                                                    child: new Image.asset(
                                                        widget.list[index]
                                                                    .isSelected ??
                                                                false
                                                            ? AppImages
                                                                .removePlayerIcon
                                                            : AppImages
                                                                .addPlayerIcon,
                                                        fit: BoxFit.fill),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                new Divider(
                                  color: Colors.white,
                                  height: 0.5,
                                  thickness: 0.5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          if (widget.fantasyType ==
                                  AppConstants.BOWLING_FANTASY_TYPE &&
                              widget.type == 1) return;
                          bool isSelected =
                              widget.list[index].isSelected ?? false;
                          widget.onPlayerClick(!isSelected, index, widget.type);
                        },
                      ),
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }

  void checkList(int position) {
    bool isSelected = widget.list[position].isSelected ?? false;
    if (widget.type == 1) {
      if (widget.fantasyType == AppConstants.BOWLING_FANTASY_TYPE) {
        alpha = 0.3;
      } else if (widget.selectedPlayer.wk_selected ==
          widget.selectedPlayer.wk_max_count) {
        if (!isSelected)
          alpha = 0.3;
        else
          alpha = 1.0;
      } else if (widget.selectedPlayer.wk_selected >=
              widget.selectedPlayer.wk_min_count &&
          widget.selectedPlayer.extra_player == 0) {
        if (!isSelected)
          alpha = 0.3;
        else
          alpha = 1.0;
      } else if (widget.exeedCredit) {
        if (!isSelected)
          alpha = 1.0;
        else if (widget.limit.total_credits! -
                widget.selectedPlayer.total_credit >=
            widget.selectedPlayer.total_credit +
                double.parse(widget.list[position].credit))
          alpha = 1.0;
        else
          alpha = 0.3;
      } else if (double.parse(widget.list[position].credit) >
          (widget.limit.total_credits! - widget.selectedPlayer.total_credit)) {
        if (!isSelected)
          alpha = 0.3;
        else
          alpha = 1.0;
      } else {
        alpha = 1.0;
      }
    } else if (widget.type == 3) {
      if (widget.selectedPlayer.ar_selected ==
          widget.selectedPlayer.ar_maxcount) {
        if (!isSelected)
          alpha = 0.3;
        else
          alpha = 1.0;
      } else if (widget.selectedPlayer.ar_selected >=
              widget.selectedPlayer.ar_mincount &&
          widget.selectedPlayer.extra_player == 0) {
        if (!isSelected)
          alpha = 0.3;
        else
          alpha = 1.0;
      } else if (widget.exeedCredit) {
        if (!isSelected)
          alpha = 1.0;
        else if (widget.limit.total_credits! -
                widget.selectedPlayer.total_credit >=
            widget.selectedPlayer.total_credit +
                double.parse(widget.list[position].credit))
          alpha = 1.0;
        else
          alpha = 0.3;
      } else if (double.parse(widget.list[position].credit) >
          (widget.limit.total_credits! - widget.selectedPlayer.total_credit)) {
        if (!isSelected)
          alpha = 0.3;
        else
          alpha = 1.0;
      } else {
        alpha = 1.0;
      }
    } else if (widget.type == 2) {
      if (widget.selectedPlayer.bat_selected ==
          widget.selectedPlayer.bat_maxcount) {
        if (!isSelected)
          alpha = 0.3;
        else
          alpha = 1.0;
      } else if (widget.selectedPlayer.bat_selected >=
              widget.selectedPlayer.bat_mincount &&
          widget.selectedPlayer.extra_player == 0) {
        if (!isSelected)
          alpha = 0.3;
        else
          alpha = 1.0;
      } else if (widget.exeedCredit) {
        if (!isSelected)
          alpha = 1.0;
        else if (widget.limit.total_credits! -
                widget.selectedPlayer.total_credit >=
            widget.selectedPlayer.total_credit +
                double.parse(widget.list[position].credit))
          alpha = 1.0;
        else
          alpha = 0.3;
      } else if (double.parse(widget.list[position].credit) >
          (widget.limit.total_credits! - widget.selectedPlayer.total_credit)) {
        if (!isSelected)
          alpha = 0.3;
        else
          alpha = 1.0;
      } else {
        alpha = 1.0;
      }
    } else if (widget.type == 4) {
      if (widget.selectedPlayer.bowl_selected ==
          widget.selectedPlayer.bowl_maxcount) {
        if (!isSelected)
          alpha = 0.3;
        else
          alpha = 1.0;
      } else if (widget.selectedPlayer.bowl_selected >=
              widget.selectedPlayer.bowl_mincount &&
          widget.selectedPlayer.extra_player == 0) {
        if (!isSelected)
          alpha = 0.3;
        else
          alpha = 1.0;
      } else if (widget.exeedCredit) {
        if (!isSelected)
          alpha = 1.0;
        else if (widget.limit.total_credits! -
                widget.selectedPlayer.total_credit >=
            widget.selectedPlayer.total_credit +
                double.parse(widget.list[position].credit))
          alpha = 1.0;
        else
          alpha = 0.3;
      } else if (double.parse(widget.list[position].credit) >
          (widget.limit.total_credits! - widget.selectedPlayer.total_credit)) {
        if (!isSelected)
          alpha = 0.3;
        else
          alpha = 1.0;
      } else {
        alpha = 1.0;
      }
    } else if (widget.type == 5) {
      if (widget.selectedPlayer.c_selected ==
          widget.selectedPlayer.c_max_count) {
        if (!isSelected)
          alpha = 0.3;
        else
          alpha = 1.0;
      } else if (widget.selectedPlayer.c_selected >=
              widget.selectedPlayer.c_min_count &&
          widget.selectedPlayer.extra_player == 0) {
        if (!isSelected)
          alpha = 0.3;
        else
          alpha = 1.0;
      } else if (widget.exeedCredit) {
        if (isSelected)
          alpha = 1.0;
        else if (100 - widget.selectedPlayer.total_credit >=
            widget.selectedPlayer.total_credit +
                double.parse(widget.list[position].credit))
          alpha = 1.0;
        else
          alpha = 0.3;
      } else if (double.parse(widget.list[position].credit) >
          (100 - widget.selectedPlayer.total_credit)) {
        if (!isSelected)
          alpha = 0.3;
        else
          alpha = 1.0;
      } else {
        alpha = 1.0;
      }
    }
  }
}
