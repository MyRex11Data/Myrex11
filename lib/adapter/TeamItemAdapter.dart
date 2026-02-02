import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/app_navigator.dart';
import 'package:myrex11/appUtilities/teamsharebottomsheet.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/repository/model/team_response.dart';
import 'package:myrex11/views/CreateTeam.dart';

class TeamItemAdapter extends StatefulWidget {
  GeneralModel model;
  Team team;
  bool isForJoinContest;
  int index;
  Player? player;
  Function? onTeamCreated;
  Function? mySelectedcount;
  String? checkfrom;

  TeamItemAdapter(this.model, this.team, this.isForJoinContest, this.index,
      {this.player, this.onTeamCreated, this.mySelectedcount, this.checkfrom});

  @override
  _TeamItemAdapterState createState() => new _TeamItemAdapterState();
}

class _TeamItemAdapterState extends State<TeamItemAdapter> {
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
        opacity: widget.team.is_joined != 1 ? 1 : .3,
        child: new Container(
          child: new Row(
            children: [
              new Expanded(
                  child: Stack(children: [
                widget.team.is_non_playing_players == 1 ||
                        widget.team.is_substitute_players == 1
                    ? Card(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          children: [
                            widget.team.is_non_playing_players == 1
                                ? Container(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Color(0xffffddde),
                                        Colors.white
                                      ]),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10.0),
                                        // bottomRight: Radius.circular(10.0),
                                        topLeft: Radius.circular(10.0),
                                        // bottomLeft: Radius.circular(10.0)
                                      ),
                                    ),
                                    height: 50,
                                    // width: 300,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2, left: 12, bottom: 20),
                                      child: Row(
                                        children: [
                                          new Container(
                                            height: 8,
                                            width: 8,
                                            margin: EdgeInsets.only(right: 6),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xffc61d24)),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Color(0xffc61d24)),
                                          ),
                                          Text(
                                              widget.team
                                                  .is_non_playing_players_text!,
                                              style: TextStyle(
                                                  color: Color(0xffc61d24),
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                            widget.team.is_non_playing_players == 1 &&
                                    widget.team.is_substitute_players == 1
                                ? Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                AppImages.SubstituteBg),
                                            fit: BoxFit.fill)
                                        // borderRadius: BorderRadius.only(
                                        //   topRight: Radius.circular(10.0),
                                        //   // bottomRight: Radius.circular(10.0),
                                        //   topLeft: Radius.circular(10.0),
                                        //   // bottomLeft: Radius.circular(10.0)
                                        // ),
                                        ),
                                    height: 50,
                                    // width: 300,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2, left: 12, bottom: 20),
                                      child: Row(
                                        children: [
                                          new Container(
                                            height: 8,
                                            width: 8,
                                            margin: EdgeInsets.only(right: 6),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Color(0xff102881),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Color(0xff102881),
                                            ),
                                          ),
                                          Text(widget.team.is_substitute_text!,
                                              style: TextStyle(
                                                  color: Color(0xff102881),
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  )
                                : widget.team.is_non_playing_players == 0 &&
                                        widget.team.is_substitute_players == 1
                                    ? Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          // image: DecorationImage(
                                          //     image: AssetImage(AppImages.SubstituteBg),
                                          //     fit: BoxFit.fill)
                                          gradient: LinearGradient(colors: [
                                            Color(0xffd8e0fb),
                                            Color(0xffd8e0fb),
                                            Colors.white
                                          ]),
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10.0),
                                            // bottomRight: Radius.circular(10.0),
                                            topLeft: Radius.circular(10.0),
                                            // bottomLeft: Radius.circular(10.0)
                                          ),
                                        ),
                                        height: 50,
                                        // width: 300,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 2, left: 12, bottom: 20),
                                          child: Row(
                                            children: [
                                              new Container(
                                                height: 8,
                                                width: 8,
                                                margin:
                                                    EdgeInsets.only(right: 6),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Color(0xff102881),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Color(0xff102881),
                                                ),
                                              ),
                                              Text(
                                                  widget
                                                      .team.is_substitute_text!,
                                                  style: TextStyle(
                                                      color: Color(0xff102881),
                                                      fontSize: 12)),
                                            ],
                                          ),
                                        ))
                                    : Container(),
                          ],
                        ),
                      )
                    : Container(),
                Padding(
                  padding: widget.team.is_non_playing_players == 1 ||
                          widget.team.is_substitute_players == 1
                      ? const EdgeInsets.only(top: 30)
                      : const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () {
                      openPreview();
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(widget.model.sportKey ==
                                    AppConstants.TAG_CRICKET
                                ? AppImages.cricketTeamBgIcon
                                : widget.model.sportKey ==
                                        AppConstants.TAG_FOOTBALL
                                    ? AppImages.myteam_field
                                    : widget.model.sportKey ==
                                            AppConstants.TAG_BASKETBALL
                                        ? AppImages.myteams_basketball_bg
                                        : AppImages.kabbadiTeamBgIcon),
                            fit: BoxFit.cover,
                          ),
                        ),
                        padding: EdgeInsets.all(0),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.30),
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Color(0xFF003d07)
                                                  .withOpacity(0.4),
                                              width: 0.3))),
                                  child: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      new Container(
                                        margin: EdgeInsets.only(left: 10),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Team ' +
                                              widget.team.teamnumber.toString(),
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                        ),
                                      ),
                                      !(widget.model.isFromLiveFinish ?? false)
                                          ? new Container(
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: new Row(
                                                children: [
                                                  Visibility(
                                                    visible: widget
                                                                .isForJoinContest &&
                                                            widget.team
                                                                    .is_joined !=
                                                                1
                                                        ? false
                                                        : true,
                                                    child: new GestureDetector(
                                                      behavior: HitTestBehavior
                                                          .translucent,
                                                      child: new Container(
                                                        padding:
                                                            EdgeInsets.all(4),
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Color(
                                                                    0xff007913),
                                                                border:
                                                                    Border.all(
                                                                  color: Color(
                                                                      0xff02520D),
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4)),
                                                        margin: EdgeInsets.only(
                                                            left: 0, right: 15),
                                                        height: 26,
                                                        // width: 26,
                                                        child: Image(
                                                          image: AssetImage(
                                                            AppImages
                                                                .teamViewIcon,
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        openPreview();
                                                      },
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: widget
                                                                .isForJoinContest &&
                                                            widget.team
                                                                    .is_joined !=
                                                                1
                                                        ? false
                                                        : true,
                                                    child: new GestureDetector(
                                                      behavior: HitTestBehavior
                                                          .translucent,
                                                      child: new Container(
                                                        padding:
                                                            EdgeInsets.all(4),
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Color(
                                                                    0xff007913),
                                                                border:
                                                                    Border.all(
                                                                  color: Color(
                                                                      0xff02520D),
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4)),
                                                        margin: EdgeInsets.only(
                                                            right: 15, left: 0),
                                                        height: 26,
                                                        // width: 26,
                                                        child: Image(
                                                          image: AssetImage(
                                                            AppImages
                                                                .teamEditIcon,
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        if (widget.team
                                                                .is_joined ==
                                                            0) {
                                                          widget.model
                                                                  .onTeamCreated =
                                                              widget
                                                                  .onTeamCreated;
                                                          widget.model
                                                                  .selectedList =
                                                              widget
                                                                  .team.players;
                                                          widget.model.teamId =
                                                              widget
                                                                  .team.teamid;
                                                          widget.model
                                                                  .teamName =
                                                              'Team ' +
                                                                  widget.team
                                                                      .teamnumber
                                                                      .toString();
                                                          widget.model
                                                                  .isFromEditOrClone =
                                                              true;
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => CreateTeam(
                                                                      widget
                                                                          .model,
                                                                      teamId: widget
                                                                          .team
                                                                          .teamid))).then(
                                                              (value) {
                                                            setState(() {
                                                              widget
                                                                  .onTeamCreated!();
                                                            });
                                                          });
                                                          // navigateToCreateTeam(
                                                          //     context,
                                                          //     widget.model,
                                                          //     teamid: widget
                                                          //         .team.teamid);
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      right: 15,
                                                    ),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        ShareBottomSheet
                                                            .openBottomSheet(
                                                                context,
                                                                widget.team
                                                                        .team_share_link ??
                                                                    '',
                                                                widget.model);
                                                      },
                                                      child: Container(
                                                        height: 26,
                                                        child: Image.asset(
                                                            AppImages
                                                                .teamshare),
                                                      ),
                                                    ),
                                                  ),
                                                  new GestureDetector(
                                                    behavior: HitTestBehavior
                                                        .translucent,
                                                    child: new Container(
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xff007913),
                                                          border: Border.all(
                                                            color: Color(
                                                                0xff02520D),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4)),
                                                      margin: EdgeInsets.only(
                                                          left: 0, right: 0),
                                                      height: 26,
                                                      // width: 26,
                                                      child: Image(
                                                        image: AssetImage(
                                                          AppImages.copyIcon,
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      if (widget
                                                              .team.is_joined ==
                                                          0) {
                                                        widget.model
                                                                .selectedList =
                                                            widget.team.players;
                                                        widget.model.teamId = 0;
                                                        widget.model.teamName =
                                                            'Team ' +
                                                                widget.team
                                                                    .teamnumber
                                                                    .toString();
                                                        widget.model
                                                                .isFromEditOrClone =
                                                            true;
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        CreateTeam(
                                                                          widget
                                                                              .model,
                                                                        ))).then(
                                                            (value) {
                                                          setState(() {
                                                            widget
                                                                .onTeamCreated!();
                                                          });
                                                        });
                                                        // navigateToCreateTeam(
                                                        //     context,
                                                        //     widget.model);
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(
                                              child: Visibility(
                                                visible: true,
                                                child: new GestureDetector(
                                                  behavior: HitTestBehavior
                                                      .translucent,
                                                  child: new Container(
                                                    padding: EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xff007913),
                                                        border: Border.all(
                                                          color:
                                                              Color(0xff02520D),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4)),
                                                    margin: EdgeInsets.only(
                                                        left: 0, right: 15),
                                                    height: 26,
                                                    // width: 22,
                                                    child: Image(
                                                      image: AssetImage(
                                                        AppImages.teamViewIcon,
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    openPreview();
                                                  },
                                                ),
                                              ),
                                              // padding:
                                              //     EdgeInsets.only(right: 10),
                                              // child: Row(
                                              //   children: [
                                              //     Text(
                                              //       'POINTS :',
                                              //       textAlign: TextAlign.end,
                                              //       style: TextStyle(
                                              //         fontSize: 11,
                                              //         color: Colors.white,
                                              //         fontWeight:
                                              //             FontWeight.w500,
                                              //       ),
                                              //     ),
                                              //     Text(
                                              //       widget.team.points!
                                              //           .toString(),
                                              //       textAlign: TextAlign.end,
                                              //       style: TextStyle(
                                              //         fontSize: 16,
                                              //         color: Colors.white,
                                              //         fontWeight:
                                              //             FontWeight.w500,
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                            ),
                                      // !widget.isForJoinContest
                                      //     ? Container(
                                      //         margin: EdgeInsets.only(
                                      //             left: 10, right: 10),
                                      //         alignment: Alignment.centerLeft,
                                      //         child: Text(
                                      //           'Fantasy Type (' +
                                      //               widget.team.fantasytype
                                      //                   .toString() +
                                      //               ')',
                                      //           style: TextStyle(
                                      //               fontFamily: "Roboto",
                                      //               color: Colors.white,
                                      //               fontWeight: FontWeight.w500,
                                      //               fontSize: 14),
                                      //         ),
                                      //       )
                                      //     : SizedBox.shrink(),
                                      // !(widget.model.isFromLiveFinish??false)?new Container(
                                      //   margin: EdgeInsets.only(right: 10),
                                      //   child: new Row(
                                      //     children: [
                                      //       new GestureDetector(
                                      //         behavior: HitTestBehavior.translucent,
                                      //         child: new Container(
                                      //           margin: EdgeInsets.only(right: 10),
                                      //           height: 18,
                                      //           width: 18,
                                      //           child: Image(
                                      //             image: AssetImage(
                                      //               AppImages.teamEditIcon,),
                                      //             color: Colors.white,),
                                      //         ),
                                      //         onTap: (){
                                      //           widget.model.selectedList=widget.team.players;
                                      //           widget.model.teamId=widget.team.teamid;
                                      //           widget.model.teamName='Team '+widget.team.teamnumber.toString();
                                      //           widget.model.isFromEditOrClone=true;
                                      //           navigateToCreateTeam(context, widget.model);
                                      //         },
                                      //       ),
                                      //       new GestureDetector(
                                      //         behavior: HitTestBehavior.translucent,
                                      //         child: new Container(
                                      //           margin: EdgeInsets.only(
                                      //               left: 15, right: 10),
                                      //           height: 18,
                                      //           width: 18,
                                      //           child: Image(
                                      //             image: AssetImage(
                                      //               AppImages.copyIcon,),
                                      //             color: Colors.white,),
                                      //         ),
                                      //         onTap: (){
                                      //           widget.model.selectedList=widget.team.players;
                                      //           widget.model.teamId=0;
                                      //           widget.model.teamName='Team '+widget.team.teamnumber.toString();
                                      //           widget.model.isFromEditOrClone=true;
                                      //           navigateToCreateTeam(context, widget.model);
                                      //         },
                                      //       ),
                                      //       new GestureDetector(
                                      //         behavior: HitTestBehavior.translucent,
                                      //         child: new Container(
                                      //           margin: EdgeInsets.only(
                                      //               left: 15, right: 10),
                                      //           height: 18,
                                      //           width: 23,
                                      //           child: Image(
                                      //             image: AssetImage(
                                      //               AppImages.teamViewIcon,),
                                      //             color: Colors.white,),
                                      //         ),
                                      //         onTap: (){
                                      //           openPreview();
                                      //         },
                                      //       ),
                                      //
                                      //     ],
                                      //   ),
                                      // ):new Container(),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width * 1,
                                  child: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(),
                                      (widget.model.isFromLiveFinish == true)
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Points',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  widget.team.points.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ), // Text(widget.model)
                                              ],
                                            )
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          border: Border.all(
                                                              color:
                                                                  Colors.white),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              widget.team
                                                                  .team1_name
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                                widget.team
                                                                    .team1_player_count
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Container(
                                                      clipBehavior:
                                                          Clip.antiAlias,

                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      // elevation: 0,

                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                                widget.team
                                                                    .team2_name
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                                widget.team
                                                                    .team2_player_count
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                      new Container(
                                        child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            new Container(
                                              margin: EdgeInsets.only(
                                                  left: 10, right: 5),
                                              child: Stack(
                                                alignment: Alignment.topLeft,
                                                children: [
                                                  Container(
                                                    child: Center(
                                                      child: Text(
                                                        'C',
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    width:
                                                        18, // Width of the container
                                                    height:
                                                        18, // Height of the container
                                                    decoration: BoxDecoration(
                                                      color: Colors
                                                          .black, // Fill color
                                                      shape: BoxShape
                                                          .circle, // Makes the container round
                                                      border: Border.all(
                                                        color: Colors
                                                            .white, // Border color
                                                        width:
                                                            1, // Border width
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          new Stack(
                                                            alignment: Alignment
                                                                .topCenter,
                                                            children: [
                                                              Stack(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                children: [
                                                                  Container(
                                                                    height: 55,
                                                                    width: 55,
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      imageUrl: widget
                                                                          .team
                                                                          .captainImage(),
                                                                      placeholder: (context,
                                                                              url) =>
                                                                          Image.asset(
                                                                              AppImages.defaultAvatarIcon),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          Image.asset(
                                                                              AppImages.defaultAvatarIcon),
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                height: 75,
                                                                child: Stack(
                                                                    children: [
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                            color: widget.team.captainteamName() == 'team1'
                                                                                ? Colors.white
                                                                                : Colors.black,
                                                                            border: Border.all(color: Colors.white)),
                                                                        height:
                                                                            20,
                                                                        width:
                                                                            75,
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                2),
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Flexible(
                                                                                child: Text(
                                                                              widget.team.captainName(),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(fontFamily: "Roboto", fontSize: 12, fontWeight: FontWeight.w400, color: widget.team.captainteamName() == 'team1' ? Colors.black : Colors.white),
                                                                              textAlign: TextAlign.center,
                                                                            ))
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      widget.team
                                                                              .cPlaying()
                                                                          ? Padding(
                                                                              padding: const EdgeInsets.only(bottom: 0),
                                                                              child: Container(
                                                                                height: 7,
                                                                                width: 7,
                                                                                margin: EdgeInsets.only(top: 2, left: 3),
                                                                                alignment: Alignment.center,
                                                                                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white)),
                                                                              ),
                                                                            )
                                                                          : SizedBox(),
                                                                      widget.team
                                                                              .cSubstitute()
                                                                          ? Padding(
                                                                              padding: const EdgeInsets.only(bottom: 20),
                                                                              child: new Container(
                                                                                height: 7,
                                                                                width: 7,
                                                                                margin: EdgeInsets.only(top: 2, left: 3),
                                                                                alignment: Alignment.center,
                                                                                decoration: BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(4), color: Color(0xff102881)),
                                                                              ),
                                                                            )
                                                                          : SizedBox(),
                                                                    ]),
                                                              ),
                                                            ],
                                                          ),
                                                          // new Container(
                                                          //   height: 24,
                                                          //   width: 24,
                                                          //   alignment: Alignment.center,
                                                          //   decoration: BoxDecoration(
                                                          //       border: Border.all(
                                                          //           color: Colors.white),
                                                          //       borderRadius: BorderRadius
                                                          //           .circular(12),
                                                          //       color: Colors.black
                                                          //   ),
                                                          //   child: new Text('C',
                                                          //     style: TextStyle(
                                                          //         fontFamily: "Roboto",
                                                          //         color: Colors.white,
                                                          //         fontWeight: FontWeight.w500,
                                                          //         fontSize: 10),
                                                          //     textAlign: TextAlign.center,),
                                                          // ),
                                                        ],
                                                      ),
                                                      // Text(
                                                      //   'Captain',
                                                      //   style: TextStyle(
                                                      //       fontFamily: "Roboto",
                                                      //       color: Colors.white,
                                                      //       fontWeight:
                                                      //           FontWeight.w400,
                                                      //       fontSize: 12),
                                                      //   textAlign: TextAlign.center,
                                                      // ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Container(
                                            //   // height: 20,
                                            //   // width: 20,
                                            //   decoration: BoxDecoration(
                                            //     shape: BoxShape.circle,
                                            //     color: Colors.transparent,
                                            //     border: Border.all(
                                            //         color: Colors.transparent),
                                            //   ),
                                            //   child: Padding(
                                            //     padding:
                                            //         const EdgeInsets.all(4),
                                            //     child: Center(
                                            //       child: Text(
                                            //         'VS',
                                            //         style: TextStyle(
                                            //             color:
                                            //                 Colors.transparent,
                                            //             fontSize: 12),
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                            new Container(
                                              margin: EdgeInsets.only(
                                                  left: 5, right: 10),
                                              child: Stack(
                                                alignment: Alignment.topLeft,
                                                children: [
                                                  Container(
                                                    child: Center(
                                                      child: Text(
                                                        'VC',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    width:
                                                        18, // Width of the container
                                                    height:
                                                        18, // Height of the container
                                                    decoration: BoxDecoration(
                                                      color: Color(
                                                          0xffffffff), // Fill color
                                                      shape: BoxShape
                                                          .circle, // Makes the container round
                                                      border: Border.all(
                                                        color: Colors
                                                            .black, // Border color
                                                        width:
                                                            1, // Border width
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      new Stack(
                                                        children: [
                                                          new Stack(
                                                            alignment: Alignment
                                                                .topCenter,
                                                            children: [
                                                              Stack(
                                                                children: [
                                                                  new Container(
                                                                    height: 55,
                                                                    width: 55,
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      imageUrl: widget
                                                                          .team
                                                                          .vcCaptainImage(),
                                                                      placeholder: (context,
                                                                              url) =>
                                                                          Image.asset(
                                                                              AppImages.defaultAvatarIcon),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          Image.asset(
                                                                              AppImages.defaultAvatarIcon),
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              new Container(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                height: 75,
                                                                child: Stack(
                                                                    children: [
                                                                      Container(
                                                                        child:
                                                                            Container(
                                                                          decoration: BoxDecoration(
                                                                              color: widget.team.vcCaptainTeamName() == 'team1' ? Colors.white : Colors.black,
                                                                              border: Border.all(color: Colors.black)),
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              75,
                                                                          margin:
                                                                              EdgeInsets.only(top: 2),
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Flexible(
                                                                                  child: Text(
                                                                                widget.team.vcCaptainName(),
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(fontFamily: "Roboto", fontSize: 12, fontWeight: FontWeight.w400, color: widget.team.vcCaptainTeamName() == 'team1' ? Colors.black : Colors.white),
                                                                                textAlign: TextAlign.center,
                                                                              ))
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      widget.team.players!.length !=
                                                                              0
                                                                          ? Container(
                                                                              child: widget.team.vcPlaying()
                                                                                  ? Padding(
                                                                                      padding: const EdgeInsets.only(bottom: 0),
                                                                                      child: Container(
                                                                                        height: 7,
                                                                                        width: 7,
                                                                                        margin: EdgeInsets.only(top: 2, left: 3),
                                                                                        alignment: Alignment.center,
                                                                                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white)),
                                                                                      ),
                                                                                    )
                                                                                  : SizedBox(),
                                                                            )
                                                                          : SizedBox(),
                                                                      widget.team.players!.length !=
                                                                              0
                                                                          ? Container(
                                                                              child: widget.team.vcSubstitute()
                                                                                  ? Padding(
                                                                                      padding: const EdgeInsets.only(bottom: 20),
                                                                                      child: Container(
                                                                                        height: 7,
                                                                                        width: 7,
                                                                                        margin: EdgeInsets.only(top: 2, left: 3),
                                                                                        alignment: Alignment.center,
                                                                                        decoration: BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(4), color: Color(0xff102881)),
                                                                                      ),
                                                                                    )
                                                                                  : SizedBox(),
                                                                            )
                                                                          : SizedBox()
                                                                    ]),
                                                              ),
                                                            ],
                                                          ),
                                                          // new Container(
                                                          //   height: 24,
                                                          //   width: 24,
                                                          //   alignment: Alignment.center,
                                                          //   decoration: BoxDecoration(
                                                          //       border: Border.all(
                                                          //           color: Colors.white),
                                                          //       borderRadius: BorderRadius
                                                          //           .circular(12),
                                                          //       color: Colors.black
                                                          //   ),
                                                          //   child: new Text('VC',
                                                          //     style: TextStyle(
                                                          //         fontFamily: "Roboto",
                                                          //         color: Colors.white,
                                                          //         fontWeight: FontWeight.w500,
                                                          //         fontSize: 10),
                                                          //     textAlign: TextAlign.center,),
                                                          // ),
                                                        ],
                                                      ),
                                                      // Text(
                                                      //   'V Captain',
                                                      //   style: TextStyle(
                                                      //       fontFamily: "Roboto",
                                                      //       color: Colors.white,
                                                      //       fontWeight:
                                                      //           FontWeight.w400,
                                                      //       fontSize: 12),
                                                      //   textAlign: TextAlign.center,
                                                      // ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        margin: EdgeInsets.only(top: 10),
                                      ),

                                      // Column(
                                      //   children: [
                                      //     !(widget.model.isFromLiveFinish ??
                                      //             false)
                                      //         ? InkWell(
                                      //             onTap: () {
                                      //               if (widget.team.is_joined ==
                                      //                   0) {
                                      //                 widget.model
                                      //                         .selectedList =
                                      //                     widget.team.players;
                                      //                 widget.model.teamId =
                                      //                     widget.team.teamid;
                                      //                 widget.model.teamName =
                                      //                     'Team ' +
                                      //                         widget.team
                                      //                             .teamnumber
                                      //                             .toString();
                                      //                 widget.model
                                      //                         .isFromEditOrClone =
                                      //                     true;
                                      //                 navigateToCreateTeam(
                                      //                     context, widget.model,
                                      //                     teamid: widget
                                      //                         .team.teamid);
                                      //               }
                                      //             },
                                      //             child: Container(
                                      //               height: 24,
                                      //               width: 82,
                                      //               margin: EdgeInsets.only(
                                      //                   right: 12, top: 10),
                                      //               decoration: BoxDecoration(
                                      //                 borderRadius:
                                      //                     BorderRadius.all(
                                      //                         Radius.circular(
                                      //                             3)),
                                      //                 color: Colors.black
                                      //                     .withOpacity(0.5),
                                      //                 // border: Border.all(color: Colors.black.withOpacity(0.5)),
                                      //               ),
                                      //               child: Row(
                                      //                 children: [
                                      //                   Container(
                                      //                     margin:
                                      //                         EdgeInsets.only(
                                      //                       left: 12,
                                      //                     ),
                                      //                     height: 12,
                                      //                     width: 12,
                                      //                     child: Image.asset(
                                      //                         AppImages
                                      //                             .teamEditIcon,
                                      //                         color:
                                      //                             Colors.white),
                                      //                   ),
                                      //                   Padding(
                                      //                     padding:
                                      //                         const EdgeInsets
                                      //                                 .only(
                                      //                             left: 8.0),
                                      //                     child: Text('Edit',
                                      //                         style: TextStyle(
                                      //                             color: Colors
                                      //                                 .white,
                                      //                             fontSize:
                                      //                                 12)),
                                      //                   ),
                                      //                 ],
                                      //               ),
                                      //             ),
                                      //           )
                                      //         : Container(),
                                      //     !(widget.model.isFromLiveFinish ??
                                      //             false)
                                      //         ? InkWell(
                                      //             onTap: () {
                                      //               openPreview();
                                      //             },
                                      //             child: Container(
                                      //               height: 24,
                                      //               width: 82,
                                      //               margin: EdgeInsets.only(
                                      //                   right: 12, top: 10),
                                      //               decoration: BoxDecoration(
                                      //                 borderRadius:
                                      //                     BorderRadius.all(
                                      //                         Radius.circular(
                                      //                             3)),
                                      //                 color: Colors.black
                                      //                     .withOpacity(0.5),
                                      //                 // border: Border.all(color: Colors.black.withOpacity(0.5)),
                                      //               ),
                                      //               child: Row(
                                      //                 children: [
                                      //                   Container(
                                      //                       margin:
                                      //                           EdgeInsets.only(
                                      //                         left: 12,
                                      //                       ),
                                      //                       height: 12,
                                      //                       width: 12,
                                      //                       child: Image.asset(
                                      //                           AppImages
                                      //                               .teamViewIcon,
                                      //                           color: Colors
                                      //                               .white)),
                                      //                   Padding(
                                      //                     padding:
                                      //                         const EdgeInsets
                                      //                                 .only(
                                      //                             left: 8.0),
                                      //                     child: Text(
                                      //                       'Preview',
                                      //                       style: TextStyle(
                                      //                           color: Colors
                                      //                               .white,
                                      //                           fontSize: 12),
                                      //                     ),
                                      //                   ),
                                      //                 ],
                                      //               ),
                                      //             ),
                                      //           )
                                      //         : Container(),
                                      //     !(widget.model.isFromLiveFinish ??
                                      //             false)
                                      //         ? InkWell(
                                      //             onTap: () {
                                      //               if (widget.team.is_joined ==
                                      //                   0) {
                                      //                 widget.model
                                      //                         .selectedList =
                                      //                     widget.team.players;
                                      //                 widget.model.teamId = 0;
                                      //                 widget.model.teamName =
                                      //                     'Team ' +
                                      //                         widget.team
                                      //                             .teamnumber
                                      //                             .toString();
                                      //                 widget.model
                                      //                         .isFromEditOrClone =
                                      //                     true;
                                      //                 navigateToCreateTeam(
                                      //                     context,
                                      //                     widget.model);
                                      //               }
                                      //             },
                                      //             child: Container(
                                      //               height: 24,
                                      //               width: 82,
                                      //               margin: EdgeInsets.only(
                                      //                   right: 12, top: 10),
                                      //               decoration: BoxDecoration(
                                      //                 borderRadius:
                                      //                     BorderRadius.all(
                                      //                         Radius.circular(
                                      //                             3)),
                                      //                 color: Colors.black
                                      //                     .withOpacity(0.5),
                                      //                 // border: Border.all(color: Colors.black.withOpacity(0.5)),
                                      //               ),
                                      //               child: Row(
                                      //                 children: [
                                      //                   Container(
                                      //                       margin:
                                      //                           EdgeInsets.only(
                                      //                         left: 12,
                                      //                       ),
                                      //                       height: 12,
                                      //                       width: 12,
                                      //                       child: Image.asset(
                                      //                         AppImages
                                      //                             .copyIcon,
                                      //                         color:
                                      //                             Colors.white,
                                      //                       )),
                                      //                   Padding(
                                      //                     padding:
                                      //                         const EdgeInsets
                                      //                                 .only(
                                      //                             left: 8.0),
                                      //                     child: Text(
                                      //                       'Clone',
                                      //                       style: TextStyle(
                                      //                           color: Colors
                                      //                               .white,
                                      //                           fontSize: 12),
                                      //                     ),
                                      //                   ),
                                      //                 ],
                                      //               ),
                                      //             ),
                                      //           )
                                      //         : Container(),
                                      //   ],
                                      // )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              color: LightprimaryColor,
                              width: MediaQuery.of(context).size.width,
                              height: 30,
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(left: 10),
                                        alignment: Alignment.center,
                                        child: keeperCount()
                                        //  Row(
                                        //   children: [
                                        //     Text(
                                        //       'WK',
                                        //       style: TextStyle(
                                        //           fontFamily: "Roboto",
                                        //           color: Colors.grey,
                                        //           fontWeight: FontWeight.w400,
                                        //           fontSize: 12),
                                        //     ),
                                        //     Text(
                                        //     ,
                                        //       style: TextStyle(
                                        //           fontFamily: "Roboto",
                                        //           color: Colors.black,
                                        //           fontWeight: FontWeight.bold,
                                        //           fontSize: 12),
                                        //     ),
                                        //   ],
                                        // ),
                                        ),
                                    new Container(
                                      margin: EdgeInsets.only(left: 10),
                                      alignment: Alignment.center,
                                      child: batsmanCount(),
                                      //  Row(
                                      //   children: [
                                      //     Text(
                                      //       'BAT',
                                      //       style: TextStyle(
                                      //           color: Colors.grey,
                                      //           fontWeight: FontWeight.bold,
                                      //           fontSize: 12),
                                      //     ),
                                      //     Text(
                                      //       batsmanCount(),
                                      //       style: TextStyle(
                                      //           color: Colors.black,
                                      //           fontWeight: FontWeight.bold,
                                      //           fontSize: 12),
                                      //     ),
                                      //   ],
                                      // ),
                                    ),
                                    if (widget.model.sportKey !=
                                        AppConstants.TAG_KABADDI)
                                      new Container(
                                        margin: EdgeInsets.only(left: 10),
                                        alignment: Alignment.center,
                                        child: allRounderCount(),
                                        //  Row(
                                        //   children: [
                                        //     Text(
                                        //       "AR",
                                        //       style: TextStyle(
                                        //           color: Colors.grey,
                                        //           fontWeight: FontWeight.bold,
                                        //           fontSize: 12),
                                        //     ),
                                        //     Text(
                                        //       allRounderCount(),
                                        //       style: TextStyle(
                                        //           color: Colors.black,
                                        //           fontWeight: FontWeight.bold,
                                        //           fontSize: 12),
                                        //     ),
                                        //   ],
                                        // ),
                                      ),
                                    new Container(
                                      margin: EdgeInsets.only(left: 10),
                                      alignment: Alignment.center,
                                      child: bolwerCount(),
                                      //  Row(
                                      //   children: [
                                      //     Text(
                                      //       "BOWL",
                                      //       style: TextStyle(
                                      //           color: Colors.grey,
                                      //           fontWeight: FontWeight.w400,
                                      //           fontSize: 12),
                                      //     ),
                                      //     Text(
                                      //       bolwerCount(),
                                      //       style: TextStyle(
                                      //           color: Colors.black,
                                      //           fontWeight: FontWeight.bold,
                                      //           fontSize: 12),
                                      //     ),
                                      //   ],
                                      // ),
                                    ),
                                    if (widget.model.sportKey ==
                                        AppConstants.TAG_BASKETBALL)
                                      new Container(
                                        margin: EdgeInsets.only(left: 10),
                                        alignment: Alignment.center,
                                        child: Text(
                                          CCount(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ])),
              widget.isForJoinContest && widget.team.is_joined != 1
                  ? new Container(
                      width: 30,
                      child: Checkbox(
                        activeColor: Color(0xFF45b336),
                        checkColor: Colors.white,
                        value: widget.team.isSelected ?? false,
                        shape: CircleBorder(),
                        onChanged: (value) {
                          if (widget.isForJoinContest) {
                            widget.model.teamClickListener!(widget.index);
                          }
                        },
                        // onChanged: (bool? value) {
                        //   setState(() {
                        //     widget.team.isSelected ?? true;
                        //     if (widget.isForJoinContest) {
                        //       widget.model.teamClickListener!(widget.index);
                        //     }
                        //     if (value == false) {
                        //       allSelect.value = false;
                        //       setState(() {});
                        //     }
                        //   });
                        // },
                      ),
                    )
                  : new Container(
                      width: widget.team.is_joined == 1 ? 30 : 0,
                    ),
            ],
          ),
        ),
      ),
      onTap: () {
        if ((widget.model.isFromLiveFinish ?? false)) {
          openPreview();
        } else if (widget.isForJoinContest && widget.team.is_joined != 1) {
          widget.model.teamClickListener!(widget.index);
        }
      },
    );
  }

  Row keeperCount() {
    int i = 0;
    String name = "WK ";
    for (Player player in widget.team.players!) {
      if (widget.model.sportKey == "CRICKET") {
        if (player.role!.toLowerCase() ==
            AppConstants.KEY_PLAYER_ROLE_KEEP.toLowerCase()) i++;
        name = "WK ";
      } else if (widget.model.sportKey == "FOOTBALL") {
        if (player.role!.toLowerCase() ==
            AppConstants.KEY_PLAYER_ROLE_GK.toLowerCase()) i++;
        name = "GK ";
      } else if (widget.model.sportKey == AppConstants.TAG_KABADDI) {
        if (player.role!.toLowerCase() ==
            AppConstants.KEY_PLAYER_ROLE_DEF.toLowerCase()) i++;
        name = "DEF ";
      } else {
        if (player.role!.toLowerCase() ==
            AppConstants.KEY_PLAYER_ROLE_PG.toLowerCase()) i++;
        name = "PG ";
      }
    }
    return Row(
      children: [
        Text(
          name + "",
          style: TextStyle(
              fontFamily: "Roboto",
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 12),
        ),
        Text(i.toString() + "",
            style: TextStyle(
                fontFamily: "Roboto",
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12))
      ],
    );
  }

  Row batsmanCount() {
    int i = 0;
    String name = "BAT ";
    for (Player player in widget.team.players!) {
      if (widget.model.sportKey == "CRICKET") {
        if (player.role!.toLowerCase() ==
            AppConstants.KEY_PLAYER_ROLE_BAT.toLowerCase()) i++;
        name = "BAT ";
      } else if (widget.model.sportKey == "FOOTBALL") {
        if (player.role!.toLowerCase() ==
            AppConstants.KEY_PLAYER_ROLE_DEF.toLowerCase()) i++;
        name = "DEF ";
      } else if (widget.model.sportKey == AppConstants.TAG_KABADDI) {
        if (player.role!.toLowerCase() ==
            AppConstants.KEY_PLAYER_ROLE_ALL_R.toLowerCase()) i++;
        name = "ALL ";
      } else {
        if (player.role!.toLowerCase() ==
            AppConstants.KEY_PLAYER_ROLE_SG.toLowerCase()) i++;
        name = "SG ";
      }
    }
    return Row(
      children: [
        Text(
          name + "",
          style: TextStyle(
              fontFamily: "Roboto",
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 12),
        ),
        Text(i.toString() + "",
            style: TextStyle(
                fontFamily: "Roboto",
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12))
      ],
    );
  }

  Row allRounderCount() {
    int i = 0;
    String name = "AR ";
    for (Player player in widget.team.players!) {
      if (widget.model.sportKey == "CRICKET") {
        if (player.role!.toLowerCase() ==
            AppConstants.KEY_PLAYER_ROLE_ALL_R.toLowerCase()) i++;
        name = "AR ";
      } else if (widget.model.sportKey == "FOOTBALL" ||
          widget.model.sportKey == AppConstants.TAG_KABADDI) {
        if (player.role!.toLowerCase() ==
            AppConstants.KEY_PLAYER_ROLE_MID.toLowerCase()) i++;
        name = "MID ";
      } else {
        if (player.role!.toLowerCase() ==
            AppConstants.KEY_PLAYER_ROLE_SF.toLowerCase()) i++;
        name = "SF ";
      }
    }
    return Row(
      children: [
        Text(
          name + "",
          style: TextStyle(
              fontFamily: "Roboto",
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 12),
        ),
        Text(i.toString() + "",
            style: TextStyle(
                fontFamily: "Roboto",
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12))
      ],
    );
  }

  Row bolwerCount() {
    int i = 0;
    String name = "BOWL ";
    for (Player player in widget.team.players!) {
      if (widget.model.sportKey == "CRICKET") {
        if (player.role!.toLowerCase() ==
            AppConstants.KEY_PLAYER_ROLE_BOL.toLowerCase()) i++;
        name = "BOWL ";
      } else if (widget.model.sportKey == "FOOTBALL") {
        if (player.role!.toLowerCase() ==
            AppConstants.KEY_PLAYER_ROLE_ST.toLowerCase()) i++;
        name = "ST ";
      } else if (widget.model.sportKey == AppConstants.TAG_KABADDI) {
        if (player.role!.toLowerCase() ==
            AppConstants.KEY_PLAYER_ROLE_RD.toLowerCase()) i++;
        name = "RAIDER ";
      } else {
        if (player.role!.toLowerCase() ==
            AppConstants.KEY_PLAYER_ROLE_PF.toLowerCase()) i++;
        name = "PF ";
      }
    }
    return Row(
      children: [
        Text(
          name + "",
          style: TextStyle(
              fontFamily: "Roboto",
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 12),
        ),
        Text(i.toString() + "",
            style: TextStyle(
                fontFamily: "Roboto",
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12))
      ],
    );
  }

  String CCount() {
    int i = 0;
    for (Player player in widget.team.players!) {
      if (player.role!.toLowerCase() ==
          AppConstants.KEY_PLAYER_ROLE_C.toLowerCase()) i++;
    }
    return "C " + "" + i.toString() + "";
  }

  void openPreview() {
    List<Player> selectedWkList = [];
    List<Player> selectedBatLiSt = [];
    List<Player> selectedArList = [];
    List<Player> selectedBowlList = [];
    List<Player> selectedcList = [];
    for (Player player in widget.team.players!) {
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
        selectedWkList.add(player);
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
        selectedBatLiSt.add(player);
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
        selectedArList.add(player);
      } else if (player.role.toString().toLowerCase() ==
          (widget.model.sportKey == AppConstants.TAG_CRICKET
                  ? AppConstants.KEY_PLAYER_ROLE_BOL
                  : widget.model.sportKey == AppConstants.TAG_BASKETBALL
                      ? AppConstants.KEY_PLAYER_ROLE_PF
                      : AppConstants.KEY_PLAYER_ROLE_ST)
              .toString()
              .toLowerCase()) {
        selectedBowlList.add(player);
      } else if (player.role.toString().toLowerCase() ==
          AppConstants.KEY_PLAYER_ROLE_C.toString().toLowerCase()) {
        selectedcList.add(player);
      }
    }
    widget.model.selectedWkList = selectedWkList;
    widget.model.selectedBatLiSt = selectedBatLiSt;
    widget.model.selectedArList = selectedArList;
    widget.model.selectedBowlList = selectedBowlList;
    widget.model.selectedcList = selectedcList;
    // widget.model.isForLeaderBoard=false;
    // widget.model.teamName='Team '+widget.team.teamnumber.toString();

    widget.model.selectedList = widget.team.players;
    widget.model.teamId = widget.team.teamid;
    widget.model.teamName = 'Team ' + widget.team.teamnumber.toString();
    widget.model.isFromEditOrClone = true;
    widget.model.isEditable = true;
    widget.model.onTeamCreated = widget.onTeamCreated;
    navigateToTeamPreview(context, widget.model, check: widget.checkfrom);
  }
}
