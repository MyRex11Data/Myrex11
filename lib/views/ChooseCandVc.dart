import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myrex11/adapter/CandVcPlayerItemAdapter.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/app_navigator.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/buildType/buildType.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/dataModels/JoinChallengeDataModel.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/create_team_request.dart';
import 'package:myrex11/repository/model/create_team_response.dart';
import 'package:myrex11/repository/model/team_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';
import 'package:myrex11/customWidgets/VisionCustomTimerController.dart';
import '../customWidgets/MatchHeader.dart';

class ChooseCandVc extends StatefulWidget {
  Function? onTeamCreated;
  GeneralModel model;
  int? contestNumber;
  double? scrollPosition;
  bool? isDynaminLink;
  String? isLineUp;
  String? check;
  String? checkScreen;
  String? contestFrom;
  int? joinSimilar;
  ChooseCandVc(this.model,
      {this.isLineUp,
      this.isDynaminLink,
      this.onTeamCreated,
      this.contestNumber,
      this.scrollPosition,
      this.check,
      this.checkScreen,
      this.contestFrom,
      this.joinSimilar});

  @override
  _ChooseCandVcState createState() => new _ChooseCandVcState();
}

class _ChooseCandVcState extends State<ChooseCandVc>
    with WidgetsBindingObserver {
  // final timeController = CustomTimerController();
  late int batC, wkC, alC, bwC;
  String displayRole = '';
  String selectedCaptainName = "";
  String selectedVcCaptainName = "";
  String userId = '0';
  int isCsorted = 0, isVCsorted = 0, isType = 0, ispoints = 0;
  var teamid;
  late Duration duration;
  Timer? timer;
  late DateTime endTime;
  bool timesend = false;
  bool isSorting = false;
  final VisionCustomTimerController controller = VisionCustomTimerController();

  @override
  void initState() {
    super.initState();
    print(widget.joinSimilar);

    /*widget.model.selectedcList = [];*/
    captainSelected();
    vcCaptainSelected();
    createHeaders();

    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
        .then((value) => {
              setState(() {
                userId = value;
              })
            });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    teamid = widget.model.teamId;
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
    return new Scaffold(
        body: new WillPopScope(
            child: new Stack(
              children: [
                SafeArea(
                  top: false,
                  child: new Scaffold(
                    backgroundColor: bgColorDark,
                    body: new Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        new Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(color: primaryColor),
                              child: Column(
                                children: [
                                  PreferredSize(
                                    preferredSize: Size.fromHeight(38),
                                    // Set this height
                                    child: Container(
                                      margin: EdgeInsets.only(top: 35),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 15,
                                            right: 12,
                                            top: 12,
                                            bottom: 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            new Row(
                                              children: [
                                                new GestureDetector(
                                                  behavior: HitTestBehavior
                                                      .translucent,
                                                  onTap: () => {_onWillPop()},
                                                  child: new Container(
                                                    padding: EdgeInsets.only(
                                                        right: 12),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: new Container(
                                                      height: 30,
                                                      child: Image(
                                                        image: AssetImage(
                                                            AppImages
                                                                .backImageURL),
                                                        // color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                new Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                        "Choose Captain & V. Captain",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                AppConstants
                                                                    .textBold,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14)),
                                                    new Container(
                                                      // margin: EdgeInsets.only(left: 10),
                                                      child: MatchHeader(
                                                          widget.model.teamVs!,
                                                          widget.model
                                                              .headerText!,
                                                          widget.model
                                                                  .isFromLive ??
                                                              false,
                                                          widget.model
                                                                  .isFromLiveFinish ??
                                                              false,
                                                          teamColor:
                                                              Colors.white,
                                                          timerColor:
                                                              Colors.white,
                                                          screenType:
                                                              "createTeam"),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            if (AppConstants
                                                .how_to_play_url.isNotEmpty)
                                              new Container(
                                                margin: EdgeInsets.only(
                                                    top: 0, right: 10),
                                                alignment: Alignment.center,
                                                child: new Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    new GestureDetector(
                                                      behavior: HitTestBehavior
                                                          .translucent,
                                                      child: new Container(
                                                        child: new Row(
                                                          children: [
                                                            new Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              height: 30,
                                                              child: Image(
                                                                image: AssetImage(
                                                                    AppImages
                                                                        .helpIcon),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      onTap: () => {
                                                        navigateToVisionWebView(
                                                            context,
                                                            'How to Play',
                                                            AppConstants
                                                                .how_to_play_url)
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(0),
                                    margin: EdgeInsets.only(
                                        left: 20,
                                        top: 10,
                                        bottom: 16,
                                        right: 20),
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        new Container(
                                            child: new Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                              new Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  30)),
                                                      child: new Container(
                                                        height: 40,
                                                        width: 40,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: widget
                                                              .model.team1Logo!,
                                                          placeholder: (context,
                                                                  url) =>
                                                              new Image.asset(
                                                                  AppImages
                                                                      .logoPlaceholderURL),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              new Image.asset(
                                                                  AppImages
                                                                      .logoPlaceholderURL),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  new Container(
                                                    // margin:
                                                    //     EdgeInsets.only(left: 10),
                                                    child: new Column(
                                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        new Container(
                                                          // width: 50,
                                                          margin:
                                                              EdgeInsets.only(
                                                            top: 2,
                                                          ),
                                                          child: new Text(
                                                            widget.model.teamVs!
                                                                .split(
                                                                    ' VS ')[0],
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Trim',
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ])),
                                        Container(
                                          // margin: EdgeInsets.only(right: 10),
                                          child: new Container(
                                            alignment: Alignment.centerRight,
                                            margin: EdgeInsets.only(top: 2),
                                            child: new Text(
                                              "VS",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  // fontFamily: "Roboto",
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                        new Container(
                                            child: new Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(right: 8),
                                              child: new Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                margin: EdgeInsets.only(top: 2),
                                                child: new Text(
                                                  " " +
                                                      widget.model.teamVs!
                                                          .split(' VS ')[1] +
                                                      "",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontFamily: "Roboto",
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ),
                                            ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                // margin: EdgeInsets.only(
                                                //   bottom: 5,
                                                // ),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      widget.model.team2Logo!,
                                                  placeholder: (context, url) =>
                                                      new Image.asset(AppImages
                                                          .logoPlaceholderURL),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      new Image.asset(AppImages
                                                          .logoPlaceholderURL),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              color: Color(0xff9155EB),
                              child: Column(
                                children: [
                                  Text("Choose Captain and Vice Captain",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          //  fontFamily: AppConstants.textBold,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                  new Container(
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        new Container(
                                            height: 40,
                                            margin: EdgeInsets.only(
                                                left: 10, right: 5),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                backgroundColor:
                                                    Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3)),
                                              ),
                                              child: new Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  new Container(
                                                    height: 24,
                                                    width: 24,
                                                    margin: EdgeInsets.only(
                                                        right: 5),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        color: Colors.black),
                                                    child: new Text(
                                                      'C',
                                                      style: TextStyle(
                                                          //fontFamily: "Roboto",
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Get 2x points',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                              onPressed: () {
                                                // navigateToCreateTeam(context);
                                              },
                                            )),
                                        new Container(
                                            height: 40,
                                            margin: EdgeInsets.only(
                                                left: 5, right: 10),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                backgroundColor:
                                                    Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3)),
                                              ),
                                              child: new Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  new Container(
                                                    height: 24,
                                                    width: 24,
                                                    margin: EdgeInsets.only(
                                                        right: 5),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        color: Colors.black),
                                                    child: new Text(
                                                      'VC',
                                                      style: TextStyle(
                                                          fontFamily: "Roboto",
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Get 1.5x points',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                              onPressed: () {
                                                // navigateToCreateTeam(context);
                                              },
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            new Container(
                              height: 35,
                              color: Color(0xFFfafafa),
                              //   margin: EdgeInsets.only(top: 15),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (isType == 2 || isType == 0) {
                                          isType = 1;
                                          widget.model.selectedList!.sort(
                                              (a, b) => a.teamcode!
                                                  .compareTo(b.teamcode!));
                                        } else {
                                          isType = 2;
                                          print("BHHHHH" + isType.toString());
                                          widget.model.selectedList!.sort(
                                              (a, b) => b.teamcode!
                                                  .compareTo(a.teamcode!));
                                        }
                                        isVCsorted = 0;
                                        isCsorted = 0;
                                        ispoints = 0;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        new Container(
                                          margin: EdgeInsets.only(left: 20),
                                          child: Text(
                                            'Type',
                                            style: TextStyle(
                                                color: isType != 0
                                                    ? Colors.black
                                                    : Colors.grey,
                                                //  fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        isType != 0
                                            ? new Container(
                                                margin:
                                                    EdgeInsets.only(right: 4),
                                                height: 13,
                                                width: 5,
                                                child: Image(
                                                  image: AssetImage(
                                                    isType == 1
                                                        ? AppImages.downSort
                                                        : AppImages.upSort,
                                                  ),
                                                  color: Colors.black,
                                                ),
                                              )
                                            : new Container(),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 20),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          new Container(
                                            //  width: 70,
                                            margin: EdgeInsets.only(
                                                right: 5, left: 0),
                                            // alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Points',
                                              style: TextStyle(
                                                  color: ispoints != 0
                                                      ? Colors.black
                                                      : Colors.grey,
                                                  // fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14),
                                            ),
                                          ),
                                          ispoints != 0
                                              ? new Container(
                                                  margin:
                                                      EdgeInsets.only(right: 4),
                                                  height: 13,
                                                  width: 5,
                                                  child: Image(
                                                    image: AssetImage(
                                                      ispoints == 1
                                                          ? AppImages.downSort
                                                          : AppImages.upSort,
                                                    ),
                                                    color: Colors.black,
                                                  ),
                                                )
                                              : new Container(),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        if (ispoints == 2 || ispoints == 0) {
                                          ispoints = 1;
                                          widget.model.selectedList!.sort(
                                              (a, b) => a
                                                  .getPoints()
                                                  .compareTo(b.getPoints()));
                                        } else {
                                          ispoints = 2;
                                          widget.model.selectedList!.sort(
                                              (a, b) => b
                                                  .getPoints()
                                                  .compareTo(a.getPoints()));
                                        }
                                        isVCsorted = 0;
                                        isCsorted = 0;
                                        isType = 0;
                                      });
                                    },
                                  ),
                                  new Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 10, left: 0),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (isCsorted == 2 ||
                                                    isCsorted == 0) {
                                                  isCsorted = 1;
                                                  widget.model.selectedList!
                                                      .sort((a, b) => a
                                                          .getcaptainselected()
                                                          .compareTo(b
                                                              .getcaptainselected()));
                                                } else {
                                                  isCsorted = 2;
                                                  widget.model.selectedList!
                                                      .sort((a, b) => b
                                                          .getcaptainselected()
                                                          .compareTo(a
                                                              .getcaptainselected()));
                                                }
                                                isVCsorted = 0;
                                                ispoints = 0;
                                                isType = 0;
                                              });
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                new Container(
                                                  // width: 40,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    '% C BY',
                                                    style: TextStyle(
                                                        color: isCsorted != 0
                                                            ? Colors.black
                                                            : Colors.grey,
                                                        //  fontFamily: 'Roboto',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                                isCsorted != 0
                                                    ? new Container(
                                                        margin: EdgeInsets.only(
                                                            left: 4),
                                                        height: 13,
                                                        width: 5,
                                                        child: Image(
                                                          image: AssetImage(
                                                            isCsorted == 1
                                                                ? AppImages
                                                                    .downSort
                                                                : AppImages
                                                                    .upSort,
                                                          ),
                                                          color: Colors.black,
                                                        ),
                                                      )
                                                    : new Container(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (isVCsorted == 2 ||
                                                isVCsorted == 0) {
                                              isVCsorted = 1;
                                              widget.model.selectedList!.sort(
                                                  (a, b) => a
                                                      .getvicecaptainselected()
                                                      .compareTo(b
                                                          .getvicecaptainselected()));
                                            } else {
                                              isVCsorted = 2;
                                              widget.model.selectedList!.sort(
                                                  (a, b) => b
                                                      .getvicecaptainselected()
                                                      .compareTo(a
                                                          .getvicecaptainselected()));
                                            }
                                            isCsorted = 0;
                                            ispoints = 0;

                                            isType = 0;
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 25, left: 10),
                                          child: Row(
                                            children: [
                                              new Container(
                                                // width: 40,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  '% VC BY',
                                                  style: TextStyle(
                                                      color: isVCsorted != 0
                                                          ? Colors.black
                                                          : Colors.grey,
                                                      //  fontFamily: 'Roboto',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14),
                                                ),
                                              ),
                                              isVCsorted != 0
                                                  ? new Container(
                                                      margin: EdgeInsets.only(
                                                          left: 4),
                                                      height: 13,
                                                      width: 5,
                                                      child: Image(
                                                        image: AssetImage(
                                                          isVCsorted == 1
                                                              ? AppImages
                                                                  .downSort
                                                              : AppImages
                                                                  .upSort,
                                                        ),
                                                        color: Colors.black,
                                                      ),
                                                    )
                                                  : new Container(),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 0.8,
                              thickness: 0.8,
                            ),
                            Expanded(
                              child: new Container(
                                color: Colors.white,
                                child: new ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount:
                                        widget.model.selectedList!.length,
                                    padding: EdgeInsets.only(bottom: 70),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      bool isdisplayRole = isDisplayRole(index);
                                      return CandVcPlayerItemAdapter(
                                        widget.model.selectedList![index],
                                        captainViceCaptainListener,
                                        index,
                                        isdisplayRole,
                                        displayRole,
                                        widget.model.matchKey,
                                        widget.model.sportKey,
                                        widget.model.fantasyType,
                                        widget.model.slotId,
                                        widget.model.selectedList,
                                        isSorting: isSorting,
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                        new Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: new Row(
                            children: [
                              new Flexible(
                                child: GestureDetector(
                                  onTap: () {
                                    List<Player> selectedWkList = [];
                                    List<Player> selectedBatLiSt = [];
                                    List<Player> selectedArList = [];
                                    List<Player> selectedBowlList = [];
                                    List<Player> selectedCList = [];

                                    for (Player player
                                        in widget.model.selectedList!) {
                                      if (player.isSelected ?? false) {
                                        if (player.role
                                                .toString()
                                                .toLowerCase() ==
                                            (widget.model.sportKey ==
                                                        AppConstants.TAG_CRICKET
                                                    ? AppConstants
                                                        .KEY_PLAYER_ROLE_KEEP
                                                    : widget.model.sportKey ==
                                                            AppConstants
                                                                .TAG_KABADDI
                                                        ? AppConstants
                                                            .KEY_PLAYER_ROLE_DEF
                                                        : widget.model
                                                                    .sportKey ==
                                                                AppConstants
                                                                    .TAG_BASKETBALL
                                                            ? AppConstants
                                                                .KEY_PLAYER_ROLE_PG
                                                            : AppConstants
                                                                .KEY_PLAYER_ROLE_GK)
                                                .toString()
                                                .toLowerCase()) {
                                          selectedWkList.add(player);
                                        }
                                        if (player.role
                                                .toString()
                                                .toLowerCase() ==
                                            (widget.model.sportKey ==
                                                        AppConstants.TAG_CRICKET
                                                    ? AppConstants
                                                        .KEY_PLAYER_ROLE_BAT
                                                    : widget.model.sportKey ==
                                                            AppConstants
                                                                .TAG_KABADDI
                                                        ? AppConstants
                                                            .KEY_PLAYER_ROLE_ALL_R
                                                        : widget.model
                                                                    .sportKey ==
                                                                AppConstants
                                                                    .TAG_BASKETBALL
                                                            ? AppConstants
                                                                .KEY_PLAYER_ROLE_SG
                                                            : AppConstants
                                                                .KEY_PLAYER_ROLE_DEF)
                                                .toString()
                                                .toLowerCase()) {
                                          selectedBatLiSt.add(player);
                                        }
                                        if (player.role
                                                .toString()
                                                .toLowerCase() ==
                                            (widget.model.sportKey ==
                                                        AppConstants.TAG_CRICKET
                                                    ? AppConstants
                                                        .KEY_PLAYER_ROLE_ALL_R
                                                    : widget.model.sportKey ==
                                                            AppConstants
                                                                .TAG_KABADDI
                                                        ? AppConstants
                                                            .KEY_PLAYER_ROLE_RD
                                                        : widget.model
                                                                    .sportKey ==
                                                                AppConstants
                                                                    .TAG_BASKETBALL
                                                            ? AppConstants
                                                                .KEY_PLAYER_ROLE_SF
                                                            : AppConstants
                                                                .KEY_PLAYER_ROLE_MID)
                                                .toString()
                                                .toLowerCase()) {
                                          selectedArList.add(player);
                                        }
                                        if (player.role
                                                .toString()
                                                .toLowerCase() ==
                                            (widget.model.sportKey ==
                                                        AppConstants.TAG_CRICKET
                                                    ? AppConstants
                                                        .KEY_PLAYER_ROLE_BOL
                                                    : widget.model.sportKey ==
                                                            AppConstants
                                                                .TAG_BASKETBALL
                                                        ? AppConstants
                                                            .KEY_PLAYER_ROLE_PF
                                                        : AppConstants
                                                            .KEY_PLAYER_ROLE_ST)
                                                .toString()
                                                .toLowerCase()) {
                                          selectedBowlList.add(player);
                                        }
                                        if (player.role
                                                .toString()
                                                .toLowerCase() ==
                                            AppConstants.KEY_PLAYER_ROLE_C
                                                .toString()
                                                .toLowerCase()) {
                                          selectedCList.add(player);
                                        }
                                      }
                                    }

                                    widget.model.selectedWkList =
                                        selectedWkList;
                                    widget.model.selectedBatLiSt =
                                        selectedBatLiSt;
                                    widget.model.selectedArList =
                                        selectedArList;
                                    widget.model.selectedBowlList =
                                        selectedBowlList;
                                    widget.model.selectedcList = selectedCList;
                                    widget.model.isEditable = false;

                                    navigateToTeamPreview(context, widget.model,
                                        check: "CandVc");
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        border: Border.all(
                                            color: primaryColor, width: 2)),
                                    width: MediaQuery.of(context).size.width,
                                    height: 40,
                                    margin:
                                        EdgeInsets.only(left: 20, right: 10),
                                    child: Center(
                                        child: Text(
                                      "Team Preview",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                ),
                                flex: 1,
                              ),
                              new Flexible(
                                child: GestureDetector(
                                  onTap: () {
                                    widget.model.teamId =
                                        teamid ?? widget.model.teamId;
                                    if (selectedCaptainName == "" ||
                                        selectedVcCaptainName == "") {
                                      MethodUtils.showError(context,
                                          "Please select Captain & V. Captain");
                                      return;
                                    }
                                    createTeam();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: selectedCaptainName.isNotEmpty &&
                                              selectedVcCaptainName.isNotEmpty
                                          ? primaryColor
                                          : Colors.grey,
                                      image: DecorationImage(
                                          image:
                                              AssetImage(AppImages.Btngradient),
                                          fit: BoxFit.fill),
                                      border: Border.all(
                                        color: selectedCaptainName.isNotEmpty &&
                                                selectedVcCaptainName.isNotEmpty
                                            ? blueColor
                                            : Colors.grey,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    // decoration: BoxDecoration(
                                    //   color: selectedCaptainName.isNotEmpty &&
                                    //           selectedVcCaptainName.isNotEmpty
                                    //       ? primaryColor
                                    //       : Colors.grey,
                                    //   gradient: selectedCaptainName
                                    //               .isNotEmpty &&
                                    //           selectedVcCaptainName.isNotEmpty
                                    //       ? LinearGradient(
                                    //           transform: GradientRotation(52.61 *
                                    //               3.14159 /
                                    //               180), // Convert degrees to radians
                                    //           begin: Alignment.topLeft,
                                    //           end: Alignment.bottomRight,
                                    //           stops: [
                                    //             0.1502,
                                    //             0.1706,
                                    //             0.2410,
                                    //             0.2781,
                                    //             0.3280,
                                    //             0.3681,
                                    //             0.5620,
                                    //             0.6553,
                                    //             0.7411,
                                    //             0.7849,
                                    //             0.8103
                                    //           ],
                                    //           colors: [
                                    //             Color(0xFFB2B2AF),
                                    //             Color(0xFFBEBEBB),
                                    //             Color(0xFFE1E1E1),
                                    //             Color(0xFFEFEFEF),
                                    //             Color(0xFFF2F2F2),
                                    //             Color(0xFFFCFCFC),
                                    //             Color(0xFFD1D1D1),
                                    //             Color(0xFFDBDBDB),
                                    //             Color(0xFFE8E8E8),
                                    //             Color(0xFFF5F5F5),
                                    //             Color(0xFFFFFFFF),
                                    //           ],
                                    //         )
                                    //       : LinearGradient(colors: [
                                    //           Colors.grey,
                                    //           Colors.grey
                                    //         ]),
                                    //   borderRadius: BorderRadius.all(
                                    //     Radius.circular(30),
                                    //   ),
                                    //   border: Border.all(
                                    //     color: selectedCaptainName.isNotEmpty &&
                                    //             selectedVcCaptainName.isNotEmpty
                                    //         ? Color(0xFF6A0BF8)
                                    //         : Colors.transparent,
                                    //     width: 1,
                                    //   ),
                                    // ),

                                    height: 40,
                                    width: MediaQuery.of(context).size.width,
                                    // borderRadius: 5,
                                    margin:
                                        EdgeInsets.only(left: 10, right: 20),
                                    child: Center(
                                      child: Text(
                                        "Continue",
                                        style: TextStyle(
                                            // color: Colors.white,
                                            color: selectedCaptainName
                                                        .isNotEmpty &&
                                                    selectedVcCaptainName
                                                        .isNotEmpty
                                                ? Colors.black
                                                : const Color.fromARGB(
                                                    255, 106, 104, 104),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            onWillPop: _onWillPop));
  }

  Future<bool> _onWillPop() async {
    for (int i = 0; i < widget.model.selectedList!.length; i++) {
      widget.model.selectedList![i].isCaptain = false;
      widget.model.selectedList![i].isVcCaptain = false;
    }
    Navigator.pop(context);
    return Future.value(false);
  }

  void createTeam() async {
    AppLoaderProgress.showLoader(context);
    StringBuffer sb = new StringBuffer();
    String captain = "";
    String vcCaptain = "";
    for (Player player in widget.model.selectedList!) {
      if (!(player.isHeader ?? false)) sb.write(player.id.toString());
      sb.write(",");

      if (player.isCaptain ?? false) captain = player.id.toString();

      if (player.isVcCaptain ?? false) vcCaptain = player.id.toString();
    }
    CreateTeamRequest loginRequest = new CreateTeamRequest(
        userid: userId,
        matchkey: widget.model.matchKey,
        sport_key: widget.model.sportKey,
        fantasy_type: widget.model.fantasyType.toString(),
        slotes_id: widget.model.slotId.toString(),
        teamid: widget.model.teamId ?? 0,
        fantasy_type_id: CricketTypeFantasy.getCricketType(
            widget.model.fantasyType.toString(),
            sportsKey: widget.model
                .sportKey) /*widget.model.fantasyType==1?"7":widget.model.fantasyType==2?"6":"0"*/,
        captain: captain,
        vicecaptain: vcCaptain,
        players: sb.toString());
    final client = ApiClient(AppRepository.dio);
    CreateTeamResponse response = await client.createTeam(loginRequest);
    AppLoaderProgress.hideLoader(context);
    if (response.status == 1) {
      if (widget.model.contest != null &&
          widget.model.contest!.id! > 0 &&
          response.result != null &&
          response.result!.teamcount == 1) {
        MethodUtils.checkBalance(
            0,
            JoinChallengeDataModel(
                context,
                0,
                int.parse(userId),
                widget.model.contest!.id!,
                widget.model.fantasyType!,
                // widget.model.slotId!,
                1,
                widget.model.contest!.is_bonus!,
                widget.model.contest!.win_amount!,
                widget.model.contest!.maximum_user!,
                response.result!.teamid.toString(),
                widget.model.contest!.entryfee.toString(),
                widget.model.matchKey.toString(),
                widget.model.sportKey.toString(),
                widget.model.joinedSwitchTeamId.toString(),
                false,
                0,
                0,
                onJoinContestResult,
                widget.model.contest!,
                bonusPercentage: widget.model.contest!.bonus_percent),
            joinSimilar: widget.joinSimilar,
            contestNumber: widget.contestNumber ?? 0,
            genModel: widget.model,
            scrollPosition: widget.scrollPosition,
            isLineUp: widget.isLineUp);
      } else {
        if (widget.model.onTeamCreated != null) {
          widget.model.onTeamCreated!();
        }

        Navigator.of(context).pop();
        Navigator.of(context).pop();
        // }
        // }
      }
    }
    if (widget.contestFrom == 'fromallcontest') {
      print('contestFrom${widget.contestFrom}');
      widget.model.teamId = response.result!.teamid;
    }

    if (widget.onTeamCreated != null) {
      widget.onTeamCreated!();
    }
    if (widget.model.onTeamCreated != null) {
      widget.model.onTeamCreated!();
    }
    Fluttertoast.showToast(
        msg: response.message!,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1);
  }

  void captainViceCaptainListener(
      bool isCaptain, int index, List<Player>? selectedList) {
    widget.model.selectedList = selectedList;
    if (isCaptain) {
      for (int i = 0; i < widget.model.selectedList!.length; i++) {
        widget.model.selectedList![i].isCaptain = false;
      }

      if (widget.model.selectedList![index].isVcCaptain ?? false) {
        // isVice = false;
        selectedVcCaptainName = "";
        widget.model.selectedList![index].isVcCaptain = false;
      }

      widget.model.selectedList![index].isCaptain = true;

      selectedCaptainName = widget.model.selectedList![index].name!;
    } else {
      for (int i = 0; i < widget.model.selectedList!.length; i++) {
        widget.model.selectedList![i].isVcCaptain = false;
      }
      if (widget.model.selectedList![index].isCaptain ?? false) {
        // isCap = false;
        selectedCaptainName = "";
        widget.model.selectedList![index].isCaptain = false;
      }

      widget.model.selectedList![index].isVcCaptain = true;
      selectedVcCaptainName = widget.model.selectedList![index].name!;
    }
    setState(() {});
  }

  void createHeaders() {
    batC = 0;
    wkC = 0;
    alC = 0;
    bwC = 0;
    for (int i = 0; i < widget.model.selectedList!.length; i++) {
      if (widget.model.selectedList![i].role.toString().toLowerCase() ==
              AppConstants.KEY_PLAYER_ROLE_KEEP.toString().toLowerCase() ||
          widget.model.selectedList![i].role.toString().toLowerCase() ==
              AppConstants.KEY_PLAYER_ROLE_GK.toString().toLowerCase() ||
          widget.model.selectedList![i].role.toString().toLowerCase() ==
              AppConstants.KEY_PLAYER_ROLE_PG.toString().toLowerCase() ||
          widget.model.selectedList![i].role.toString().toLowerCase() ==
              AppConstants.KEY_PLAYER_ROLE_OF.toString().toLowerCase()) {
        batC = wkC += 1;
      } else if (widget.model.selectedList![i].role.toString().toLowerCase() ==
              AppConstants.KEY_PLAYER_ROLE_BAT.toString().toLowerCase() ||
          widget.model.selectedList![i].role.toString().toLowerCase() ==
              AppConstants.KEY_PLAYER_ROLE_DEF.toString().toLowerCase() ||
          widget.model.selectedList![i].role.toString().toLowerCase() ==
              AppConstants.KEY_PLAYER_ROLE_SG.toString().toLowerCase() ||
          widget.model.selectedList![i].role.toString().toLowerCase() ==
              AppConstants.KEY_PLAYER_ROLE_IF.toString().toLowerCase()) {
        alC = batC += 1;
      } else if (widget.model.selectedList![i].role.toString().toLowerCase() ==
              AppConstants.KEY_PLAYER_ROLE_ALL_R.toString().toLowerCase() ||
          widget.model.selectedList![i].role.toString().toLowerCase() ==
              AppConstants.KEY_PLAYER_ROLE_MID.toString().toLowerCase() ||
          widget.model.selectedList![i].role.toString().toLowerCase() ==
              AppConstants.KEY_PLAYER_ROLE_SF.toString().toLowerCase() ||
          widget.model.selectedList![i].role.toString().toLowerCase() ==
              AppConstants.KEY_PLAYER_ROLE_PITCHER.toString().toLowerCase()) {
        bwC = alC += 1;
      } else if (widget.model.selectedList![i].role.toString().toLowerCase() ==
          AppConstants.KEY_PLAYER_ROLE_PF.toString().toLowerCase()) {
        bwC += 1;
      } else if (widget.model.selectedList![i].role.toString().toLowerCase() ==
              AppConstants.KEY_PLAYER_ROLE_BOL.toString().toLowerCase() ||
          widget.model.selectedList![i].role.toString().toLowerCase() ==
              AppConstants.KEY_PLAYER_ROLE_ST.toString().toLowerCase() ||
          widget.model.selectedList![i].role.toString().toLowerCase() ==
              AppConstants.KEY_PLAYER_ROLE_C.toString().toLowerCase() ||
          widget.model.selectedList![i].role.toString().toLowerCase() ==
              AppConstants.KEY_PLAYER_ROLE_CATCHER.toString().toLowerCase()) {
        break;
      }
    }
  }

  bool isDisplayRole(int index) {
    if (index + 1 < widget.model.selectedList!.length) {
      displayRole = widget.model.selectedList![index + 1].display_role!;
      if (index + 1 == wkC) {
        return true;
      } else if (index + 1 == batC) {
        return true;
      } else if (index + 1 == alC) {
        return true;
      } else if (index + 1 == bwC &&
          widget.model.selectedList![index].role.toString().toLowerCase() ==
              AppConstants.KEY_PLAYER_ROLE_PF.toString().toLowerCase()) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  void captainSelected() {
    for (var player in widget.model.selectedList!) {
      if (player.isCaptain ?? false) {
        selectedCaptainName = player.name!;
        break;
      }
    }
  }

  void vcCaptainSelected() {
    for (var player in widget.model.selectedList!) {
      if (player.isVcCaptain ?? false) {
        selectedVcCaptainName = player.name!;
        break;
      }
    }
  }

  void onJoinContestResult(int isJoined, String referCode) {
    print('teampop ${widget.checkScreen}');
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    // if (widget.checkScreen == 'flxible') {
    //   Navigator.of(context).pop();
    //   Navigator.of(context).pop();
    //   Navigator.of(context).pop();
    // } else {

    // }

    // Navigator.of(context).pop();
    if (isJoined == 1) {
      widget.model.onJoinContestResult!(isJoined, referCode);
      if (widget.model.onTeamCreated != null) {
        widget.model.onTeamCreated!();
      }
    }
  }
}
