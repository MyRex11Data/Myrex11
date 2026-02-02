import 'package:json_annotation/json_annotation.dart';

import 'category_contest_response.dart';
part 'team_response.g.dart';

@JsonSerializable()
class Player {
  int? id;
  int? playing_11;
  int? captain;
  int? vicecaptain;
  int? is_visible_last_match_played;
  int? is_playing_show;
  int? is_playing;
  int? is_substitute;
  int? last_match;
  String? role;
  String? short_role;
  String? display_role;
  String? playerkey;
  String? name;
  String? teamcolor;
  String? team;
  String? selected_by;
  String? captain_selected_by;
  String? vice_captain_selected_by;
  String? last_match_played_info_text;
  String? teamcode;
  String? image;
  String? captaionText;
  String? vCaptainText;
  String? last_match_text;
  dynamic batting_order;
  bool? isSelected;
  bool? isHeader;
  int? count;
  var isCaptain;
  var isVcCaptain;
  var credit;
  var points;
  var series_points;
  List<int>? last_played_points;

  Player(
      {this.id,
      this.playing_11,
      this.captain,
      this.vicecaptain,
      this.is_visible_last_match_played,
      this.is_playing_show,
      this.is_playing,
      this.last_match,
      this.role,
      this.short_role,
      this.display_role,
      this.playerkey,
      this.name,
      this.teamcolor,
      this.team,
      this.selected_by,
      this.captain_selected_by,
      this.vice_captain_selected_by,
      this.last_match_played_info_text,
      this.teamcode,
      this.is_substitute,
      this.image,
      this.captaionText,
      this.vCaptainText,
      this.last_match_text,
      this.isSelected,
      this.isHeader,
      this.count,
      this.isCaptain,
      this.isVcCaptain,
      this.credit,
      this.points,
      this.series_points,
      this.last_played_points,
      this.batting_order});

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerToJson(this);

  String getShortName() {
    if (name!.isNotEmpty) {
      name = name!.trim();
      if (name!.length > 0) {
        var names = name!.split(" ");
        names.remove("");
        if (names.length > 2)
          return names[0].substring(0, 1) +
              " " +
              names[1].substring(0, 1) +
              " " +
              names[names.length - 1];
        else if (names.length > 1)
          return names[0].substring(0, 1) + " " + names[names.length - 1];
        else
          return names[0];
      } else
        return name!;
    }

    return "";
  }

  double getSelectedBy() {
    return double.parse((selected_by ?? '0'));
  }

  double getPoints() {
    return double.parse((series_points.toString()));
  }

  double getCredits() {
    return double.parse((credit.toString()));
  }

  double getcaptainselected() {
    return double.parse((captain_selected_by.toString()));
  }

  double getvicecaptainselected() {
    return double.parse((vice_captain_selected_by.toString()));
  }

  String getPreviewShortName() {
    if (name!.isNotEmpty) {
      name = name!.trim();
      if (name!.length > 0) {
        var names = name!.split(" ");
        names.remove("");
        if (names.length > 2)
          return names[0].substring(0, 1) +
              ". " +
              names[1].substring(0, 1) +
              ". " +
              names[names.length - 1];
        else if (names.length > 1)
          return names[0].substring(0, 1) + ". " + names[names.length - 1];
        else
          return names[0];
      } else
        return name!;
    }

    return "";
  }
}

@JsonSerializable()
class Team {
  int? teamid;
  int? userid;
  int? teamnumber;
  int? is_joined;
  String? sport_key;
  String? matchkey;
  String? image;
  String? team1_name;
  String? team2_name;
  var team1_player_count;
  var team2_player_count;
  bool? isSelected;
  List<Player>? players;
  int? is_non_playing_players;
  int? is_substitute_players;
  String? is_non_playing_players_text;
  String? is_substitute_text;
  var points;
  dynamic fantasy_type_id;
  dynamic fantasytype;

  String? team_share_link;

