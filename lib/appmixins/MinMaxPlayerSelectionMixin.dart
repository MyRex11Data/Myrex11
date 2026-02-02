import 'package:myrex11/appUtilities/app_constants.dart';

mixin MinMaxPlayer {
  int minAllRounder(String fantasyType) {
    if (fantasyType == "0") {
      return 1;
    } else if (fantasyType == "1") {
      return 0;
    } else {
      return 1;
    }
  }

  int minBatsman(String fantasyType) {
    if (fantasyType == "0") {
      return 1;
    } else if (fantasyType == "1") {
      return 0;
    } else {
      return 3;
    }
  }

  int minBowler(String fantasyType) {
    if (fantasyType == "0") {
      return 1;
    } else if (fantasyType == "1") {
      return 0;
    } else {
      return 3;
    }
  }

  int minWicketKeeper(String fantasyType) {
    if (fantasyType == "0") {
      return 1;
    } else if (fantasyType == "1") {
      return 0;
    } else {
      return 1;
    }
  }

  int maxAllRounder(String fantasyType) {
    if (fantasyType == "0") {
      return 8;
    } else if (fantasyType == "1") {
      return 6;
    } else {
      return 4;
    }
  }

  int maxBatsman(String fantasyType) {
    if (fantasyType == "0") {
      return 8;
    } else if (fantasyType == "1") {
      return 6;
    } else {
      return 6;
    }
  }

  int maxBowler(String fantasyType) {
    if (fantasyType == "0") {
      return 8;
    } else if (fantasyType == "1") {
      return 6;
    } else {
      return 6;
    }
  }

  int maxWicketKeeper(String fantasyType) {
    if (fantasyType == "0") {
      return 8;
    } else if (fantasyType == "1") {
      return 6;
    } else {
      return 4;
    }
  }

  int extraPlayer(String fantasyType, String? sportKey) {
    if (sportKey == AppConstants.TAG_CRICKET) {
      if (fantasyType == "0") {
        return 7;
      } else if (fantasyType == "1") {
        return 6;
      } else {
        return 3;
      }
    } else if (sportKey == AppConstants.TAG_KABADDI) {
      return 4;
    } else {
      return 3;
    }
  }
}
