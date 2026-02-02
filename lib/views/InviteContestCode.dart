import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myrex11/adapter/ContestItemAdapter.dart';
import 'package:myrex11/adapter/TeamItemAdapter.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/app_navigator.dart';
import 'package:myrex11/appUtilities/defaultbutton.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/customWidgets/CustomProgressIndicator.dart';
import 'package:myrex11/customWidgets/MatchHeader.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/dataModels/JoinChallengeDataModel.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/category_contest_response.dart';
import 'package:myrex11/repository/model/join_contest_by_code_request.dart';
import 'package:myrex11/repository/model/join_contest_by_code_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';

class InviteContestCode extends StatefulWidget {
  GeneralModel model;
  int currentContestIndex;
  Function? onTeamCreated;
  InviteContestCode(this.currentContestIndex, this.model, {this.onTeamCreated});
  @override
  _InviteContestCodeState createState() => new _InviteContestCodeState();
}

class _InviteContestCodeState extends State<InviteContestCode> {
  TextEditingController codeController = TextEditingController();
  bool _enable = false;
  String userId = '0';
  Contest contest = Contest();

  @override
  void initState() {
    super.initState();
    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
        .then((value) => {
              setState(() {
                userId = value;
              })
            });
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
                Brightness.light) /* set Status bar icon color in iOS. */
        );

    return WillPopScope(
      child: Container(
        color: primaryColor,
        child: new Scaffold(
          backgroundColor: Colors.white,
          /*  appBar: PreferredSize(
            preferredSize: Size.fromHeight(55), // Set this height
            child: Container(
             // padding: EdgeInsets.only(top: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  new GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => {Navigator.pop(context)},
                    child: new Container(
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.centerLeft,
                      child: new Container(
                        width: 16,
                        height: 16,
                        child: Image(
                          image: AssetImage(AppImages.backImageURL),
                          fit: BoxFit.fill,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  new Container(
                    child: new Text('Invite Contest Code',
                        style: TextStyle(
                            fontFamily: "Roboto",
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),*/

          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60), // Set this height
            child: Container(
              padding: EdgeInsets.only(
                top: 45,
                bottom: 14,
                left: 16,
              ),
              decoration: BoxDecoration(color: primaryColor
                  // image: DecorationImage(image: AssetImage("assets/images/Ic_creatTeamBackGround.png"),fit: BoxFit.cover)
                  ),
              child: Row(
                children: [
                  AppConstants.backButtonFunction(),
                  Text("Invite Contest Code",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16)),
                ],
              ),
            ),
          ),
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                child: new SingleChildScrollView(
                  child: new Container(
                    child: new Column(
                      children: [
                        new Container(
                          padding: EdgeInsets.only(top: 50),
                          alignment: Alignment.center,
                          child: Text(
                            'Contest Code',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 20,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        new Container(
                          padding: EdgeInsets.only(top: 10, bottom: 20),
                          alignment: Alignment.center,
                          child: Text(
                            'Enter the invitation code you received.',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 14,
                              color: Colors.grey,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        new Container(
                          margin: EdgeInsets.all(10),
                          child: new Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              new Container(
                                height: 45,
                                child: TextField(
                                  controller: codeController,
                                  decoration: InputDecoration(
                                    counterText: "",
                                    filled: true,
                                    hintStyle: TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    hintText: 'Enter Contest Code',
                                    fillColor: Colors.white,
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Color(0xFFEDE2FE), width: 1),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                          color: Color(0xFFEDE2FE), width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                          color: Color(0xFFEDE2FE), width: 1),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (codeController.text.isEmpty)
                              MethodUtils.showError(
                                  context, "Please enter contest code.");
                            else {
                              FocusScope.of(context).unfocus();
                              joinContestByCode();
                            }
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.only(
                                left: 12, right: 12, top: 20, bottom: 0),
                            decoration: BoxDecoration(
                              color: buttonGreenColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              border: Border.all(
                                color: Color(0xFF6A0BF8),
                                width: 2,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 20),
                              child: Center(
                                child: Text(
                                  "Join This Contest",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: AppConstants.textBold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: () {
        Navigator.pop(context);
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: primaryColor,
                /* set Status bar color in Android devices. */
                statusBarIconBrightness: Brightness.light,
                /* set Status bar icons color in Android devices.*/
                statusBarBrightness:
                    Brightness.dark) /* set Status bar icon color in iOS. */
            );
        return Future.value(false);
      },
    );
  }

  void joinContestByCode() async {
    AppLoaderProgress.showLoader(context);
    JoinContestByCodeRequest contestRequest = JoinContestByCodeRequest(
        user_id: userId,
        matchkey: widget.model.matchKey,
        sport_key: widget.model.sportKey,
        fantasy_type: widget.model.fantasyType.toString(),
        slotes_id: widget.model.slotId.toString(),
        getcode: codeController.text.toString());
    final client = ApiClient(AppRepository.dio);
    JoinContestByCodeResponse response =
        await client.joinByContestCode(contestRequest);
    setState(() {
      AppLoaderProgress.hideLoader(context);
    });
    if (response.status == 1) {
      if (response.result![0].message == 'Challenge opened') {
        Contest contest = response.result![0].contest!;
        if (widget.model.teamCount == 1) {
          print("team count if ${widget.model.teamCount}");
          MethodUtils.checkBalance(
              widget.currentContestIndex,
              new JoinChallengeDataModel(
                  context,
                  0,
                  int.parse(userId),
                  contest.id!,
                  widget.model.fantasyType!,
                  // widget.model.slotId!,
                  1,
                  contest.is_bonus!,
                  contest.win_amount!,
                  contest.maximum_user!,
                  widget.model.teamId.toString(),
                  contest.entryfee.toString(),
                  contest.matchkey!,
                  widget.model.sportKey!,
                  widget.model.joinedSwitchTeamId.toString(),
                  false,
                  0,
                  0,
                  onJoinContestResult,
                  contest,
                  bonusPercentage: contest.bonus_percent));
        } else if (widget.model.teamCount! > 0) {
          print("team count else if ${widget.model.teamCount}");
          navigateToMyJoinTeams(widget.currentContestIndex, context,
              widget.model, contest, onJoinContestResult);
        } else {
          widget.model.onJoinContestResult = onJoinContestResult;
          widget.model.contest = contest;
          widget.model.teamId = 0;

          navigateToCreateTeam(context, widget.model,
              onTeamCreated: widget.onTeamCreated);
        }
      } else if (response.result![0].message == 'Already used') {
        MethodUtils.showError(context, "Invite code already used.");
      } else if (response.result![0].message == 'Challenge closed') {
        MethodUtils.showError(
            context, "Sorry, this League is full! Please join another League.");
      } else if (response.result![0].message == 'invalid code') {
        MethodUtils.showError(context, "Invalid code.");
      } else {
        MethodUtils.showError(context, response.result![0].message);
      }
    } else {
      MethodUtils.showError(context, response.message);
    }
  }

  void onJoinContestResult(int isJoined, String referCode) {
    if (isJoined == 1) {
      // Navigator.pop(context);
      widget.model.onJoinContestResult!(isJoined, referCode);
    }
  }
}
