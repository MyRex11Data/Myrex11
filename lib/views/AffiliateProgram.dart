import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myrex11/views/AffiliateMatches.dart';
import 'package:myrex11/views/ReferList.dart';
import 'package:intl/intl.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/promoter_total_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';

class AffiliateProgram extends StatefulWidget {
  @override
  _AffiliateProgramState createState() => new _AffiliateProgramState();
}

class _AffiliateProgramState extends State<AffiliateProgram> {
  TextEditingController codeController = TextEditingController();
  bool _enable = false;
  String start_date = '';
  String end_date = '';
  late String userId = '0';
  PromoterTotalResult result = new PromoterTotalResult(
      winning: '0', deposit: '0', matches: '0', team_join: '0', aff_bal: '0');
  DateFormat dateFormat = new DateFormat("dd-MM-yyyy");
  DateFormat apDateFormat = new DateFormat("yyyy-MM-dd");
  bool detailsFetch = false;

  int total_referal_all = 0;
  @override
  void initState() {
    super.initState();

    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
        .then((value) => {
              setState(() {
                userId = value;
              })
            });
    AppPrefrence.getInt(AppConstants.TOTAL_REFERAL_COUNT, 0).then((value) => {
          setState(() {
            total_referal_all = value;
          })
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  safeAreaupdate(primarycolor) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: primarycolor,
            /* set Status bar color in Android devices. */

            statusBarIconBrightness: Brightness.light,
            /* set Status bar icons color in Android devices.*/

            statusBarBrightness:
                Brightness.dark) /* set Status bar icon color in iOS. */
        );
  }

