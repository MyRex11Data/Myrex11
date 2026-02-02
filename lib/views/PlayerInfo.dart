import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/base_request.dart';
import 'package:myrex11/repository/model/player_info_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';

class PlayerInfo extends StatefulWidget {
  String? matchKey, playerName, team, playerImage, sportKey;
  int? playerId, type, fantasyType, slotId;
  int index;
  bool? isSelected;
  String isFrom;
  String shorRole;
  Function? onPlayerClick;
  String? selected_by;
  String? points;
  int? matchPlayed;
  String? teamcode;
  PlayerInfo(
      this.matchKey,
      this.playerId,
      this.playerName,
      this.team,
      this.playerImage,
      this.isSelected,
      this.index,
      this.type,
      this.sportKey,
      this.fantasyType,
      //  this.slotId,
      this.isFrom,
      this.onPlayerClick,
      this.shorRole,
      this.selected_by,
      this.points,
      this.matchPlayed,
      this.teamcode);
  @override
  _PlayerInfoState createState() => new _PlayerInfoState();
}

class _PlayerInfoState extends State<PlayerInfo> {
  late String userId = '0';
  PlayerInfoResult playerInfoResult = PlayerInfoResult();
  String? playerName = "";
  bool loading = false;
  @override
  void initState() {
    super.initState();
    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
        .then((value) => {
              setState(() {
                userId = value;
                getPLayerInfo();
              })
            });
  }

  @override
  void dispose() {
    super.dispose();
  }

