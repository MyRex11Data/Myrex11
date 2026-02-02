import 'package:myrex11/views/newUI/registerNew.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/app_navigator.dart';

import 'package:flutter/services.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../appUtilities/method_utils.dart';
import '../customWidgets/app_circular_loader.dart';
import '../repository/app_repository.dart';
import '../repository/model/join_contest_by_code_request.dart';
import '../repository/model/join_contest_by_code_response.dart';
import '../repository/retrofit/api_client.dart';

class More extends StatefulWidget {
  PackageInfo _packageInfo;
  More(this._packageInfo);
  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  bool logout_dialog = false;
  String userId = "";
  int isVisibleAffiliate = 0;

  int isAccountDisable = 0;
  bool delete_acc_dialog = false;
  String show_refer_earn = '';
  String show_refer_list = '';
  @override
  void initState() {
    super.initState();

    AppPrefrence.getInt(AppConstants.IS_ACCOUNT_WALLET_DISABLE, 0)
        .then((value) => {
              setState(() {
                isAccountDisable = value;
              })
            });
    AppPrefrence.getString(AppConstants.SHOW_REFER_EARN).then((value) => {
          setState(() {
            show_refer_earn = value;
          })
        });

    AppPrefrence.getString(AppConstants.SHOW_REFER_LIST).then((value) => {
          setState(() {
            show_refer_list = value;
          })
        });

    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
        .then((value) => {
              setState(() {
                userId = value;
              })
            });

    AppPrefrence.getInt(AppConstants.IS_VISIBLE_AFFILIATE, 0).then((value) => {
          setState(() {
            isVisibleAffiliate = value;
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
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55), // Set this height
        child: Container(
            padding: EdgeInsets.only(
              top: 40,
              bottom: 12,
              left: 16,
            ),
            decoration: BoxDecoration(color: primaryColor
                // image: DecorationImage(
                //     image:
                //         AssetImage("assets/images/Ic_creatTeamBackGround.png"),
                //     fit: BoxFit.cover)
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  // width: 100,
                  height: 35,
                  // margin: EdgeInsets.only(top: 35,),
                  child: new Image(
                    image: AssetImage(
                      AppImages.LogoWhite,
                    ),
                    // fit: BoxFit.contain,
                  ),
                ),
              ],
            )),
      ),
      body: new Stack(
        children: [
          new SingleChildScrollView(
            child: new Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      // image: DecorationImage(
                      //     image: AssetImage(AppImages.commanBackground),
                      //     fit: BoxFit.cover),
                      color: Colors.white),
                  child: new Column(
                    children: [
                      if (AppConstants.respnsible_play.isNotEmpty)
                        new GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: new Container(
                            height: 50,
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 10),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: borderColor)),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Container(
                                  padding: EdgeInsets.all(5),
                                  child: new Row(
                                    children: [
                                      new Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        height: 28,
                                        width: 28,
                                        child: Image.asset(
                                          AppImages.responsibleicon,
                                          scale: 2,
                                        ),
                                      ),
                                      new Text(
                                        'Responsible Play',
                                        style: TextStyle(
                                            color: lightBlack,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Roboto"),
                                      ),
                                    ],
                                  ),
                                ),
                                new Container(
                                  margin: EdgeInsets.only(right: 15),
                                  height: 16,
                                  width: 10,
                                  child: Image.asset(
                                    AppImages.moreForwardIcon,
                                    color: borderColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () => {
                            navigateToVisionWebView(context, 'Responsible Play',
                                AppConstants.respnsible_play)
                          },
                        ),
                      if (AppConstants.fantasy_point_url.isNotEmpty)
                        new GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: new Container(
                            height: 50,
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 10),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: borderColor)),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Container(
                                  padding: EdgeInsets.all(5),
                                  child: new Row(
                                    children: [
                                      new Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        height: 28,
                                        width: 28,
                                        child: Image.asset(
                                          AppImages.moreFantasyPointIcon,
                                          scale: 2,
                                        ),
                                      ),
                                      new Text(
                                        'Fantasy Point System',
                                        style: TextStyle(
                                            color: lightBlack,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Roboto"),
                                      ),
                                    ],
                                  ),
                                ),
                                new Container(
                                  margin: EdgeInsets.only(right: 15),
                                  height: 16,
                                  width: 10,
                                  child: Image.asset(
                                    AppImages.moreForwardIcon,
                                    color: borderColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () => {
                            navigateToVisionWebView(
                                context,
                                'Fantasy Point System',
                                AppConstants.fantasy_point_url)
                          },
                        ),
                      if (AppConstants.privacy_url.isNotEmpty)
                        new GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: new Container(
                            height: 50,
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 10),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: borderColor)),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Container(
                                  padding: EdgeInsets.all(5),
                                  child: new Row(
                                    children: [
                                      new Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        height: 28,
                                        width: 28,
                                        child: Image.asset(
                                          AppImages.morePrivacyIcon,
                                          scale: 2,
                                        ),
                                      ),
                                      new Text(
                                        'Privacy Policy',
                                        style: TextStyle(
                                            color: lightBlack,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Roboto"),
                                      ),
                                    ],
                                  ),
                                ),
                                new Container(
                                  margin: EdgeInsets.only(right: 15),
                                  height: 16,
                                  width: 10,
                                  child: Image.asset(
                                    AppImages.moreForwardIcon,
                                    color: borderColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () => {
                            navigateToVisionWebView(context, 'Privacy Policy',
                                AppConstants.privacy_url)
                          },
                        ),
                      if (AppConstants.terms_url.isNotEmpty)
                        new GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: new Container(
                            height: 50,
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 10),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: borderColor)),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Container(
                                  padding: EdgeInsets.all(5),
                                  child: new Row(
                                    children: [
                                      new Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        height: 28,
                                        width: 28,
                                        child: Image.asset(
                                          AppImages.terms_conditions,
                                          scale: 2,
                                        ),
                                      ),
                                      new Text(
                                        'Terms & Condition',
                                        style: TextStyle(
                                            color: lightBlack,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Roboto"),
                                      ),
                                    ],
                                  ),
                                ),
                                new Container(
                                  margin: EdgeInsets.only(right: 15),
                                  height: 16,
                                  width: 10,
                                  child: Image.asset(
                                    AppImages.moreForwardIcon,
                                    color: borderColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () => {
                            navigateToVisionWebView(context,
                                'Terms & Condition', AppConstants.terms_url)
                          },
                        ),
                      if (AppConstants.fair_play.isNotEmpty)
                        new GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: new Container(
                            height: 50,
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 10),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Color(0xffEDE2FE))),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Container(
                                  padding: EdgeInsets.all(5),
                                  child: new Row(
                                    children: [
                                      new Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        height: 28,
                                        width: 28,
                                        child: Image.asset(
                                          "assets/images/fair_play.png",
                                          scale: 2,
                                        ),
                                      ),
                                      new Text(
                                        'Fair Play',
                                        style: TextStyle(
                                            color: lightBlack,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Roboto"),
                                      ),
                                    ],
                                  ),
                                ),
                                new Container(
                                  margin: EdgeInsets.only(right: 15),
                                  height: 16,
                                  width: 10,
                                  child: Image.asset(
                                    AppImages.moreForwardIcon,
                                    color: borderColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () => {
                            navigateToVisionWebView(
                                context, 'Fair Play', AppConstants.fair_play)
                          },
                        ),
                      if (AppConstants.refund_policy.isNotEmpty)
                        isAccountDisable == 1
                            ? new GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                child: new Container(
                                  height: 50,
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, top: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                      border:
                                          Border.all(color: Color(0xffEDE2FE))),
                                  child: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      new Container(
                                        padding: EdgeInsets.all(5),
                                        child: new Row(
                                          children: [
                                            new Container(
                                              margin: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              height: 28,
                                              width: 28,
                                              child: Image.asset(
                                                AppImages.refundIcon,
                                                scale: 2,
                                              ),
                                            ),
                                            new Text(
                                              'Refund Policy',
                                              style: TextStyle(
                                                  color: lightBlack,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Roboto"),
                                            ),
                                          ],
                                        ),
                                      ),
                                      new Container(
                                        margin: EdgeInsets.only(right: 15),
                                        height: 16,
                                        width: 10,
                                        child: Image.asset(
                                          AppImages.moreForwardIcon,
                                          color: borderColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () => {
                                  navigateToVisionWebView(
                                      context,
                                      'Refund Policy',
                                      AppConstants.refund_policy)
                                },
                              )
                            : Container(),
                      if (AppConstants.about_us_url.isNotEmpty)
                        new GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: new Container(
                            height: 50,
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 10),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Color(0xffEDE2FE))),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Container(
                                  padding: EdgeInsets.all(5),
                                  child: new Row(
                                    children: [
                                      new Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        height: 28,
                                        width: 28,
                                        child: Image.asset(
                                          AppImages.moreInformationIcon,
                                          scale: 2,
                                        ),
                                      ),
                                      new Text(
                                        'About Us',
                                        style: TextStyle(
                                            color: lightBlack,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Roboto"),
                                      ),
                                    ],
                                  ),
                                ),
                                new Container(
                                  margin: EdgeInsets.only(right: 15),
                                  height: 16,
                                  width: 10,
                                  child: Image.asset(
                                    AppImages.moreForwardIcon,
                                    color: borderColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () => {
                            navigateToVisionWebView(
                                context, 'About Us', AppConstants.about_us_url)
                          },
                        ),
                      if (AppConstants.how_to_play_url.isNotEmpty)
                        new GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: new Container(
                            height: 50,
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 10),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Color(0xffEDE2FE))),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Container(
                                  padding: EdgeInsets.all(5),
                                  child: new Row(
                                    children: [
                                      new Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        height: 28,
                                        width: 28,
                                        child: Image.asset(
                                          AppImages.moreFindIcon,
                                          scale: 2,
                                        ),
                                      ),
                                      new Text(
                                        'How to Play',
                                        style: TextStyle(
                                            color: lightBlack,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Roboto"),
                                      ),
                                    ],
                                  ),
                                ),
                                new Container(
                                  margin: EdgeInsets.only(right: 15),
                                  height: 16,
                                  width: 10,
                                  child: Image.asset(
                                    AppImages.moreForwardIcon,
                                    color: borderColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () => {
                            navigateToVisionWebView(context, 'How to Play',
                                AppConstants.how_to_play_url)
                          },
                        ),
                      new GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: new Container(
                          height: 50,
                          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Color(0xffEDE2FE))),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              new Container(
                                padding: EdgeInsets.all(5),
                                child: new Row(
                                  children: [
                                    new Container(
                                      margin:
                                          EdgeInsets.only(left: 10, right: 10),
                                      height: 28,
                                      width: 28,
                                      child: Image.asset(
                                        AppImages.moreCallIcon,
                                        scale: 2,
                                      ),
                                    ),
                                    new Text(
                                      'Help Desk',
                                      style: TextStyle(
                                          color: lightBlack,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Roboto"),
                                    ),
                                  ],
                                ),
                              ),
                              new Container(
                                margin: EdgeInsets.only(right: 15),
                                height: 16,
                                width: 10,
                                child: Image.asset(
                                  AppImages.moreForwardIcon,
                                  color: borderColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () => {navigateToContactUs(context)},
                      ),
                      new Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(
                            top: 20, bottom: 20, left: 10, right: 10),
                        child: new Text(
                          'Version ' +
                              widget._packageInfo.version +
                              '(' +
                              widget._packageInfo.buildNumber +
                              ')',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          delete_acc_dialog
              ? Container(
                  color: Colors.black38,
                  child: AlertDialog(
                    title: Text("Delete Account"),
                    content: Text(
                        "Are you sure, you want to delete your account permanently?"),
                    actions: [
                      cancelButton(context),
                      deleteAccButton(context),
                    ],
                  ),
                )
              : new Container(),
        ],
      ),
    );
  }

  Widget cancelButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
        // Ensure that delete_acc_dialog is part of the state
        // and that this code is within a StatefulWidget
        setState(() {
          delete_acc_dialog = false;
        });
      },
      child: Text("NO"),
    );
  }

  Widget deleteAccButton(context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
      child: Text("YES DELETE"),
      onPressed: () {
        deleteAccount();
      },
    );
  }

  void deleteAccount() async {
    AppLoaderProgress.showLoader(context);
    JoinContestByCodeRequest contestRequest =
        new JoinContestByCodeRequest(user_id: userId);
    final client = ApiClient(AppRepository.dio);
    JoinContestByCodeResponse response =
        await client.deleteUserAccount(contestRequest);
    setState(() {
      AppLoaderProgress.hideLoader(context);
    });
    if (response.status == 1) {
      // if (response.result![0].message == 'Challenge closed') {
      //   MethodUtils.showError(
      //       context, "Sorry, this League is full! Please join another League.");
      // } else if (response.result![0].message == 'invalid code') {
      //   MethodUtils.showError(context, "Invalid code.");
      // } else {
      //   MethodUtils.showError(context, response.result![0].message);
      // }
      MethodUtils.showError(context, response.message);
      Future.delayed(const Duration(seconds: 0), () {
        onDeleteMoveLogin();
      });
    } else {
      MethodUtils.showError(context, response.message);
    }
  }

  void onDeleteMoveLogin() {
    AppPrefrence.clearPrefrence();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => RegisterNew()),
        ModalRoute.withName("/main"));
  }

  Widget continueButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        AppPrefrence.clearPrefrence();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => RegisterNew()),
          ModalRoute.withName("/main"),
        );
      },
      child: Text("YES"),
    );
  }
}
