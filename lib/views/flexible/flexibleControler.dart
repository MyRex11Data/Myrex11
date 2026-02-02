import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_navigator.dart';
import 'package:myrex11/buildType/buildType.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/base_request.dart';
import 'package:myrex11/repository/model/base_response.dart';
import 'package:myrex11/repository/model/category_contest_response.dart';
import 'package:myrex11/repository/model/contest_details_response.dart';
import 'package:myrex11/repository/model/contest_request.dart';
import 'package:myrex11/repository/model/flexible_data_response.dart';
import 'package:myrex11/repository/model/score_card_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';
import 'package:myrex11/views/UpcomingContests.dart';
import 'package:get/get.dart';

class FlexibleController extends GetxController {
  String userId;
  String matchKey;
  String challenge_id;
  var isLoading = false.obs;
  var isLoadingFi = false.obs;
  var dataModel = Result().obs;
  var currentMatchIndex = 0.obs;
  var clickIndex = 0.obs;
  var currentContestMatchIndex = 0.obs;
  List<WinnerScoreCardItem> breakupList = [];
  List<JoinedContestTeam> leaderboardList = [];
  GeneralModel model;
  Contest? contest;
  List<Widget> tabs = <Widget>[];
  List<Widget> tabs2 = <Widget>[];
  int page = 0;
  dynamic isLeaderboardCall = 0;
  int currentContestIndex;
  String? totalUser;
  int popcount = 0;

  FlexibleController(this.currentContestIndex, this.contest, this.model,
      {required this.userId,
      required this.matchKey,
      required this.challenge_id});

  void onSwitchTeam(int id) {
    model.isSwitchTeam = true;
    model.joinedSwitchTeamId = id;
    navigateToMyJoinTeams(currentContestIndex, AppConstants.context, model,
        contest!, onJoinContestResult);
    update();
  }

  Widget getWinningTab() {
    return GetBuilder<FlexibleController>(
        builder: (newController) => ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(0)),
              child: new Container(
                height: 45,
                alignment: Alignment.center,
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Text(
                  'Winning Breakup',
                  style: TextStyle(
                      fontFamily: "Roboto",
                      color: currentMatchIndex.value == 0
                          ? primaryColor
                          : Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
              ),
            ));
  }

  Widget getLeaderboardTab() {
    return GetBuilder<FlexibleController>(
        builder: (newController) => ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(0)),
              child: new Container(
                height: 45,
                alignment: Alignment.center,
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Text(
                  'Leaderboard',
                  style: TextStyle(
                      fontFamily: "Roboto",
                      color: currentMatchIndex.value == 1
                          ? primaryColor
                          : Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
              ),
            ));
  }

  Widget getMaxFill() {
    return new ClipRRect(
      borderRadius: BorderRadius.horizontal(left: Radius.circular(50)),
      child: new Container(
        height: 45,
        alignment: Alignment.center,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Text(
          'Winning Breakup',
          style: TextStyle(
              fontFamily: "Roboto",
              color: currentContestMatchIndex.value == 0
                  ? Colors.red
                  : Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14),
        ),
      ),
    );
  }

