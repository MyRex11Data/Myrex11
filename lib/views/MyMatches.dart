import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:myrex11/adapter/ShimmerMatchItemAdapter.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/app_navigator.dart';
import 'package:flutter/services.dart';
import 'package:myrex11/appUtilities/date_utils.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/repository/model/finish_matchlist_response.dart';
import 'package:myrex11/repository/model/matchlist_response.dart';
import 'package:myrex11/views/NoMatchesListFound.dart';
import 'package:myrex11/GetXController/UpcomingMyMatchesGetController.dart';

import 'UpcomingContests.dart';

class MyMatches extends StatefulWidget {
  Function? pullRefresh;
  Function? getMyMatchFinishList;
  MatchListResponse? matchListResponse;
  FinishMatchListResponse? finishMatchListResponse;
  bool? isMyMatchLoading;

  MyMatches({
    this.pullRefresh,
    this.matchListResponse,
    this.finishMatchListResponse,
    this.isMyMatchLoading,
    this.getMyMatchFinishList,
  });

  @override
  _MyMatchesState createState() => _MyMatchesState();
}

class _MyMatchesState extends State<MyMatches> with TickerProviderStateMixin {
  int _currentSportIndex = 0;
  // final upcomingMyMatchesGetController=Get.put(UpcomingMyMatchesGetController());
  int currentMatchIndex = 0;
  bool back_dialog = false;
  final List<CustomTimerController> _controller = [];
  final _pageViewController = PageController();
  late TabController _tabController;
  String balance = '';

