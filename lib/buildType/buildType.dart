import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';

class BuildType{
 static bool isForPlayStore = false;
 static bool isForIOS = false;
}

class CricketTypeFantasy {

 static getCricketType(String fantasyType, {String? sportsKey}){
  if( sportsKey!=null && sportsKey=='CRICKET'){
   if(fantasyType == "0"){
    return "7";
   }else if(fantasyType == "1"){
    return "6";
   }else{
    return "0";
   }
  }else{
    return "0";
  }
 }
}

class SportTypeFantasy{
 static getSportType(String? sportKey, GeneralModel model){
  if(sportKey==AppConstants.TAG_FOOTBALL){
   return "11";
  }else if(sportKey==AppConstants.TAG_KABADDI){
   return "7";
  }else if(sportKey==AppConstants.TAG_CRICKET){
   if(CricketTypeFantasy.getCricketType(model.fantasyType.toString(),sportsKey: sportKey)=="6"){
     return "6";
   }else{
    return "11";
   }
  }else if(sportKey==AppConstants.TAG_BASKETBALL){
   return "8";
  }
 }
}