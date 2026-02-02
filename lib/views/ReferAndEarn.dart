import 'package:fluttertoast/fluttertoast.dart';
import 'package:myrex11/appUtilities/defaultbutton.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/base_request.dart';
import 'package:myrex11/repository/model/refer_dynamic_link.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:flutter/services.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:share_plus/share_plus.dart';
import '../customWidgets/app_circular_loader.dart';
import '../repository/retrofit/api_client.dart';

class ReferAndEarn extends StatefulWidget {
  @override
  _ReferAndEarnState createState() => _ReferAndEarnState();
}

class _ReferAndEarnState extends State<ReferAndEarn> {
  TextEditingController nameController = TextEditingController();
  TextEditingController teamNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController changeController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  String? signup_refer_statement;
  String? refer_statement;
  String? Both_earn;
  String lifetime_commission = '';
  String? Both_earn_stmt;
  String lifetime_commission_stmt = '';
  String is_lifetime_commission = '';
  String? shareLink;
  String refer_msg = '';
  var val;
  var groupValue;
  late String referCode = '0';

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();

    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_REFER_CODE)
        .then((value) => {
              setState(() {
                referCode = value;
              })
            });

    AppPrefrence.getString(AppConstants.Refer_code).then((value) => {
          setState(() {
            referCode = value;
          })
        });

    AppPrefrence.getString(AppConstants.signup_refer_statement)
        .then((value) => {
              setState(() {
                signup_refer_statement = value;
              })
            });

    AppPrefrence.getString(AppConstants.refer_statement).then((value) => {
          setState(() {
            refer_statement = value;
          })
        });

    AppPrefrence.getString(AppConstants.Both_earn).then((value) => {
          setState(() {
            Both_earn = value;
          })
        });

    AppPrefrence.getString(AppConstants.lifetime_commission).then((value) => {
          setState(() {
            lifetime_commission = value;
          })
        });

    AppPrefrence.getString(AppConstants.Both_earn_stmt).then((value) => {
          setState(() {
            Both_earn_stmt = value;
          })
        });

    AppPrefrence.getString(AppConstants.lifetime_commission_stmt)
        .then((value) => {
              setState(() {
                lifetime_commission_stmt = value;
              })
            });

    AppPrefrence.getString(AppConstants.is_lifetime_commission)
        .then((value) => {
              setState(() {
                is_lifetime_commission = value;
              })
            });

    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();

    getDynamicLintRefer();
    setState(() {
      _packageInfo = info;
    });
  }

  void getDynamicLintRefer() async {
    AppLoaderProgress.showLoader(context);
    GeneralRequest loginRequest =
        new GeneralRequest(referral: referCode, device_type: "ANDROID");
    final client = ApiClient(AppRepository.dio);
    ReferDynamicLink dynamicLinkResponse =
        await client.getDynamicLintRefer(loginRequest);
    AppLoaderProgress.hideLoader(context);
    if (dynamicLinkResponse.status == 1) {
      shareLink = dynamicLinkResponse.data!.shortLink;
      refer_msg = dynamicLinkResponse.data!.refer_msg ?? '';
    } else {
      Fluttertoast.showToast(
          msg: dynamicLinkResponse.message!,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        /* set Status bar color in Android devices. */
        statusBarIconBrightness: Brightness.light,
        /* set Status bar icons color in Android devices. */
        statusBarBrightness:
            Brightness.dark) /* set Status bar icon color in iOS. */);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60), // Set this height
        child: Container(
          padding: EdgeInsets.only(
            top: 50,
            bottom: 12,
            left: 16,
          ),
          decoration: BoxDecoration(color: primaryColor
              // image: DecorationImage(
              // image: AssetImage("assets/images/Ic_creatTeamBackGround.png"),
              // fit: BoxFit.cover)
              ),
          child: Row(
            children: [
              new GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => {Navigator.pop(context)},
                child: new Container(
                  padding: EdgeInsets.only(left: 0, right: 8),
                  alignment: Alignment.centerLeft,
                  child: new Container(
                    // width: 24,
                    height: 30,
                    child: Image(
                      image: AssetImage(AppImages.backImageURL),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Text("Invite Friend ",
                  style: TextStyle(
                      fontFamily: "Roboto",
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16)),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            // image: DecorationImage(
            //     image: AssetImage(AppImages.commanBackground),
            //     fit: BoxFit.cover),
            color: Colors.white),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  // Container(
                  //   // height: 370,
                  //   alignment: Alignment.topCenter,
                  //   decoration: BoxDecoration(
                  //     color: primaryColor,
                  //     // image: DecorationImage(
                  //     //     image: AssetImage(AppImages.referScreenIcon),
                  //     //     fit: BoxFit.fill)
                  //   ),
                  //   child: new Column(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       Padding(
                  //         padding: EdgeInsets.only(top: Platform.isIOS ? 40 : 30),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           children: [
                  //             new GestureDetector(
                  //               behavior: HitTestBehavior.translucent,
                  //               onTap: () => {Navigator.pop(context)},
                  //               child: new Container(
                  //                 padding: EdgeInsets.only(
                  //                     left: 15, right: 6, top: 15, bottom: 16),
                  //                 alignment: Alignment.centerLeft,
                  //                 child: new Container(
                  //                   width: 16,
                  //                   height: 16,
                  //                   child: Image(
                  //                     image: AssetImage(AppImages.backImageURL),
                  //                     fit: BoxFit.fill,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //             new Container(
                  //               child: new Text('Refer & Earn',
                  //                   style: TextStyle(
                  //                       fontFamily: "Roboto",
                  //                       color: Colors.white,
                  //                       fontWeight: FontWeight.w500,
                  //                       fontSize: 16)),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    child: Image(
                      image: AssetImage(AppImages.referHeaderIcon),
                      fit: BoxFit.fill,
                    ),
                  ),
                  /* new Container(
                     margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                     alignment: Alignment.center,
*/ /*                          child: new Text(
                             'Refer to your friend and get ₹100 Also we have to show 25% lifetime commission to the users.',
                             style: TextStyle(
                                 fontFamily: AppConstants.textSemiBold,
                                 color: Colors.white,
                                 fontWeight: FontWeight.w700,
                                 fontSize: 16,
                                 height: 1.5),
                             textAlign: TextAlign.center,
                           ),*/ /*
                     child: RichText(
                       textAlign: TextAlign.center,
                       text: TextSpan(children: <TextSpan>[
                         TextSpan(
                             text: 'Refer to your friend and Get ',
                             style: TextStyle(
                                 fontFamily: AppConstants.textSemiBold,
                                 color: Colors.black,
                                 fontWeight: FontWeight.w700,
                                 fontSize: 16,
                                 height: 1.5)),
                         TextSpan(
                             text: '₹100 ',
                             style: TextStyle(
                                 fontFamily: AppConstants.textSemiBold,
                                 color: Colors.black,
                                 fontWeight: FontWeight.w700,
                                 fontSize: 16,
                                 height: 1.5)),
                         TextSpan(
                             text: 'and ',
                             style: TextStyle(
                                 fontFamily: AppConstants.textSemiBold,
                                 color: Colors.black,
                                 fontWeight: FontWeight.w700,
                                 fontSize: 16,
                                 height: 1.5)),
                         TextSpan(
                             text: ' 20% lifetime commission ',
                             style: TextStyle(
                                 // fontFamily: AppConstants.textSemiBold,
                                 color: Colors.black,
                                 fontWeight: FontWeight.w700,
                                 fontSize: 16,
                                 height: 1.5)),
                         TextSpan(
                             text: 'on refer',
                             style: TextStyle(
                                 fontFamily: AppConstants.textSemiBold,
                                 color: Colors.black,
                                 fontWeight: FontWeight.w700,
                                 fontSize: 16,
                                 height: 1.5)),
                       ]),
                     ),
                   ),*/
                  Container(
                    margin:
                        EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
                    alignment: Alignment.center,
                    child: new Text(
                      '${signup_refer_statement ?? ""}',
                      style: TextStyle(
                          fontFamily: AppConstants.textSemiBold,
                          color: textCol,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 5, bottom: 15, left: 15, right: 15),
                    alignment: Alignment.center,
                    child: new Text(
                      '${refer_statement ?? ""}',
                      style: TextStyle(
                          fontFamily: "Roboto",
                          color: Color(0xFF747474),
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 10, bottom: 10, left: 22, right: 15),
                    alignment: Alignment.centerLeft,
                    child: new Text(
                      'Your referral code:',
                      style: TextStyle(
                        color: Color(0xff626262),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Container(
                      // height: 85,
                      decoration: BoxDecoration(
                          color: LightprimaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              referCode,
                              style: TextStyle(
                                color: Color(0Xff525252),
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                        new ClipboardData(text: referCode))
                                    .then((_) {
                                  MethodUtils.showSuccess(
                                      context, "Invite code copied.");
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                width: 80,
                                height: 60,
                                child: Center(
                                    child: Text(
                                  'Copy',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                )),
                              ),
                            )
                            // Row(
                            //   // crossAxisAlignment: CrossAxisAlignment.center,
                            //   // mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     // Image(
                            //     //   image: AssetImage(
                            //     //     AppImages.copyIcon,
                            //     //   ),
                            //     //   height: 20,
                            //     //   color: Colors.white,
                            //     //   fit: BoxFit.fill,
                            //     // ),
                            //     // SizedBox(
                            //     //   width: 4,
                            //     // ),
                            //     // Text(
                            //     //   "Copy",
                            //     //   style: TextStyle(
                            //     //     color: Colors.white,
                            //     //     fontWeight: FontWeight.w500,
                            //     //     fontSize: 11,
                            //     //   ),
                            //     //   textAlign: TextAlign.center,
                            //     // ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //       image: DecorationImage(
                  //           image: AssetImage(
                  //     AppImages.copyIcons,
                  //   ))),
                  //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  //   // color: refercodecolor,
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 17),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Column(
                  //           children: [
                  //             Text(
                  //               "Your referral code:",
                  //               style: TextStyle(
                  //                 color: primaryColor,
                  //                 fontWeight: FontWeight.w500,
                  //                 fontSize: 11,
                  //               ),
                  //               textAlign: TextAlign.center,
                  //             ),
                  //             Text(
                  //               referCode,
                  //               style: TextStyle(
                  //                 color: primaryColor,
                  //                 fontWeight: FontWeight.w500,
                  //                 fontSize: 18,
                  //               ),
                  //               textAlign: TextAlign.center,
                  //             ),
                  //           ],
                  //         ),
                  //         new GestureDetector(
                  //           behavior: HitTestBehavior.translucent,
                  //           child: Row(
                  //             // crossAxisAlignment: CrossAxisAlignment.center,
                  //             // mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               Image(
                  //                 image: AssetImage(
                  //                   AppImages.copyIcon,
                  //                 ),
                  //                 height: 20,
                  //                 color: Colors.white,
                  //                 fit: BoxFit.fill,
                  //               ),
                  //               SizedBox(
                  //                 width: 4,
                  //               ),
                  //               Text(
                  //                 "Copy",
                  //                 style: TextStyle(
                  //                   color: Colors.white,
                  //                   fontWeight: FontWeight.w500,
                  //                   fontSize: 11,
                  //                 ),
                  //                 textAlign: TextAlign.center,
                  //               ),
                  //             ],
                  //           ),
                  //           onTap: () {
                  //             Clipboard.setData(
                  //                     new ClipboardData(text: referCode))
                  //                 .then((_) {
                  //               MethodUtils.showSuccess(
                  //                   context, "Invite code copied.");
                  //             });
                  //           },
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  Container(
                    margin: EdgeInsets.only(
                        top: 25, bottom: 15, left: 22, right: 15),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'How does it work?',
                      style: TextStyle(
                        color: Color(0xFF626262),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: Color(0xffededed))),
                    margin: EdgeInsets.only(left: 16, right: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: new Row(
                        children: [
                          new Container(
                            margin: EdgeInsets.only(right: 20),
                            height: 36,
                            width: 36,
                            child: new Image.asset(AppImages.referReferIcon,
                                fit: BoxFit.fill),
                          ),
                          new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              new Text(
                                'Invite your Friends',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                              ),
                              new Container(
                                margin: EdgeInsets.only(top: 5),
                                child: new Text(
                                  // 'Share Code',
                                  'Just share your referral code',
                                  style: TextStyle(
                                      color: Color(0xFF7f7f7f),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: Color(0xffededed))),
                    margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 20),
                            height: 36,
                            width: 36,
                            child: new Image.asset(AppImages.rupeeReferIcon,
                                fit: BoxFit.fill),
                          ),
                          new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              new Text(
                                'Signup & deposit',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                              ),
                              new Container(
                                margin: EdgeInsets.only(top: 5),
                                child: new Text(
                                  // 'Friend Deposits',
                                  'Refer your friends for signup and deposit',
                                  style: TextStyle(
                                      color: Color(0xFF7f7f7f),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: Color(0xffededed))),
                    margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 20),
                            height: 36,
                            width: 36,
                            child: new Image.asset(AppImages.bonusReferIcon,
                                fit: BoxFit.fill),
                          ),
                          new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (Both_earn!.isNotEmpty)
                                Text(
                                  '${Both_earn ?? ""}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                              if (Both_earn_stmt!.isNotEmpty)
                                new Container(
                                  width: 240,
                                  margin: EdgeInsets.only(top: 5),
                                  child: new Text(
                                    // 'You will get ₹100 & Your friend will get ₹300',
                                    '${Both_earn_stmt ?? ""}',
                                    style: TextStyle(
                                        color: Color(0xFF7f7f7f),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  is_lifetime_commission == "1"
                      ? Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              border: Border.all(color: Color(0xffededed))),
                          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 20),
                                  height: 36,
                                  width: 36,
                                  child: new Image.asset(
                                      AppImages.lifetimeReferIcon,
                                      fit: BoxFit.fill),
                                ),
                                new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (lifetime_commission!.isNotEmpty)
                                      Text(
                                        "${lifetime_commission ?? ""}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    if (lifetime_commission_stmt!.isNotEmpty)
                                      new Container(
                                        width: 240,
                                        margin: EdgeInsets.only(top: 5),
                                        child: new Text(
                                          '${lifetime_commission_stmt ?? ""}',
                                          style: TextStyle(
                                              color: Color(0xFF7f7f7f),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                  // Container(
                  //   decoration: BoxDecoration(
                  //       color: borderColor,
                  //       borderRadius: BorderRadius.all(Radius.circular(8)),
                  //       border: Border.all(color: Color(0xffededed))),
                  //   margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(10),
                  //     child: Row(
                  //       children: [
                  //         Container(
                  //           margin: EdgeInsets.only(right: 20),
                  //           height: 36,
                  //           width: 36,
                  //           child: new Image.asset(
                  //               AppImages.fiveFriendReferIcon,
                  //               fit: BoxFit.fill),
                  //         ),
                  //         new Text(
                  //           'Refer 5 users and get free entry',
                  //           style: TextStyle(
                  //               color: Color(0xFF2d2d2d),
                  //               fontSize: 12,
                  //               fontWeight: FontWeight.w700),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  DefaultButton(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(16, 20, 16, 20),
                    color: primaryColor,
                    text: "Refer Friend",
                    textcolor: Colors.white,
                    borderRadius: 30,
                    onpress: () {
                      _onShare(context);
                    },
                  )
                  // new Container(
                  //     width: MediaQuery.of(context).size.width,
                  //     height: 50,
                  //     margin: EdgeInsets.fromLTRB(20, 30, 20, 20),
                  //     child: RaisedButton(
                  //       textColor: Colors.white,
                  //       color: primaryColor,
                  //       child: Text(
                  //         'Refer Friend',
                  //         style: TextStyle(fontSize: 15),
                  //       ),
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(5)),
                  //       onPressed: () {
                  //         _onShare(context);
                  //       },
                  //     )),
                ],
              )
            ],
          ),
        ),
      ),
/*      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55), // Set this height
        child: Container(
          padding: EdgeInsets.only(top: 28),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              new GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => {Navigator.pop(context)},
                child: new Container(
                  padding: EdgeInsets.all(15),
                  alignment: Alignment.centerLeft,
                  child: new Container(
                    width: 16,
                    height: 16,
                    child: Image(
                      image: AssetImage(AppImages.backImageURL),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              new Container(
                child: new Text('Refer & Earn',
                    style: TextStyle(
                        fontFamily: "Roboto",
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18)),
              ),
            ],
          ),
        ),
      ),*/
    );
  }

  _onShare(BuildContext context) async {
    String shareBody = refer_msg
        // "Here's " +
        //     AppConstants.rupee +
        //     AppConstants.invite_bonus +
        //     " to play fantasy cricket with me On " +
        //     _packageInfo.appName +
        //     " Click " +
        //     shareLink! +
        //     " to download " +
        //     _packageInfo.appName +
        //     " app & use My code " +
        //     referCode +
        //     " To Register"
        ;
    final RenderBox box = context.findRenderObject() as RenderBox;
    await Share.share(shareBody,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
