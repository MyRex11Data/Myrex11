

class BuildType{
 //for website  both should be false
 //for playstore  isForPlayStore = true ,other false
 //for ios  isForIOS = true
 static bool isForPlayStore = true;
 static bool isForIOS = false;
}

class CricketTypeFantasy {

 static getCricketType(String fantasyType, {String? sportsKey}){
  if( sportsKey!=null && sportsKey=='CRICKET'){
  return fantasyType;
  }else{
    return "0";
  }
 }

 /* static getCricketType(String fantasyType, {String? sportsKey}){
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
 }*/
}

/*
class SportTypeFantasy{

 static getSportType(String? sportKey, GeneralModel model){
  if(sportKey==AppConstants.TAG_FOOTBALL){
   return "11";
  }else if(sportKey==AppConstants.TAG_KABADDI){
   return "7";
  }else if(sportKey==AppConstants.TAG_CRICKET){
   if(CricketTypeFantasy.getCricketType(model.fantasyType.toString(),sportsKey: sportKey)=="6" || CricketTypeFantasy.getCricketType(model.fantasyType.toString(),sportsKey: sportKey)=="1"){
  //   return "6";
    return model.fantasyType == 1 ? "6" : model.fantasyType;
   }else{
    return "11";
   }
  }else if(sportKey==AppConstants.TAG_BASKETBALL){
   return "8";
  }
 }
}*/
