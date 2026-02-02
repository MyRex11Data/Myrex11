import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/app_navigator.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/customWidgets/CustomToolTip.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/repository/model/contest_details_response.dart';

class Leaderboard extends StatefulWidget {
  List<JoinedContestTeam> leaderboardList;
  String userId;
  bool isContestDetails;
  String pdfUrl;
  GeneralModel model;
  Function? getLeaderboardList;
  int? pageIndex;
  dynamic isLeaderboardCall;
  dynamic totalUser;
  int? currentContestIndex;
  Leaderboard(this.totalUser, this.leaderboardList, this.userId,
      this.isContestDetails, this.pdfUrl, this.model,
      {this.getLeaderboardList,
      this.pageIndex,
      this.isLeaderboardCall,
      this.currentContestIndex});

  @override
  _LeaderboardState createState() => new _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  SuperTooltip? tooltip;
  late Offset offset;
  double scale = 1.0;
  bool isCompareTeamActive = false;
  GlobalKey btnKey = GlobalKey();
  String team1Id = '0';
  int clickIndex = 0;
  ScrollController _scrollController = ScrollController();
  final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (widget.isLeaderboardCall != null && widget.isLeaderboardCall != 0) {
          widget.getLeaderboardList!();
        }
        setState(() {});
        // Load more data when user reaches the end of the list.
        // You can call your data source's method here to fetch the next page.
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
    return Padding(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          right: widget.model.isFromLiveFinish == true ? 10 : 10,
          left: widget.model.isFromLiveFinish == true ? 10 : 10),
      child: new Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              // border: Border.all(color: borderColor, width: 0.7),
              // image: DecorationImage(
              //     image: AssetImage(AppImages.commanBackground),
              //     fit: BoxFit.cover),
              color: Colors.transparent),
          child: Column(
            children: [
              // new Divider(height: 1,thickness: 1,),
              !widget.isContestDetails
                  ? Column(
                      children: [
                        new Container(
                          height: 35,
                          color: Colors.transparent,
                          padding:
                              EdgeInsets.only(left: 5, right: 10, bottom: 10),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              !widget.isContestDetails &&
                                      widget.leaderboardList.length > 1
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 0),
                                          child: Tooltip(
                                            decoration: BoxDecoration(
                                                color: primaryColor),
                                            // Provide a global key with the "TooltipState" type to show
                                            // the tooltip manually when trigger mode is set to manual.
                                            key: tooltipkey,
                                            triggerMode:
                                                TooltipTriggerMode.manual,
                                            showDuration:
                                                const Duration(seconds: 2),
                                            message:
                                                "Now tap on a team to start comparing.",
                                            // child: const Text(
                                            //     'Tap on the FAB'),
                                          ),
                                        ),
                                        GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          child: Opacity(
                                            opacity: scale,
                                            child: new Container(
                                              /* decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(color: Colors.grey.shade300)
                              ),*/
                                              child: new Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  new Container(
                                                    margin: EdgeInsets.only(
                                                        left: 0,
                                                        right: 5,
                                                        top: 2),
                                                    height: 16,
                                                    width: 16,
                                                    child: Image(
                                                      image: AssetImage(
                                                        AppImages
                                                            .compareTeamIcon,
                                                      ),
                                                      color: primaryColor,
                                                    ),
                                                  ),
                                                  new Text('Compare Teams',
                                                      style: TextStyle(
                                                          fontFamily: "Roboto",
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 63, 62, 62),
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 12)),
                                                ],
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              scale = 0.3;
                                            });
                                            isCompareTeamActive = true;
                                            tooltipkey.currentState
                                                ?.ensureTooltipVisible();
                                          },
                                        ),
                                      ],
                                    )
                                  : new Container(),
                              new GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                child: new Container(
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      new Container(
                                        margin:
                                            EdgeInsets.only(left: 5, right: 5),
                                        height: 13,
                                        width: 13,
                                        child: Image(
                                          image: AssetImage(
                                            AppImages.downloadIcon,
                                          ),
                                          color: primaryColor,
                                        ),
                                      ),
                                      new Text('Download',
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 12)),
                                    ],
                                  ),
                                ),
                                onTap: () => {
                                  if (widget.pdfUrl.isEmpty)
                                    {
                                      MethodUtils.showError(
                                          context, 'PDF Not Ready Yet')
                                    }
                                  else
                                    {_launchURL(widget.pdfUrl)}
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: !widget.isContestDetails
                      ? LightprimaryColor
                      : LightprimaryColor,
                ),
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        widget.totalUser != null
                            ? 'ALL TEAMS (' + widget.totalUser.toString() + ')'
                            : 'ALL TEAMS (' +
                                widget.leaderboardList.length.toString() +
                                ')',
                        style: TextStyle(
                            // fontFamily: "Roboto",
                            color: Color(0xff717072),
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    ),
                    !widget.isContestDetails
                        ? Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 5),
                                width: 50,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Points'.toUpperCase(),
                                  style: TextStyle(
                                      color: Color(0xff717072),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                ),
                              ),
                              new Container(
                                margin: EdgeInsets.only(right: 10, left: 0),
                                width: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  '#Rank'.toUpperCase(),
                                  style: TextStyle(
                                      color: Color(0xff717072),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                ),
                              ),
                            ],
                          )
                        : new Container(),
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: borderColor,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      border: Border(
                          left: BorderSide(color: borderColor, width: 1),
                          right: BorderSide(color: borderColor, width: 1),
                          bottom: BorderSide(color: borderColor, width: 1)),
                      // image: DecorationImage(
                      //     image: AssetImage(AppImages.commanBackground),
                      //     fit: BoxFit.cover),
                      color: Colors.transparent),
                  child: ListView.builder(
                      padding: EdgeInsets.all(0),
                      controller: _scrollController,
                      key: btnKey,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: widget.leaderboardList.length,
                      itemBuilder: (BuildContext context, int index) {
                        int selfTeamsCount = 0;
                        //  clickIndex = index;
                        widget.leaderboardList.forEach((element) {
                          if (int.parse(widget.userId) == element.userid) {
                            selfTeamsCount++;
                          }
                        });
                        if (widget.userId ==
                            widget.leaderboardList[index].userid.toString()) {
                          if (selfTeamsCount > 1) {
                            team1Id = widget.leaderboardList[clickIndex].team_id
                                .toString();
                          } else {
                            team1Id = widget.leaderboardList[index].team_id
                                .toString();
                          }
                          //   team1Id=widget.leaderboardList[index].team_id.toString();
                        }

                        return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: new Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: (widget.leaderboardList
                                                .indexOf(widget
                                                    .leaderboardList[index]) ==
                                            widget.leaderboardList.length - 1)
                                        ? Radius.circular(10)
                                        : Radius.circular(0),
                                    bottomLeft: (widget.leaderboardList.indexOf(
                                                widget
                                                    .leaderboardList[index]) ==
                                            widget.leaderboardList.length - 1)
                                        ? Radius.circular(10)
                                        : Radius.circular(0)),
                                gradient: widget.userId ==
                                        widget.leaderboardList[index].userid.toString()
                                    ? LinearGradient(colors: [
                                        Color.fromARGB(255, 248, 207, 87)
                                            .withOpacity(0.1),
                                        // Color(0xffE6AD00).withOpacity(0.3),
                                        Color(0xffffffff)
                                      ], begin: Alignment.centerLeft, end: Alignment.centerRight)
                                    : LinearGradient(colors: [Colors.transparent, Colors.transparent])),
                            // color:
                            //     (widget.leaderboardList[index].is_champion ?? 0) ==
                            //             1
                            //         ? champBg
                            //         : widget.userId ==
                            //                 widget.leaderboardList[index].userid
                            //                     .toString()
                            //             ? Color(0xFFebf3ee)
                            //             : Colors.white,
                            child: index == clickIndex
                                ? Opacity(
                                    opacity: widget.userId ==
                                            widget.leaderboardList[index].userid
                                                .toString()
                                        ? scale
                                        : 1,
                                    child: Column(
                                      children: [
                                        new Container(
                                          padding: EdgeInsets.only(
                                              left: 10,
                                              right: 0,
                                              top: 10,
                                              bottom: 10),
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              new Row(
                                                children: [
                                                  new Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    child: new ClipRRect(
                                                      borderRadius: BorderRadius
                                                          .all(Radius.circular(
                                                              (widget.leaderboardList[index]
                                                                              .is_champion ??
                                                                          0) ==
                                                                      1
                                                                  ? 24
                                                                  : 18)),
                                                      child: new Container(
                                                        height: (widget
                                                                        .leaderboardList[
                                                                            index]
                                                                        .is_champion ??
                                                                    0) ==
                                                                1
                                                            ? 46
                                                            : 36,
                                                        width: (widget
                                                                        .leaderboardList[
                                                                            index]
                                                                        .is_champion ??
                                                                    0) ==
                                                                1
                                                            ? 46
                                                            : 36,
                                                        child:
                                                            CachedNetworkImage(
                                                                imageUrl: widget
                                                                        .leaderboardList[
                                                                            index]
                                                                        .user_image ??
                                                                    '',
                                                                placeholder: (context,
                                                                        url) =>
                                                                    new Image
                                                                        .asset(
                                                                      AppImages
                                                                          .userAvatarIcon,
                                                                    ),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    new Image
                                                                        .asset(
                                                                      AppImages
                                                                          .userAvatarIcon,
                                                                    ),
                                                                fit: BoxFit
                                                                    .fill),
                                                      ),
                                                    ),
                                                  ),
                                                  new Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      new Text(
                                                        widget
                                                            .leaderboardList[
                                                                index]
                                                            .name!,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Roboto",
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      double.parse(widget
                                                                  .leaderboardList[
                                                                      index]
                                                                  .win_amount
                                                                  .toString()) >
                                                              0
                                                          ? new Container(
                                                              margin: EdgeInsets
                                                                  .only(top: 2),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  new Text(
                                                                    widget.userId ==
                                                                            widget.leaderboardList[index].userid.toString()
                                                                        ? 'YOU WON: '
                                                                        : 'WON: ',
                                                                    style: TextStyle(
                                                                        //fontFamily: "Roboto",
                                                                        color: greenColor,
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.w400),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            right:
                                                                                2),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          13,
                                                                      width: 13,
                                                                      child: Image.asset(
                                                                          AppImages
                                                                              .goldcoin),
                                                                    ),
                                                                  ),
                                                                  new Text(
                                                                    widget
                                                                        .leaderboardList[
                                                                            index]
                                                                        .win_amount,
                                                                    // widget.userId == widget.leaderboardList[index].userid.toString()
                                                                    //     ? 'YOU WON ' +
                                                                    //         widget.leaderboardList[index].win_amount
                                                                    //             .toString()
                                                                    //     : 'WON ' +
                                                                    //         widget.leaderboardList[index].win_amount.toString(),
                                                                    style: TextStyle(
                                                                        //fontFamily: "Roboto",
                                                                        color: greenColor,
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.w400),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : new Container(),
                                                      !widget.isContestDetails &&
                                                              widget
                                                                      .leaderboardList[
                                                                          index]
                                                                      .win_amount ==
                                                                  0 &&
                                                              widget
                                                                      .leaderboardList[
                                                                          index]
                                                                      .is_winning_zone !=
                                                                  0
                                                          ? new Container(
                                                              margin: EdgeInsets
                                                                  .only(top: 2),
                                                              child: new Text(
                                                                'IN WINNING ZONE',
                                                                style: TextStyle(
                                                                    // fontFamily: "Roboto",
                                                                    color: greenColor,
                                                                    fontSize: 13,
                                                                    fontWeight: FontWeight.w400),
                                                              ),
                                                            )
                                                          : new Container(),
                                                      /*      widget.leaderboardList[index].userrank=="1"&&widget.leaderboardList[index].is_winning_zone==0?new Container(
                                                    margin: EdgeInsets.only(top: 2),
                                                    child: new Text(
                                                      'IN WINNING ZONE',
                                                      style: TextStyle(fontFamily: "Roboto",
                                                          color: greenColor,
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w400),
                                                    ),
                                                  ):new Container()
                                            */
                                                    ],
                                                  )
                                                ],
                                              ),
                                              !widget.isContestDetails
                                                  ? Row(
                                                      children: [
                                                        new Container(
                                                          width: 50,
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            widget
                                                                .leaderboardList[
                                                                    index]
                                                                .getPoints()!,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Roboto",
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                        new Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 10,
                                                                  left: 0),
                                                          width: 50,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            '${widget.leaderboardList[index].userrank ?? ''}',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Roboto",
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : widget
                                                          .leaderboardList[
                                                              index]
                                                          .isjoined!
                                                      ? GestureDetector(
                                                          behavior:
                                                              HitTestBehavior
                                                                  .translucent,
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 20),
                                                            height: 25,
                                                            width: 25,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            child: Image.asset(
                                                              AppImages
                                                                  .switchTeamIcon,
                                                              fit: BoxFit.fill,
                                                              color:
                                                                  primaryColor,
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            widget.model
                                                                    .onSwitchTeam!(
                                                                widget
                                                                    .leaderboardList[
                                                                        index]
                                                                    .join_id);
                                                          },
                                                        )
                                                      : Container(),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          height: 1,
                                          thickness: 1,
                                          color: borderColor,
                                        ),
                                      ],
                                    ),
                                  )
                                : Column(
                                    children: [
                                      new Container(
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            right: 0,
                                            top: 10,
                                            bottom: 10),
                                        child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            new Row(
                                              children: [
                                                new Container(
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  child: new ClipRRect(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular((widget
                                                                        .leaderboardList[
                                                                            index]
                                                                        .is_champion ??
                                                                    0) ==
                                                                1
                                                            ? 24
                                                            : 18)),
                                                    child: new Container(
                                                      height: (widget
                                                                      .leaderboardList[
                                                                          index]
                                                                      .is_champion ??
                                                                  0) ==
                                                              1
                                                          ? 46
                                                          : 36,
                                                      width: (widget
                                                                      .leaderboardList[
                                                                          index]
                                                                      .is_champion ??
                                                                  0) ==
                                                              1
                                                          ? 46
                                                          : 36,
                                                      child: CachedNetworkImage(
                                                          imageUrl: widget
                                                              .leaderboardList[
                                                                  index]
                                                              .user_image!,
                                                          placeholder: (context,
                                                                  url) =>
                                                              new Image.asset(
                                                                AppImages
                                                                    .userAvatarIcon,
                                                              ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              new Image.asset(
                                                                AppImages
                                                                    .userAvatarIcon,
                                                              ),
                                                          fit: BoxFit.fill),
                                                    ),
                                                  ),
                                                ),
                                                new Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    new Text(
                                                      widget
                                                          .leaderboardList[
                                                              index]
                                                          .name!,
                                                      style: TextStyle(
                                                          fontFamily: "Roboto",
                                                          color: Colors.black,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    double.parse(widget
                                                                .leaderboardList[
                                                                    index]
                                                                .win_amount
                                                                .toString()) >
                                                            0
                                                        ? new Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 2),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                new Text(
                                                                  widget.userId ==
                                                                          widget
                                                                              .leaderboardList[index]
                                                                              .userid
                                                                              .toString()
                                                                      ? 'YOU WON: '
                                                                      : 'WON: ',
                                                                  style: TextStyle(
                                                                      //fontFamily: "Roboto",
                                                                      color: greenColor,
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.w400),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              2),
                                                                  child:
                                                                      Container(
                                                                    height: 13,
                                                                    width: 13,
                                                                    child: Image.asset(
                                                                        AppImages
                                                                            .goldcoin),
                                                                  ),
                                                                ),
                                                                new Text(
                                                                  widget
                                                                      .leaderboardList[
                                                                          index]
                                                                      .win_amount,
                                                                  // widget.userId == widget.leaderboardList[index].userid.toString()
                                                                  //     ? 'YOU WON ' +
                                                                  //         widget.leaderboardList[index].win_amount
                                                                  //             .toString()
                                                                  //     : 'WON ' +
                                                                  //         widget.leaderboardList[index].win_amount.toString(),
                                                                  style: TextStyle(
                                                                      //fontFamily: "Roboto",
                                                                      color: greenColor,
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.w400),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : new Container(),
                                                    !widget.isContestDetails &&
                                                            widget
                                                                    .leaderboardList[
                                                                        index]
                                                                    .win_amount ==
                                                                0 &&
                                                            widget
                                                                    .leaderboardList[
                                                                        index]
                                                                    .is_winning_zone !=
                                                                0
                                                        ? new Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 2),
                                                            child: new Text(
                                                              'IN WINNING ZONE',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Roboto",
                                                                  color:
                                                                      greenColor,
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          )
                                                        : new Container(),
                                                    /*      widget.leaderboardList[index].userrank=="1"&&widget.leaderboardList[index].is_winning_zone==0?new Container(
                                                    margin: EdgeInsets.only(top: 2),
                                                    child: new Text(
                                                      'IN WINNING ZONE',
                                                      style: TextStyle(fontFamily: "Roboto",
                                                          color: greenColor,
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w400),
                                                    ),
                                                  ):new Container()
                                            */
                                                  ],
                                                )
                                              ],
                                            ),
                                            !widget.isContestDetails
                                                ? Row(
                                                    children: [
                                                      new Container(
                                                        width: 50,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          widget
                                                                  .leaderboardList[
                                                                      index]
                                                                  .points ??
                                                              '0',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Roboto",
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                      new Container(
                                                        margin: EdgeInsets.only(
                                                            right: 10, left: 0),
                                                        width: 50,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          widget
                                                                  .leaderboardList[
                                                                      index]
                                                                  .userrank ??
                                                              '-',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Roboto",
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : widget.leaderboardList[index]
                                                        .isjoined!
                                                    ? GestureDetector(
                                                        behavior:
                                                            HitTestBehavior
                                                                .translucent,
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          height: 25,
                                                          width: 25,
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child: Image.asset(
                                                            AppImages
                                                                .switchTeamIcon,
                                                            fit: BoxFit.fill,
                                                            color: primaryColor,
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          widget.model
                                                                  .onSwitchTeam!(
                                                              widget
                                                                  .leaderboardList[
                                                                      index]
                                                                  .join_id);
                                                        },
                                                      )
                                                    : Container(),
                                          ],
                                        ),
                                      ),
                                      if ((widget.leaderboardList.indexOf(
                                              widget.leaderboardList[index]) !=
                                          widget.leaderboardList.length - 1))
                                        Divider(
                                          height: 1,
                                          thickness: 1,
                                          color: borderColor,
                                        ),
                                    ],
                                  ),
                          ),
                          onTap: () {
                            clickIndex = index;
                            setState(() {});
                            if (isCompareTeamActive) {
                              if (widget.userId !=
                                  widget.leaderboardList[index].userid
                                      .toString()) {
                                /* if(int.parse(team1Id)==widget.leaderboardList[index].team_id){
                                      Fluttertoast.showToast(msg: "You can't compare same team");
                                    }else{
                                      navigateToCompareTeam(context, widget.model.matchKey!, widget.model.sportKey!, team1Id, widget.leaderboardList[index].team_id.toString(), widget.model.fantasyType.toString(), widget.model.slotId.toString(), widget.leaderboardList[index].challenge_id.toString());
                                    }*/
                                navigateToCompareTeam(
                                    context,
                                    widget.model.matchKey!,
                                    widget.model.sportKey!,
                                    team1Id,
                                    widget.leaderboardList[index].team_id
                                        .toString(),
                                    widget.model.fantasyType.toString(),
                                    widget.model.slotId.toString(),
                                    widget.leaderboardList[index].challenge_id
                                        .toString(),
                                    widget.model);
                                setState(() {
                                  scale = 1;
                                });
                                isCompareTeamActive = false;
                              }
                            } else {
                              if (widget.userId ==
                                      widget.leaderboardList[index].userid
                                          .toString() ||
                                  !widget.isContestDetails) {
                                widget.model.isForLeaderBoard = true;
                                widget.model.teamId =
                                    widget.leaderboardList[index].team_id;
                                widget.model.challengeId =
                                    widget.leaderboardList[index].challenge_id;
                                widget.model.teamName =
                                    widget.leaderboardList[index].name;
                                navigateToTeamPreview(context, widget.model);
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        'Sorry!! Team preview is available after match started.',
                                    toastLength: Toast.LENGTH_SHORT,
                                    timeInSecForIosWeb: 1);
                              }
                            }
                          },
                        );
                      }),
                ),
              ),
            ],
          )),
    );
  }

  void onTap() {
    if (!isCompareTeamActive) {
      setState(() {
        scale = 0.3;
      });
      CustomToolTip popup = CustomToolTip(
        context,
        text: 'Now tap on a team to start comparing',
        textStyle:
            TextStyle(fontFamily: "Roboto", color: Colors.white, fontSize: 12),
        height: 40,
        width: 260,
        backgroundColor: primaryColor,
        padding: EdgeInsets.all(10.0),
        borderRadius: BorderRadius.circular(5.0),
        shadowColor: Colors.transparent,
      );
      popup.show(
        widgetKey: btnKey,
      );
      isCompareTeamActive = true;
    } else {
      setState(() {
        isCompareTeamActive = false;
        scale = 1;
      });
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