  Widget getCurrentFill() {
    return new ClipRRect(
      borderRadius: BorderRadius.horizontal(right: Radius.circular(50)),
      child: new Container(
        height: 45,
        alignment: Alignment.center,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Text(
          'Leaderboard',
          style: TextStyle(
              fontFamily: "Roboto",
              color: currentContestMatchIndex.value == 1
                  ? Colors.red
                  : Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 14),
        ),
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();
    model.onSwitchTeam = onSwitchTeam;
    model.onSwitchTeamResult = onSwitchTeamResult;

    update();
    // getLeaderboardList();
    getFlexibleData(AppConstants.context, isLoadingFirst: true);
  }

  void onSwitchTeamResult() {
    getLeaderboardList();
  }

  void onJoinContestResult(int isJoined, String referCode) {
    contest!.isjoined = true;
    contest!.refercode = referCode;
    contest!.joinedusers = contest!.joinedusers! + 1;
    getFlexibleData(AppConstants.context);
    // if (popcount == 0) {
    //   leaderboardList.clear();
    //   getLeaderboardList();
    //   print('popjoin');

    update();

    //   popcount = 1;
    // }
    // model.onJoinContestResult!(contest!.joinedusers, contest!.refercode);
  }

  @override
  void dispose() {
    Get.delete<FlexibleController>();
    super.dispose();
  }

  getFlexibleData(BuildContext context, {bool? isLoadingFirst}) async {
    // AppLoaderProgress.showLoader(context);
    //isLoading.value = true;

    if (isLoadingFirst != null && isLoadingFirst) {
      isLoadingFi.value = true;
    }

    GeneralRequest generalRequest = new GeneralRequest(
        user_id: userId,
        matchkey: matchKey,
        challenge_id: challenge_id,
        fantasy_type_id: CricketTypeFantasy.getCricketType(
            model.fantasyType.toString(),
            sportsKey: model.sportKey));
    final client = ApiClient(AppRepository.dio);
    FlexibleDataResponse dataResponse =
        await client.flexibleDataResponse(generalRequest);
    if (dataResponse.status == 1) {
      dataModel.value = dataResponse.result!;
      update();
    }
    // AppLoaderProgress.hideLoader(context!);
    isLoadingFi.value = false;
    isLoading.value = false;
    update();
  }

  void getWinnerPriceCard() async {
    // AppLoaderProgress.showLoader(context);
    isLoading.value = true;
    ContestRequest request = new ContestRequest(
      user_id: userId,
      challenge_id: contest!.id.toString(),
      fantasy_type_id: CricketTypeFantasy.getCricketType(
          model.fantasyType.toString(),
          sportsKey: model
              .sportKey) /*model.fantasyType==1?"7":model.fantasyType==2 ?"6":"0"*/,
      matchkey: model.matchKey,
    );

    final client = ApiClient(AppRepository.dio);
    ScoreCardResponse response = await client.getWinnersPriceCard(request);
    if (response.status == 1) {
      isLoading.value = false;
      breakupList = response.result!;
      update();
    }
    isLoading.value = false;
    update();
    // Fluttertoast.showToast(msg: response.message, toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 1);
    /*  setState(() {
      AppLoaderProgress.hideLoader(context);
    });*/
  }

  getLeaderboardList() async {
    page++;
    //  AppLoaderProgress.showLoader(context);
    isLoading.value = true;
    ContestRequest request = new ContestRequest(
        user_id: userId,
        challenge_id: contest!.id.toString(),
        matchkey: matchKey,
        sport_key: model.sportKey,
        fantasy_type_id: CricketTypeFantasy.getCricketType(
            model.fantasyType.toString(),
            sportsKey: model
                .sportKey) /*model.fantasyType==1?"7":model.fantasyType==2 ?"6":"0"*/,
        page: "$page");
    final client = ApiClient(AppRepository.dio);
    ContestDetailResponse response = await client.getLeaderboardList(request);
    if (response.status == 1) {
      totalUser = response.result!.totaljoin.toString();
      if (response.pages_status == "0" || response.pages_status == 0) {
        leaderboardList = response.result!.contest!;
        page = 0;
      } else {
        isLeaderboardCall = response.pages_status;
        leaderboardList.addAll(response.result!.contest!);
      }
    }
    isLoading.value = false;
    //   Fluttertoast.showToast(msg: response.message!, toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 1);
    update();
    /*  setState(() {
      AppLoaderProgress.hideLoader(context);
    });*/
  }

  void favouriteContest() async {
    // AppLoaderProgress.showLoader(context);
    // isLoading.value = true;

    GeneralRequest request = new GeneralRequest(
      user_id: userId,
      challenge_id: "${contest!.real_challenge_id ?? contest!.challenge_id}",
      my_fav_contest: (contest!.is_fav_contest == 1 ? 0 : 1).toString(),
    );

    final client = ApiClient(AppRepository.dio);
    GeneralResponse response = await client.getFavouriteContest(request);

    if (response.status == 1) {
      contest!.is_fav_contest = contest!.is_fav_contest == 1 ? 0 : 1;
    }

    Fluttertoast.showToast(
        msg: response.message!,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1);
    //  isLoading.value = false;
    update();
    Get.off(UpcomingContests(model));
    //  AppLoaderProgress.hideLoader(context);
  }

  Future<void> onRefresh() async {
    getFlexibleData(AppConstants.context);
  }
}