  Team(
      {this.teamid,
      this.userid,
      this.teamnumber,
      this.is_joined,
      this.sport_key,
      this.matchkey,
      this.image,
      this.team1_name,
      this.team2_name,
      this.team1_player_count,
      this.team2_player_count,
      this.isSelected,
      this.players,
      this.points,
      this.is_non_playing_players,
      this.is_substitute_players,
      this.is_non_playing_players_text,
      this.is_substitute_text,
      this.fantasy_type_id,
      this.fantasytype,
      this.team_share_link});
  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
  Map<String, dynamic> toJson() => _$TeamToJson(this);

  String captainImage() {
    String captionImage = "";
    for (var player in players!) {
      if (player.captain == 1) {
        captionImage = player.image!;
        break;
      }
    }
    return captionImage;
  }

  String vcCaptainImage() {
    String vcCaptionImage = "";
    for (var player in players!) {
      if (player.vicecaptain == 1) {
        vcCaptionImage = player.image!;
        break;
      }
    }
    return vcCaptionImage;
  }

  String captainName() {
    String captainName = "";
    for (var player in players!) {
      if (player.captain == 1) {
        captainName = player.name!;
        break;
      }
    }
    return captainName;
  }

  String vcCaptainName() {
    String vcCaptainName = "";
    for (var player in players!) {
      if (player.vicecaptain == 1) {
        vcCaptainName = player.name!;
        break;
      }
    }
    return vcCaptainName;
  }

  String captainteamName() {
    String captainTeamName = "";
    for (var player in players!) {
      if (player.captain == 1) {
        captainTeamName = player.team!;
        break;
      }
    }
    return captainTeamName;
  }

  String vcCaptainTeamName() {
    String vcCaptainTeamName = "";
    for (var player in players!) {
      if (player.vicecaptain == 1) {
        vcCaptainTeamName = player.team!;
        break;
      }
    }
    return vcCaptainTeamName;
  }

  bool vcPlaying() {
    bool vcCaptainPlaying = false;
    for (var player in players!) {
      if (player.vicecaptain == 1) {
        vcCaptainPlaying =
            player.is_playing_show == 1 && player.is_playing == 0;
        break;
      }
    }
    return vcCaptainPlaying;
  }

  bool vcSubstitute() {
    bool vcCaptainPlaying = false;
    for (var player in players!) {
      if (player.vicecaptain == 1) {
        vcCaptainPlaying = player.is_playing_show == 1 &&
            player.is_playing == 0 &&
            player.is_substitute == 1;
        break;
      }
    }
    return vcCaptainPlaying;
  }

  bool cPlaying() {
    bool cCaptainPlaying = false;
    for (var player in players!) {
      if (player.captain == 1) {
        cCaptainPlaying = player.is_playing_show == 1 && player.is_playing == 0;
        break;
      }
    }
    return cCaptainPlaying;
  }

  bool cSubstitute() {
    bool cCaptainPlaying = false;
    for (var player in players!) {
      if (player.captain == 1) {
        cCaptainPlaying = player.is_playing_show == 1 &&
            player.is_playing == 0 &&
            player.is_substitute == 1;
        break;
      }
    }
    return cCaptainPlaying;
  }
}

@JsonSerializable()
class TeamItem {
  int? user_teams;
  int? joined_leagues;
  List<Team>? teams;

  TeamItem({this.user_teams, this.joined_leagues, this.teams});

  factory TeamItem.fromJson(Map<String, dynamic> json) =>
      _$TeamItemFromJson(json);
  Map<String, dynamic> toJson() => _$TeamItemToJson(this);
}

@JsonSerializable()
class MyTeamResponse {
  int? status;
  String? message;
  TeamItem? result;

  MyTeamResponse({this.status, this.message, this.result});

  factory MyTeamResponse.fromJson(Map<String, dynamic> json) =>
      _$MyTeamResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MyTeamResponseToJson(this);
}