  uiUpdate() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark));
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    //         statusBarColor: Colors.black,
    //         /* set Status bar color in Android devices. */
    //
    //         statusBarIconBrightness: Brightness.light,
    //         /* set Status bar icons color in Android devices.*/
    //
    //         statusBarBrightness:
    //             Brightness.dark) /* set Status bar icon color in iOS. */
    //     );
    uiUpdate();

    return Container(
      color: primaryColor,
      child: SafeArea(
        // top: false,
        bottom: false,
        child: new Scaffold(
          appBar: AppBar(
            toolbarHeight: loading == true
                ? 60
                : Platform.isIOS
                    ? 130
                    : 140,
            automaticallyImplyLeading: false,
            actions: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: primaryColor,
                padding: EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () => {Navigator.pop(context)},
                                child: Container(
                                  padding: EdgeInsets.only(left: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    height: 30,
                                    child: Image(
                                      image: AssetImage(AppImages.backImageURL),
                                      fit: BoxFit.fill,
                                      //  color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              new Container(
                                margin: EdgeInsets.only(left: 5),
                                child: new Text("Player Info",
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ),
                              //SizedBox(width: 10,),
                            ],
                          ),
                        ),
                      ],
                    ),
                    loading == false
                        ? new Container(
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 20),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Stack(
                                  alignment: Alignment.bottomLeft,
                                  children: [
                                    Container(
                                      child: CachedNetworkImage(
                                        width: 80,
                                        height: 80,
                                        imageUrl: widget.playerImage ?? '',
                                        placeholder: (context, url) =>
                                            new Image.asset(
                                                AppImages.player_avatar),
                                        errorWidget: (context, url, error) =>
                                            new Image.asset(
                                                AppImages.player_avatar),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 3,
                                      ),
                                      child: Container(
                                        height: 20,
                                        // width: 45,
                                        decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              // top: 3.0,
                                              // bottom: 3,
                                              left: 5,
                                              right: 5),
                                          child: Center(
                                            child: Text(
                                              widget.teamcode ?? '',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                /* new Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: new Text(widget.playerName!,
                                      style: TextStyle(
                                          fontFamily: "Roboto",
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18)),
                                ),*/
                                new Container(
                                  margin: EdgeInsets.only(left: 20, right: 15),
                                  alignment: Alignment.center,
                                  child: IntrinsicHeight(
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: new Column(
                                            children: [
                                              new Container(
                                                child: new Text("Credits",
                                                    style: TextStyle(
                                                        fontFamily: "Roboto",
                                                        color:
                                                            Color(0xFFb3ffffff),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12)),
                                              ),
                                              new Container(
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                child: new Text(
                                                    playerInfoResult!
                                                        .playercredit
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontFamily: "Roboto",
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Container(
                                          child: new Column(
                                            children: [
                                              new Container(
                                                child: new Text("Point",
                                                    style: TextStyle(
                                                        fontFamily: "Roboto",
                                                        color:
                                                            Color(0xFFb3ffffff),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12)),
                                              ),
                                              new Container(
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                child: new Text(
                                                    playerInfoResult!
                                                        .playerpoints
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontFamily: AppConstants
                                                            .textBold,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
              color: Colors.transparent,
              elevation: 0,
              shadowColor: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (widget.fantasyType ==
                              AppConstants.BOWLING_FANTASY_TYPE &&
                          widget.type == 1) return;
                      bool isSelected = widget.isSelected ?? false;
                      Navigator.of(context).pop();
                      widget.onPlayerClick!(
                          !isSelected, widget.index, widget.type);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 200,
                        height: 40,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Center(
                          child: Text(
                            widget.isSelected ?? false
                                ? 'Remove'
                                : 'Add To Team',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
              // new DefaultButton(
              //                   height: 42,
              //                   // width: 100,
              //                   width: MediaQuery.of(context).size.width,
              //                   margin:
              //                       EdgeInsets.only(right: 60, left: 60, bottom: 30),

              //                   text: widget.isSelected ?? false
              //                       ? 'Remove'
              //                       : 'Add To Team',
              //                   textcolor: widget.isSelected ?? false
              //                       ? Colors.white
              //                       : Colors.white,
              //                   color: widget.isSelected ?? false
              //                       ? primaryColor
              //                       : primaryColor,
              //                   borderRadius: 10,
              //                   onpress: () {
              //                     if (widget.fantasyType ==
              //                             AppConstants.BOWLING_FANTASY_TYPE &&
              //                         widget.type == 1) return;
              //                     bool isSelected = widget.isSelected ?? false;
              //                     Navigator.of(context).pop();
              //                     widget.onPlayerClick!(
              //                         !isSelected, widget.index, widget.type);
              //                   },
              //                 )
              // : new DefaultButton(
              //     height: 0,
              //     // width: 100,
              //     width: MediaQuery.of(context).size.width,
              //     // margin:
              //     //     EdgeInsets.only(right: 60, left: 60, bottom: 30),

              //     text: widget.isSelected ?? false ? '' : '',
              //     textcolor: widget.isSelected ?? false
              //         ? Colors.white
              //         : Colors.white,
              //     color: widget.isSelected ?? false
              //         ? Colors.white
              //         : Colors.white,
              //     borderRadius: 0,
              //     onpress: () {
              //       // if (widget.fantasyType ==
              //       //         AppConstants.BOWLING_FANTASY_TYPE &&
              //       //     widget.type == 1) return;
              //       // bool isSelected = widget.isSelected ?? false;
              //       // Navigator.of(context).pop();
              //       // widget.onPlayerClick!(
              //       //     !isSelected, widget.index, widget.type);
              //     },
              //   ),,
              ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 12, top: 10),
                        child: new Text(playerName ?? '',
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17)),
                      ),
                      Row(
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(left: 14, top: 4, bottom: 10),
                            child: new Text(("${widget.shorRole} "),
                                style: TextStyle(
                                    fontFamily: AppConstants.textBold,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14)),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 14, top: 4, bottom: 10),
                            child: new Text(
                                playerInfoResult!.battingstyle ?? "-",
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    color: textcolor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14)),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              Divider(
                color: Color(0xffe2e2e2),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // margin: EdgeInsets.only(
                          //     left: 4,
                          //     top: 4,
                          //     bottom: 10),
                          child: Text("Matches Played",
                              style: TextStyle(
                                  fontFamily: AppConstants.textBold,
                                  color: Color(0xff7e7e7e),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          // margin: EdgeInsets.only(
                          //     left: 14,
                          //     top: 4,
                          //     bottom: 10),
                          child: new Text("${widget.matchPlayed ?? "0"}",
                              style: TextStyle(
                                  fontFamily: AppConstants.textBold,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(
                                color: Color(0xffe2e2e2),
                              ),
                              right: BorderSide(
                                color: Color(0xffe2e2e2),
                              ))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // margin: EdgeInsets.only(
                              //     left: 14,
                              //     top: 4,
                              //     bottom: 10),
                              child: new Text("Avg. Point",
                                  style: TextStyle(
                                      fontFamily: AppConstants.textBold,
                                      color: Color(0xff7e7e7e),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              // margin: EdgeInsets.only(
                              //     left: 14,
                              //     top: 4,
                              //     bottom: 10),
                              child: new Text("${widget.points ?? "0.0"}",
                                  style: TextStyle(
                                      fontFamily: AppConstants.textBold,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // margin: EdgeInsets.only(
                            //     right: 14,
                            //     top: 4,
                            //     bottom: 10),
                            child: new Text("Sel. By",
                                style: TextStyle(
                                    fontFamily: AppConstants.textBold,
                                    color: Color(0xff7e7e7e),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            // margin: EdgeInsets.only(
                            //     right: 14,
                            //     top: 4,
                            //     bottom: 10),
                            child: new Text("${widget.selected_by ?? "0.0"}",
                                style: TextStyle(
                                    fontFamily: AppConstants.textBold,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Color(0xffe2e2e2),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 15, left: 10),
                child: new Text("Matchwise Fantasy Stats",
                    style: TextStyle(
                        fontFamily: "Roboto",
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              Container(
                height: 30,
                color: lightGrayColor,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        'Match',
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                      ),
                    ),
                    new Row(
                      children: [
                        new Container(
                          width: 50,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Points',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                          ),
                        ),
                        new Container(
                          margin: EdgeInsets.only(right: 10, left: 0),
                          width: 100,
                          alignment: Alignment.center,
                          child: Text(
                            'Selected By',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              loading == false
                  ? Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              // height: MediaQuery.of(context).size.height * 0.37,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: playerInfoResult!.matches == null
                                    ? 0
                                    : playerInfoResult!.matches!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            right: 0,
                                            top: 10,
                                            bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  playerInfoResult!
                                                          .matches![index]
                                                          .short_name ??
                                                      '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 2),
                                                  child: Text(
                                                    playerInfoResult!
                                                            .matches![index]
                                                            .matchdate ??
                                                        '',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: 50,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    playerInfoResult!
                                                        .matches![index]
                                                        .total_points
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 10, left: 0),
                                                  width: 100,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    playerInfoResult!
                                                            .matches![index]
                                                            .selectper ??
                                                        "",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        height: 1,
                                        thickness: 1,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container()
            ],
          ),

          // bottomSheet: widget.isFrom == '0'
          //     ?
          // body: (playerInfoResult) != null
          //     ? new Container(
          //         alignment: Alignment.topCenter,
          //         color: Colors.black,
          //         child: new Column(
          //           children: [
          //             /* Padding(
          //             padding: const EdgeInsets.all(16.0),
          //             child: new Divider(
          //               height: 1,
          //               thickness: 1,
          //               color: Colors.grey,
          //             ),
          //           ),*/

          //             /*    new Container(
          //       margin: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
          //       child: new Card(
          //         child: new Container(
          //           // padding: EdgeInsets.all(10),
          //           child: IntrinsicHeight(
          //             child: new Row(
          //               mainAxisSize: MainAxisSize.max,
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 new Flexible(child: new Container(
          //                   margin: EdgeInsets.only(left: 5),
          //                   alignment: Alignment.topLeft,
          //                   child: Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: new Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         new Container(
          //                           child: new Text("Bats",
          //                               style: TextStyle(
          //                                   fontFamily: "Roboto",
          //                                   color: Colors.grey,
          //                                   fontWeight: FontWeight.w400,
          //                                   fontSize: 14)),
          //                         ),
          //                         new Container(
          //                           margin: EdgeInsets.only(top: 10),
          //                           child: new Text(playerInfoResult!.battingstyle??"",
          //                               style: TextStyle(
          //                                   fontFamily: "Roboto",
          //                                   color: Colors.black,
          //                                   fontWeight: FontWeight.w500,
          //                                   fontSize: 14)),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),flex: 1,),
          //                 VerticalDivider(
          //                   thickness: .5,
          //                   width: 20,

          //                   color: Colors.grey,
          //                 ),
          //                 new Flexible(child: new Container(
          //                   alignment: Alignment.topLeft,
          //                   margin: EdgeInsets.only(left: 5),
          //                   child: Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: new Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         new Container(
          //                           child: new Text("Bowl",
          //                               style: TextStyle(
          //                                   fontFamily: "Roboto",
          //                                   color: Colors.grey,
          //                                   fontWeight: FontWeight.w400,
          //                                   fontSize: 14)),
          //                         ),
          //                         new Container(
          //                           margin: EdgeInsets.only(top: 10),
          //                           child: new Text(playerInfoResult!.bowlingstyle??"",
          //                               style: TextStyle(
          //                                   fontFamily: "Roboto",
          //                                   color: Colors.black,
          //                                   fontWeight: FontWeight.w500,
          //                                   fontSize: 14)),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),flex: 1,),

          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),*/
          //             new Container(
          //               height: MediaQuery.of(context).size.height * 0.7,
          //               color: Colors.white,
          //               child: new Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [],
          //               ),
          //             )
          //           ],
          //         ),
          //       )
          //     : Container(),
        ),
      ),
    );
  }

  void getPLayerInfo() async {
    setState(() {
      loading = true;
    });
    AppLoaderProgress.showLoader(context);
    GeneralRequest generalRequest = new GeneralRequest(
        user_id: userId,
        matchkey: widget.matchKey,
        playerid: widget.playerId.toString(),
        sport_key: widget.sportKey,
        fantasy_type: widget.fantasyType.toString(),
        slotes_id: widget.slotId.toString());
    final client = ApiClient(AppRepository.dio);
    PLayerInfoResponse pLayerInfoResponse =
        await client.getPlayerInfo(generalRequest);
    if (pLayerInfoResponse.status == 1) {
      AppLoaderProgress.hideLoader(context);
      playerInfoResult = pLayerInfoResponse.result!;
      playerName = playerInfoResult.playername;
      widget.matchPlayed = playerInfoResult.match_played;
      widget.selected_by = playerInfoResult.selected_percent;
      widget.points = playerInfoResult.total_points;
    }

    setState(() {
      loading = false;
    });
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
    return Future.value(false);
  }
}
