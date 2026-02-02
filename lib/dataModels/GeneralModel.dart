import 'package:myrex11/repository/model/banner_response.dart';
import 'package:myrex11/repository/model/team_preview_point_response.dart';
import 'package:myrex11/repository/model/team_response.dart';

import '../repository/model/category_contest_response.dart';

class GeneralModel {
  String? bannerImage;
  String? seriesName;
  String? matchKey;
  String? teamVs;
  String? firstUrl;
  String? secondUrl;
  String? headerText;
  String? sportKey;
  String? filterType;
  String? teamName;
  String? team1Name;
  String? team2Name;
  String? team1Logo;
  String? team2Logo;
  String? team1Score;
  String? team2Score;
  String? winningText;
  int? battingFantasy;
  int? bowlingFantasy;
  int? liveFantasy;
  int? secondInningFantasy;
  int? reverseFantasy;
  int? teamCount;
  int? teamId;
  Contest? contest;
  int? categoryId;
  int? fantasyType;
  int? slotId;
  int? localTeamCount;
  int? visitorTeamCount;
  int? joinedSwitchTeamId;
  int? challengeId;
  int? is_winning_zone;
  bool? isFromEditOrClone;
  bool? isFromLive;
  bool? isFromLiveFinish;
  bool? isSwitchTeam;
  bool? isForLeaderBoard;
  bool? isEditable;
  Function? teamClickListener;
  List<Slots>? fantasySlots;
  List<Player>? selectedWkList;
  List<Player>? selectedBatLiSt;
  List<Player>? selectedArList;
  List<Player>? selectedBowlList;
  List<Player>? selectedcList;
  List<Player>? selectedList;
  Function? onJoinContestResult;
  Function? onTeamCreated;
  Function? onSwitchTeam;
  Function? onSwitchTeamResult;
  int? unlimited_credit_match;
  String? unlimited_credit_text;
  int? credittype;
  bool? isaccountverified;
  int? commentry;
  int? scorecard;
  String? launch_status;
  String? toss;
  String? allContest;
  String? format;
  int? teamNumber;
  TeamPointResponseItem? result;
  bool? isTeamShare;

  GeneralModel(
      {this.is_winning_zone,
      this.seriesName,
      this.bannerImage,
      this.matchKey,
      this.teamVs,
      this.firstUrl,
      this.secondUrl,
      this.headerText,
      this.sportKey,
      this.filterType,
      this.teamName,
      this.team1Name,
      this.team2Name,
      this.team1Logo,
      this.team2Logo,
      this.team1Score,
      this.team2Score,
      this.winningText,
      this.battingFantasy,
      this.bowlingFantasy,
      this.liveFantasy,
      this.secondInningFantasy,
      this.reverseFantasy,
      this.teamCount,
      this.teamId,
      this.contest,
      this.categoryId,
      this.fantasyType,
      this.slotId,
      this.localTeamCount,
      this.visitorTeamCount,
      this.joinedSwitchTeamId,
      this.challengeId,
      this.isFromEditOrClone,
      this.isFromLive,
      this.isFromLiveFinish,
      this.isSwitchTeam,
      this.isForLeaderBoard,
      this.teamClickListener,
      this.fantasySlots,
      this.selectedWkList,
      this.selectedBatLiSt,
      this.selectedArList,
      this.selectedBowlList,
      this.selectedcList,
      this.selectedList,
      this.onJoinContestResult,
      this.onTeamCreated,
      this.onSwitchTeam,
      this.toss,
      this.onSwitchTeamResult,
      this.unlimited_credit_text,
      this.unlimited_credit_match,
      this.credittype,
      this.launch_status,
      this.isaccountverified,
      this.commentry,
      this.scorecard,
      this.allContest,
      this.format,
      this.teamNumber,
      this.result,
      this.isTeamShare});
}
