import 'dart:io';

import 'package:myrex11/views/newUI/registerNew.dart';
import 'package:myrex11/views/newUI/setTeamName.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/repository/model/category_contest_response.dart';
import 'package:myrex11/repository/model/create_private_contest_request.dart';
import 'package:myrex11/repository/model/player_points_response.dart';
import 'package:myrex11/repository/model/refresh_score_response.dart';
import 'package:myrex11/views/AddBalance.dart';
import 'package:myrex11/views/AffiliateMatches.dart';
import 'package:myrex11/views/AffiliateProgram.dart';
import 'package:myrex11/views/AllContests.dart';
import 'package:myrex11/views/BreakupPlayerPoints.dart';
import 'package:myrex11/views/ChooseCandVc.dart';
import 'package:myrex11/views/CompareTeam.dart';
import 'package:myrex11/views/ContactUs.dart';
import 'package:myrex11/views/CreateTeam.dart';
import 'package:myrex11/views/Home.dart';
import 'package:myrex11/views/InviteContestCode.dart';
import 'package:myrex11/views/LiveFinishContestDetails.dart';
import 'package:myrex11/views/LiveFinishedContests.dart';
import 'package:myrex11/views/MyJoinTeams.dart';
import 'package:myrex11/views/PlayerInfo.dart';
import 'package:myrex11/views/PrivateContest.dart';

import 'package:myrex11/views/RecentTransactions.dart';
import 'package:myrex11/views/ReferAndEarn.dart';
import 'package:myrex11/views/ReferList.dart';
import 'package:myrex11/views/TeamPreview.dart';
import 'package:myrex11/views/UpcomingContestDetails.dart';
import 'package:myrex11/views/UpcomingContests.dart';
import 'package:myrex11/views/UserNotifications.dart';
import 'package:myrex11/views/UserProfile.dart';
import 'package:myrex11/views/FocusWebView.dart';
import 'package:myrex11/views/Wallet.dart';
import 'package:myrex11/views/WinningBreakupManager.dart';
import 'package:myrex11/views/WithdrawCash.dart';
import 'package:myrex11/views/playingHistory.dart';
import '../appUtilities/app_routes.dart';
import '../repository/model/invite_contest_response.dart';

//=============================================================================

void openScreenAsLeftToRight(BuildContext context, Widget targetWidget) =>
    openScreenAsPlatformWiseRoute(context, targetWidget, isFullScreen: true);

void navigateToCompareTeam(
        BuildContext context,
        String matchKey,
        String sportKey,
        String team1Id,
        String team2Id,
        String fantasyType,
        String slotId,
        String challengeId,
        GeneralModel model) =>
    openScreenAsLeftToRight(
        context,
        CompareTeam(matchKey, sportKey, team1Id, team2Id, fantasyType, slotId,
            challengeId, model));

void navigateToWithdrawCash(BuildContext context,
        {String? type, bool? withdrawOption, String? affiliate_commission}) =>
    openScreenAsLeftToRight(
        context,
        WithdrawCash(
          type: type,
          withdrawOption: withdrawOption,
          affiliate_commission: affiliate_commission,
        ));

Future<void> navigateToHomePage(BuildContext context,
        {int? index, String? check}) async =>
    openScreenAsLeftToRight(
        context, HomePage(index: index, isDynamicT: false, screenCheck: check));

void navigateToVisionWebView(BuildContext context, var title, var url) =>
    openScreenAsLeftToRight(
        context,
        FocusWebView(
          title,
          url,
          key: UniqueKey(),
        ));

void navigateToAffiliateMatches(BuildContext context, String start_date,
        String end_date, String userid) =>
    openScreenAsLeftToRight(
        context, AffiliateMatches(start_date, end_date, userid));

void navigateToAffiliateProgram(BuildContext context) =>
    openScreenAsLeftToRight(context, AffiliateProgram());

void navigateToPlayingHistory(BuildContext context, String userId) =>
    openScreenAsLeftToRight(context, PlayingHistory(userId));

// void navigateToUserStats(
//         BuildContext context, String seriesId, String userId, String check) =>
//     openScreenAsLeftToRight(context, UserStats(seriesId, userId, check));

