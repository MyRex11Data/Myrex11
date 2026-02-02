import 'package:get/get.dart';
class UpcomingMyMatchesGetController extends GetxController{
  List  SecTestTimingVariable=[];
  List  MinuteTestTimingVariable=[];

  void onInit(){
    super.onInit();
  }
  void TimeFunction(String min,String sec,int index){
    SecTestTimingVariable[index]=sec;
    MinuteTestTimingVariable[index]=min;
    print("upcoming calling");
    update();
  }
}