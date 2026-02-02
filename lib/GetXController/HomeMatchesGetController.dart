import 'package:get/get.dart';
class HomeMatchesGetController extends GetxController{
  List  HomeSecTestTimingVariable=[];
  List  HomeMinuteTestTimingVariable=[];

  void onInit(){
    super.onInit();
  }

  void TimeFunction(String min,String sec,int index){
    HomeSecTestTimingVariable[index]=sec;
    HomeMinuteTestTimingVariable[index]=min;
    print("home calling");
   update();
  }

}