import 'package:fluttertoast/fluttertoast.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/date_utils.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:flutter/services.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/base_request.dart';
import 'package:myrex11/repository/model/notification_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';

class UserNotifications extends StatefulWidget {
  @override
  _UserNotificationsState createState() => _UserNotificationsState();
}

class _UserNotificationsState extends State<UserNotifications> {
  late String userId = '0';
  List<NotificationItem> notificationList = [];
  @override
  void initState() {
    super.initState();
    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
        .then((value) => {
              setState(() {
                userId = value;
                getNotification();
              })
            });
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
    return Container(
      height: MediaQuery.sizeOf(context).height,
      decoration: BoxDecoration(
          // image: DecorationImage(
          //     image: AssetImage(AppImages.commanBackground), fit: BoxFit.cover),
          color: Colors.white),
      child: new Scaffold(
        backgroundColor: Colors.transparent,
        /*appBar: PreferredSize(
          preferredSize: Size.fromHeight(55), // Set this height
          child: Container(
            padding: EdgeInsets.only(top: 28),
            color: primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                new GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => {Navigator.pop(context)},
                  child: new Container(
                    padding:
                        EdgeInsets.only(left: 15, right: 8, top: 15, bottom: 15),
                    alignment: Alignment.centerLeft,
                    child: new Container(
                      width: 16,
                      height: 16,
                      child: Image(
                        image: AssetImage(AppImages.backImageURL),
                        fit: BoxFit.fill,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                new Container(
                  child: new Text('Your Notifications',
                      style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16)),
                ),
              ],
            ),
          ),
        ),*/

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(55), // Set this height
          child: Container(
            padding: EdgeInsets.only(
              top: 50,
              bottom: 12,
              left: 16,
            ),
            decoration: BoxDecoration(
              color: primaryColor
                // image: DecorationImage(
                //     image:
                //         AssetImage("assets/images/Ic_creatTeamBackGround.png"),
                //     fit: BoxFit.cover)
            ),
            child: Row(
              children: [
                AppConstants.backButtonFunction(),
                Text("Notifications",
                    style: TextStyle(
                        fontFamily: "Roboto",
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
              ],
            ),
          ),
        ),
        body: new SingleChildScrollView(
          child: new Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: borderColor1,
                    // border: Border.all(
                    //   color: primaryColor, // Border color
                    //   width: 0.7, // Optional: Border width
                    // ),
                    borderRadius:
                        BorderRadius.circular(10.0), // Add rounded corners
                  ),
                  child: notificationList.length > 0
                      ? Column(
                          children: List.generate(
                          notificationList.length,
                          (index) => new Column(
                            children: [
                              new Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 10, bottom: 10),
                                child: new Row(
                                  children: [
                                    new Container(
                                      margin: EdgeInsets.only(right: 10),
                                      height: 30,
                                      width: 30,
                                      child: new Image.asset(
                                          AppImages.notification_bell_icon1,
                                          fit: BoxFit.fill),
                                    ),
                                    new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        new Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              80,
                                          child: new Text(
                                            notificationList[index].title!,
                                            softWrap: true,
                                            style: TextStyle(
                                                color: textCol,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        new Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: new Text(
                                            DateFormat
                                                .getNotificationDateFormat(
                                                    DateFormat.getDateFormat(
                                                        notificationList[index]
                                                            .created_at!)!),
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              new Divider(
                                height: 2,
                              )
                            ],
                          ),
                        ))
                      : Row(
                        children: [
                          new Container(
                            padding: EdgeInsets.all(8),
                            height: 60,
                            child: Image(
                              image: AssetImage(AppImages.notification_bell_icon1),
                            ),
                          ),
                          SizedBox(width: 8,),
                          Text("No notifications for today", style: TextStyle(color: Colors.grey),)
                        ],
                      ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void getNotification() async {
    AppLoaderProgress.showLoader(context);
    GeneralRequest loginRequest = new GeneralRequest(user_id: userId);
    final client = ApiClient(AppRepository.dio);
    GetNotificationResponse notificationResponse =
        await client.getUserNotification(loginRequest);
    AppLoaderProgress.hideLoader(context);
    if (notificationResponse.status == 1) {
      notificationList = notificationResponse.result!;
      if (notificationList.length > 0) {
        setState(() {});
      } else {
        Fluttertoast.showToast(
            msg: "No Notification you got yet",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1);
      }
    }
  }
}