void navigateToAddBalance(BuildContext context, String promo_code,
        {String? entryFee, String? isFromCheck}) =>
    openScreenAsLeftToRight(
        context,
        AddBalance(
          promo_code,
          entryFee: entryFee,
          isFromCheck: isFromCheck,
        ));

void navigateToRecentTransactions(BuildContext context) =>
    openScreenAsLeftToRight(context, RecentTransactions());

void navigateToBreakupPlayerPoints(
        BuildContext context, MultiSportsPlayerPointItem breakupPoint) =>
    openScreenAsLeftToRight(context, BreakupPlayerPoints(breakupPoint));
//
void navigateToLiveFinishContestDetails(BuildContext context,
        LiveFinishedContestData contest, GeneralModel model,
        {String? match_status}) =>
    openScreenAsLeftToRight(
        context,
        LiveFinishContestDetails(
          contest,
          model,
          match_status: match_status,
        ));

void navigateToLiveFinishContests(BuildContext context, GeneralModel model,
        {String? match_status, String? sports_key}) =>
    openScreenAsLeftToRight(context,
        LiveFinishContests(model, match_status, sports_key: sports_key));

void navigateToInviteContestCode(
        int currentContestIndex, BuildContext context, GeneralModel model,
        {Function? onTeamCreated}) =>
    openScreenAsLeftToRight(
        context,
        InviteContestCode(
          currentContestIndex,
          model,
        ));

void navigateToMyJoinTeams(
  int currentContestIndex,
  BuildContext context,
  GeneralModel model,
  dynamic contest,
  Function onJoinContestResult, {
  int? contestNumber,
  double? scrollPotion,
  int? joinSimilar,
}) =>
    openScreenAsLeftToRight(
        context,
        MyJoinTeams(
          currentContestIndex,
          model,
          contest,
          onJoinContestResult,
          contestNumber: contestNumber,
          scrollPosition: scrollPotion,
          joinSimilar: joinSimilar,
        ));

void navigateToWinningBreakupManager(
        int currentContestIndex,
        BuildContext context,
        GeneralModel model,
        CreatePrivateContestRequest request,
        Function onTeamCreated,
        int _currentIndex) =>
    openScreenAsLeftToRight(
        context,
        WinningBreakupManager(
            currentContestIndex, request, model, onTeamCreated, _currentIndex));

void navigateToPrivateContest(
        int currentContestIndex,
        BuildContext context,
        GeneralModel model,
        Function onTeamCreated,
        List<dynamic> maxMinList,
        int _currentIndex) =>
    openScreenAsLeftToRight(
        context,
        PrivateContest(currentContestIndex, model, onTeamCreated, maxMinList,
            _currentIndex));

void navigateToTeamPreview(BuildContext context, GeneralModel model,
        {String? check}) =>
    openScreenAsLeftToRight(
        context,
        TeamPreview(
          model,
          check: check,
        ));

void navigateToChooseCandVc(BuildContext context, GeneralModel model,
        {String? isLineUp,
        bool? isDynaminLink,
        Contest? contest,
        Function? onTeamCreated,
        int? contestNumber,
        double? scrollPosition,
        String? check,
        String? checkScreen,
        String? contestFrom,
        int? joinSimilar}) =>
    openScreenAsLeftToRight(
        context,
        ChooseCandVc(
          model,
          onTeamCreated: onTeamCreated,
          contestNumber: contestNumber,
          scrollPosition: scrollPosition,
          isDynaminLink: isDynaminLink,
          isLineUp: isLineUp,
          check: check,
          checkScreen: checkScreen,
          contestFrom: contestFrom,
          joinSimilar: joinSimilar,
        ));

void navigateToPlayerInfo(
        BuildContext context,
        String? matchKey,
        int? playerId,
        String? playerName,
        String? team,
        String? playerImage,
        bool? isSelected,
        int index,
        int? type,
        String? sportKey,
        int? fantasyType,
        //  int? slotId,
        String isFrom,
        Function? onPlayerClick,
        String shorRole,
        String? selected_by,
        String? points,
        int? matchPlayed,
        String? teamcode) =>
    openScreenAsLeftToRight(
        context,
        PlayerInfo(
            matchKey,
            playerId,
            playerName,
            team,
            playerImage,
            isSelected,
            index,
            type,
            sportKey,
            fantasyType,
            //  slotId,
            isFrom,
            onPlayerClick,
            shorRole,
            selected_by,
            points,
            matchPlayed,
            teamcode));

