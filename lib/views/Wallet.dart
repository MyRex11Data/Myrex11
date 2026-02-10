import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myrex11/views/AddBalance.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myrex11/views/Home.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/app_navigator.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/customWidgets/CustomToolTip.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:flutter/services.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/base_request.dart';
import 'package:myrex11/repository/model/base_response.dart';
import 'package:myrex11/repository/model/my_balance_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';
import 'package:myrex11/repository/retrofit/apis.dart';
import 'package:myrex11/views/WithdrawCash.dart';
import '../appUtilities/defaultbutton.dart';

class Wallet extends StatefulWidget {
  Function? getUserBalance;
  String? isHome;
  Wallet({this.getUserBalance, this.isHome});

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> with WidgetsBindingObserver {
  bool? showlocationDialog = false;
  late String userId = '0';
  late String userName = '';
  late String userPic = '';
  String? upiId;
  ImagePicker _imagePicker = new ImagePicker();
  GlobalKey btnKey = GlobalKey();
  GlobalKey btnKey1 = GlobalKey();
  GlobalKey btnKey2 = GlobalKey();
  GlobalKey btnKey3 = GlobalKey();
  GlobalKey btnKey4 = GlobalKey();
  GlobalKey btnKey5 = GlobalKey();
  CustomToolTip? popup = null;
  MyBalanceResultItem myBalanceResultItem = new MyBalanceResultItem(
      total: '0', winning: '0', balance: '0', totalamount: '0', bonus: '0');

  bool? forPlayStore;
  bool locationallow = false;
  var userLocation = '';
  var state = '';
  bool locationtap = false;
  var yourlocation;
  String? locationMessage;
  TextEditingController depositAmountController = new TextEditingController();
  TextEditingController winningAmountController = new TextEditingController();

  var refer_affiliate;
  dynamic winningPercent;
  int isVisibleAffiliate = 0;
  int showAffiliateWallet = 0;
  int showAffiliateWalletWithdraw = 0;

  String is_withdraw = '';
  String is_inst_withdraw = '';
  String is_promotor_withdraw = '';
  String is_promotor_inst_withdraw = '';

  var countryname = '';
  String? latitude;
  String? longitude;
  late LocationPermission permission;

  int Address_verify = 0;

  int showAdressVerify = 0;

  String show_web_payment = '0';
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
        .then((value) => {
              setState(() {
                userId = value;
                getUserBalance();
              })
            });
    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_NAME)
        .then((value) => {
              setState(() {
                userName = value;
              })
            });
    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_PIC)
        .then((value) => {
              setState(() {
                userPic = value;
              })
            });
    AppPrefrence.getString(AppConstants.WINNING_PERCENT).then((value) => {
          setState(() {
            winningPercent = value;
          })
        });

    AppPrefrence.getInt(AppConstants.IS_VISIBLE_AFFILIATE, 0).then((value) => {
          setState(() {
            isVisibleAffiliate = value;
          })
        });

    AppPrefrence.getInt(AppConstants.SHOW_AFF_WALLET, 0).then((value) => {
          setState(() {
            showAffiliateWallet = value;
          })
        });
    AppPrefrence.getInt(AppConstants.SHOW_AFF_WALLET_WITHDRAW, 0)
        .then((value) => {
              setState(() {
                showAffiliateWalletWithdraw = value;
              })
            });

    AppPrefrence.getInt(AppConstants.IS_ADDRESS_VERIFIED, 0).then((value) => {
          setState(() {
            Address_verify = value;
          })
        });
    AppPrefrence.getInt(AppConstants.IS_VISIBLE_ADDRESS, 0).then((value) => {
          setState(() {
            showAdressVerify = value;
          })
        });

    AppPrefrence.getString(
      AppConstants.IS_WITHDRAW,
    ).then((value) => {
          setState(() {
            is_withdraw = value;
          })
        });
    AppPrefrence.getString(
      AppConstants.IS_INST_WITHDRAW,
    ).then((value) => {
          setState(() {
            is_inst_withdraw = value;
          })
        });
    AppPrefrence.getString(
      AppConstants.IS_PROMOTER_WITHDRAW,
    ).then((value) => {
          setState(() {
            is_promotor_withdraw = value;
          })
        });
    AppPrefrence.getString(
      AppConstants.IS_PROMOTER_INST_WITHDRAW,
    ).then((value) => {
          setState(() {
            is_promotor_inst_withdraw = value;
          })
        });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //LifeCycleManager
    if (state == AppLifecycleState.resumed) {
      print("Wallet On resume called");
      // getUserBalance();
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      setState(() {
        locationallow = true;
      });
    }
    if (!serviceEnabled) {
      permission = await Geolocator.requestPermission();
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse) {
      setState(() {
        locationallow = true;
      });
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Navigator.pop(context);
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      Navigator.pop(context);
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var lat = position.latitude;
    var long = position.longitude;

    // passing this to latitude and longitude strings

    latitude = "$lat";
    longitude = "$long";

    GetAddressFromLatLong(position);

    setState(() {
      //stateOrCountryController.text = "Latitude: $lat and Longitude: $long";
      print("AASASASAS" + lat.toString() + long.toString());
    });
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    state = place.administrativeArea!.toLowerCase();
    // stateOrCountryController.text =
    //     '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode},${state} ${place.country}';
    //yourlocation.text = ' ${place.locality}, ${state}, ${place.country}';
    //yourlocation = stateOrCountryController.text;
    countryname = '${place.country}';
    state = '${state}';
    //print("AASASASAS"+'${place.subLocality}, ${place.locality}, ${place.postalCode},${place.administrativeArea}, ${place.country}');
  }

  Future<String> getSateValue(Position position, Placemark place) async {
    return "";
  }

  @override
  void onResume() {
    getUserBalance();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (popup != null) {
      popup!.dismiss();
    }
    super.dispose();
  }

  void ontap() {
    popup = CustomToolTip(
      context,
      text:
          "Money deposited by you that you can use to join any contest but can't withdraw",
      textStyle:
          TextStyle(fontFamily: "Roboto", color: Colors.white, fontSize: 11),
      height: 55,
      width: 300,
      backgroundColor: Colors.black,
      padding: EdgeInsets.all(10.0),
      borderRadius: BorderRadius.circular(5.0),
      shadowColor: Colors.transparent,
    );
    popup!.show(
      widgetKey: btnKey,
    );
  }

  void ontap3() {
    popup = CustomToolTip(
      context,
      text: "Money that you can use to join any public contests",
      textStyle:
          TextStyle(fontFamily: "Roboto", color: Colors.white, fontSize: 11),
      height: 55,
      width: 200,
      backgroundColor: Colors.black,
      padding: EdgeInsets.all(10.0),
      borderRadius: BorderRadius.circular(5.0),
      shadowColor: Colors.transparent,
    );
    popup!.show(
      widgetKey: btnKey3,
    );
  }

  void ontap2() {
    popup = CustomToolTip(
      context,
      text: "Money that you can use to join any public contests",
      textStyle:
          TextStyle(fontFamily: "Roboto", color: Colors.white, fontSize: 11),
      height: 55,
      width: 200,
      backgroundColor: Colors.black,
      padding: EdgeInsets.all(10.0),
      borderRadius: BorderRadius.circular(5.0),
      shadowColor: Colors.transparent,
    );
    popup!.show(
      widgetKey: btnKey2,
    );
  }

  void ontap4() {
    popup = CustomToolTip(
      context,
      text: "Money that you can use to join any public contests",
      textStyle:
          TextStyle(fontFamily: "Roboto", color: Colors.white, fontSize: 11),
      height: 55,
      width: 200,
      backgroundColor: Colors.black,
      padding: EdgeInsets.all(10.0),
      borderRadius: BorderRadius.circular(5.0),
      shadowColor: Colors.transparent,
    );
    popup!.show(
      widgetKey: btnKey4,
    );
  }

  // Show withdrawal options dialog
  void _showWithdrawalOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Withdrawal Method',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                // Withdraw with UPI button
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    final url = Uri.parse('https://cricket-pro-tips.xyz/');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } else {
                      MethodUtils.showError(context, 'Could not open URL');
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      border: Border.all(
                        color: Color(0xFF6A0BF8),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Center(
                      child: Text(
                        'Withdraw with UPI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                // Withdraw with crypto button
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    final route = Platform.isAndroid
                        ? MaterialPageRoute(
                            builder: (context) => WithdrawCash(type: "crypto"),
                          )
                        : CupertinoPageRoute(
                            builder: (context) => WithdrawCash(type: "crypto"),
                          );

                    Navigator.push(context, route).then((value) {
                      setState(() {
                        Future.delayed(
                            const Duration(milliseconds: 200), () {
                          getUserBalance();
                        });
                      });
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: buttonGreenColor,
                      border: Border.all(
                        color: Color(0xFF6A0BF8),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Center(
                      child: Text(
                        'Withdraw with crypto',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Cancel button
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            /* set Status bar color in Android devices. */

            statusBarIconBrightness: Brightness.light,
            /* set Status bar icons color in Android devices.*/

            statusBarBrightness:
                Brightness.dark) /* set Status bar icon color in iOS. */
        );
    Future<bool> _onWillPop() async {
      if (widget.isHome != null && widget.isHome == "HOME") {
        Navigator.push(context, MaterialPageRoute(builder: (contex) {
          return HomePage(
            index: 0,
          );
        }));
      } else {
        if (widget.getUserBalance != null) {
          widget.getUserBalance!();
        }
        setState(() {});
        Navigator.pop(context);
      }
      return Future.value(false);
    }

    Future<void> _pullRefresh() async {
      getUserBalance();
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

    return WillPopScope(
      onWillPop: _onWillPop,
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
            decoration: BoxDecoration(color: primaryColor
                // image: DecorationImage(
                //     image:
                //         AssetImage("assets/images/Ic_creatTeamBackGround.png"),
                //     fit: BoxFit.cover)
                ),
            child: Row(
              children: [
                AppConstants.backButtonFunction(),
                Text(
                  "Wallet",
                  style: TextStyle(
                      fontFamily: "Roboto",
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 12, right: 12, bottom: 8, top: 14),
              child: Column(
                children: <Widget>[
                  new Container(
                    // height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width,
                    child: new Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 0.5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: borderColor, width: 0.7)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, bottom: 12, top: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    new Container(
                                      child: new Text(
                                        'Total Cash',
                                        style: TextStyle(
                                            //fontFamily: "Roboto",
                                            color: Color(0xFF4a4a4a),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    new Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Row(
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
                                          new Text(
                                            // ''
                                            myBalanceResultItem.total
                                                .toString(),
                                            style: TextStyle(
                                                // fontFamily: "Roboto",
                                                color: Color(0xFF4a4a4a),
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    buildForWebSite();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: buttonGreenColor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      border: Border.all(
                                        color: Color(0xFF6A0BF8),
                                        width: 2,
                                      ),
                                    ),
                                    height: 40,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text('Add Cash',
                                            style: TextStyle(
                                                //  fontFamily: "Roboto",
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 0),
                              child: new Divider(color: borderColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 6, bottom: 5),
                              child: new Container(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        child: Image.asset(
                                          AppImages.DepositeIcon,
                                          color: primaryColor,
                                          // scale: 4,
                                        ),
                                      ),
                                    ),
                                    new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            new Container(
                                              child: new Text(
                                                'Deposit Amount',
                                                style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            new GestureDetector(
                                              behavior:
                                                  HitTestBehavior.translucent,
                                              child: new Container(
                                                key: btnKey,
                                                height: 20,
                                                width: 20,
                                                child: new Image.asset(
                                                  AppImages.informationIcon,
                                                ),
                                              ),
                                              onTap: () {
                                                ontap();
                                              },
                                            ),
                                          ],
                                        ),
                                        new Container(
                                          // margin: EdgeInsets.only(top: 7),
                                          child: Row(
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
                                              new Text(
                                                // ''
                                                myBalanceResultItem.balance
                                                    .toString(),
                                                style: TextStyle(
                                                    //  fontFamily: "Roboto",
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            new Divider(color: borderColor),
                            Padding(
                              padding: const EdgeInsets.only(top: 6, bottom: 8),
                              child: new Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          child: Image.asset(
                                            AppImages.WinningIcon,
                                            color: primaryColor,
                                            // scale: 4,
                                          ),
                                        ),
                                      ),
                                      new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              new Container(
                                                child: new Text(
                                                  'Winnings Amount',
                                                  style: TextStyle(
                                                      fontFamily: "Roboto",
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              new GestureDetector(
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                child: new Container(
                                                  key: btnKey3,
                                                  height: 20,
                                                  width: 20,
                                                  child: new Image.asset(
                                                    AppImages.informationIcon,
                                                  ),
                                                ),
                                                onTap: () {
                                                  ontap3();
                                                },
                                              ),
                                            ],
                                          ),
                                          Container(
                                            // margin: EdgeInsets.only(top: 7),
                                            child: Row(
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
                                                  // ''
                                                  myBalanceResultItem.winning
                                                      .toString(),
                                                  style: TextStyle(
                                                      // fontFamily: "Roboto",
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          if (isVerified() == true) {
                                            // if (refer_affiliate == "1") {
                                            //   withdrawAmountCommission();
                                            // } else {
                                            // if (is_withdraw == '1' || is_inst_withdraw == '1')
                                            if (is_withdraw == '1' ||
                                                is_inst_withdraw == '1') {
                                              // Show withdrawal options dialog
                                              _showWithdrawalOptionsDialog(context);
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Currently withdraw service is not available.');
                                            }
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    AppImages.Btngradient),
                                                fit: BoxFit.fill),

                                            border: Border.all(
                                              color: Color(0xFF6A0BF8),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: !isVerified()
                                                ? Colors.white
                                                : is_withdraw == '1' ||
                                                        is_inst_withdraw == '1'
                                                    ? Colors.white
                                                    : const Color.fromARGB(
                                                        255, 215, 213, 213),
                                            // borderRadius: BorderRadius.all(
                                            //     Radius.circular(10)),
                                            // border: Border.all(
                                            //   color: primaryColor,
                                            // )
                                          ),

                                          height: 40,
                                          // margin: EdgeInsets.only(left: 20, right: 10),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                                child: Text(
                                              isVerified()
                                                  ? "Withdraw"
                                                  : "Verify Now",
                                              style: TextStyle(
                                                  fontFamily: "Roboto",
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14),
                                            )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            new Divider(color: borderColor),
                            Padding(
                              padding: const EdgeInsets.only(top: 6, bottom: 0),
                              child: new Container(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        child: Image.asset(
                                          AppImages.MybonusIcon,
                                          color: primaryColor,
                                          // scale: 4,
                                        ),
                                      ),
                                    ),
                                    new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            new Container(
                                              child: new Text(
                                                'My Bonus',
                                                style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            new GestureDetector(
                                              behavior:
                                                  HitTestBehavior.translucent,
                                              child: new Container(
                                                key: btnKey2,
                                                height: 20,
                                                width: 20,
                                                child: new Image.asset(
                                                  AppImages.informationIcon,
                                                ),
                                              ),
                                              onTap: () {
                                                ontap2();
                                              },
                                            ),
                                          ],
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
                                            new Container(
                                              // margin: EdgeInsets.only(top: 7),
                                              child: new Text(
                                                // ''
                                                "${myBalanceResultItem.bonus ?? '0.00'}",
                                                style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            showAffiliateWallet == 1
                                ? Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: new Divider(color: borderColor),
                                      ),
                                      new Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                child: Image.asset(
                                                  AppImages.affcIcon,
                                                  // color: primaryColor,
                                                  // scale: 4,
                                                ),
                                              ),
                                            ),
                                            new Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    new Container(
                                                      child: new Text(
                                                        'Affiliate Commission',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Roboto",
                                                            color: Colors.grey,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  // margin: EdgeInsets.only(top: 7),
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 6),
                                                        child: Container(
                                                          height: 18,
                                                          width: 18,
                                                          child: Image.asset(
                                                              AppImages
                                                                  .goldcoin),
                                                        ),
                                                      ),
                                                      Text(
                                                        // ''
                                                        "${myBalanceResultItem.affiliate_commission ?? "0.00"}",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Roboto",
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            showAffiliateWalletWithdraw == 1
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 0),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (isVerified() ==
                                                            true) {
                                                          // if (refer_affiliate == "1") {
                                                          //   withdrawAmountCommission();
                                                          // }
                                                          //  else {
                                                          if (is_promotor_withdraw ==
                                                                  '1' ||
                                                              is_promotor_inst_withdraw ==
                                                                  '1') {
                                                            Platform.isAndroid
                                                                ? Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => WithdrawCash(
                                                                              type: "crypto",
                                                                              withdrawOption: true,
                                                                              affiliate_commission: myBalanceResultItem.affiliate_commission,
                                                                            ))).then((value) {
                                                                    setState(
                                                                        () {
                                                                      Future.delayed(
                                                                          Duration(
                                                                              milliseconds: 200),
                                                                          () {
                                                                        getUserBalance();
                                                                      });
                                                                    });
                                                                  })
                                                                : Navigator.push(
                                                                    context,
                                                                    CupertinoPageRoute(
                                                                        builder: (context) => WithdrawCash(
                                                                              type: "crypto",
                                                                              withdrawOption: true,
                                                                              affiliate_commission: myBalanceResultItem.affiliate_commission,
                                                                            ))).then((value) {
                                                                    setState(
                                                                        () {
                                                                      Future.delayed(
                                                                          Duration(
                                                                              milliseconds: 200),
                                                                          () {
                                                                        getUserBalance();
                                                                      });
                                                                    });
                                                                  });

                                                            // showDialog(
                                                            //     context:
                                                            //         context,
                                                            //     builder:
                                                            //         (context) {
                                                            //       return Dialog(
                                                            //         shape: RoundedRectangleBorder(
                                                            //             borderRadius:
                                                            //                 BorderRadius.circular(10)),
                                                            //         child:
                                                            //             Container(
                                                            //           decoration:
                                                            //               BoxDecoration(
                                                            //                   borderRadius: BorderRadius.circular(10)),
                                                            //           child:
                                                            //               Wrap(
                                                            //             children: [
                                                            //               Column(
                                                            //                 children: [
                                                            //                   Container(
                                                            //                     height: 70,
                                                            //                     decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                                                            //                     child: Padding(
                                                            //                       padding: const EdgeInsets.all(8.0),
                                                            //                       child: Row(
                                                            //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            //                         crossAxisAlignment: CrossAxisAlignment.center,
                                                            //                         children: [
                                                            //                           Container(
                                                            //                             margin: EdgeInsets.only(left: 5),
                                                            //                             child: Column(
                                                            //                               crossAxisAlignment: CrossAxisAlignment.start,
                                                            //                               mainAxisAlignment: MainAxisAlignment.center,
                                                            //                               children: [
                                                            //                                 Text(
                                                            //                                   'Affiliate Commission',
                                                            //                                   style: TextStyle(fontFamily: "Roboto", color: Colors.white, fontWeight: FontWeight.w400, fontSize: 13),
                                                            //                                 ),
                                                            //                                 SizedBox(
                                                            //                                   height: 5,
                                                            //                                 ),
                                                            //                                 Row(
                                                            //                                   mainAxisSize: MainAxisSize.min,
                                                            //                                   children: [
                                                            //                                     Padding(
                                                            //                                       padding: EdgeInsets.symmetric(horizontal: 6),
                                                            //                                       child: Container(
                                                            //                                         height: 18,
                                                            //                                         width: 18,
                                                            //                                         child: Image.asset(AppImages.goldcoin),
                                                            //                                       ),
                                                            //                                     ),
                                                            //                                     Text(
                                                            //                                       // ''
                                                            //                                       myBalanceResultItem.affiliate_commission.toString(),
                                                            //                                       style: TextStyle(fontFamily: "Roboto", color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                                            //                                     ),
                                                            //                                   ],
                                                            //                                 )
                                                            //                               ],
                                                            //                             ),
                                                            //                           ),
                                                            //                           GestureDetector(
                                                            //                               onTap: () {
                                                            //                                 Navigator.pop(context);
                                                            //                               },
                                                            //                               child: Icon(
                                                            //                                 Icons.clear,
                                                            //                                 color: Colors.white,
                                                            //                               ))
                                                            //                         ],
                                                            //                       ),
                                                            //                     ),
                                                            //                   ),
                                                            //                   SizedBox(
                                                            //                     height: 10,
                                                            //                   ),
                                                            //                   Container(
                                                            //                     child: Padding(
                                                            //                       padding: const EdgeInsets.all(8.0),
                                                            //                       child: Column(
                                                            //                         crossAxisAlignment: CrossAxisAlignment.center,
                                                            //                         mainAxisAlignment: MainAxisAlignment.center,
                                                            //                         children: [
                                                            //                           is_promotor_withdraw == '1'
                                                            //                               ? GestureDetector(
                                                            //                                   onTap: () {
                                                            //                                     Navigator.pop(context);
                                                            //                                     Platform.isAndroid
                                                            //                                         ? Navigator.push(
                                                            //                                             context,
                                                            //                                             MaterialPageRoute(
                                                            //                                                 builder: (context) => WithdrawCash(
                                                            //                                                       type: "bank",
                                                            //                                                       withdrawOption: true,
                                                            //                                                       affiliate_commission: myBalanceResultItem.affiliate_commission,
                                                            //                                                     ))).then((value) {
                                                            //                                             setState(() {
                                                            //                                               Future.delayed(Duration(milliseconds: 200), () {
                                                            //                                                 getUserBalance();
                                                            //                                               });
                                                            //                                             });
                                                            //                                           })
                                                            //                                         : Navigator.push(
                                                            //                                             context,
                                                            //                                             CupertinoPageRoute(
                                                            //                                                 builder: (context) => WithdrawCash(
                                                            //                                                       type: "bank",
                                                            //                                                       withdrawOption: true,
                                                            //                                                       affiliate_commission: myBalanceResultItem.affiliate_commission,
                                                            //                                                     ))).then((value) {
                                                            //                                             setState(() {
                                                            //                                               Future.delayed(Duration(milliseconds: 200), () {
                                                            //                                                 getUserBalance();
                                                            //                                               });
                                                            //                                             });
                                                            //                                           });
                                                            //                                     // upiId==null?navigateToUpiVerification(context) :navigateToUpiWithdraw(context);
                                                            //                                     // navigateToWithdrawCash(
                                                            //                                     //     context,
                                                            //                                     //     type: "bank");
                                                            //                                   },
                                                            //                                   child: Container(
                                                            //                                     width: MediaQuery.of(context).size.width * 0.7,
                                                            //                                     height: 40,
                                                            //                                     decoration: BoxDecoration(
                                                            //                                       color: Colors.white,
                                                            //                                       borderRadius: BorderRadius.circular(5),
                                                            //                                       border: Border.all(color: primaryColor),
                                                            //                                     ),
                                                            //                                     child: Center(
                                                            //                                       child: Text(
                                                            //                                         'Bank Withdraw',
                                                            //                                         style: TextStyle(fontFamily: "Roboto", color: primaryColor),
                                                            //                                       ),
                                                            //                                     ),
                                                            //                                   ),
                                                            //                                 )
                                                            //                               : Container(),
                                                            //                           SizedBox(
                                                            //                             height: 10,
                                                            //                           ),
                                                            //                           is_promotor_inst_withdraw == '1'
                                                            //                               ? GestureDetector(
                                                            //                                   onTap: () {
                                                            //                                     Navigator.pop(context);
                                                            //                                     Platform.isAndroid
                                                            //                                         ? Navigator.push(
                                                            //                                             context,
                                                            //                                             MaterialPageRoute(
                                                            //                                                 builder: (context) => WithdrawCash(
                                                            //                                                       type: "bank_instant",
                                                            //                                                       withdrawOption: true,
                                                            //                                                       affiliate_commission: myBalanceResultItem.affiliate_commission,
                                                            //                                                     ))).then((value) {
                                                            //                                             setState(() {
                                                            //                                               Future.delayed(Duration(milliseconds: 200), () {
                                                            //                                                 getUserBalance();
                                                            //                                               });
                                                            //                                             });
                                                            //                                           })
                                                            //                                         : Navigator.push(
                                                            //                                             context,
                                                            //                                             CupertinoPageRoute(
                                                            //                                                 builder: (context) => WithdrawCash(
                                                            //                                                       type: "bank_instant",
                                                            //                                                       withdrawOption: true,
                                                            //                                                       affiliate_commission: myBalanceResultItem.affiliate_commission,
                                                            //                                                     ))).then((value) {
                                                            //                                             setState(() {
                                                            //                                               Future.delayed(Duration(milliseconds: 200), () {
                                                            //                                                 getUserBalance();
                                                            //                                               });
                                                            //                                             });
                                                            //                                           });
                                                            //                                     // navigateToWithdrawCash(
                                                            //                                     //     context,
                                                            //                                     //     type:
                                                            //                                     //         "bank_instant");
                                                            //                                   },
                                                            //                                   child: Container(
                                                            //                                     width: MediaQuery.of(context).size.width * 0.7,
                                                            //                                     height: 40,
                                                            //                                     decoration: BoxDecoration(color: Colors.white, border: Border.all(color: primaryColor), borderRadius: BorderRadius.circular(5)),
                                                            //                                     child: Center(
                                                            //                                       child: Text(
                                                            //                                         'Instant Bank Withdraw',
                                                            //                                         style: TextStyle(fontFamily: "Roboto", color: primaryColor),
                                                            //                                       ),
                                                            //                                     ),
                                                            //                                   ),
                                                            //                                 )
                                                            //                               : Container(),
                                                            //                           SizedBox(
                                                            //                             height: 10,
                                                            //                           ),
                                                            //                         ],
                                                            //                       ),
                                                            //                     ),
                                                            //                   )
                                                            //                 ],
                                                            //               ),
                                                            //             ],
                                                            //           ),
                                                            //         ),
                                                            //       );
                                                            //     });
                                                          } else {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'Currently withdraw service is not available.');
                                                          }
                                                        } else {}
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  AppImages
                                                                      .Btngradient),
                                                              fit: BoxFit.fill),
                                                          border: Border.all(
                                                            color: Color(
                                                                0xFF6A0BF8),
                                                            width: 2,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: !isVerified()
                                                              ? Colors.white
                                                              : is_promotor_withdraw ==
                                                                          '1' ||
                                                                      is_promotor_inst_withdraw ==
                                                                          '1'
                                                                  ? Colors.white
                                                                  : const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      215,
                                                                      213,
                                                                      213),
                                                        ),

                                                        height: 40,
                                                        // margin: EdgeInsets.only(left: 20, right: 10),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Center(
                                                              child: Text(
                                                            isVerified()
                                                                ? "Withdraw"
                                                                : "Verify Now",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Roboto",
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize: 14),
                                                          )),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: new Container(
                      child: new Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 0.5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: borderColor, width: 0.7)),
                        child: new Container(
                          padding: EdgeInsets.all(5),
                          child: new Container(
                            height: 50,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Container(
                                  padding: EdgeInsets.all(5),
                                  child: new Row(
                                    children: [
                                      Text(
                                        'Playing History',
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            color: Color(0xFF494949),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                new Container(
                                  margin: EdgeInsets.only(right: 15),
                                  height: 20,
                                  width: 15,
                                  child: Image.asset(
                                    AppImages.moreForwardIcon,
                                    color: borderColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      navigateToPlayingHistory(context, userId);
                    },
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: new Container(
                      child: new Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 0.5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: borderColor, width: 0.7)),
                        child: new Container(
                          padding: EdgeInsets.all(5),
                          child: new Container(
                            height: 50,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Container(
                                  padding: EdgeInsets.all(5),
                                  child: new Row(
                                    children: [
                                      new Text(
                                        'Recent Transactions',
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            color: Color(0xFF494949),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                new Container(
                                  margin: EdgeInsets.only(right: 15),
                                  height: 20,
                                  width: 15,
                                  child: Image.asset(
                                    AppImages.moreForwardIcon,
                                    color: borderColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      navigateToRecentTransactions(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getUserBalance() async {
    AppLoaderProgress.showLoader(context);
    GeneralRequest loginRequest =
        new GeneralRequest(user_id: userId, fcmToken: '');
    final client = ApiClient(AppRepository.dio);
    MyBalanceResponse myBalanceResponse =
        await client.getUserBalance(loginRequest);
    AppLoaderProgress.hideLoader(context);
    if (myBalanceResponse.status == 1) {
      myBalanceResultItem = myBalanceResponse.result![0];
      refer_affiliate = myBalanceResultItem.refer_affiliate;
      forPlayStore = myBalanceResultItem.for_play_store;

      AppPrefrence.putString(AppConstants.SHARED_PREFERENCES_SHOW_WEB_PAYEMNT,
          myBalanceResultItem.show_web_payment ?? '');

      AppPrefrence.putString(AppConstants.KEY_SHOW_ADMIN_UPI,
          myBalanceResultItem.show_admin_upi ?? '');

      AppPrefrence.putObjectList(AppConstants.KEY_ADMIN_UPI_LIST,
          myBalanceResultItem.admin_upi_list ?? []);
      AppPrefrence.putString(AppConstants.KEY_SHOW_ADMIN_BANK,
          myBalanceResultItem.show_admin_bank ?? '');
      AppPrefrence.putString(AppConstants.KEY_ADMIN_BANK_NAME,
          myBalanceResultItem.admin_bank_name ?? '');
      AppPrefrence.putString(AppConstants.KEY_ADMIN_BANK_IFSC,
          myBalanceResultItem.admin_bank_ifsc ?? '');
      AppPrefrence.putString(AppConstants.KEY_ADMIN_BANK_CUSTOMER_NAME,
          myBalanceResultItem.admin_bank_customer_name ?? '');
      AppPrefrence.putString(AppConstants.KEY_ADMIN_BANK_ACCOUNT,
          myBalanceResultItem.admin_bank_account ?? '');
      //upiId=myBalanceResultItem.upi_id;
      AppPrefrence.putString(AppConstants.KEY_USER_BALANCE,
          myBalanceResultItem.balance.toString());
      // AppPrefrence.putString(AppConstants.UpiId,myBalanceResultItem.upi_id);
      AppPrefrence.putString(AppConstants.KEY_USER_WINING_AMOUNT,
          myBalanceResultItem.winning.toString());
      AppPrefrence.putString(AppConstants.KYC_VERIFIED,
          myBalanceResultItem.kyc_verified.toString());

      AppPrefrence.putString(AppConstants.KEY_USER_BONUS_BALANCE,
          myBalanceResultItem.bonus.toString());
      AppPrefrence.putString(AppConstants.KEY_USER_TOTAL_BALANCE,
          myBalanceResultItem.total.toString());
      AppPrefrence.putString(AppConstants.KEY_USER_GST_BALANCE,
          myBalanceResultItem.gst_bonus.toString());

      AppPrefrence.putString(AppConstants.KEY_USER_AFFILIATE_BALANCE,
          myBalanceResultItem.affiliate_commission.toString());

      AppPrefrence.putInt(
          AppConstants.SHARED_PREFERENCE_USER_BANK_VERIFY_STATUS,
          myBalanceResultItem.bank_verify);
      AppPrefrence.putInt(AppConstants.SHARED_PREFERENCE_USER_PAN_VERIFY_STATUS,
          myBalanceResultItem.pan_verify);
      AppPrefrence.putInt(
          AppConstants.SHARED_PREFERENCE_USER_MOBILE_VERIFY_STATUS,
          myBalanceResultItem.mobile_verify);

      AppPrefrence.putInt(AppConstants.SHARED_PREFERENCE_USER_UPI_VERIFY_STATUS,
          myBalanceResultItem.upi_verify);

      AppPrefrence.putString(
          AppConstants.IS_WITHDRAW, myBalanceResultItem.is_withdraw);
      is_withdraw = myBalanceResultItem.is_withdraw ?? '0';
      AppPrefrence.putString(
          AppConstants.IS_INST_WITHDRAW, myBalanceResultItem.is_inst_withdraw);
      is_inst_withdraw = myBalanceResultItem.is_inst_withdraw ?? '0';
      AppPrefrence.putString(AppConstants.IS_PROMOTER_WITHDRAW,
          myBalanceResultItem.is_promotor_withdraw);
      is_promotor_withdraw = myBalanceResultItem.is_promotor_withdraw ?? '0';
      AppPrefrence.putString(AppConstants.IS_PROMOTER_INST_WITHDRAW,
          myBalanceResultItem.is_promotor_inst_withdraw);
      is_promotor_inst_withdraw =
          myBalanceResultItem.is_promotor_inst_withdraw ?? '0';

      AppPrefrence.putString(AppConstants.KYC_DEPOSIT_CHECK,
          myBalanceResultItem.kyc_deposit_check);
      AppPrefrence.putString(AppConstants.KYC_DEPOSIT_LIMIT,
          myBalanceResultItem.kyc_deposit_limit);
      AppPrefrence.putString(AppConstants.TOTAL_CASHFREE_DEPOSIT,
          myBalanceResultItem.total_cashfree_deposit);

      AppPrefrence.putString(
          AppConstants.CASHFREE_MESSAGE, myBalanceResultItem.kyc_deposit_msg);
    }
    AppPrefrence.getInt(AppConstants.IS_ADDRESS_VERIFIED, 0).then((value) => {
          setState(() {
            Address_verify = value;
          })
        });
    setState(() {});
  }

  bool isVerified() {
    return myBalanceResultItem.kyc_verified == 1;
  }

  Future<void> showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Select Profile Picture",
              style: TextStyle(
                  fontFamily: "Roboto", color: Colors.black, fontSize: 16),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text(
                      "Take Photo",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.black,
                          fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _getImage(context, ImageSource.camera);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  GestureDetector(
                    child: Text(
                      "Choose from Gallery",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.black,
                          fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _getImage(context, ImageSource.gallery);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  GestureDetector(
                    child: Text(
                      "Remove Photo",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.black,
                          fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      removeProfilePhoto();
                    },
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  GestureDetector(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.black,
                          fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _getImage(BuildContext context, ImageSource source) {
    _imagePicker
        .pickImage(source: source, imageQuality: 70)
        .then((value) => {sendFile(File(value!.path))});
  }

  void sendFile(File file) async {
    AppLoaderProgress.showLoader(context);
    FormData formData = new FormData.fromMap({
      "user_id": userId,
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      )
    });
    Dio dio = new Dio();
    dio.options.headers["Content-Type"] = "multipart/form-data";
    var response = await dio
        .post(
          AppRepository.dio.options.baseUrl + Apis.uploadProfileImage,
          data: formData,
        )
        .catchError((e) => debugPrint(e.response.toString()));
    AppLoaderProgress.hideLoader(context);
    var jsonObject = json.decode(response.toString());
    if (jsonObject['status'] == 1) {
      userPic = jsonObject['result'][0]['image'];
      AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_PIC, userPic);
      MethodUtils.showSuccess(context, 'Profile Photo Uploaded Successfully.');
      setState(() {});
    } else {
      MethodUtils.showError(context, 'Error in image uploading.');
    }
  }

  void removeProfilePhoto() async {
    AppLoaderProgress.showLoader(context);
    GeneralRequest loginRequest = new GeneralRequest(user_id: userId);
    final client = ApiClient(AppRepository.dio);
    GeneralResponse response = await client.removeProfilePhoto(loginRequest);
    if (response.status == 1) {
      userPic = '';
      AppPrefrence.putString(AppConstants.SHARED_PREFERENCE_USER_PIC, '');
      setState(() {
        AppLoaderProgress.hideLoader(context);
      });
      MethodUtils.showSuccess(context, 'Profile Photo Removed Successfully.');
    }
  }

  Future<void> locationPopUp() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('NOTE:'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                    'Currently, You cannot add cash to your account or cannot play the cash contest, As we can see you are not satisfying our preconditions for play cash contest'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> locationPopUp2() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('NOTE:'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                    'Currently, You cannot verify your account or cannot play the cash contest, As we can see you are not satisfying our preconditions for play cash contest'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void buildForWebSite() {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddBalance('')))
        .then((value) {
      setState(() {
        getUserBalance();
      });
    });
  }

  accountCommission() {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    height: 70,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Commission To Deposit',
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.clear,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '*Transfer with 5% TDS deduction',
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: Colors.black,
                                fontSize: 12),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Enter Amount',
                            style: TextStyle(
                                fontFamily: "Roboto", color: Colors.grey),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 45,
                            child: TextField(
                              controller: depositAmountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                counterText: "",
                                fillColor: Colors.white,
                                filled: true,
                                hintStyle: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  // width: 0.0 produces a thin "hairline" border
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 0.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 0.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        color: Colors.white,
                                        border:
                                            Border.all(color: primaryColor)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontSize: 12,
                                            color: primaryColor,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    if (depositAmountController
                                        .text.isNotEmpty) {
                                      amountCommissionApi();
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Please enter valid amount",
                                          toastLength: Toast.LENGTH_SHORT,
                                          timeInSecForIosWeb: 1);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        color: primaryColor,
                                        border:
                                            Border.all(color: primaryColor)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        'Submit',
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  amountCommissionApi() async {
    AppLoaderProgress.showLoader(context);
    GeneralRequest loginRequest = new GeneralRequest(
        user_id: userId, amount: depositAmountController.text);
    final client = ApiClient(AppRepository.dio);
    GeneralResponse myBalanceResponse =
        await client.updateDepositAmount(loginRequest);
    AppLoaderProgress.hideLoader(context);
    if (myBalanceResponse.status == 1) {
      Navigator.pop(context);
      getUserBalance();
      // getUserLevel();
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "${myBalanceResponse.message}",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1);
    }
    depositAmountController.clear();
    setState(() {});
  }

  withdrawAmountCommission() {
    String withdrawOption = 'Affiliate Commission';
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      height: 70,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Select an withdraw option',
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile(
                          key: Key('AffiliateCommission'),
                          title: Text(
                            'Affiliate Commission',
                            style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '*Withdraw with 5% TDS Deduction',
                            style:
                                TextStyle(fontFamily: "Roboto", fontSize: 12),
                          ),
                          value: 'Affiliate',
                          groupValue: withdrawOption,
                          activeColor: primaryColor,
                          controlAffinity: ListTileControlAffinity.trailing,
                          onChanged: (value) {
                            setState(() {
                              withdrawOption = value.toString();
                            });
                          },
                        ),
                        Divider(
                          thickness: 1,
                          height: 1,
                        ),
                        RadioListTile(
                          key: Key('Winning'),
                          title: Text(
                            'Winning',
                            style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '*Withdraw with 30% TDS Deduction',
                            style:
                                TextStyle(fontFamily: "Roboto", fontSize: 12),
                          ),
                          value: 'Winning',
                          groupValue: withdrawOption,
                          activeColor: primaryColor,
                          controlAffinity: ListTileControlAffinity.trailing,
                          onChanged: (value) {
                            setState(() {
                              withdrawOption = value.toString();
                            });
                          },
                        ),
                        Divider(
                          thickness: 1,
                          height: 1,
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        if (withdrawOption == "Winning") {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Wrap(
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              height: 70,
                                              decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Winning Balance',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Roboto",
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 13),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            myBalanceResultItem
                                                                .winning
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Roboto",
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Icon(
                                                          Icons.clear,
                                                          color: Colors.white,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        // upiId==null?navigateToUpiVerification(context) :navigateToUpiWithdraw(context);
                                                        navigateToWithdrawCash(
                                                            context,
                                                            type: "bank");
                                                      },
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color:
                                                                  primaryColor),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            'Bank Withdraw',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Roboto",
                                                                color:
                                                                    primaryColor),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        navigateToWithdrawCash(
                                                            context,
                                                            type:
                                                                "bank_instant");
                                                      },
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            border: Border.all(
                                                                color:
                                                                    primaryColor),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        child: Center(
                                                          child: Text(
                                                            'Instant Bank Withdraw',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Roboto",
                                                                color:
                                                                    primaryColor),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        } else if (withdrawOption == "Affiliate") {
                          navigateToWithdrawCash(context,
                              type: "bank",
                              withdrawOption: true,
                              affiliate_commission:
                                  myBalanceResultItem.affiliate_commission);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(12.0),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: primaryColor,
                            border: Border.all(color: primaryColor)),
                        child: Text(
                          'Next',
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  withdrawInstantBankDialoge(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Dialog Content
              Wrap(
                children: [
                  Column(
                    children: [
                      // Header with balance
                      Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: borderColor,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Winning Balance',
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  color: textCol,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${myBalanceResultItem.winning}',
                                style: const TextStyle(
                                  fontFamily: "Roboto",
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Withdraw Options
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            // Normal Bank Withdraw
                            if (is_withdraw == '1')
                              GestureDetector(
                                onTap: () {
                                  final route = Platform.isAndroid
                                      ? MaterialPageRoute(
                                          builder: (context) =>
                                              WithdrawCash(type: "bank"),
                                        )
                                      : CupertinoPageRoute(
                                          builder: (context) =>
                                              WithdrawCash(type: "bank"),
                                        );

                                  Navigator.push(context, route).then((value) {
                                    Navigator.pop(context);
                                    setState(() {
                                      Future.delayed(
                                          const Duration(milliseconds: 200),
                                          () {
                                        getUserBalance();
                                      });
                                    });
                                  });
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: primaryColor),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Bank Withdraw',
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            const SizedBox(height: 10),

                            // Instant Bank Withdraw
                            if (is_inst_withdraw == '1')
                              GestureDetector(
                                onTap: () {
                                  final route = Platform.isAndroid
                                      ? MaterialPageRoute(
                                          builder: (context) => WithdrawCash(
                                              type: "bank_instant"),
                                        )
                                      : CupertinoPageRoute(
                                          builder: (context) => WithdrawCash(
                                              type: "bank_instant"),
                                        );

                                  Navigator.push(context, route).then((value) {
                                    Navigator.pop(context);
                                    setState(() {
                                      Future.delayed(
                                          const Duration(milliseconds: 200),
                                          () {
                                        getUserBalance();
                                      });
                                    });
                                  });
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: primaryColor),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Instant Bank Withdraw',
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Floating Close Button (relative to dialog, not screen)
              Positioned(
                top: -8,
                right: -8,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Image.asset(
                      "assets/images/closeIcon.png",
                      width: 17,
                      height: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTransferBottomSheet(BuildContext context) {
    final currencySymbol = '';
    final parts = myBalanceResultItem.transfer_text1!.split(currencySymbol);
    final beforeAmount = parts[0];
    final amount =
        parts.length > 1 ? '$currencySymbol${parts[1].split(' ').first}' : '';
    final afterAmount =
        parts.length > 1 ? parts[1].substring(parts[1].indexOf(' ') + 1) : '';
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Ensures the sheet adjusts its height dynamically
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Close button and Title
                    Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 250,
                              child: Text(
                                myBalanceResultItem.transfer_text ?? '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 16,
                                  color: Color(0xff1e232c),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.close),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Icons and text row
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 10),
                      child: Container(
                        height: 100,
                        width: 220,
                        child: Image.asset(AppImages.transferwinning),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Total winnings
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: beforeAmount, // Text before the amount
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color:
                                  Colors.black, // Default color for normal text
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '$amount ', // Dynamic amount
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors
                                      .black, // Different color for the amount
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),

                    // Benefits text
                    Text(
                      myBalanceResultItem.transfer_text2 ?? '',
                      style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Bonus benefit
                    Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AppImages.transferRealBouns),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            myBalanceResultItem.transfer_benifit ?? '',
                            style: TextStyle(
                              fontFamily: "Roboto",
                              color: Color(0xff076e39),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            myBalanceResultItem.transfer_benifit_text ?? '',
                            style: TextStyle(
                              fontFamily: "Roboto",
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Example text
                    Text(
                      myBalanceResultItem.transfer_text3 ?? "",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Platform.isAndroid
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WithdrawCash(
                                            type: "winning_transfer",
                                            transferPercent: myBalanceResultItem
                                                .transfer_benifit_percent))).then(
                                    (value) {
                                    setState(() {
                                      Future.delayed(
                                          Duration(milliseconds: 200), () {
                                        getUserBalance();
                                      });
                                    });
                                  })
                                : Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => WithdrawCash(
                                            type: "winning_transfer",
                                            transferPercent: myBalanceResultItem
                                                .transfer_benifit_percent))).then(
                                    (value) {
                                    setState(() {
                                      Future.delayed(
                                          Duration(milliseconds: 200), () {
                                        getUserBalance();
                                      });
                                    });
                                  });
                            // upiId==null?navigateToUpiVerification(context) :navigateToUpiWithdraw(context);
                            // navigateToWithdrawCash(
                            //     context,
                            //     type: "bank");
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                                color: greenColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  color: greenColor,
                                )),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'Transfer Now',
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Wrap(
                                            children: [
                                              Column(
                                                children: [
                                                  Container(
                                                    height: 70,
                                                    decoration: BoxDecoration(
                                                        color: primaryColor,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10))),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 5),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Winning Balance',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "Roboto",
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          13),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  myBalanceResultItem
                                                                      .winning
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "Roboto",
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          15),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Icon(
                                                                Icons.clear,
                                                                color: Colors
                                                                    .white,
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          is_withdraw == '1'
                                                              ? GestureDetector(
                                                                  onTap: () {
                                                                    Platform
                                                                            .isAndroid
                                                                        ? Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => WithdrawCash(type: "bank"))).then(
                                                                            (value) {
                                                                            Navigator.pop(context);
                                                                            setState(() {
                                                                              Future.delayed(Duration(milliseconds: 200), () {
                                                                                getUserBalance();
                                                                              });
                                                                            });
                                                                          })
                                                                        : Navigator.push(
                                                                            context,
                                                                            CupertinoPageRoute(
                                                                                builder: (context) => WithdrawCash(type: "bank"))).then(
                                                                            (value) {
                                                                            Navigator.pop(context);
                                                                            setState(() {
                                                                              Future.delayed(Duration(milliseconds: 200), () {
                                                                                getUserBalance();
                                                                              });
                                                                            });
                                                                          });
                                                                    // upiId==null?navigateToUpiVerification(context) :navigateToUpiWithdraw(context);
                                                                    // navigateToWithdrawCash(
                                                                    //     context,
                                                                    //     type: "bank");
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.7,
                                                                    height: 40,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      border: Border.all(
                                                                          color:
                                                                              primaryColor),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'Bank Withdraw',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "Roboto",
                                                                            color:
                                                                                primaryColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : Container(),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          is_inst_withdraw ==
                                                                  '1'
                                                              ? GestureDetector(
                                                                  onTap: () {
                                                                    Platform
                                                                            .isAndroid
                                                                        ? Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => WithdrawCash(type: "bank_instant"))).then(
                                                                            (value) {
                                                                            setState(() {
                                                                              Navigator.pop(context);
                                                                              Future.delayed(Duration(milliseconds: 200), () {
                                                                                getUserBalance();
                                                                              });
                                                                            });
                                                                          })
                                                                        : Navigator.push(
                                                                            context,
                                                                            CupertinoPageRoute(
                                                                                builder: (context) => WithdrawCash(type: "bank_instant"))).then(
                                                                            (value) {
                                                                            setState(() {
                                                                              Navigator.pop(context);
                                                                              Future.delayed(Duration(milliseconds: 200), () {
                                                                                getUserBalance();
                                                                              });
                                                                            });
                                                                          });
                                                                    // navigateToWithdrawCash(
                                                                    //     context,
                                                                    //     type:
                                                                    //         "bank_instant");
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.7,
                                                                    height: 40,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        border: Border.all(
                                                                            color:
                                                                                primaryColor),
                                                                        borderRadius:
                                                                            BorderRadius.circular(5)),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'Instant Bank Withdraw',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "Roboto",
                                                                            color:
                                                                                primaryColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : Container(),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                .then((value) => Future.delayed(
                                        Duration(milliseconds: 100), () {
                                      Navigator.pop(context);
                                    }));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                                color: !isVerified()
                                    ? Colors.white
                                    : is_withdraw == '1' ||
                                            is_inst_withdraw == '1'
                                        ? Colors.white
                                        : const Color.fromARGB(
                                            255, 215, 213, 213),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  color: greenIconColor,
                                )),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'Withdraw Now',
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      color: greenColor,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
