import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myrex11/buildType/buildType.dart';
import 'package:myrex11/adapter/TeamItemAdapter.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/dataModels/JoinChallengeDataModel.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/base_response.dart';
import 'package:myrex11/repository/model/contest_request.dart';
import 'package:myrex11/repository/model/team_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';
import 'package:myrex11/views/CreateTeam.dart';

class MyJoinTeams extends StatefulWidget {
  int currentContestIndex;
  GeneralModel model;
  dynamic contest;
  Function onJoinContestResult;
  int? contestNumber;
  double? scrollPosition;
  int? joinSimilar;

  MyJoinTeams(this.currentContestIndex, this.model, this.contest,
      this.onJoinContestResult,
      {this.contestNumber, this.scrollPosition, this.joinSimilar});

  @override
  _MyJoinTeamsState createState() => new _MyJoinTeamsState();
}

// ValueNotifier<bool> allSelect = ValueNotifier(false);
bool allSelect = false;

class _MyJoinTeamsState extends State<MyJoinTeams> {
  String userId = '0';
  bool showSelectAll = false;
  List<Team> teamsList = [];
  int joinedCount = 0;
  int teamCount = 0;
  int teamId = 0;
  int selectedTeamCount = 0;
  int joinedContestCount = 0;
  bool isSwitchTeam = false;
  bool isAllSelected = false;
  bool myCountSelected = false;
  @override
  void initState() {
    super.initState();

    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
        .then((value) => {
              setState(() {
                userId = value;
                myCountSelected = true;
                getMyTeams();
              })
            });
    isSwitchTeam = widget.model.isSwitchTeam ?? false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        child: SafeArea(
          top: false,
          child: Scaffold(
            backgroundColor: bgColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(55), // Set this height
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: primaryColor,
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //     image: AssetImage("assets/images/ic_black.png"),
                //     fit: BoxFit.cover,
                //   ),
                // ),
                //  padding: !Platform.isAndroid ? EdgeInsets.zero : EdgeInsets.zero,
                padding: EdgeInsets.only(top: 28),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    new GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => {
                        setState(() {
                          allSelect = false;
                        }),
                        Navigator.pop(context)
                      },
                      child: new Container(
                        padding: EdgeInsets.only(left: 15, right: 10),
                        alignment: Alignment.centerLeft,
                        child: new Container(
                          height: 24,
                          child: Image(
                            image: AssetImage(AppImages.backImageURL),
                            // fit: BoxFit.fill,
                            // color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    new Container(
                        child:
                            (widget.contest.multi_entry == 1 && !isSwitchTeam) ||
                                    showSelectAll
                                ? Text('Select Your Team',
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18))
                                : Text('My Teams',
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18))),
                  ],
                ),
              ),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    children: [
                      (widget.contest.multi_entry == 1 && !isSwitchTeam) ||
                              showSelectAll
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  // Divider(
                                  //   thickness: 0,
                                  //   color: Colors.grey,
                                  // ),
                                  Container(
                                    padding: EdgeInsets.only(left: 10, top: 10),
                                    // alignment: Alignment.centerLeft,
                                    child: Center(
                                      child: Text(
                                          "You can enter upto " +
                                              widget.contest.max_multi_entry_user
                                                  .toString() +
                                              " teams in this contest",
                                          style: TextStyle(
                                              fontFamily: 'robot',
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14)),
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0,
                                    color: Colors.grey,
                                  ),
                                  /*getIsJoinedTeam(teamsList) ?*/ Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        new Container(
                                          child: new Text(
                                              'Select All (' +
                                                  getTotalSelectedWithJoined()
                                                      .toString() +
                                                  ')',
                                              style: TextStyle(
                                                  fontFamily: 'robot',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14)),
                                        ),
                                        new GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            setState(() {
                                              if (allSelect) {
                                                allSelect = false;
                                              } else {
                                                allSelect = true;
                                              }
                                              myCountSelected = false;
                                              selectAll();
                                            });
                                          },
                                          child: new Container(
                                            padding: EdgeInsets.all(8),
                                            alignment: Alignment.centerLeft,
                                            child: new Container(
                                              child: Image(
                                                width: 22,
                                                height: 22,
                                                image: AssetImage(
                                                    getTeamList(teamsList) ||
                                                            allSelect
                                                        ? AppImages.checkTeamIcon
                                                        : AppImages
                                                            .uncheckTeamIcon),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ) /*: SizedBox.shrink()*/, //Row
                                ],
                              ),
                            )
                          : Container(),
                      Expanded(
                          child: Container(
                        height: MediaQuery.of(context).size.height,
                        padding: EdgeInsets.only(
                            bottom: (widget.contest.multi_entry == 1 &&
                                    !isSwitchTeam &&
                                    widget.contest.is_join_similar_contest != 1)
                                ? 80
                                : 65,
                            top: 8,
                            left: 8,
                            right: 8),
                        child: new ListView.builder(
                            //key: UniqueKey(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: teamsList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return new TeamItemAdapter(
                                widget.model,
                                teamsList[index],
                                true,
                                index,
                                onTeamCreated: onTeamCreated,
                              );
                            }),
                      ))
                    ],
                  ),
                  // widget.contest.multi_entry==1 && !isSwitchTeam?new Container(
                  //   height: 80,
                  //   padding: EdgeInsets.all(10),
                  //   color: Colors.white,
                  //   child: new Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       new Container(
                  //         margin: EdgeInsets.only(left: 10,top: 5),
                  //         child: new Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             new Container(
                  //               child: new Text('No. of Teams',
                  //                   style: TextStyle(
                  //                       fontFamily: 'robot',
                  //                       color: Colors.grey,
                  //                       fontWeight: FontWeight.w400,
                  //                       fontSize: 12)),
                  //             ),
                  //             new Container(
                  //               child: new Text(selectedTeamCount.toString(),
                  //                   style: TextStyle(
                  //                       fontFamily: 'robot',
                  //                       color: Colors.black,
                  //                       fontWeight: FontWeight.w400,
                  //                       fontSize: 18)),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       new Container(
                  //         child: new Row(
                  //           children: [
                  //             new Container(
                  //                 width:100,
                  //                 height: 45,
                  //                 margin: EdgeInsets.only(left: 5),
                  //                 child: RaisedButton(
                  //                   textColor: Colors.white,
                  //                   elevation: .5,
                  //                   color: primaryColor,
                  //                   child: Text(
                  //                     'JOIN',
                  //                     style: TextStyle(fontSize: 14,color: Colors.white),
                  //                   ),
                  //                   shape: RoundedRectangleBorder(
                  //                       borderRadius:
                  //                       BorderRadius.circular(3)),
                  //                   onPressed: () {
                  //                     joinContest();
                  //                   },
                  //                 )
                  //             ),
                  //             new Container(
                  //                 margin: EdgeInsets.only(left: 10),
                  //                 child: new GestureDetector(
                  //                   behavior: HitTestBehavior.translucent,
                  //                   child: new Container(
                  //                     child: new ClipRRect(
                  //                       borderRadius: BorderRadius.all(Radius.circular(28)),
                  //                       child: new Container(
                  //                         color: primaryColor,
                  //                         height: 56,
                  //                         width: 56,
                  //                         padding: EdgeInsets.all(10),
                  //                         child: Image(
                  //                           image: AssetImage(AppImages.createTeamIcon),color: Colors.white,),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   onTap: (){
                  //                     widget.model.onTeamCreated=onTeamCreated;
                  //                     widget.model.teamId=0;
                  //                     navigateToCreateTeam(context,widget.model);
                  //                   },
                  //                 )
                  //             )
                  //           ],
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ):
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: new Container(
                      padding: EdgeInsets.all(13),
                      child: new Row(
                        children: [
                          new Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  widget.model.onTeamCreated = onTeamCreated;
                                  widget.model.teamId = 0;
                                  selectedTeamCount = 0;

                                  allSelect = false;
                                  teamId = 0;

                                  myCountSelected = true;
                                  Platform.isAndroid
                                      ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreateTeam(widget.model)))
                                          .then((value) {
                                          onTeamCreated();
                                          // setState(() {
                                          //   Future.delayed(
                                          //       Duration(milliseconds: 400),
                                          //       () {
                                          //     // allSelect = false;
                                          //     // selectAll();
                                          //   });
                                          // });
                                        })
                                      : Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      CreateTeam(widget.model)))
                                          .then((value) {
                                          onTeamCreated();
                                        });

                                  // navigateToCreateTeam(context, widget.model);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      border: Border.all(
                                        color: primaryColor,
                                      )),
                                  child: Center(
                                    child: Text(
                                      'Create Team ' +
                                          (teamsList.length + 1).toString(),
                                      style: TextStyle(color: primaryColor),
                                    ),
                                  ),
                                  height: 45,
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(right: 5),
                                  // borderRadius: 3,
                                  // text: 'Create Team (' +
                                  //     (teamsList.length + 1).toString() +
                                  //     ')',
                                ),
                              ),
                              flex: 1),

                          //  Container(
                          //     width:
                          //     MediaQuery.of(context).size.width,
                          //     height: 45,
                          //     margin: EdgeInsets.only(right: 5),
                          //     child: RaisedButton(
                          //       textColor: Colors.white,
                          //       elevation: .5,
                          //       color: Colors.black,
                          //       child: Text(
                          //         'Create Team ('+(teamsList.length+1).toString()+')',
                          //         style: TextStyle(fontSize: 14,color: Colors.white),
                          //       ),
                          //       shape: RoundedRectangleBorder(
                          //           borderRadius:
                          //           BorderRadius.circular(3)),
                          //       onPressed: () {
                          //         widget.model.onTeamCreated=onTeamCreated;
                          //         widget.model.teamId=0;
                          //         navigateToCreateTeam(context,widget.model);
                          //       },
                          //     )),flex: 1,),

                          new Flexible(
                            child: GestureDetector(
                              onTap: () {
                                if (widget.contest.max_multi_entry_user! <
                                        selectedTeamCount &&
                                    widget.contest.multi_entry == 1) {
                                  Fluttertoast.showToast(
                                      msg: "You can enter with max " +
                                          widget.contest.max_multi_entry_user!
                                              .toString() +
                                          " teams");
                                } else {
                                  joinContest();
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Center(
                                  child: Text(
                                    "Join Contest",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                height: 45,
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(left: 5),
                              ),
                            ),
                            flex: 1,
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
        onWillPop: _onWillPop);
  }

  Future<bool> _onWillPop() async {
    setState(() {
      widget.model.isSwitchTeam = false;
      allSelect = false;
      Navigator.pop(context);
    });
    return Future.value(false);
  }

  void getMyTeams() async {
    setState(() {
      joinedCount = 0;
    });

    var fantacyId = CricketTypeFantasy.getCricketType(
        widget.model.fantasyType.toString(),
        sportsKey: widget.model.sportKey);
    AppLoaderProgress.showLoader(context);
    ContestRequest contestRequest = ContestRequest(
        user_id: userId,
        matchkey: widget.model.matchKey,
        sport_key: widget.model.sportKey,
        fantasy_type: widget.model.fantasyType.toString(),
        slotes_id: widget.model.slotId.toString(),
        fantasy_type_id: fantacyId,
        challenge_id: widget.contest.id.toString());
    final client = ApiClient(AppRepository.dio);
    MyTeamResponse response = await client.getMyTeams(contestRequest);
    if (response.status == 1) {
      teamsList = response.result!.teams!;
      teamCount = response.result!.user_teams!;
      joinedContestCount = response.result!.joined_leagues!;
      if (widget.contest.multi_entry == 1 && !isSwitchTeam) {
        for (int i = 0; i < teamsList.length; i++) {
          if (teamsList[i].is_joined == 1) {
            joinedCount++;
          }
        }
        int remainingCount = teamCount - joinedCount;
        showSelectAll = true;
        if (remainingCount <=
            (widget.contest.max_multi_entry_user! - joinedCount)) {
          allSelect = false;
        } else {
          showSelectAll = false;
        }
      } else {
        showSelectAll = false;
      }
    }
    widget.model.teamClickListener = teamClickListener;

    setState(() {
      AppLoaderProgress.hideLoader(context);
    });
  }

  void switchTeam() async {
    AppLoaderProgress.showLoader(context);
    ContestRequest contestRequest = new ContestRequest(
        userid: userId,
        matchkey: widget.model.matchKey,
        sport_key: widget.model.sportKey,
        teamid: getMultiTeamId().toString(),
        joinid: widget.model.joinedSwitchTeamId.toString(),
        challenge_id: widget.contest.id.toString());
    final client = ApiClient(AppRepository.dio);
    GeneralResponse response = await client.switchTeam(contestRequest);
    Navigator.pop(context);
    AppLoaderProgress.hideLoader(context);
    Fluttertoast.showToast(
        msg: response.message!,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1);
    if (widget.model.onSwitchTeamResult != null) {
      widget.model.onSwitchTeamResult!();
    }
  }

  void selectAll() {
    selectedTeamCount = 0;
    for (int i = 0; i < teamsList.length; i++) {
      teamsList[i].isSelected = false;
      if (teamsList[i].is_joined != 1) {
        if (allSelect) {
          teamsList[i].isSelected = true;
          selectedTeamCount++;
        }
      }
    }
    setState(() {});
  }

  int getTotalSelectedWithJoined() {
    int selectedTeamCount = 0;

    for (int i = 0; i < teamsList.length; i++) {
      if (teamsList[i].isSelected ?? false || teamsList[i].is_joined == 1) {
        selectedTeamCount++;
      }
    }

    return myCountSelected == false
        ? selectedTeamCount
        : selectedTeamCount - joinedCount;
  }

  int getTotalSelected() {
    int selectedTeamCount = 0;
    for (int i = 0; i < teamsList.length; i++) {
      if (teamsList[i].isSelected ?? false) {
        selectedTeamCount++;
      }
    }
    return selectedTeamCount;
  }

  String getMultiTeamId() {
    StringBuffer stringBuilder = new StringBuffer();
    if (teamsList.length == 1 &&
        teamsList[0].is_joined != 1 &&
        widget.contest.multi_entry == 0 &&
        !isSwitchTeam) {
      stringBuilder.write(teamsList[0].teamid);
    } else if (isSwitchTeam || widget.contest.multi_entry == 0) {
      if (teamId != 0) {
        stringBuilder.write(teamId);
      }
    } else if (widget.contest.multi_entry == 1) {
      for (int i = 0; i < teamsList.length; i++) {
        if (teamsList[i].isSelected ?? false) {
          stringBuilder.write(teamsList[i].teamid);
          stringBuilder.write(",");
        }
      }
    }
    return stringBuilder.toString().trim();
  }

  void teamClickListener(int position) {
    for (Player player in teamsList[position].players ?? []) {
      int? playerid = player.id;
    }
    if (teamsList[position].is_joined != 1) {
      if (isSwitchTeam || widget.contest.multi_entry == 0) {
        for (int i = 0; i < teamsList.length; i++) {
          teamsList[i].isSelected = false;
        }
        teamId = teamsList[position].teamid!;
        teamsList[position].isSelected = true;
        selectedTeamCount = 1;

        // ((MyTeamsActivity) context).mBinding.btnJoinContest.setBackgroundColor(context.getResources().getColor(R.color.colorPrimary));
      } else {
        if (teamsList[position].isSelected ?? false) {
          teamsList[position].isSelected = false;
          selectedTeamCount--;
          if (selectedTeamCount < teamsList.length) {
            setState(() {
              allSelect = false;
            });
          }
          // ((MyTeamsActivity) context).mBinding.btnJoinContest.setBackgroundColor(context.getResources().getColor(R.color.colorPrimary));
        } else if (!(teamsList[position].isSelected ?? false) &&
            widget.contest.max_multi_entry_user !=
                selectedTeamCount + joinedCount) {
          teamsList[position].isSelected = true;
          selectedTeamCount++;

          if (selectedTeamCount == teamsList.length - joinedCount) {
            setState(() {
              allSelect = true;
            });
          }
          // ((MyTeamsActivity) context).mBinding.btnJoinContest.setBackgroundColor(context.getResources().getColor(R.color.colorPrimary));
        } else
          MethodUtils.showError(
              context,
              "You can only enter with upto " +
                  widget.contest.max_multi_entry_user.toString() +
                  " teams");
      }
      setState(() {});
    }
  }

  // void teamClickListener(int position) {
  //   if (teamsList[position].is_joined != 1) {
  //     if (isSwitchTeam ||
  //         widget.contest.multi_entry == 0 ||
  //         widget.contest.is_join_similar_contest == 1) {
  //       for (int i = 0; i < teamsList.length; i++) {
  //         teamsList[i].isSelected = false;
  //       }
  //       teamId = teamsList[position].teamid!;
  //       teamsList[position].isSelected = true;
  //       selectedTeamCount = 1;
  //       // ((MyTeamsActivity) context).mBinding.btnJoinContest.setBackgroundColor(context.getResources().getColor(R.color.colorPrimary));
  //     } else {
  //       if (teamsList[position].isSelected ?? false) {
  //         teamsList[position].isSelected = false;
  //         selectedTeamCount--;
  //         // ((MyTeamsActivity) context).mBinding.btnJoinContest.setBackgroundColor(context.getResources().getColor(R.color.colorPrimary));
  //       } else if (!(teamsList[position].isSelected ?? false) &&
  //           widget.contest.max_multi_entry_user !=
  //               selectedTeamCount + joinedCount) {
  //         teamsList[position].isSelected = true;
  //         selectedTeamCount++;
  //         teamsList.forEach((element) {
  //           if (element.isSelected == false) {}
  //         });
  //         // ((MyTeamsActivity) context).mBinding.btnJoinContest.setBackgroundColor(context.getResources().getColor(R.color.colorPrimary));
  //       } else
  //         MethodUtils.showError(
  //             context,
  //             "You can only enter with upto " +
  //                 widget.contest.max_multi_entry_user.toString() +
  //                 " teams");
  //     }
  //     setState(() {});
  //   }
  // }

  void joinContest() {
    if (getMultiTeamId().length != 0) {
      if (isSwitchTeam) {
        switchTeam();
      } else {
        // Add null checks for required fields
        if (widget.model.fantasyType == null) {
          MethodUtils.showError(context, "Fantasy type is not available");
          return;
        }
        if (widget.model.matchKey == null) {
          MethodUtils.showError(context, "Match key is not available");
          return;
        }
        if (widget.model.sportKey == null) {
          MethodUtils.showError(context, "Sport key is not available");
          return;
        }
        if (widget.contest.id == null) {
          MethodUtils.showError(context, "Contest ID is not available");
          return;
        }
        
        MethodUtils.checkBalance(
            widget.currentContestIndex,
            new JoinChallengeDataModel(
                context,
                0,
                int.parse(userId),
                widget.contest.id!,
                widget.model.fantasyType!,
                //  widget.model.slotId!,
                getTotalSelected(),
                widget.contest.is_bonus ?? false,
                widget.contest.win_amount ?? 0,
                widget.contest.maximum_user ?? 0,
                getMultiTeamId(),
                widget.contest.entryfee?.toString() ?? "0",
                widget.model.matchKey!,
                widget.model.sportKey!,
                widget.model.joinedSwitchTeamId?.toString() ?? "0",
                isSwitchTeam,
                0,
                0,
                onJoinContestResult,
                widget.contest!,
                bonusPercentage: widget.contest.bonus_percent),
            joinSimilar: widget.joinSimilar,
            contestNumber: widget.contestNumber ?? 0,
            scrollPosition: widget.scrollPosition);
      }
    } else {
      MethodUtils.showError(
          context, "Please select at least one team to join contest");
    }
  }

  void onJoinContestResult(int isJoined, String referCode) {
    if (isJoined == 1) {
      widget.onJoinContestResult(isJoined, referCode);
      Navigator.of(context).pop();
    }
  }

  void onTeamCreated() {
    getMyTeams();
  }

  bool getIsJoinedTeam(List<Team> teamsList) {
    bool allTeamAlreadyJoin = false;
    teamsList.forEach((element) {
      if (element.is_joined == 1) {
        allTeamAlreadyJoin = true;
      }
    });
    return allTeamAlreadyJoin;
  }

  bool getTeamList(List<Team> teamsList) {
    isAllSelected = true;

    for (var item in teamsList) {
      if (item.isSelected == null || item.isSelected == false) {
        isAllSelected = false;
        break;
      }
    }

    return isAllSelected;
  }
}
