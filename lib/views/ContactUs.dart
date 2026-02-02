import 'package:url_launcher/url_launcher.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:flutter/services.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/repository/model/banner_response.dart';

// import 'package:zendesk/zendesk.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  String _platformVersion = 'Unknown';
  // final Zendesk zendesk = Zendesk();
  var val;
  var groupValue;
  var _dropDownValue;
  String userName = '';
  String mobile = '';
  String email = '';
  String _accountKey = '7UXmll9t3CRqMSsp2u5G7ZPSuF8NEHLo';
  String _applicationId = '098384531b1a603b9e9b339b92dca9986c856ff9580c73a1';

  ContactInfo? contactInfo;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadContactInfo();
  }

  void _loadUserData() async {
    final name =
        await AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_NAME);
    final mobile = await AppPrefrence.getString(
        AppConstants.SHARED_PREFERENCE_USER_MOBILE);
    final email =
        await AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_EMAIL);

    setState(() {
      userName = name;
      this.mobile = mobile;
      this.email = email;
      // initZendesk();
    });
  }

  void _loadContactInfo() async {
    final info = await AppPrefrence.getContactInfo();
    setState(() {
      contactInfo = info;
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
      //color: primaryColor,
      height: MediaQuery.sizeOf(context).height,

      child: new Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(55), // Set this height
          child: Container(
            padding: EdgeInsets.only(
              top: 50,
              bottom: 12,
              left: 16,
            ),
            decoration: BoxDecoration(
                // image: DecorationImage(
                //     image:
                //         AssetImage("assets/images/Ic_creatTeamBackGround.png"),
                //     fit: BoxFit.cover)
                color: primaryColor),
            child: Row(
              children: [
                AppConstants.backButtonFunction(),
                Text("Contact Us",
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
          height: MediaQuery.sizeOf(context).height,
          decoration: BoxDecoration(
              // image: DecorationImage(
              // image: AssetImage(AppImages.contactUsBG), fit: BoxFit.cover),
              //color: Colors.white
              ),
          child: new Column(
            children: [
              new Container(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 60, bottom: 60),
                    child: new Image.asset(
                      AppImages.contactUsBgIcon,
                      height: 130,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 16),
                child: new Container(
                  alignment: Alignment.centerLeft,
                  child: new Text(
                      contactInfo?.title ?? 'Feel free to contact us at:',
                      style: TextStyle(
                          fontFamily: "Roboto",
                          color: Color(0xff0d141a),
                          fontWeight: FontWeight.normal,
                          fontSize: 16)),
                ),
              ),
              /*                  GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  child: new Container(
                                    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                    child: new Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: new Container(
                                        margin: EdgeInsets.all(20),
                                        child: new Row(
                                          children: [
                                            new Container(
                                              margin: EdgeInsets.only(right: 20),
                                              height: 60,
                                              width: 60,
                                              child: new Image.asset(
                                                  AppImages.contactChatIcon,
                                                  fit: BoxFit.fill),
                                            ),
                                            new Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                new Text(
                                                  'Chat with Us:',
                                                  style: TextStyle(fontFamily: "Roboto",
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                                new Container(
                                                  margin: EdgeInsets.only(top: 5),
                                                  child: new Text(
                                                    'We are live and ready to help!',
                                                    style: TextStyle(fontFamily: "Roboto",
                                                        color: Colors.grey,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w400),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    zendesk.setDepartment('Support').then((r) {
                                      print('startChat finished');
                                    }).catchError((e) {
                                      print('error $e');
                                    });
                                    zendesk
                                        .startChat(
                                      isPreChatFormEnabled: false,
                                      isAgentAvailabilityEnabled: true,
                                      isOfflineFormEnabled: false,
                                      isChatTranscriptPromptEnabled: true,
                                    )
                                        .then((r) {
                                      print('startChat finished');
                                    }).catchError((e) {
                                      print('error $e');
                                    });
                                  },
                                ),*/

              GestureDetector(
                onTap: () {
                  final email =
                      contactInfo?.email_detail ?? 'support@myrex11.in';
                  _launchURL('mailto:$email');
                },
                child: Card(
                  elevation: 0.5,
                  margin: EdgeInsets.only(left: 16, right: 16, top: 20),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0.7, color: borderColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      dense: true,
                      // minLeadingWidth: 0,
                      contentPadding: EdgeInsets.only(left: 7),
                      visualDensity: VisualDensity(horizontal: -2.0),
                      leading: Container(
                        decoration: BoxDecoration(),
                        child: new Image.asset(AppImages.emailContactIcon,
                            fit: BoxFit.fill),
                      ),
                      title: new Text(
                        'Email us:',
                        style: TextStyle(
                            fontFamily: "Roboto",
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                      ),
                      subtitle: new Container(
                        margin: EdgeInsets.only(top: 0),
                        child: new Text(
                          contactInfo?.email_detail ?? 'support@myrex11.in',
                          style: TextStyle(
                              fontFamily: "Roboto",
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (contactInfo?.mobile_detail != null &&
                  contactInfo!.mobile_detail!.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    final mobile =
                        contactInfo?.mobile_detail ?? '+91 1234567890';
                    if (mobile.contains('t.me') || mobile.contains('tg')) {
                      _launchTelegram(mobile);
                    } else {
                      _launchURL(mobile);
                    }
                  },
                  child: Card(
                    elevation: 0.5,
                    margin: EdgeInsets.only(left: 16, right: 16, top: 20),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.7, color: borderColor),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        dense: true,
                        // minLeadingWidth: 0,
                        contentPadding: EdgeInsets.only(left: 7),
                        visualDensity: VisualDensity(horizontal: -2.0),
                        leading: Container(
                          decoration: BoxDecoration(),
                          child: new Image.asset(AppImages.callContactIcon,
                              fit: BoxFit.fill),
                        ),
                        title: new Text(
                          'Live Support',
                          style: TextStyle(
                              fontFamily: "Roboto",
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: new Container(
                          margin: EdgeInsets.only(top: 0),
                          child: new Text(
                            contactInfo?.mobile_detail ?? '+91 1234567890',
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: 80,
              ),
              if ((contactInfo?.facebook != null &&
                      contactInfo!.facebook!.isNotEmpty) ||
                  (contactInfo?.instagram != null &&
                      contactInfo!.instagram!.isNotEmpty) ||
                  (contactInfo?.twitter != null &&
                      contactInfo!.twitter!.isNotEmpty) ||
                  (contactInfo?.youtube != null &&
                      contactInfo!.youtube!.isNotEmpty) ||
                  (contactInfo?.telegram != null &&
                      contactInfo!.telegram!.isNotEmpty) ||
                  (contactInfo?.whatsup != null &&
                      contactInfo!.whatsup!.isNotEmpty))
                Container(
                  // margin: EdgeInsets.only(left: 20),
                  alignment: Alignment.center,
                  child: new Text(
                    'Connect with us',
                    style: TextStyle(
                        fontFamily: "Roboto",
                        color: Color(0xFF767676),
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              // new Container(
              //   margin: EdgeInsets.only(left:10, right: 10, top: 25),
              //   child: new Card(
              //     shape: RoundedRectangleBorder(
              //         side: BorderSide(width: 2, color: Color(0xFFf9f9f9)),
              //       borderRadius: BorderRadius.circular(50.0),
              //     ),
              //     child: new Container(
              //       child: new Row(
              //         children: [
              //           new Container(
              //             decoration: BoxDecoration(
              //                 color: Colors.white,
              //                 borderRadius: BorderRadius.only(
              //                     topLeft: Radius.circular(50),
              //                     bottomLeft: Radius.circular(50))
              //
              //             ),
              //             margin: EdgeInsets.only(right: 20),
              //             height: 83,
              //             // width: 82,
              //             child: Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: new Image.asset(
              //                   AppImages.emailContactIcon,
              //                   fit: BoxFit.fill),
              //             ),
              //           ),
              //           Padding(
              //             padding:
              //                 const EdgeInsets.only(top: 20.0, bottom: 20),
              //             child: new Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 new Text(
              //                   'Email Us:',
              //                   style: TextStyle(fontFamily: "Roboto",
              //                       color: Colors.black,
              //                       fontSize: 16,
              //                       fontWeight: FontWeight.w500),
              //                 ),
              //                 new Container(
              //                   margin: EdgeInsets.only(top: 5),
              //                   child: new Text(
              //                     'support@focus11.in',
              //                     style: TextStyle(fontFamily: "Roboto",
              //                         color: Colors.grey,
              //                         fontSize: 16,
              //                         fontWeight: FontWeight.w400),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),

              SizedBox(
                height: 10,
              ),
              new Container(
                // margin: EdgeInsets.all(10),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (contactInfo?.facebook != null &&
                        contactInfo!.facebook!.isNotEmpty)
                      _buildSocialIcon(
                        AppImages.facebookIcon,
                        contactInfo!.facebook!,
                      ),
                    if (contactInfo?.instagram != null &&
                        contactInfo!.instagram!.isNotEmpty)
                      _buildSocialIcon(
                        AppImages.instaIcon,
                        contactInfo!.instagram!,
                      ),
                    if (contactInfo?.twitter != null &&
                        contactInfo!.twitter!.isNotEmpty)
                      _buildSocialIcon(
                        AppImages.twitterIcon,
                        contactInfo!.twitter!,
                      ),
                    if (contactInfo?.youtube != null &&
                        contactInfo!.youtube!.isNotEmpty)
                      _buildSocialIcon(
                        AppImages.youtubeIcon,
                        contactInfo!.youtube!,
                      ),
                    if (contactInfo?.telegram != null &&
                        contactInfo!.telegram!.isNotEmpty)
                      _buildSocialIcon(
                        AppImages.telegramIcon,
                        contactInfo!.telegram!,
                      ),
                    if (contactInfo?.whatsup != null &&
                        contactInfo!.whatsup!.isNotEmpty)
                      _buildSocialIcon(
                        AppImages.whatsappIcon,
                        contactInfo!.whatsup!,
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchTelegram(String rawUrl) async {
    String cleanUrl = rawUrl.trim();

    // Add scheme if missing
    if (!cleanUrl.startsWith('http') && !cleanUrl.startsWith('tg://')) {
      cleanUrl = 'https://$cleanUrl';
    }

    Uri webUri = Uri.parse(cleanUrl);

    // Extract username safely
    if (webUri.host.contains('t.me')) {
      final String? username =
          webUri.pathSegments.isNotEmpty ? webUri.pathSegments.first : null;

      if (username != null && username.isNotEmpty) {
        final Uri tgUri = Uri.parse('tg://resolve?domain=$username');

        try {
          await launchUrl(
            tgUri,
            mode: LaunchMode.externalApplication,
          );
          return;
        } catch (_) {
          // Telegram not available → fallback
        }
      }
    }

    // Final fallback (browser or Telegram auto-redirect)
    await launchUrl(
      webUri,
      mode: LaunchMode.externalApplication,
    );
  }

  Widget _buildSocialIcon(String iconAsset, String url) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        height: 40,
        width: 40,
        child: Image.asset(iconAsset, fit: BoxFit.fill),
      ),
      onTap: () => _launchURL(url),
    );
  }

  _launchURL(String url) async {
    print(['url', url]);
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print(['exception', e]);
    }
  }

  Future<void> openTelegram() async {
    final Uri tgUri = Uri.parse('tg://resolve?domain=mr11helpbot');
    final Uri webUri = Uri.parse('https://t.me/mr11helpbot');

    try {
      await launchUrl(
        tgUri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      // Android 8 fallback
      await launchUrl(
        webUri,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