void navigateToAllContests(BuildContext context, GeneralModel model) =>
    openScreenAsLeftToRight(context, AllContests(model, 0));

void navigateToCreateTeam(
  BuildContext context,
  GeneralModel model,
  // TODO: Named argument
  {
  bool? isDynaminLink,
  int? teamid,
  Contest? contest,
  Function? onTeamCreated,
  String? check,
  int? contestNumber,
  double? scrollPotion,
  int? joinSimilar,
}) =>
    openScreenAsLeftToRight(
        context,
        CreateTeam(
          model,
          isDynaminLink: isDynaminLink,
          contest: contest,
          onTeamCreated: onTeamCreated,
          check: check,
          contestNumber: contestNumber,
          scrollPosition: scrollPotion,
          teamId: teamid,
          joinSimilar: joinSimilar,
        ));

void navigateToUpcomingContestDetails(int currentContestIndex,
        BuildContext context, GeneralModel model, Contest contest,
        {Function? onTeamCreated,
        bool? isMyContest,
        Function? onResume,
        int? joinSimilar}) =>
    openScreenAsLeftToRight(
        context,
        UpcomingContestDetails(
          currentContestIndex,
          model,
          contest,
          onTeamCreated: onTeamCreated,
          isMyContest: isMyContest,
          onResume: onResume,
          joinSimilar: joinSimilar,
        ));

Future<void> navigateToUpcomingContests(
        BuildContext context, GeneralModel model,
        {double? scrollPosition,
        String? sports_key,
        bool? isDynaminLink,
        Result? result,
        List? matchKeyID,
        bool? isTeamShare}) async =>
    openScreenAsLeftToRight(
        context,
        UpcomingContests(model,
            scrollPosition: scrollPosition,
            sports_key: sports_key,
            isTeamShare: isTeamShare));

void navigateToReferList(BuildContext context) =>
    openScreenAsLeftToRight(context, ReferList());

void navigateToContactUs(BuildContext context) =>
    openScreenAsLeftToRight(context, ContactUs());

/*void navigateToVerifyAccount(BuildContext context) =>
    openScreenAsLeftToRight(context, VerifyAccountDetail());*/

void navigateToUserNotifications(BuildContext context) =>
    openScreenAsLeftToRight(context, UserNotifications());

void navigateToReferAndEarn(BuildContext context) =>
    openScreenAsLeftToRight(context, ReferAndEarn());

void navigateToUserProfile(BuildContext context) =>
    openScreenAsLeftToRight(context, UserProfile());

void navigateToWallet(BuildContext context, {Function? getUserBalance}) =>
    openScreenAsLeftToRight(context, Wallet(getUserBalance: getUserBalance));

/*void navigateToOtpVerify(
        BuildContext context, String otpVerify, String emailverify) =>
    openScreenAsLeftToRight(context, OtpVerify(otpVerify, emailverify));*/

void navigateToRegisterNew(BuildContext context) =>
    openScreenAsLeftToRight(context, RegisterNew());

void navigateToSetTeamName(BuildContext context) =>
    openScreenAsLeftToRight(context, SetTeamName());

void navigateToLogin(BuildContext context) =>
    openScreenAsLeftToRight(context, RegisterNew());

openScreenAsBottomToTop(BuildContext context, Widget targetWidget,
        {bool isFullScreen = false}) async =>
    await Navigator.of(context)
        .push(AppRoute.createRoute(targetWidget, isFullScreen: isFullScreen));

//Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => targetWidget));

//=============================================================================

void openScreenAsPlatformWiseRoute(BuildContext context, Widget targetWidget,
        {bool isFullScreen = false}) async =>
    await Platform.isIOS
        ? Navigator.of(context).push(CupertinoPageRoute(
            builder: (BuildContext context) => targetWidget,
            fullscreenDialog: isFullScreen))
        : Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => targetWidget,
            fullscreenDialog: isFullScreen));
