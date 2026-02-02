import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myrex11/adapter/ContestItemAdapter.dart';
import 'package:myrex11/adapter/ShimmerContestItemAdapter.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/defaultbutton.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/buildType/buildType.dart';
import 'package:myrex11/customWidgets/MatchHeader.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/category_contest_response.dart';
import 'package:myrex11/repository/model/contest_request.dart';
import 'package:myrex11/repository/model/contest_response.dart';
import 'package:myrex11/repository/model/score_card_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';
import 'package:need_resume/need_resume.dart';

class AllContests extends StatefulWidget {
  GeneralModel model;
  int? _contestItemIndex;
  double? scrollPosition;
  String? checkScreen;

  AllContests(
    this.model,
    this._contestItemIndex, {
    this.scrollPosition,
    this.checkScreen,
  });
  @override
  AllContestsState createState() => new AllContestsState();

  @override
  BuildContext? context;

  @override
  String? userId;
}

class AllContestsState extends ResumableState<AllContests> {
  String userId = '0';
  bool contestLoading = false;

  bool checked1 = false,
      checked2 = false,
      checked3 = false,
      checked4 = false,
      checked5 = false,
      checked6 = false,
      checked7 = false,
      checked8 = false;

  bool checked9 = false,
      checked10 = false,
      checked11 = false,
      checked12 = false,
      checked13 = false,
      checked14 = false,
      checked15 = false,
      checked16 = false,
      checked17 = false,
      checked18 = false,
      checked19 = false,
      checked30 = false;

  ScrollController _scrollController = ScrollController();
  int pageNumber = 0;

  bool isPagination = false;
  int isWinnings = 0, isTeam = 0, isEntry = 0, isWinner = 0;
  List<Contest> contestList = [];
  List<String> entryFee = [];
  List<String> winning = [];
  List<String> contest_type = [];
  List<String> contest_size = [];
  double _scrollPosition = 0.0;
  bool scrollValue = false;
  int isAccountDisable = 0;

  @override
  void onResume() {
    // TODO: implement onResume
    super.onResume();
  }

  @override
  void initState() {
    super.initState();

    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //          setState(() {
    //   pageNumber = 0;
    //   contestList.clear();
    // });
    //     getAllContest(true);
    //     // if (widget.model.categoryId == 111 || widget.model.categoryId == null) {
    //     //   if (widget.model.filterType != "all_filters") {
    //     //     getAllContest(true);
    //     //   }
    //     // } else {
    //     //   getAllContestByCategoryId(true);
    //     // }

    //     // Load more data when user reaches the end of the list.
    //     // You can call your data source's method here to fetch the next page.
    //   }
    // });

    // if (!_scrollController.hasClients) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     _scrollController.jumpTo(widget.scrollPosition ?? 0.0);
    //     _scrollController.addListener(() {
    //       widget.scrollPosition = _scrollController.offset;
    //       setState(() {});
    //     });
    //   });
    // }

    AppPrefrence.getInt(AppConstants.IS_ACCOUNT_WALLET_DISABLE, 0)
        .then((value) => {
              setState(() {
                isAccountDisable = value;
              })
            });

    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
        .then((value) => {
              setState(() {
                userId = value;
                contestList.clear();
                pageNumber = 0;
                getAllContest(false);
                // if (widget.model.categoryId == 111 ||
                //     widget.model.categoryId == null) {
                //   if (widget.model.filterType != "all_filters") {
                //     getAllContest(false);
                //   }
                // } else {
                //   getAllContestByCategoryId(false);
                // }
              })
            });
  }