  bool shimmer = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    AppPrefrence.getString(AppConstants.KEY_USER_TOTAL_BALANCE)
        .then((value) => {
              setState(() {
                balance = value;
              })
            });
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
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        // image: DecorationImage(
        // image: AssetImage(AppImages.commanBackground), fit: BoxFit.cover),
        color: Colors.white,
      ),
      child: new Scaffold(
        backgroundColor: bgColor,
        appBar: PreferredSize(
          child: new Container(
            //  margin: EdgeInsets.fromLTRB(12, 10, 12, 0),
            height: 40,
            // decoration: BoxDecoration(
            //   //  border: Border.all(color: bgColorDark, width: 1.5),
            //     borderRadius: BorderRadius.all(Radius.circular(8))),
            child: new DefaultTabController(
                length: 3,
                child: new Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1), // 👈 Divider line
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelPadding: EdgeInsets.all(0),
                    onTap: (int index) {
                      if (widget.isMyMatchLoading == false) {
                        setState(() {
                          currentMatchIndex = index;
                          // if (_tabController.index == 1) {
                          //   _pageViewController.jumpToPage(1);
                          // } else if (_tabController.index == 2) {
                          //   _pageViewController.jumpToPage(2);
                          // } else if (_tabController.index == 0) {
                          //   _pageViewController.jumpToPage(0);
                          // }
                        });
                        widget.matchListResponse!.result!.clear();
                        onTabTapped(index);
                        // currentMatchIndex > 1
                        //     ? widget.getMyMatchFinishList!(currentMatchIndex)
                        //     : widget.pullRefresh!(
                        //         currentMatchIndex,
                        //       );
                      }
                    },
                    indicatorWeight: 2,
                    indicatorColor: primaryColor,
                    isScrollable: false,
                    tabs: [
                      new ClipRRect(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(8),
                        ),
                        child: new Container(
                          height: 40,
                          alignment: Alignment.center,
                          margin: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            // border: Border(
                            //     right: BorderSide(
                            //   color: bgColorDark,
                            //   width: 1,
                            //   style: BorderStyle.solid,
                            // )),
                            color: currentMatchIndex == 0
                                ? Colors.white
                                : Colors.white,
                          ),
                          child: Text(
                            'Upcoming',
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: _tabController.index == 0
                                    ? primaryColor
                                    : Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 14),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(0),
                        margin: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          // border: Border(
                          //   right: BorderSide(
                          //       color: bgColorDark,
                          //       width: 1,
                          //       style: BorderStyle.solid),
                          // ),
                          color: currentMatchIndex == 1
                              ? Colors.white
                              : Colors.white,
                        ),
                        child: Text(
                          'Live',
                          style: TextStyle(
                              fontFamily: "Roboto",
                              color: _tabController.index == 1
                                  ? primaryColor
                                  : Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 14),
                        ),
                      ),
                      ClipRRect(
                        borderRadius:
                            BorderRadius.horizontal(right: Radius.circular(8)),
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            // border: Border(
                            //     left: BorderSide(
                            //   color: bgColorDark,
                            //   width: currentMatchIndex == 2 ? 1 : 0,
                            //   style: BorderStyle.solid,
                            // )),
                            color: currentMatchIndex == 2
                                ? Colors.white
                                : Colors.white,
                          ),
                          child: Text(
                            'Completed',
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: _tabController.index == 2
                                    ? primaryColor
                                    : Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 14),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ),
          preferredSize: Size.fromHeight(60),
        ),
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(55), // Set this height
        //   child: Container(
        //     width: MediaQuery.of(context).size.width,
        //     color: primaryColor,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         Container(
        //           // padding: EdgeInsets.only(top: 28, left: 10),
        //           padding: Platform.isAndroid
        //               ? EdgeInsets.only(top: 0, left: 15)
        //               : EdgeInsets.only(left: 10),
        //           child: Text(
        //             'My Contest',
        //             style: TextStyle(color: Colors.white, fontSize: 16),
        //           ),
        //         ),
        //         new Container(
        //           padding: Platform.isAndroid
        //               ? EdgeInsets.only(top: 0, right: 10)
        //               : EdgeInsets.only(right: 10),
        //           alignment: Alignment.center,
        //           child: new GestureDetector(
        //             behavior: HitTestBehavior.translucent,
        //             child: Row(
        //               children: [
        //                 Text(
        //                   "₹$balance",
        //                   style: TextStyle(
        //                       color: Colors.white,
        //                       fontWeight: FontWeight.normal,
        //                       fontFamily: "Roboto",
        //                       fontSize: 15),
        //                 ),
        //                 // Text("₹"+myBalanceResultItem.totalamount.toString(),style: TextStyle(color: Colors.white),),
        //                 new Container(
        //                   margin: EdgeInsets.only(right: 5, left: 5),
        //                   height: 28,
        //                   width: 28,
        //                   child: Image(
        //                       image: AssetImage(AppImages.wallet_icon)),
        //                 ),
        //                 new GestureDetector(
        //                   behavior: HitTestBehavior.translucent,
        //                   child: new Container(
        //                     // margin: EdgeInsets.only(right: 0, left: 5),
        //                     height: 28,
        //                     width: 28,
        //                     child: Image(
        //                         image: AssetImage(
        //                       AppImages.notification_bell_icon,
        //                     )
        //                         //notification==0?AppImages.notificationImageURL:AppImages.notificationDotIcon),
        //                         ),
        //                   ),
        //                   onTap: () =>
        //                       {navigateToUserNotifications(context)},
        //                 )
        //               ],
        //             ),
        //             onTap: () => {
        //               setState(() {
        //                 AppConstants.movetowallet = true;
        //               }),
        //               Platform.isAndroid
        //                   ? Navigator.push(
        //                       context,
        //                       MaterialPageRoute(
        //                           builder: (context) => Wallet(

        //                               // multiple_contest: _dropDownValue ?? '1', joinSimilar: widget.contest.is_join_similar_contest
        //                               ))).then((value) {
        //                       setState(() {
        //                         AppConstants.movetowallet = false;
        //                       });
        //                     })
        //                   : Navigator.push(
        //                       context,
        //                       CupertinoPageRoute(
        //                           builder: (context) => Wallet(

        //                               // multiple_contest: _dropDownValue ?? '1',
        //                               // joinSimilar: widget.contest.is_join_similar_contest
        //                               ))).then((value) {
        //                       setState(() {
        //                         AppConstants.movetowallet = false;
        //                       });
        //                     })
        //             },
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // ),

        body: MyMatchesView(),
        /*  PageView(
          controller: _pageViewController,
          pageSnapping: widget.isMyMatchLoading == false,
          physics: CustomScrollPhysics(),
          children: <Widget>[
            MyMatchesView(),
            MyMatchesView(),
            MyMatchesView(),
          ],
          onPageChanged: (index) {
            onTabTapped(
              index,
            );
          },
        ),*/
        // GestureDetector(
        //   onTap: () {},
        //   child: Padding(
        //     padding: const EdgeInsets.only(
        //       top: 12,
        //     ),
        //     child: new Column(
        //       children: [

        //       ],
        //     ),
        //   ),
        // ),
        //  body:
      ),
    );
  }

  void onTabTapped(index) {
    // setState(() {
    if (widget.isMyMatchLoading == false) {
      setState(() {
        currentMatchIndex = index;
      });

      currentMatchIndex > 1
          ? widget.getMyMatchFinishList!(
              currentMatchIndex,
            )
          : widget.pullRefresh!(
              currentMatchIndex,
            );
    }
    // });
  }

  Widget MyMatchesView() {
    return RefreshIndicator(
      onRefresh: _pullRefresh,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          child: !widget.isMyMatchLoading!
              ? widget.matchListResponse!.result!.length > 0
                  ? ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: 8, right: 8, bottom: 4, top: 4),
                          child: GetBuilder<UpcomingMyMatchesGetController>(
                              builder: (controller) {
                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount:
                                    widget.matchListResponse!.result!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  controller.MinuteTestTimingVariable.add("");
                                  controller.SecTestTimingVariable.add("");
                                  _controller.add(CustomTimerController());
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 3),
                                    child: Visibility(
                                      visible:
                                          "${controller.MinuteTestTimingVariable[index]}:"
                                                      "${controller.SecTestTimingVariable[index]}" ==
                                                  "00:-1"
                                              ? false
                                              : true,
                                      child: Stack(
                                        alignment: Alignment.topCenter,
                                        children: [
                                          GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 7),
                                              child: Card(
                                                clipBehavior: Clip.antiAlias,
                                                elevation: 1,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  // side: BorderSide(
                                                  //   color: Color(
                                                  //       0xFFFFE8E8), // 👈 your border color
                                                  //   width:
                                                  //       1, // 👈 border thickness
                                                  // ),
                                                ),
                                                child: Container(
                                                  padding: EdgeInsets.all(0),
                                                  child: Container(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: 28,
                                                          margin:
                                                              EdgeInsets.only(
                                                            top: 5,
                                                            bottom: 1,
                                                            left: 10,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 0),
                                                            child: Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.8,
                                                              // margin: EdgeInsets.only(top: ),
                                                              child: Center(
                                                                child: Text(
                                                                  widget
                                                                      .matchListResponse!
                                                                      .result![
                                                                          index]
                                                                      .name!,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        "Roboto",
                                                                    color: Color(
                                                                        0xff202b3d),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1.5,
                                                          // margin: EdgeInsets.only(left: 20,right: 20,top: 6),
                                                          height: 1,
                                                          decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: AssetImage(
                                                                      "assets/images/ic_graident.png"),
                                                                  fit: BoxFit
                                                                      .cover)),
                                                        ),
                                                        Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            Container(
                                                              /* decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                      colors: [MethodUtils.hexToColor(widget.matchDetails.team1_color!).withOpacity(.1), Colors.white.withOpacity(.05),MethodUtils.hexToColor(widget.matchDetails.team2_color!).withOpacity(.1)],)
                                ),*/
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          0),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Flexible(
                                                                    child:
                                                                        Stack(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      children: [
                                                                        ShaderMask(
                                                                          blendMode:
                                                                              BlendMode.srcATop,
                                                                          shaderCallback:
                                                                              (Rect bounds) {
                                                                            return LinearGradient(
                                                                              colors: [
                                                                                MethodUtils.hexToColor(widget.matchListResponse!.result![index].team1_color!).withOpacity(.2),
                                                                                Colors.white
                                                                              ],
                                                                              begin: Alignment.centerLeft,
                                                                              end: Alignment.centerRight,
                                                                            ).createShader(bounds);
                                                                          },
                                                                          child:
                                                                              Image.asset(
                                                                            AppImages.home_match_item_bg_left,
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              220,
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  Stack(
                                                                                    alignment: Alignment.centerLeft,
                                                                                    children: [
                                                                                      Container(
                                                                                        height: 20,
                                                                                        width: 110,
                                                                                        child: Image(
                                                                                          image: AssetImage(AppImages.leftTeamIcon),
                                                                                          fit: BoxFit.fill,
                                                                                          color: MethodUtils.hexToColor(widget.matchListResponse!.result![index].team1_color!).withOpacity(.01),
                                                                                        ),
                                                                                      ),
                                                                                      Row(
                                                                                        children: [
                                                                                          Padding(
                                                                                            padding: EdgeInsets.only(left: 7),
                                                                                            child: ClipRRect(
                                                                                              borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                                              child: Container(
                                                                                                height: 30,
                                                                                                width: 30,
                                                                                                child: CachedNetworkImage(
                                                                                                  imageUrl: widget.matchListResponse!.result![index].team1logo!,
                                                                                                  placeholder: (context, url) => Image.asset(
                                                                                                    AppImages.logoPlaceholderURL,
                                                                                                  ),
                                                                                                  errorWidget: (context, url, error) => Image.asset(
                                                                                                    AppImages.logoPlaceholderURL,
                                                                                                  ),
                                                                                                  fit: BoxFit.fill,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            margin: EdgeInsets.only(left: 5),
                                                                                            child: Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Container(
                                                                                                  margin: EdgeInsets.only(top: 0),
                                                                                                  width: 60,
                                                                                                  child: Text(widget.matchListResponse!.result![index].team1display!, textAlign: TextAlign.left, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: "Roboto", color: lightBlack, fontWeight: FontWeight.bold, fontSize: 14)),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    flex: 1,
                                                                  ),
                                                                  Flexible(
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              widget.matchListResponse!.result![index].unlimited_credit_match == 1
                                                                                  ? Padding(
                                                                                      padding: const EdgeInsets.only(right: 0, top: 20),
                                                                                      child: Text(widget.matchListResponse!.result![index].unlimited_credit_text!, style: TextStyle(fontFamily: "Roboto", color: Color(0xFFe6a100), fontWeight: FontWeight.w400, fontSize: 13)),
                                                                                    )
                                                                                  : Container(),
                                                                            ],
                                                                          ),
                                                                          // widget.matchDetails
                                                                          //             .is_leaderboard ==
                                                                          //         1
                                                                          //     ? Container(
                                                                          //         height: 32,
                                                                          //         padding: EdgeInsets.all(3),
                                                                          //         margin: EdgeInsets.only(
                                                                          //             bottom: 0),
                                                                          //         child: Image(
                                                                          //             image: AssetImage(AppImages
                                                                          //                 .matchLeaderboardIcon)),
                                                                          //       )
                                                                          //     : Container(),
                                                                          // SizedBox(
                                                                          //   height: 4,
                                                                          // ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    flex: 1,
                                                                  ),
                                                                  Flexible(
                                                                    child:
                                                                        Stack(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      children: [
                                                                        ShaderMask(
                                                                          blendMode:
                                                                              BlendMode.srcATop,
                                                                          shaderCallback:
                                                                              (Rect bounds) {
                                                                            return LinearGradient(
                                                                              colors: [
                                                                                MethodUtils.hexToColor(widget.matchListResponse!.result![index].team2_color!).withOpacity(.2),
                                                                                Colors.white
                                                                              ],
                                                                              begin: Alignment.centerRight,
                                                                              end: Alignment.centerLeft,
                                                                            ).createShader(bounds);
                                                                          },
                                                                          child:
                                                                              Image.asset(
                                                                            AppImages.home_match_item_bg_right,
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              220,
                                                                          child:
                                                                              new Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  Stack(
                                                                                    alignment: Alignment.centerRight,
                                                                                    children: [
                                                                                      new Container(
                                                                                        height: 20,
                                                                                        width: 110,
                                                                                        child: Image(
                                                                                          image: AssetImage(AppImages.rightTeamIcon),
                                                                                          fit: BoxFit.fill,
                                                                                          color: MethodUtils.hexToColor(widget.matchListResponse!.result![index].team2_color!).withOpacity(.01),
                                                                                        ),
                                                                                      ),
                                                                                      Row(
                                                                                        children: [
                                                                                          Container(
                                                                                            margin: EdgeInsets.only(right: 5),
                                                                                            child: Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                                                              children: [
                                                                                                Container(
                                                                                                  margin: EdgeInsets.only(top: 0),
                                                                                                  width: 60,
                                                                                                  alignment: Alignment.centerRight,
                                                                                                  child: Text(widget.matchListResponse!.result![index].team2display!, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left, style: TextStyle(fontFamily: "Roboto", color: lightBlack, fontWeight: FontWeight.bold, fontSize: 14)),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          Padding(
                                                                                            padding: EdgeInsets.only(right: 7),
                                                                                            child: ClipRRect(
                                                                                              borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                                              child: Container(
                                                                                                height: 30,
                                                                                                width: 30,
                                                                                                child: CachedNetworkImage(
                                                                                                  imageUrl: widget.matchListResponse!.result![index].team2logo!,
                                                                                                  placeholder: (context, url) => Image.asset(
                                                                                                    AppImages.logoPlaceholderURL,
                                                                                                    //   color: Colors.grey
                                                                                                  ),
                                                                                                  errorWidget: (context, url, error) => Image.asset(
                                                                                                    AppImages.logoPlaceholderURL,
                                                                                                    //   color: Colors.grey
                                                                                                  ),
                                                                                                  fit: BoxFit.fill,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    flex: 1,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 10),
                                                              child:
                                                                  Image.asset(
                                                                AppImages
                                                                    .home_match_item_middle,
                                                                height: 24,
                                                                width: 242,
                                                              ),
                                                            ),
                                                            // Padding(
                                                            //   padding: const EdgeInsets.only(top: 14),
                                                            //   child: Container(
                                                            //     height: 33, width:33,
                                                            //     child: Image.asset(
                                                            //       AppImages.teamVs,
                                                            //     ),
                                                            //   ),
                                                            // )
                                                            // Padding(
                                                            //   padding: const EdgeInsets.only(top: 2),
                                                            //   child: Container(
                                                            //       alignment: Alignment.bottomCenter,
                                                            //       // margin: EdgeInsets.only(top: 30),
                                                            //       child: Column(
                                                            //         children: [
                                                            //           Text(
                                                            //             "${widget.matchDetails.match_date}",
                                                            //             // widget.matchDetails.match_time.toString(),
                                                            //             style: TextStyle(
                                                            //                 fontSize: 11,
                                                            //                 color: Colors.black,
                                                            //                 fontFamily: 'Roboto'),
                                                            //           ),
                                                            //           Text(
                                                            //             "${widget.matchDetails.match_time}",
                                                            //             // widget.matchDetails.match_time.toString(),
                                                            //             style: TextStyle(
                                                            //                 fontSize: 11,
                                                            //                 color: Color(0xff747474),
                                                            //                 fontFamily: 'Roboto'),
                                                            //           ),
                                                            //         ],
                                                            //       )),
                                                            // ),
                                                          ],
                                                        ),
                                                        Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    width: 105,
                                                                    margin: EdgeInsets.only(
                                                                        bottom:
                                                                            0,
                                                                        left:
                                                                            10,
                                                                        top: 0),
                                                                    child:
                                                                        new Text(
                                                                      widget
                                                                          .matchListResponse!
                                                                          .result![
                                                                              index]
                                                                          .team1name!,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "Roboto",
                                                                          color:
                                                                              lightBlack,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              10),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: 105,
                                                                    margin: EdgeInsets.only(
                                                                        bottom:
                                                                            0,
                                                                        right:
                                                                            8,
                                                                        top: 0),
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    child: Text(
                                                                      widget
                                                                          .matchListResponse!
                                                                          .result![
                                                                              index]
                                                                          .team2name!,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "Roboto",
                                                                          color:
                                                                              lightBlack,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              10),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Container(
                                                                    // width: 105,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12),

                                                                      color: widget.matchListResponse!.result![index].match_status!.toLowerCase() ==
                                                                              'completed'
                                                                          ? Color(0xff3F8F54)
                                                                              .withAlpha(20)
                                                                          : widget.matchListResponse!.result![index].match_status!.toLowerCase() == 'live' || widget.matchListResponse!.result![index].match_status!.toLowerCase() == 'under review'
                                                                              ? Color(0xffDF0E0E).withAlpha(20)
                                                                              : Color(0xffDF0E0E1A).withAlpha(1),
                                                                      // image:
                                                                      //     DecorationImage(
                                                                      //         image:
                                                                      //             AssetImage(
                                                                      //   widget.matchListResponse!.result![index].match_status!
                                                                      //               .toLowerCase() ==
                                                                      //           'completed'
                                                                      //       ? AppImages
                                                                      //           .finishMatch
                                                                      //       : widget.matchListResponse!.result![index].match_status!.toLowerCase() == 'live' ||
                                                                      //               widget.matchListResponse!.result![index].match_status!.toLowerCase() ==
                                                                      //                   'under review'
                                                                      //           ? AppImages
                                                                      //               .livematch
                                                                      //       :"",
                                                                      //           // : AppImages
                                                                      //           //     .home_card_icon,
                                                                      // )),
                                                                    ),
                                                                    // height: 25,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: currentMatchIndex ==
                                                                            0
                                                                        ? CustomTimer(
                                                                            from:
                                                                                Duration(milliseconds: DateFormat.getFormattedDateObj(widget.matchListResponse!.result![index].time_start!)!.millisecondsSinceEpoch - MethodUtils.getDateTime().millisecondsSinceEpoch),
                                                                            to: Duration(milliseconds: 0),
                                                                            onBuildAction:
                                                                                CustomTimerAction.auto_start,
                                                                            controller:
                                                                                _controller[index],
                                                                            builder:
                                                                                (CustomTimerRemainingTime remaining) {
                                                                              if (remaining.minutes == '00' && remaining.seconds == '-1' || int.parse(remaining.minutes) < -1 || (remaining.seconds.contains('-') || remaining.minutes.contains('-'))) {
                                                                                _controller[index].pause();
                                                                                controller.TimeFunction(remaining.minutes, remaining.seconds, index);
                                                                                WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
                                                                                      widget.pullRefresh!(currentMatchIndex);
                                                                                    }));
                                                                              }
                                                                              return Row(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                                                                                    child: Text(
                                                                                      // int.parse(remaining
                                                                                      //     .days) >=
                                                                                      //     1
                                                                                      //     ? int.parse(remaining
                                                                                      //     .days) >
                                                                                      //     1
                                                                                      //     ? "${remaining.days} Days "
                                                                                      //     : " ${remaining.days} Day"
                                                                                      //     : int.parse(remaining
                                                                                      //     .hours) >=
                                                                                      //     1
                                                                                      //     ? ("${remaining.hours}h : ${remaining.minutes}m")
                                                                                      //     : "${remaining.minutes}m : ${remaining.seconds == '-1' ? "00" : remaining.seconds}s",

                                                                                      getTime(remaining),
                                                                                      style: TextStyle(
                                                                                          // fontFamily: "Roboto",
                                                                                          color: lightBlack,
                                                                                          fontSize: 11,
                                                                                          fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                                                                                    child: Text(
                                                                                      // int.parse(remaining
                                                                                      //     .days) >=
                                                                                      //     1
                                                                                      //     ? int.parse(remaining
                                                                                      //     .days) >
                                                                                      //     1
                                                                                      //     ? "${remaining.days} Days "
                                                                                      //     : " ${remaining.days} Day"
                                                                                      //     : int.parse(remaining
                                                                                      //     .hours) >=
                                                                                      //     1
                                                                                      //     ? ("${remaining.hours}h : ${remaining.minutes}m")
                                                                                      //     : "${remaining.minutes}m : ${remaining.seconds == '-1' ? "00" : remaining.seconds}s",

                                                                                      ' | ${widget.matchListResponse!.result![index].match_date}',
                                                                                      style: TextStyle(
                                                                                          // fontFamily: "Roboto",
                                                                                          color: lightBlack,
                                                                                          fontSize: 11,
                                                                                          fontWeight: FontWeight.normal),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          )
                                                                        : Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                left: 10,
                                                                                right: 10,
                                                                                top: 4,
                                                                                bottom: 4),
                                                                            child:
                                                                                Text(
                                                                              widget.matchListResponse!.result![index].match_status?.toUpperCase() ?? '',
                                                                              style: TextStyle(
                                                                                  fontFamily: "Roboto",
                                                                                  color: widget.matchListResponse!.result![index].match_status!.toLowerCase() == 'completed'
                                                                                      ? greenColor
                                                                                      : widget.matchListResponse!.result![index].match_status!.toLowerCase() == 'live' || widget.matchListResponse!.result![index].match_status!.toLowerCase() == 'under review'
                                                                                          ? Color(0xffDF0E0E)
                                                                                          : primaryColor,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  fontSize: 11),
                                                                            ),
                                                                          ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        /* Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 7),
                                                          child: new Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      top: 7,
                                                                      bottom:
                                                                          4),
                                                              child: Text(
                                                                widget.matchListResponse!.result![index].name!,
                                                                style: TextStyle(
                                                                    fontFamily: "Roboto",
                                                                    //fontFamily: "Roboto",
                                                                    color: Color(0xff747474),
                                                                    fontWeight: FontWeight.w400,
                                                                    fontSize: 12),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Divider(
                                                          color:
                                                              Color(0xFFe8e8e8),
                                                          height: 1,
                                                        ),
                                                        Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            Container(
                                                              // decoration:
                                                              //     BoxDecoration(
                                                              //         gradient: LinearGradient(
                                                              //   begin: Alignment
                                                              //       .topLeft,
                                                              //   end: Alignment
                                                              //       .bottomRight,
                                                              //   colors: [
                                                              //     MethodUtils.hexToColor(widget.matchListResponse!.result![index].team1_color!)
                                                              //         .withOpacity(.1),
                                                              //     Colors
                                                              //         .white
                                                              //         .withOpacity(.05),
                                                              //     MethodUtils.hexToColor(widget.matchListResponse!.result![index].team2_color!)
                                                              //         .withOpacity(.1)
                                                              //   ],
                                                              // )),
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom: 0,
                                                                      top: 0),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Flexible(
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        ShaderMask(
                                                                          blendMode:
                                                                              BlendMode.srcATop,
                                                                          shaderCallback:
                                                                              (Rect bounds) {
                                                                            return LinearGradient(
                                                                              colors: [
                                                                                MethodUtils.hexToColor(widget.matchListResponse!.result![index].team1_color!).withOpacity(.2),
                                                                                Colors.white
                                                                              ],
                                                                              begin: Alignment.centerLeft,
                                                                              end: Alignment.centerRight,
                                                                            ).createShader(bounds);
                                                                          },
                                                                          child:
                                                                              Image.asset(
                                                                            AppImages.home_match_item_bg_left,
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              220,
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Container(
                                                                                width: 110,
                                                                                margin: EdgeInsets.only(bottom: 2, left: 10, top: 2),
                                                                                child: new Text(
                                                                                  widget.matchListResponse!.result![index].team1name!,
                                                                                  textAlign: TextAlign.left,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: TextStyle(fontFamily: "Roboto", color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12),
                                                                                ),
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  Stack(
                                                                                    alignment: Alignment.centerLeft,
                                                                                    children: [
                                                                                      // Container(
                                                                                      //   height: 20,
                                                                                      //   width: 110,
                                                                                      //   child: Image(
                                                                                      //     image: AssetImage(AppImages.leftTeamIcon),
                                                                                      //     fit: BoxFit.fill,
                                                                                      //     color: MethodUtils.hexToColor(widget.matchListResponse!.result![index].team1_color!).withOpacity(.01),
                                                                                      //   ),
                                                                                      // ),
                                                                                      Row(
                                                                                        children: [
                                                                                          Padding(
                                                                                            padding: EdgeInsets.only(left: 7),
                                                                                            child: ClipRRect(
                                                                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                                                                              child: Container(
                                                                                                //margin: EdgeInsets.only(left: 7),
                                                                                                height: 30,
                                                                                                width: 30,
                                                                                                child: CachedNetworkImage(
                                                                                                  imageUrl: widget.matchListResponse!.result![index].team1logo!,
                                                                                                  placeholder: (context, url) => Image.asset(
                                                                                                    AppImages.logoPlaceholderURL,
                                                                                                  ),
                                                                                                  errorWidget: (context, url, error) => Image.asset(
                                                                                                    AppImages.logoPlaceholderURL,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            margin: EdgeInsets.only(left: 5),
                                                                                            child: Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Container(
                                                                                                  margin: EdgeInsets.only(top: 0),
                                                                                                  width: 55,
                                                                                                  child: Text(
                                                                                                    widget.matchListResponse!.result![index].team1display!,
                                                                                                    textAlign: TextAlign.left,
                                                                                                    overflow: TextOverflow.ellipsis,
                                                                                                    style: TextStyle(fontFamily: "Roboto", color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
                                                                                                  ),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    flex: 1,
                                                                  ),
                                                                  Flexible(
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Column(
                                                                        children: [],
                                                                      ),
                                                                    ),
                                                                    flex: 1,
                                                                  ),
                                                                  Flexible(
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        ShaderMask(
                                                                          blendMode:
                                                                              BlendMode.srcATop,
                                                                          shaderCallback:
                                                                              (Rect bounds) {
                                                                            return LinearGradient(
                                                                              colors: [
                                                                                MethodUtils.hexToColor(widget.matchListResponse!.result![index].team2_color!).withOpacity(.2),
                                                                                Colors.white
                                                                              ],
                                                                              begin: Alignment.centerRight,
                                                                              end: Alignment.centerLeft,
                                                                            ).createShader(bounds);
                                                                          },
                                                                          child:
                                                                              Image.asset(
                                                                            AppImages.home_match_item_bg_right,
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              200,
                                                                          child:
                                                                              new Column(
                                                                            children: [
                                                                              Container(
                                                                                margin: EdgeInsets.only(bottom: 2, right: 10, top: 2),
                                                                                alignment: Alignment.centerRight,
                                                                                child: Text(
                                                                                  widget.matchListResponse!.result![index].team2name!,
                                                                                  textAlign: TextAlign.left,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: TextStyle(fontFamily: "Roboto", color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12),
                                                                                ),
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  Stack(
                                                                                    alignment: Alignment.centerLeft,
                                                                                    children: [
                                                                                      // new Container(
                                                                                      //   height: 20,
                                                                                      //   width: 110,
                                                                                      //   child: Image(
                                                                                      //     image: AssetImage(AppImages.rightTeamIcon),
                                                                                      //     fit: BoxFit.fill,
                                                                                      //     color: MethodUtils.hexToColor(widget.matchListResponse!.result![index].team2_color!).withOpacity(.01),
                                                                                      //   ),
                                                                                      // ),
                                                                                      Row(
                                                                                        children: [
                                                                                          Container(
                                                                                            margin: EdgeInsets.only(right: 5),
                                                                                            child: Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                                                              children: [
                                                                                                Container(
                                                                                                  margin: EdgeInsets.only(top: 0),
                                                                                                  width: 55,
                                                                                                  alignment: Alignment.centerRight,
                                                                                                  child: Text(
                                                                                                    widget.matchListResponse!.result![index].team2display!,
                                                                                                    overflow: TextOverflow.ellipsis,
                                                                                                    textAlign: TextAlign.left,
                                                                                                    style: TextStyle(fontFamily: "Roboto", color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
                                                                                                  ),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          Padding(
                                                                                            padding: EdgeInsets.only(right: 7),
                                                                                            child: ClipRRect(
                                                                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                                                                              child: Container(
                                                                                                height: 30,
                                                                                                width: 30,
                                                                                                child: CachedNetworkImage(
                                                                                                  imageUrl: widget.matchListResponse!.result![index].team2logo!,
                                                                                                  placeholder: (context, url) => Image.asset(
                                                                                                    AppImages.logoPlaceholderURL,
                                                                                                    //   color: Colors.grey
                                                                                                  ),
                                                                                                  errorWidget: (context, url, error) => Image.asset(
                                                                                                    AppImages.logoPlaceholderURL,
                                                                                                    //   color: Colors.grey
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    flex: 1,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              child: Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  // margin: EdgeInsets.only(top: 30),
                                                                  child: Text(
                                                                    "VS",
                                                                    // widget.matchDetails.match_time.toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14),
                                                                  )),
                                                            ),
                                                          ],
                                                        ),*/

                                                        // new Divider(
                                                        //   color:
                                                        //       Color(0xFFFFE8E8),
                                                        //   thickness: 1,
                                                        //   height: 1.5,
                                                        // ),

                                                        SizedBox(
                                                          height: 4,
                                                        ),

                                                        new Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            // image: DecorationImage(
                                                            //     image: AssetImage(
                                                            //         "assets/images/bottom_match_bg.png"),
                                                            //     fit: BoxFit
                                                            //         .fill),
                                                            color: Color(
                                                                0xffF1E7FF),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            // color: Colors.transparent,
                                                          ),
                                                          height: 30,
                                                          child: new Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10),
                                                                child: Row(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          widget
                                                                              .matchListResponse!
                                                                              .result![index]
                                                                              .team_count
                                                                              .toString(),
                                                                          style: TextStyle(
                                                                              color: textBrownColor,
                                                                              fontSize: 12,
                                                                              fontFamily: "Roboto",
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        Text(
                                                                          ' Team -'
                                                                              .toUpperCase(),
                                                                          style: TextStyle(
                                                                              color: textBrownColor,
                                                                              fontSize: 12,
                                                                              fontFamily: "Roboto",
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    new Container(
                                                                      color: Colors
                                                                          .transparent,
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              3,
                                                                          right:
                                                                              4),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          new Text(
                                                                            widget.matchListResponse!.result![index].joined_count.toString(),
                                                                            style: TextStyle(
                                                                                color: textBrownColor,
                                                                                fontSize: 12,
                                                                                fontFamily: "Roboto",
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                          Text(
                                                                            ' Contests Joined'.toUpperCase(),
                                                                            style: TextStyle(
                                                                                color: textBrownColor,
                                                                                fontSize: 12,
                                                                                fontFamily: "Roboto",
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              widget
                                                                          .matchListResponse!
                                                                          .result![
                                                                              index]
                                                                          .is_visible_total_earned ==
                                                                      1
                                                                  ? new Container(
                                                                      margin: EdgeInsets.only(
                                                                          right:
                                                                              10),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          new Text(
                                                                            'Total Affiliation: ',
                                                                            style: TextStyle(
                                                                                color: greenColor,
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(right: 2),
                                                                            child:
                                                                                Container(
                                                                              height: 12,
                                                                              width: 12,
                                                                              child: Image.asset(AppImages.goldcoin),
                                                                            ),
                                                                          ),
                                                                          new Text(
                                                                            widget.matchListResponse!.result![index].total_earned!.toString(),
                                                                            style: TextStyle(
                                                                                color: greenColor,
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : new Container(),
                                                              currentMatchIndex ==
                                                                          2 &&
                                                                      double.parse(widget
                                                                              .matchListResponse!
                                                                              .result![index]
                                                                              .winning_total
                                                                              .toString()) >
                                                                          0
                                                                  ? new Container(
                                                                      height:
                                                                          30,
                                                                      // width: 130,
                                                                      decoration: BoxDecoration(
                                                                          image: DecorationImage(
                                                                              image: AssetImage(AppImages.MyMatchesWonBg),
                                                                              fit: BoxFit.fill)),
                                                                      //margin: EdgeInsets.only(right: 10),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                10),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              new Text(
                                                                                'You Won: ',
                                                                                style: TextStyle(fontFamily: "Roboto", color: Color(0xff076e39), fontSize: 12, fontWeight: FontWeight.normal),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.only(right: 2),
                                                                                child: Container(
                                                                                  height: 12,
                                                                                  width: 12,
                                                                                  child: Image.asset(AppImages.goldcoin),
                                                                                ),
                                                                              ),
                                                                              new Text(
                                                                                widget.matchListResponse!.result![index].winning_total!.toString(),
                                                                                style: TextStyle(fontFamily: "Roboto", color: Color(0xff076e39), fontSize: 12, fontWeight: FontWeight.normal),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container()
                                                              //  Icon(
                                                              //     Icons.keyboard_arrow_right,
                                                              //     color: Colors.grey.shade400,
                                                              //   ),
                                                              // currentMatchIndex==2?Container():
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              if (currentMatchIndex == 0) {
                                                setState(() {
                                                  AppConstants.onContestScreen =
                                                      true;
                                                });

                                                Platform.isAndroid
                                                    ? Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              UpcomingContests(
                                                                  new GeneralModel(
                                                            bannerImage: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .banner_image,
                                                            matchKey: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .matchkey,
                                                            teamVs: (widget
                                                                    .matchListResponse!
                                                                    .result![
                                                                        index]
                                                                    .team1display! +
                                                                ' VS ' +
                                                                widget
                                                                    .matchListResponse!
                                                                    .result![
                                                                        index]
                                                                    .team2display!),
                                                            firstUrl: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .team1logo,
                                                            secondUrl: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .team2logo,
                                                            headerText: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .time_start,
                                                            sportKey: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .sport_key,
                                                            battingFantasy: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .battingfantasy,
                                                            bowlingFantasy: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .bowlingfantasy,
                                                            liveFantasy: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .livefantasy,
                                                            secondInningFantasy:
                                                                widget
                                                                    .matchListResponse!
                                                                    .result![
                                                                        index]
                                                                    .secondinning,
                                                            reverseFantasy: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .reversefantasy,
                                                            fantasySlots: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .slotes,
                                                            team1Name: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .team1name,
                                                            team2Name: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .team2name,
                                                            team1Logo: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .team1logo,
                                                            team2Logo: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .team2logo,
                                                            format: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .format,
                                                          )),
                                                          settings:
                                                              RouteSettings(
                                                                  name: "home"),
                                                        )).then((value) {
                                                        // widget.pullRefresh!(
                                                        //     currentMatchIndex,
                                                        //     stopLoading: false);
                                                        AppConstants
                                                                .onContestScreen =
                                                            false;
                                                        print(AppConstants
                                                            .onContestScreen);
                                                      })
                                                    : Navigator.push(
                                                        context,
                                                        CupertinoPageRoute(
                                                          builder: (context) =>
                                                              UpcomingContests(
                                                                  new GeneralModel(
                                                            bannerImage: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .banner_image,
                                                            matchKey: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .matchkey,
                                                            teamVs: (widget
                                                                    .matchListResponse!
                                                                    .result![
                                                                        index]
                                                                    .team1display! +
                                                                ' VS ' +
                                                                widget
                                                                    .matchListResponse!
                                                                    .result![
                                                                        index]
                                                                    .team2display!),
                                                            firstUrl: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .team1logo,
                                                            secondUrl: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .team2logo,
                                                            headerText: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .time_start,
                                                            sportKey: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .sport_key,
                                                            battingFantasy: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .battingfantasy,
                                                            bowlingFantasy: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .bowlingfantasy,
                                                            liveFantasy: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .livefantasy,
                                                            secondInningFantasy:
                                                                widget
                                                                    .matchListResponse!
                                                                    .result![
                                                                        index]
                                                                    .secondinning,
                                                            reverseFantasy: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .reversefantasy,
                                                            fantasySlots: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .slotes,
                                                            team1Name: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .team1name,
                                                            team2Name: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .team2name,
                                                            team1Logo: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .team1logo,
                                                            team2Logo: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .team2logo,
                                                            format: widget
                                                                .matchListResponse!
                                                                .result![index]
                                                                .format,
                                                          )),
                                                          settings:
                                                              RouteSettings(
                                                                  name: "home"),
                                                        )).then((value) {
                                                        widget.pullRefresh!(
                                                            currentMatchIndex,
                                                            stopLoading: false);
                                                      });
                                              } else {
                                                navigateToLiveFinishContests(
                                                    context,
                                                    new GeneralModel(
                                                      bannerImage: widget
                                                          .matchListResponse!
                                                          .result![index]
                                                          .banner_image,
                                                      matchKey: widget
                                                          .matchListResponse!
                                                          .result![index]
                                                          .matchkey,
                                                      teamVs: (widget
                                                              .matchListResponse!
                                                              .result![index]
                                                              .team1display! +
                                                          ' VS ' +
                                                          widget
                                                              .matchListResponse!
                                                              .result![index]
                                                              .team2display!),
                                                      firstUrl: widget
                                                          .matchListResponse!
                                                          .result![index]
                                                          .team1logo,
                                                      secondUrl: widget
                                                          .matchListResponse!
                                                          .result![index]
                                                          .team2logo,
                                                      headerText: widget
                                                          .matchListResponse!
                                                          .result![index]
                                                          .time_start,
                                                      sportKey: widget
                                                          .matchListResponse!
                                                          .result![index]
                                                          .sport_key,
                                                      battingFantasy: widget
                                                          .matchListResponse!
                                                          .result![index]
                                                          .battingfantasy,
                                                      bowlingFantasy: widget
                                                          .matchListResponse!
                                                          .result![index]
                                                          .bowlingfantasy,
                                                      liveFantasy: widget
                                                          .matchListResponse!
                                                          .result![index]
                                                          .livefantasy,
                                                      secondInningFantasy: widget
                                                          .matchListResponse!
                                                          .result![index]
                                                          .secondinning,
                                                      reverseFantasy: widget
                                                          .matchListResponse!
                                                          .result![index]
                                                          .reversefantasy,
                                                      fantasySlots: widget
                                                          .matchListResponse!
                                                          .result![index]
                                                          .slotes,
                                                      team1Name: widget
                                                          .matchListResponse!
                                                          .result![index]
                                                          .team1name,
                                                      team2Name: widget
                                                          .matchListResponse!
                                                          .result![index]
                                                          .team2name,
                                                      team1Logo: widget
                                                          .matchListResponse!
                                                          .result![index]
                                                          .team1logo,
                                                      team2Logo: widget
                                                          .matchListResponse!
                                                          .result![index]
                                                          .team2logo,
                                                      launch_status: widget
                                                          .matchListResponse!
                                                          .result![index]
                                                          .final_status,
                                                      isFromLive:
                                                          currentMatchIndex ==
                                                              1,
                                                      scorecard: 1,
                                                      commentry: 1,
                                                      isFromLiveFinish: true,
                                                      format: widget
                                                          .matchListResponse!
                                                          .result![index]
                                                          .format,
                                                    ),
                                                    match_status: widget
                                                        .matchListResponse!
                                                        .result![index]
                                                        .match_status);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }),
                        ),
                      ],
                    )
                  : NoMatchesListFound(
                      sportKey: AppConstants.sportKey,
                    )
              : new Container(
                  margin: EdgeInsets.all(8),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: 7,
                      itemBuilder: (BuildContext context, int index) {
                        return new ShimmerMatchItemAdapter();
                      }),
                ),
        ),
      ),
    );
  }

  String getTime(CustomTimerRemainingTime remaining) {
    return int.parse(remaining.days) >= 1
        ? int.parse(remaining.days) > 1
            ? "${remaining.days} Days"
            : "${remaining.days} Day "
        : int.parse(remaining.hours) >= 1
            ? ("${remaining.hours}h : ${remaining.minutes}m ")
            : " ${remaining.minutes}m : ${remaining.seconds == '-1' ? "00" : remaining.seconds}s";
  }

  Future<void> _pullRefresh() async {
    currentMatchIndex > 1
        ? widget.getMyMatchFinishList!(currentMatchIndex)
        : widget.pullRefresh!(
            currentMatchIndex,
          );
  }
}

class CustomScrollPhysics extends ClampingScrollPhysics {
  const CustomScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if (velocity.abs() > 1000) {
      // Cap the velocity to avoid skipping pages
      velocity = velocity.sign * 100;
    }
    return super.createBallisticSimulation(position, velocity);
  }

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }
}