  @override
  Widget build(BuildContext context) {
    safeAreaupdate(Colors.transparent);
    return new Scaffold(
      backgroundColor: Colors.white,
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(220), // Set this height
      //   child:

      // ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: primaryColor,

              // image: DecorationImage(
              //   image: AssetImage(
              //       "assets/images/Ic_creatTeamBackGround.png"), // Use NetworkImage for network images
              //   fit: BoxFit
              //       .fill, // Adjust this to control how the image is fitted
              // ),
            ),
            padding: EdgeInsets.only(top: 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 45, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      new GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => {Navigator.pop(context)},
                        child: new Container(
                          padding: EdgeInsets.only(
                              left: 16, right: 10, top: 0, bottom: 0),
                          alignment: Alignment.centerLeft,
                          child: new Container(
                            height: 30,
                            child: Image(
                              image: AssetImage(AppImages.backImageURL),
                              // color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      new Container(
                        child: new Text('Affiliate Dashboard',
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16)),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color: Color.fromARGB(255, 244, 194, 194),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 0, right: 0),
                  child: new Container(
                    decoration: BoxDecoration(
                        // color: Colors.white,
                        // borderRadius: BorderRadius.only(
                        //     topRight: Radius.circular(30),
                        //     bottomLeft: Radius.circular(20)
                        //     )
                        ),
                    child: new Column(
                      children: [
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: new GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () async {
                                  DateTime date = DateTime(1900);

                                  date = (await showDatePicker(
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary: primaryColor,
                                              // <-- SEE HERE
                                              onPrimary: Colors.white,
                                              // <-- SEE HERE
                                              onSurface:
                                                  primaryColor.withOpacity(
                                                      0.5), // <-- SEE HERE
                                            ),
                                            textButtonTheme:
                                                TextButtonThemeData(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors
                                                    .red, // button text color
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now()))!;
                                  start_date = dateFormat.format(date);
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 6),
                                        child: Text(
                                          'From Date',
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      new Container(
                                        alignment: Alignment.center,
                                        child: new Card(
                                          color: Color(0xffBB8EFF),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              side: BorderSide(
                                                  color: Colors.white,
                                                  width: 2)),
                                          child: new Container(
                                            height: 45,
                                            // width: 150,
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  new Text(
                                                    start_date.isEmpty
                                                        ? 'From Date'
                                                        : start_date,
                                                    style: TextStyle(
                                                      fontFamily: "Roboto",
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Container(
                                                    height: 16,
                                                    width: 16,
                                                    child: Image.asset(
                                                      AppImages.calendarIcon,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: new GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 6),
                                        child: Text(
                                          'End Date',
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      new Container(
                                        alignment: Alignment.center,
                                        child: new Card(
                                          color: Color(0xffBB8EFF),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              side: BorderSide(
                                                  color: Colors.white,
                                                  width: 2)),
                                          child: new Container(
                                            height: 45,
                                            // width: 150,
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  new Text(
                                                    end_date.isEmpty
                                                        ? 'To Date'
                                                        : end_date,
                                                    style: TextStyle(
                                                      fontFamily: "Roboto",
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Container(
                                                    height: 16,
                                                    width: 16,
                                                    child: Image.asset(
                                                      AppImages.calendarIcon,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () async {
                                  DateTime date = DateTime(1900);

                                  date = (await showDatePicker(
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary: primaryColor,
                                              // <-- SEE HERE
                                              onPrimary: Colors.white,
                                              // <-- SEE HERE
                                              onSurface:
                                                  primaryColor.withOpacity(
                                                      0.5), // <-- SEE HERE
                                            ),
                                            textButtonTheme:
                                                TextButtonThemeData(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors
                                                    .red, // button text color
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now()))!;

                                  end_date = dateFormat.format(date);
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 0, bottom: 15),
                          child: new GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            child: Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: new Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(AppImages.Btngradient),
                                      fit: BoxFit.fill),
                                  border: Border.all(
                                    color: Color(0xFF6A0BF8),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                // margin: EdgeInsets.only(left: 5),
                                alignment: Alignment.center,
                                child: new Text(
                                  'Get Details'.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            onTap: () {
                              if (start_date.isEmpty) {
                                MethodUtils.showError(
                                    context, "Please set a start date");
                              } else if (end_date.isEmpty) {
                                MethodUtils.showError(
                                    context, "Please set an end date");
                              } else {
                                getAffiliationTotal();
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 15, bottom: 10),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReferList(
                                // start_date: apDateFormat
                                //     .format(dateFormat.parse(start_date)),
                                // end_date: apDateFormat
                                //     .format(dateFormat.parse(end_date)),
                                //check: 'Affiliate'
                                ),
                          )).then((value) {
                        setState(() {
                          safeAreaupdate(Colors.transparent);
                        });
                      });
                      // if (start_date.isEmpty) {
                      //   MethodUtils.showError(
                      //       context, "Please set a start date");
                      // } else if (end_date.isEmpty) {
                      //   MethodUtils.showError(
                      //       context, "Please set an end date");
                      // } else if (detailsFetch == false ||
                      //     (int.parse(result.total_referal ?? '0')) == 0) {
                      //   MethodUtils.showError(context, 'No referal user.');
                      // } else {

                      // }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(color: borderColor),
                          color: LightprimaryColor),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            width: 50,
                            height: 50,
                            child: Image.asset(
                                AppImages.affiliaterefer.toString()),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Total Referral",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                total_referal_all.toString(),
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          trailing: new Container(
                            margin: EdgeInsets.only(right: 0),
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              AppImages.moreForwardIcon,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        image: DecorationImage(
                            image: AssetImage(AppImages.affilatebody),
                            fit: BoxFit.fill)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.all(color: borderColor),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                width: 50,
                                height: 50,
                                child: Image.asset(
                                    AppImages.affileatematch.toString()),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Total Matches",
                                    style: TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    result.matches.toString(),
                                    style: TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: GestureDetector(
                                onTap: () {
                                  if (start_date.isEmpty) {
                                    MethodUtils.showError(
                                        context, "Please set a start date");
                                  } else if (end_date.isEmpty) {
                                    MethodUtils.showError(
                                        context, "Please set an end date");
                                  } else if (detailsFetch == false ||
                                      (int.parse(result.matches ?? '0')) == 0) {
                                    MethodUtils.showError(
                                        context, 'No matches available.');
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AffiliateMatches(
                                                  apDateFormat.format(dateFormat
                                                      .parse(start_date)),
                                                  apDateFormat.format(dateFormat
                                                      .parse(end_date)),
                                                  userId),
                                        )).then((value) {
                                      setState(() {
                                        safeAreaupdate(Colors.transparent);
                                      });
                                    });
                                    // navigateToAffiliateMatches(
                                    //   context,
                                    //   apDateFormat
                                    //       .format(dateFormat.parse(start_date)),

                                    // );
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            AssetImage(AppImages.Btngradient),
                                        fit: BoxFit.fill),
                                    border: Border.all(
                                      color: Color(0xFF6A0BF8),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Text(
                                      'VIEW DETAILS',
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 8, vertical: 2),
                        //   child: Container(
                        //     height: 1.5,
                        //     width: MediaQuery.of(context).size.width,
                        //     decoration: BoxDecoration(
                        //         gradient: LinearGradient(colors: [
                        //       Color(0xff00bfbfbf),
                        //       Color(0xffbfbfbf),
                        //       Color(0xffbfbfbf),
                        //       Color(0xff00bfbfbf),
                        //     ])),
                        //   ),
                        // ),
                        SizedBox(
                          height: 15,
                        ),
                        historyCard(
                            color: Color(0xfff4cc95).withOpacity(0.3),
                            image: AppImages.affiliatecontest,
                            title: "Contest",
                            value: result.team_join,
                            rsIcon: false),
                        historyCard(
                            color: Color(0xffbafba9).withOpacity(0.3),
                            image: AppImages.affiliatedeposite,
                            title: "Deposit",
                            value: result.deposit,
                            rsIcon: true),
                        historyCard(
                            color: Color(0xffa9fbe1).withOpacity(0.3),
                            image: AppImages.affiliatewinning,
                            title: "Winning",
                            value: result.winning,
                            rsIcon: true),
                        historyCard(
                            color: Color(0xffa9effb).withOpacity(0.3),
                            image: AppImages.affiliaterefer,
                            title: "Referral",
                            value: result.total_referal ?? '0',
                            rsIcon: false),
                        historyCard(
                            color: Color(0xff076e39),
                            image: AppImages.totalearning,
                            title: "Total Earning",
                            value: result.total_earning ?? '0',
                            rsIcon: true),
                        SizedBox(
                          height: 4,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                border: Border.all(color: borderColor),
                                color: LightprimaryColor),
                            // decoration: BoxDecoration(
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(6)),
                            //     image: DecorationImage(
                            //         image: AssetImage(
                            //           AppImages.affiliatebalance,
                            //         ),
                            //         fit: BoxFit.fill)),
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 14, right: 14, top: 16, bottom: 16),
                                child: Container(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Affiliate Balance:",
                                          style: TextStyle(
                                            // fontFamily: "Roboto",
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 6),
                                              child: Container(
                                                height: 18,
                                                width: 18,
                                                child: Image.asset(
                                                    AppImages.goldcoin),
                                              ),
                                            ),
                                            Text(
                                              result.aff_bal.toString(),
                                              style: TextStyle(
                                                // fontFamily: "Roboto",
                                                fontSize: 18,
                                                color: const Color.fromARGB(
                                                    255, 90, 88, 88),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget historyCard({
    required Color color,
    required String image,
    required String title,
    required String? value,
    required bool? rsIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: borderColor),
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      // padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 32,
                  width: 32,
                  child: Image.asset(
                    image.toString(),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: "Roboto",
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (rsIcon == true)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Container(
                      height: 18,
                      width: 18,
                      child: Image.asset(AppImages.goldcoin),
                    ),
                  ),
                Text(
                  value ?? "0",
                  style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16,
                    color: title == 'Total Earning'
                        ? Color(0xff076e39)
                        : Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void getAffiliationTotal() async {
    AppLoaderProgress.showLoader(context);

    Map<String, dynamic> loginRequest = {
      'user_id': userId,
      'start_date': start_date.isEmpty
          ? ''
          : apDateFormat.format(dateFormat.parse(start_date)),
      'end_date': end_date.isEmpty
          ? ''
          : apDateFormat.format(dateFormat.parse(end_date))
    };

    try {
      final client = ApiClient(AppRepository.dio); // token auto included!
      PromoterTotalResponse loginResponse =
          await client.getAffiliationTotal(loginRequest);

      AppLoaderProgress.hideLoader(context);

      if (loginResponse.status == 1) {
        setState(() {
          result = loginResponse.result!;
          detailsFetch = true;
        });
      } else {
        setState(() {
          detailsFetch = false;
        });
      }
    } catch (e) {
      AppLoaderProgress.hideLoader(context);
      MethodUtils.showError(context, "Error: $e");
    }
  }
}