  Future<void> _pullRefresh() async {
    setState(() {
      pageNumber = 0;
      contestList.clear();
      isWinnings = 0;
      isTeam = 0;
      isEntry = 0;
      isWinner = 0;
    });

    getAllContest(false);
    // if (widget.model.categoryId == 111) {
    //   getAllContest(false);
    // }
    // else {
    //   getAllContestByCategoryId(false);
    // }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            /* set Status bar color in Android devices. */

            statusBarIconBrightness: Brightness.dark,
            /* set Status bar icons color in Android devices.*/

            statusBarBrightness:
                Brightness.dark) /* set Status bar icon color in iOS. */
        );

    return Container(
      color: primaryColor,
      child: SafeArea(
        top: false,
        child: new Scaffold(
          body: new WillPopScope(
            onWillPop: _onWillPop,
            child: new Stack(
              children: [
                Scaffold(
                  body: Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        color: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            MatchHeader(
                              widget.model.teamVs!,
                              widget.model.headerText!,
                              widget.model.isFromLive ?? false,
                              widget.model.isFromLiveFinish ?? false,
                              checkScreen: widget.checkScreen,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 30,
                              margin: EdgeInsets.only(top: 10, bottom: 5),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    new GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      child: new Row(
                                        children: [
                                          new Container(
                                            margin: EdgeInsets.only(
                                                left: 10, right: 2),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'PRIZE POOL',
                                              style: TextStyle(
                                                  fontFamily: "Roboto",
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          isWinnings != 0
                                              ? new Container(
                                                  height: 13,
                                                  width: 5,
                                                  child: Image(
                                                    image: AssetImage(
                                                      isWinnings == 1
                                                          ? AppImages.upSort
                                                          : AppImages.downSort,
                                                    ),
                                                    color: Colors.black,
                                                  ),
                                                )
                                              : new Container(),
                                        ],
                                      ),
                                      onTap: () {
                                        prizePoolSort();
                                      },
                                    ),
                                    new GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      child: new Row(
                                        children: [
                                          new Container(
                                            margin: EdgeInsets.only(
                                                left: 10, right: 2),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'SPOTS',
                                              style: TextStyle(
                                                  fontFamily: "Roboto",
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          isTeam != 0
                                              ? new Container(
                                                  height: 13,
                                                  width: 5,
                                                  child: Image(
                                                    image: AssetImage(
                                                      isTeam == 1
                                                          ? AppImages.upSort
                                                          : AppImages.downSort,
                                                    ),
                                                    color: Colors.black,
                                                  ),
                                                )
                                              : new Container(),
                                        ],
                                      ),
                                      onTap: () {
                                        spotsSort();
                                      },
                                    ),
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 10, right: 2),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'WINNERS',
                                              style: TextStyle(
                                                  fontFamily: "Roboto",
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          isWinner != 0
                                              ? new Container(
                                                  height: 13,
                                                  width: 5,
                                                  child: Image(
                                                    image: AssetImage(
                                                      isWinner == 1
                                                          ? AppImages.upSort
                                                          : AppImages.downSort,
                                                    ),
                                                    color: Colors.black,
                                                  ),
                                                )
                                              : new Container(),
                                        ],
                                      ),
                                      onTap: () {
                                        winnersSort();
                                      },
                                    ),
                                    new GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      child: new Row(
                                        children: [
                                          new Container(
                                            margin: EdgeInsets.only(
                                                left: 10, right: 2),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'ENTRY',
                                              style: TextStyle(
                                                  fontFamily: "Roboto",
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          isEntry != 0
                                              ? new Container(
                                                  height: 13,
                                                  width: 5,
                                                  child: Image(
                                                    image: AssetImage(
                                                      isEntry == 1
                                                          ? AppImages.upSort
                                                          : AppImages.downSort,
                                                    ),
                                                    color: Colors.black,
                                                  ),
                                                )
                                              : new Container(),
                                        ],
                                      ),
                                      onTap: () {
                                        entrySort();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            !contestLoading
                                ? new Expanded(
                                    child: RefreshIndicator(
                                    child: new Container(
                                      padding: EdgeInsets.all(8),
                                      color: contestList.length == 0
                                          ? Colors.white
                                          : bgColor,
                                      child: contestList.length == 0
                                          ? Center(
                                              child: Text(
                                                "No Contest Found.",
                                                style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    color: Colors.black54),
                                              ),
                                            )
                                          : new ListView.builder(
                                              controller: _scrollController,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: contestList.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return ContestItemAdapter(
                                                  widget._contestItemIndex,
                                                  widget.model,
                                                  contestList[index],
                                                  onJoinContestResult,
                                                  userId,
                                                  getWinnerPriceCard,
                                                  onTeamCreated,
                                                  screenCheck: 'fromallcontest',
                                                );
                                              }),
                                    ),
                                    onRefresh: _pullRefresh,
                                  ))
                                : new Expanded(
                                    child: new Container(
                                    padding: EdgeInsets.all(8),
                                    color: bgColor,
                                    child: new ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: 7,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return new ShimmerContestItemAdapter();
                                        }),
                                  ))
                          ],
                        ),
                      ),
                      // Positioned(
                      //     bottom: 4,
                      //     left: 0,
                      //     right: 0,
                      //     child: isPagination
                      //         ? Container(
                      //             color: Colors.white,
                      //             height: 60,
                      //             alignment: Alignment.center,
                      //             child: CircularProgressIndicator(
                      //               color: primaryColor,
                      //             ))
                      //         : SizedBox.shrink())
                    ],
                  ),
                  backgroundColor: bgColorDark,
                  // appBar: PreferredSize(
                  //   preferredSize: Size.fromHeight(55), // Set this height
                  //   child: Container(
                  //     color: Colors.white,
                  //     padding: EdgeInsets.only(top: 0),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Row(
                  //           children: [
                  //             GestureDetector(
                  //               behavior: HitTestBehavior.translucent,
                  //               onTap: () => {Navigator.pop(context)},
                  //               child: Container(
                  //                 padding:
                  //                     EdgeInsets.fromLTRB(15, 15, 25, 15),
                  //                 alignment: Alignment.centerLeft,
                  //                 child: Container(
                  //                   width: 24,
                  //                   height: 24,
                  //                   child: Image(
                  //                     image:
                  //                         AssetImage(AppImages.backImageURL),
                  //                     fit: BoxFit.fill,
                  //                     color: Colors.black,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //             new Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               mainAxisSize: MainAxisSize.min,
                  //               children: [
                  //                 new Text("Contests",
                  //                     style: TextStyle(
                  //                         fontFamily: "Roboto",
                  //                         color: Colors.black,
                  //                         fontWeight: FontWeight.w500,
                  //                         fontSize: 18)),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //         Container(
                  //           margin: EdgeInsets.only(top: 0, right: 20),
                  //           alignment: Alignment.center,
                  //           child: Row(
                  //             crossAxisAlignment: CrossAxisAlignment.center,
                  //             mainAxisAlignment: MainAxisAlignment.end,
                  //             mainAxisSize: MainAxisSize.max,
                  //             children: [
                  //               GestureDetector(
                  //                 behavior: HitTestBehavior.translucent,
                  //                 child: Container(
                  //                   child: Row(
                  //                     children: [
                  //                       Container(
                  //                         margin: EdgeInsets.only(left: 5),
                  //                         height: 20,
                  //                         width: 20,
                  //                         child:
                  //                             // Icon(Icons.filter_alt)
                  //                             Image(
                  //                           image: AssetImage(
                  //                             AppImages.filterIcon,
                  //                           ),
                  //                           color: Colors.black,
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //                 onTap: () {
                  //                   setState(() {
                  //                     AppConstants.isFilter = true;
                  //                   });
                  //                 },
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // )

                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(55), // Set this height
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 40,
                        bottom: 10,
                        left: 16,
                      ),
                      decoration: BoxDecoration(
                          // image: DecorationImage(
                          //     image: AssetImage(
                          //         "assets/images/Ic_creatTeamBackGround.png"),
                          //     fit: BoxFit.cover)
                          color: primaryColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              AppConstants.backButtonFunction(),
                              Text("Contests",
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16)),
                            ],
                          ),
                          isAccountDisable == 1
                              ? Container(
                                  margin: EdgeInsets.only(top: 0, right: 20),
                                  alignment: Alignment.center,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 5),
                                                height: 30,
                                                child:
                                                    // Icon(Icons.filter_alt)
                                                    Image(
                                                  image: AssetImage(
                                                    AppImages.filterIcon,
                                                  ),
                                                  // color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            AppConstants.isFilter = true;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),

                // getFilter()
                AppConstants.isFilter == true
                    ? bottomFilterSheet()
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
    if (AppConstants.isFilter != null && AppConstants.isFilter!) {
      setState(() {
        AppConstants.isFilter = false;
        // Navigator.pop(context);
      });
    }
    return Future.value(false);
  }

  void getAllContestByCategoryId(bool _isPaginationLeague,
      {bool? isInitial}) async {
    setState(() {
      if (!_isPaginationLeague) {
        contestLoading = true;
      } else {
        isPagination = false;
      }
    });
    ContestRequest contestRequest = new ContestRequest(
        user_id: userId,
        matchkey: widget.model.matchKey,
        sport_key: widget.model.sportKey,
        category_id: widget.model.categoryId.toString(),
        fantasy_type: widget.model.fantasyType.toString(),
        slotes_id: widget.model.slotId.toString(),
        fantasy_type_id: CricketTypeFantasy.getCricketType(
            widget.model.fantasyType.toString(),
            sportsKey: widget.model
                .sportKey) /*widget.model.fantasyType==1?"7":widget.model.fantasyType==2 ?"6":"0"*/,
        entryfee: entryFee.join(","),
        winning: winning.join(","),
        contest_type: contest_type.join(","),
        contest_size: contest_size.join(","));
    final client = ApiClient(AppRepository.dio);
    ContestResponse response =
        await client.getContestByCategoryId(contestRequest);
    if (response.status == 1) {
      widget.model.allContest = 'viewall';
      contestList = response.result!.contest!;
    }

    // Fluttertoast.showToast(msg: myBalanceResponse.message!, toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 1);
    setState(() {
      contestLoading = false;
    });
  }

  void getAllContest(bool _isPagination,
      {String? fromOnTeamCreated, dontshowLoading}) async {
    setState(() {
      if (!_isPagination) {
        if (dontshowLoading != 1) {
          contestLoading = true;
        }
      } else {
        isPagination = _isPagination;
      }
    });

    ContestRequest contestRequest = new ContestRequest(
        user_id: userId,
        matchkey: widget.model.matchKey,
        sport_key: widget.model.sportKey,
        fantasy_type: widget.model.fantasyType.toString(),
        slotes_id: widget.model.slotId.toString(),
        category_id: widget.model.categoryId.toString(),
        entryfee: entryFee.join(","),
        page: pageNumber.toString(),
        fantasy_type_id: CricketTypeFantasy.getCricketType(
            widget.model.fantasyType.toString(),
            sportsKey: widget.model
                .sportKey) /*widget.model.fantasyType==1?"7":widget.model.fantasyType==2?"6":"0"*/,
        winning: winning.join(","),
        contest_type: contest_type.join(","),
        contest_size: contest_size.join(","));
    final client = ApiClient(AppRepository.dio);
    ContestResponse response = await client.getContests(contestRequest);
    if (response.status == 1) {
      isPagination = false;
      setState(() {});

      pageNumber++;
      // contestList = response.result!.contest!;
      widget.model.allContest = 'viewall';
      fromOnTeamCreated == 'count'
          ? contestList = response.result!.contest ?? []
          : contestList.addAll(response.result!.contest!);
      widget.model.teamCount = response.result!.user_teams;
      if (widget.model.filterType == 'contest_size') {
        spotsSort();
      } else if (widget.model.filterType == 'entry_fee') {
        entrySort();
      }
    }

    // Fluttertoast.showToast(msg: myBalanceResponse.message!, toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 1);
    setState(() {
      scrollValue = true;

      contestLoading = false;
    });
  }

  /*
  void getAllContest2(GeneralModel model) async {

      contestLoading = true;

   ContestRequest contestRequest = new ContestRequest(
        user_id: userId,
        matchkey: model.matchKey,
        sport_key: model.sportKey,
        fantasy_type: model.fantasyType.toString(),
        slotes_id: model.slotId.toString(),
        entryfee: entryFee.join(","),
        winning: winning.join(","),
        contest_type: contest_type.join(","),
        contest_size: contest_size.join(","));
    final client = ApiClient(AppRepository.dio);
    ContestResponse response = await client.getContests(contestRequest);
    if (response.status == 1) {
      contestList = response.result!.contest!;
      if (model.filterType == 'contest_size') {
        spotsSort();
      } else if (model.filterType == 'entry_fee') {
        entrySort();
      }
    }
    // Fluttertoast.showToast(msg: myBalanceResponse.message!, toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 1);

      contestLoading = false;
    }*/

  void onJoinContestResult(int isJoined, String referCode) {
    setState(() {
      pageNumber = 0;
      // contestList.clear();
      isWinnings = 0;
      isTeam = 0;
      isEntry = 0;
      isWinner = 0;
    });
    // print('object');
    // if (isJoined == 1) {
    //   // _scrollPosition = _scrollController.position.pixels;
    _scrollPosition = _scrollController.position.pixels;
    getAllContest(false, fromOnTeamCreated: 'count', dontshowLoading: 1);
    if (scrollValue == true) {
      Future.delayed(Duration(milliseconds: 500), () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(_scrollPosition);
        });
      });
    }

    //   // if (widget.model.categoryId == 111) {
    //   //   getAllContest(false);
    //   // }
    //   // else {
    //   //   getAllContestByCategoryId(false);
    //   // }
    // }
  }

  void prizePoolSort() {
    setState(() {
      if (isWinnings == 2 || isWinnings == 0) {
        isWinnings = 1;
        contestList.sort((a, b) => a.win_amount!.compareTo(b.win_amount!));
      } else {
        isWinnings = 2;
        contestList.sort((a, b) => b.win_amount!.compareTo(a.win_amount!));
      }
      isTeam = 0;
      isEntry = 0;
      isWinner = 0;
    });
  }

  void onTeamCreated() {
    setState(() {
      pageNumber = 0;
      // contestList.clear();
      isWinnings = 0;
      isTeam = 0;
      isEntry = 0;
      isWinner = 0;
    });

    print('myCount1');
    _scrollPosition = _scrollController.position.pixels;
    getAllContest(false, fromOnTeamCreated: 'count', dontshowLoading: 1);
    if (scrollValue == true) {
      Future.delayed(Duration(milliseconds: 500), () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(_scrollPosition);
        });
      });
    }
  }

  void spotsSort() {
    setState(() {
      if (isTeam == 2 || isTeam == 0) {
        isTeam = 1;
        contestList
            .sort((a, b) => a.getLeftSpots().compareTo(b.getLeftSpots()));
      } else {
        isTeam = 2;
        contestList
            .sort((a, b) => b.getLeftSpots().compareTo(a.getLeftSpots()));
      }
      isWinnings = 0;
      isEntry = 0;
      isWinner = 0;
    });
  }

  void winnersSort() {
    setState(() {
      if (isWinner == 2 || isWinner == 0) {
        isWinner = 1;
        contestList
            .sort((a, b) => a.totalWinners().compareTo(b.totalWinners()));
      } else {
        isWinner = 2;
        contestList
            .sort((a, b) => b.totalWinners().compareTo(a.totalWinners()));
      }
      isWinnings = 0;
      isEntry = 0;
      isTeam = 0;
    });
  }

  void entrySort() {
    setState(() {
      if (isEntry == 2 || isEntry == 0) {
        isEntry = 1;
        contestList.sort((a, b) => double.parse(a.entryfee.toString())
            .compareTo(double.parse(b.entryfee.toString())));
      } else {
        isEntry = 2;
        contestList.sort((a, b) => double.parse(b.entryfee.toString())
            .compareTo(double.parse(a.entryfee.toString())));
      }
      isWinnings = 0;
      isWinner = 0;
      isTeam = 0;
    });
  }

  void getWinnerPriceCard(int id, String winAmount) async {
    AppLoaderProgress.showLoader(context);
    ContestRequest request = new ContestRequest(
      user_id: userId,
      challenge_id: id.toString(),
      matchkey: widget.model.matchKey,
    );
    final client = ApiClient(AppRepository.dio);
    ScoreCardResponse response = await client.getWinnersPriceCard(request);
    setState(() {
      AppLoaderProgress.hideLoader(context);
    });
    if (response.status == 1) {
      MethodUtils.showWinningPopup(context, response.result!, winAmount);
    }
  }

  Widget bottomFilterSheet() {
    return AppConstants.isFilter != null && AppConstants.isFilter!
        ? DraggableScrollableSheet(
            //    minChildSize: 0.15,
            //   maxChildSize: 1,
            expand: true,
            initialChildSize: 1.0,
            builder: (context, controller) {
              return Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Container(
                  margin: EdgeInsets.only(top: 0),
                  color: Colors.white,
                  child: new Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      new Column(
                        children: [
                          new Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(left: 10, right: 10),
                            color: primaryColor,
                            child: new Stack(
                              alignment: Alignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    new GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      child: new Container(
                                          child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      )),
                                      onTap: () {
                                        setState(() {
                                          AppConstants.isFilter = false;
                                          Navigator.pop(context);
                                        });
                                      },
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            //   AppConstants.isFilter = false;
                                            checked1 = false;
                                            checked2 = false;
                                            checked3 = false;
                                            checked4 = false;
                                            checked5 = false;
                                            checked6 = false;
                                            checked7 = false;
                                            checked8 = false;
                                            checked9 = false;
                                            checked10 = false;
                                            checked11 = false;
                                            checked12 = false;
                                            checked13 = false;
                                            checked14 = false;
                                            checked15 = false;
                                            checked16 = false;
                                            checked17 = false;
                                            checked18 = false;
                                            checked19 = false;
                                            checked30 = false;
                                            entryFee.clear();
                                            winning.clear();
                                            contest_size.clear();
                                            contest_type.clear();
                                          });
                                        },
                                        child: new Text('Clear',
                                            style: TextStyle(
                                                fontFamily: "Roboto",
                                                color: Colors.white70,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16)))
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: new Text('FILTER',
                                      style: TextStyle(
                                          fontFamily: "Roboto",
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16)),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                  children: [
                                    new Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width,
                                      padding:
                                          EdgeInsets.only(left: 15, right: 10),
                                      color: Colors.white,
                                      child: new Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          new Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: new Text('Entry',
                                                style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    color: textcolor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16)),
                                          )
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              checked1 = !checked1;
                                              if (checked1) {
                                                entryFee.add('1');
                                              } else {
                                                entryFee.remove('1');
                                              }
                                            });
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 8),
                                              decoration: BoxDecoration(
                                                  color: checked1
                                                      ? Colors.black
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  border: Border.all(
                                                      color: checked1
                                                          ? Colors.black
                                                          : Color(0xffe3e3e3))),
                                              child: RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    fontSize: 13.0,
                                                    color: checked1
                                                        ? Colors.white
                                                        : const Color(
                                                            0xff484848),
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  children: [
                                                    WidgetSpan(
                                                      alignment:
                                                          PlaceholderAlignment
                                                              .middle,
                                                      child: Image.asset(
                                                        AppImages.goldcoin,
                                                        width: 14,
                                                        height: 14,
                                                      ),
                                                    ),
                                                    const TextSpan(
                                                        text: '1 to '),
                                                    WidgetSpan(
                                                      alignment:
                                                          PlaceholderAlignment
                                                              .middle,
                                                      child: Image.asset(
                                                        AppImages.goldcoin,
                                                        width: 14,
                                                        height: 14,
                                                      ),
                                                    ),
                                                    const TextSpan(text: '100'),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              checked2 = !checked2;
                                              if (checked2) {
                                                entryFee.add('2');
                                              } else {
                                                entryFee.remove('2');
                                              }
                                            });
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 8),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: checked2
                                                      ? Colors.black
                                                      : Colors.transparent,
                                                  border: Border.all(
                                                      color: checked2
                                                          ? Colors.black
                                                          : Color(0xffe3e3e3))),
                                              child: RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    fontSize: 13.0,
                                                    color: checked2
                                                        ? Colors.white
                                                        : const Color(
                                                            0xff484848),
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  children: [
                                                    WidgetSpan(
                                                      alignment:
                                                          PlaceholderAlignment
                                                              .middle,
                                                      child: Image.asset(
                                                        AppImages.goldcoin,
                                                        width: 14,
                                                        height: 14,
                                                      ),
                                                    ),
                                                    const TextSpan(
                                                        text: '101 to '),
                                                    WidgetSpan(
                                                      alignment:
                                                          PlaceholderAlignment
                                                              .middle,
                                                      child: Image.asset(
                                                        AppImages.goldcoin,
                                                        width: 14,
                                                        height: 14,
                                                      ),
                                                    ),
                                                    const TextSpan(
                                                        text: '1000'),
                                                  ],
                                                ),
                                              )),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              checked3 = !checked3;
                                              if (checked3) {
                                                entryFee.add('3');
                                              } else {
                                                entryFee.remove('3');
                                              }
                                            });
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 8),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: checked3
                                                      ? Colors.black
                                                      : Colors.transparent,
                                                  border: Border.all(
                                                      color: checked3
                                                          ? Colors.black
                                                          : Color(0xffe3e3e3))),
                                              child: RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    fontSize: 13.0,
                                                    color: checked3
                                                        ? Colors.white
                                                        : const Color(
                                                            0xff484848),
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  children: [
                                                    WidgetSpan(
                                                      alignment:
                                                          PlaceholderAlignment
                                                              .middle,
                                                      child: Image.asset(
                                                        AppImages.goldcoin,
                                                        width: 14,
                                                        height: 14,
                                                      ),
                                                    ),
                                                    const TextSpan(
                                                        text: '1001 to '),
                                                    WidgetSpan(
                                                      alignment:
                                                          PlaceholderAlignment
                                                              .middle,
                                                      child: Image.asset(
                                                        AppImages.goldcoin,
                                                        width: 14,
                                                        height: 14,
                                                      ),
                                                    ),
                                                    const TextSpan(
                                                        text: '5000'),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              checked4 = !checked4;
                                              if (checked4) {
                                                entryFee.add('4');
                                              } else {
                                                entryFee.remove('4');
                                              }
                                            });
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 8),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: checked4
                                                      ? Colors.black
                                                      : Colors.transparent,
                                                  border: Border.all(
                                                      color: checked4
                                                          ? Colors.black
                                                          : Color(0xffe3e3e3))),
                                              child: RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    fontSize: 13.0,
                                                    color: checked4
                                                        ? Colors.white
                                                        : const Color(
                                                            0xff484848),
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  children: [
                                                    WidgetSpan(
                                                      alignment:
                                                          PlaceholderAlignment
                                                              .middle,
                                                      child: Image.asset(
                                                        AppImages.goldcoin,
                                                        width: 14,
                                                        height: 14,
                                                      ),
                                                    ),
                                                    const TextSpan(
                                                        text: '5000 & more'),
                                                  ],
                                                ),
                                              )),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Divider(
                                        height: 1,
                                        color: Color(0xffe3e3e3),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width,
                                      padding:
                                          EdgeInsets.only(left: 15, right: 10),
                                      color: Colors.white,
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Text('Winnings',
                                                style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    color: textcolor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16)),
                                          )
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              checked5 = !checked5;
                                              if (checked5) {
                                                winning.add('1');
                                              } else {
                                                winning.remove('1');
                                              }
                                            });
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 8),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: checked5
                                                      ? Colors.black
                                                      : Colors.transparent,
                                                  border: Border.all(
                                                      color: checked5
                                                          ? Colors.black
                                                          : Color(0xffe3e3e3))),
                                              child: RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    fontSize: 13.0,
                                                    color: checked5
                                                        ? Colors.white
                                                        : const Color(
                                                            0xff484848),
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  children: [
                                                    WidgetSpan(
                                                      alignment:
                                                          PlaceholderAlignment
                                                              .middle,
                                                      child: Image.asset(
                                                        AppImages.goldcoin,
                                                        width: 14,
                                                        height: 14,
                                                      ),
                                                    ),
                                                    const TextSpan(
                                                        text: '1 to '),
                                                    WidgetSpan(
                                                      alignment:
                                                          PlaceholderAlignment
                                                              .middle,
                                                      child: Image.asset(
                                                        AppImages.goldcoin,
                                                        width: 14,
                                                        height: 14,
                                                      ),
                                                    ),
                                                    const TextSpan(
                                                        text: '1000'),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              checked6 = !checked6;
                                              if (checked6) {
                                                winning.add('2');
                                              } else {
                                                winning.remove('2');
                                              }
                                            });
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 8),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: checked6
                                                      ? Colors.black
                                                      : Colors.transparent,
                                                  border: Border.all(
                                                      color: checked6
                                                          ? Colors.black
                                                          : Color(0xffe3e3e3))),
                                              child: RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    fontSize: 13.0,
                                                    color: checked6
                                                        ? Colors.white
                                                        : const Color(
                                                            0xff484848),
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  children: [
                                                    WidgetSpan(
                                                      alignment:
                                                          PlaceholderAlignment
                                                              .middle,
                                                      child: Image.asset(
                                                        AppImages.goldcoin,
                                                        width: 14,
                                                        height: 14,
                                                      ),
                                                    ),
                                                    const TextSpan(
                                                        text: '1001 to '),
                                                    WidgetSpan(
                                                      alignment:
                                                          PlaceholderAlignment
                                                              .middle,
                                                      child: Image.asset(
                                                        AppImages.goldcoin,
                                                        width: 14,
                                                        height: 14,
                                                      ),
                                                    ),
                                                    const TextSpan(
                                                        text: '50000'),
                                                  ],
                                                ),
                                              )),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              checked7 = !checked7;
                                              if (checked7) {
                                                winning.add('3');
                                              } else {
                                                winning.remove('3');
                                              }
                                            });
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 8),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: checked7
                                                      ? Colors.black
                                                      : Colors.transparent,
                                                  border: Border.all(
                                                      color: checked7
                                                          ? Colors.black
                                                          : Color(0xffe3e3e3))),
                                              child: RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    fontSize: 13.0,
                                                    color: checked6
                                                        ? Colors.white
                                                        : const Color(
                                                            0xff484848),
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  children: [
                                                    WidgetSpan(
                                                      alignment:
                                                          PlaceholderAlignment
                                                              .middle,
                                                      child: Image.asset(
                                                        AppImages.goldcoin,
                                                        width: 14,
                                                        height: 14,
                                                      ),
                                                    ),
                                                    const TextSpan(
                                                        text: '50001 to '),
                                                    WidgetSpan(
                                                      alignment:
                                                          PlaceholderAlignment
                                                              .middle,
                                                      child: Image.asset(
                                                        AppImages.goldcoin,
                                                        width: 14,
                                                        height: 14,
                                                      ),
                                                    ),
                                                    const TextSpan(
                                                        text: '1 Lakh'),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              checked8 = !checked8;
                                              if (checked8) {
                                                winning.add('4');
                                              } else {
                                                winning.remove('4');
                                              }
                                            });
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 8),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: checked8
                                                      ? Colors.black
                                                      : Colors.transparent,
                                                  border: Border.all(
                                                      color: checked8
                                                          ? Colors.black
                                                          : Color(0xffe3e3e3))),
                                              child: RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    fontSize: 13.0,
                                                    color: checked8
                                                        ? Colors.white
                                                        : const Color(
                                                            0xff484848),
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  children: [
                                                    WidgetSpan(
                                                      alignment:
                                                          PlaceholderAlignment
                                                              .middle,
                                                      child: Image.asset(
                                                        AppImages.goldcoin,
                                                        width: 14,
                                                        height: 14,
                                                      ),
                                                    ),
                                                    const TextSpan(
                                                        text: '1 Lakh & more'),
                                                  ],
                                                ),
                                              )),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Divider(
                                        height: 1,
                                        color: Color(0xffe3e3e3),
                                      ),
                                    ),
                                    new Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width,
                                      padding:
                                          EdgeInsets.only(left: 15, right: 10),
                                      color: Colors.white,
                                      child: new Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          new Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: new Text('Contest Type',
                                                style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    color: textcolor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16)),
                                          )
                                        ],
                                      ),
                                    ),
                                    new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              checked9 = !checked9;
                                              if (checked9) {
                                                contest_type.add('1');
                                              } else {
                                                contest_type.remove('1');
                                              }
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 8),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: checked9
                                                    ? Colors.black
                                                    : Colors.transparent,
                                                border: Border.all(
                                                    color: checked9
                                                        ? Colors.black
                                                        : Color(0xffe3e3e3))),
                                            child: Text(
                                              'Multi Entry',
                                              style: new TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 13.0,
                                                  color: checked9
                                                      ? Colors.white
                                                      : Color(0xff484848),
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              checked11 = !checked11;
                                              if (checked11) {
                                                contest_type.add('2');
                                              } else {
                                                contest_type.remove('2');
                                              }
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 8),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: checked11
                                                    ? Colors.black
                                                    : Colors.transparent,
                                                border: Border.all(
                                                    color: checked11
                                                        ? Colors.black
                                                        : Color(0xffe3e3e3))),
                                            child: Text(
                                              'Confirmed',
                                              style: new TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 13.0,
                                                  color: checked11
                                                      ? Colors.white
                                                      : Color(0xff484848),
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              checked30 = !checked30;
                                              if (checked30) {
                                                contest_type.add('4');
                                              } else {
                                                contest_type.remove('4');
                                              }
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 8),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: checked30
                                                    ? Colors.black
                                                    : Colors.transparent,
                                                border: Border.all(
                                                    color: checked30
                                                        ? Colors.black
                                                        : Color(0xffe3e3e3))),
                                            child: Text(
                                              'Flexible',
                                              style: new TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 13.0,
                                                  color: checked30
                                                      ? Colors.white
                                                      : Color(0xff484848),
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ),

                                        // GestureDetector(
                                        //   onTap: () {
                                        //     setState(() {
                                        //       checked10 = !checked10;
                                        //       if (checked10) {
                                        //         contest_type.add('3');
                                        //       } else {
                                        //         contest_type.remove('3');
                                        //       }
                                        //     });
                                        //   },
                                        //   child: Container(
                                        //     padding: EdgeInsets.symmetric(
                                        //         horizontal: 20, vertical: 8),
                                        //     decoration: BoxDecoration(
                                        //         borderRadius: BorderRadius.all(
                                        //             Radius.circular(5)),
                                        //         color: checked10
                                        //             ? Colors.black
                                        //             : Colors.transparent,
                                        //         border: Border.all(
                                        //             color: checked10
                                        //                 ? Colors.black
                                        //                 : Color(0xffe3e3e3))),
                                        //     child: Text(
                                        //       '100% Bonus',
                                        //       style: TextStyle(
                                        //           fontFamily: "Roboto",
                                        //           fontSize: 13.0,
                                        //           color: checked10
                                        //               ? Colors.white
                                        //               : Color(0xff484848),
                                        //           fontWeight:
                                        //               FontWeight.normal),
                                        //     ),
                                        //   ),
                                        // )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // new Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.start,
                                    //   children: <Widget>[
                                    //     // SizedBox(
                                    //     //   width: 15,
                                    //     // ),

                                    //     SizedBox(
                                    //       width: 15,
                                    //     ),
                                    //   ],
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Divider(
                                        height: 1,
                                        color: Color(0xffe3e3e3),
                                      ),
                                    ),
                                    new Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width,
                                      padding:
                                          EdgeInsets.only(left: 15, right: 10),
                                      color: Colors.white,
                                      child: new Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          new Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: new Text('Contest Size',
                                                style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16)),
                                          )
                                        ],
                                      ),
                                    ),
                                    new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              checked12 = !checked12;
                                              if (checked12) {
                                                contest_size.add('1');
                                              } else {
                                                contest_size.remove('1');
                                              }
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 8),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: checked12
                                                    ? Colors.black
                                                    : Colors.transparent,
                                                border: Border.all(
                                                    color: checked12
                                                        ? Colors.black
                                                        : Color(0xffe3e3e3))),
                                            child: Text(
                                              '2',
                                              style: new TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 13.0,
                                                  color: checked12
                                                      ? Colors.white
                                                      : Color(0xff484848),
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              checked13 = !checked13;
                                              if (checked13) {
                                                contest_size.add('2');
                                              } else {
                                                contest_size.remove('2');
                                              }
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 8),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: checked13
                                                    ? Colors.black
                                                    : Colors.transparent,
                                                border: Border.all(
                                                    color: checked13
                                                        ? Colors.black
                                                        : Color(0xffe3e3e3))),
                                            child: Text(
                                              '3',
                                              style: new TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 13.0,
                                                  color: checked13
                                                      ? Colors.white
                                                      : Color(0xff484848),
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              checked14 = !checked14;
                                              if (checked14) {
                                                contest_size.add('3');
                                              } else {
                                                contest_size.remove('3');
                                              }
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 8),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: checked14
                                                    ? Colors.black
                                                    : Colors.transparent,
                                                border: Border.all(
                                                    color: checked14
                                                        ? Colors.black
                                                        : Color(0xffe3e3e3))),
                                            child: Text(
                                              '4',
                                              style: new TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 13.0,
                                                  color: checked14
                                                      ? Colors.white
                                                      : Color(0xff484848),
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              checked15 = !checked15;
                                              if (checked15) {
                                                contest_size.add('4');
                                              } else {
                                                contest_size.remove('4');
                                              }
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 8),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: checked15
                                                    ? Colors.black
                                                    : Colors.transparent,
                                                border: Border.all(
                                                    color: checked15
                                                        ? Colors.black
                                                        : Color(0xffe3e3e3))),
                                            child: Text(
                                              '5 to 10',
                                              style: new TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 13.0,
                                                  color: checked15
                                                      ? Colors.white
                                                      : Color(0xff484848),
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // new Row(
                                    //   mainAxisAlignment: MainAxisAlignment.start,
                                    //   children: <Widget>[
                                    //     SizedBox(
                                    //       width: 15,
                                    //     ),
                                    //     GestureDetector(
                                    //       onTap: () {
                                    //         setState(() {
                                    //           checked14 = !checked14;
                                    //           if (checked14) {
                                    //             contest_size.add('3');
                                    //           } else {
                                    //             contest_size.remove('3');
                                    //           }
                                    //         });
                                    //       },
                                    //       child: Container(
                                    //         padding: EdgeInsets.symmetric(
                                    //             horizontal: 20, vertical: 8),
                                    //         decoration: BoxDecoration(
                                    //             borderRadius: BorderRadius.all(
                                    //                 Radius.circular(5)),
                                    //             color: checked14
                                    //                 ? Colors.black
                                    //                 : Colors.transparent,
                                    //             border: Border.all(
                                    //                 color: checked14
                                    //                     ? Colors.black
                                    //                     : Color(0xffe3e3e3))),
                                    //         child: Text(
                                    //           '4',
                                    //           style: new TextStyle(
                                    //               fontFamily: "Roboto",
                                    //               fontSize: 13.0,
                                    //               color: checked14
                                    //                   ? Colors.white
                                    //                   : Color(0xff484848),
                                    //               fontWeight: FontWeight.w400),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     SizedBox(
                                    //       width: 15,
                                    //     ),
                                    //     GestureDetector(
                                    //       onTap: () {
                                    //         setState(() {
                                    //           checked15 = !checked15;
                                    //           if (checked15) {
                                    //             contest_size.add('4');
                                    //           } else {
                                    //             contest_size.remove('4');
                                    //           }
                                    //         });
                                    //       },
                                    //       child: Container(
                                    //         padding: EdgeInsets.symmetric(
                                    //             horizontal: 20, vertical: 8),
                                    //         decoration: BoxDecoration(
                                    //             borderRadius: BorderRadius.all(
                                    //                 Radius.circular(5)),
                                    //             color: checked15
                                    //                 ? Colors.black
                                    //                 : Colors.transparent,
                                    //             border: Border.all(
                                    //                 color: checked15
                                    //                     ? Colors.black
                                    //                     : Color(0xffe3e3e3))),
                                    //         child: Text(
                                    //           '5 to 10',
                                    //           style: new TextStyle(
                                    //               fontFamily: "Roboto",
                                    //               fontSize: 13.0,
                                    //               color: checked15
                                    //                   ? Colors.white
                                    //                   : Color(0xff484848),
                                    //               fontWeight: FontWeight.w400),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              checked16 = !checked16;
                                              if (checked16) {
                                                contest_size.add('5');
                                              } else {
                                                contest_size.remove('5');
                                              }
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 8),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: checked16
                                                    ? Colors.black
                                                    : Colors.transparent,
                                                border: Border.all(
                                                    color: checked16
                                                        ? Colors.black
                                                        : Color(0xffe3e3e3))),
                                            child: Text(
                                              '11 to 20',
                                              style: new TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 13.0,
                                                  color: checked16
                                                      ? Colors.white
                                                      : Color(0xff484848),
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              checked17 = !checked17;
                                              if (checked17) {
                                                contest_size.add('6');
                                              } else {
                                                contest_size.remove('6');
                                              }
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 8),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: checked17
                                                    ? Colors.black
                                                    : Colors.transparent,
                                                border: Border.all(
                                                    color: checked17
                                                        ? Colors.black
                                                        : Color(0xffe3e3e3))),
                                            child: Text(
                                              '21 to 200',
                                              style: new TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 13.0,
                                                  color: checked17
                                                      ? Colors.white
                                                      : Color(0xff484848),
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              checked18 = !checked18;
                                              if (checked18) {
                                                contest_size.add('7');
                                              } else {
                                                contest_size.remove('7');
                                              }
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 8),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: checked18
                                                    ? Colors.black
                                                    : Colors.transparent,
                                                border: Border.all(
                                                    color: checked18
                                                        ? Colors.black
                                                        : Color(0xffe3e3e3))),
                                            child: Text(
                                              '101 to 1000',
                                              style: new TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 13.0,
                                                  color: checked18
                                                      ? Colors.white
                                                      : Color(0xff484848),
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              checked19 = !checked19;
                                              if (checked19) {
                                                contest_size.add('8');
                                              } else {
                                                contest_size.remove('8');
                                              }
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 8),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: checked19
                                                    ? Colors.black
                                                    : Colors.transparent,
                                                border: Border.all(
                                                    color: checked19
                                                        ? Colors.black
                                                        : Color(0xffe3e3e3))),
                                            child: Text(
                                              '1001 to 10000',
                                              style: new TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 13.0,
                                                  color: checked19
                                                      ? Colors.white
                                                      : Color(0xff484848),
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 60,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: new Row(
                          children: [
                            // new Flexible(
                            //   child: DefaultButton(
                            //     height: 40,
                            //     width:
                            //     MediaQuery.of(context).size.width,
                            //     color: primaryColor,
                            //     text: "Clear all filters",
                            //     margin: EdgeInsets.only(
                            //         left: 20, right: 10),
                            //     textcolor: Colors.white,
                            //     borderRadius: 3,
                            //     onpress: () {
                            //       setState(() {
                            //      //   AppConstants.isFilter = false;
                            //         checked1 = false;
                            //         checked2 = false;
                            //         checked3 = false;
                            //         checked4 = false;
                            //         checked5 = false;
                            //         checked6 = false;
                            //         checked7 = false;
                            //         checked8 = false;
                            //         checked9 = false;
                            //         checked10 = false;
                            //         checked11 = false;
                            //         checked12 = false;
                            //         checked13 = false;
                            //         checked14 = false;
                            //         checked15 = false;
                            //         checked16 = false;
                            //         checked17 = false;
                            //         entryFee.clear();
                            //         winning.clear();
                            //         contest_size.clear();
                            //         contest_type.clear();
                            //       });
                            //    /*   if (widget.model.categoryId ==
                            //           111) {
                            //         getAllContest();
                            //       } else {
                            //         getAllContestByCategoryId();
                            //       }*/
                            //     },
                            //   ),
                            //
                            //   // new Container(
                            //   //     width: MediaQuery.of(context).size.width,
                            //   //     height: 40,
                            //   //     margin:
                            //   //     child: RaisedButton(
                            //   //       textColor: Colors.white,
                            //   //       elevation: .5,
                            //   //       color: primaryColor,
                            //   //       child: Text(
                            //   //         '',
                            //   //         style: TextStyle(fontFamily: "Roboto",
                            //   //             fontSize: 14, color: Colors.white),
                            //   //       ),
                            //   //       shape: RoundedRectangleBorder(
                            //   //           borderRadius: BorderRadius.circular(3)),
                            //   //       onPressed: () {
                            //   //
                            //   //       },
                            //   //     )),
                            //
                            //   flex: 1,
                            // ),
                            new Flexible(
                              child: DefaultButton(
                                height: 45,
                                width: MediaQuery.of(context).size.width,
                                color: primaryColor,
                                text: "Apply Now",
                                margin: EdgeInsets.only(left: 15, right: 15),
                                textcolor: Colors.white,
                                borderRadius: 10,
                                onpress: () {
                                  setState(() {
                                    AppConstants.isFilter = false;
                                    pageNumber = 0;
                                    contestList.clear();
                                  });
                                  isWinnings = 0;
                                  isTeam = 0;
                                  isEntry = 0;
                                  isWinner = 0;
                                  // if (widget.model.categoryId == 111) {
                                  getAllContest(false);
                                  // }
                                  // else {
                                  //   getAllContestByCategoryId(false);
                                  // }
                                },
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            })
        : new Container();
  }
}
