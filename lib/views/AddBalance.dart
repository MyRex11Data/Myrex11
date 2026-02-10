import 'dart:convert';
import 'dart:io';
import 'package:flutter_html/flutter_html.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:myrex11/repository/model/my_balance_response.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../appUtilities/app_constants.dart';
import '../appUtilities/app_images.dart';
import '../appUtilities/defaultbutton.dart';
import '../appUtilities/method_utils.dart';
import '../customWidgets/app_circular_loader.dart';
import '../localStoage/AppPrefrences.dart';
import '../repository/app_repository.dart';
import '../repository/model/base_request.dart';
import '../repository/model/base_response.dart';
import '../repository/model/gst_details_response.dart';
import '../repository/model/offer_list_response.dart';
import '../repository/retrofit/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddBalance extends StatefulWidget {
  String promo_code;
  String? pageType;
  String? entryFee;
  String? isFromCheck;
  AddBalance(this.promo_code, {this.pageType, this.entryFee, this.isFromCheck});

  @override
  _AddBalanceState createState() => _AddBalanceState();
}

class _AddBalanceState extends State<AddBalance> {
  List<OfferListDataModel> offersList = [];
  TextEditingController amountController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  final tooltipController = JustTheController();
  String balance = '0';
  String userId = '0';
  String winningAmount = '0';
  String bonusAmount = '0';
  String promoAmount = '0';
  String winningPercent = '0';
  String gstPercent = '0';
  String rebatePercent = '0';

  String offer_text = '';
  String gst_saving = '';
  String deposit_amount_text = '';
  String deposit_amount = '';
  String gst_applicable_text = '';
  double gst_applicable = 0;
  String gst_applicable_smalltext = '';
  double real_money_bonus = 0;
  String real_money_bonus_text = '';
  String real_money_bonus_smalltext = '';
  String total_amount_text = '';
  double total_amount = 0;
  String pay = '';
  int? is_gst_rebate;
  int promoId = 0;
  bool locationallow = false;
  var userLocation = '';
  var state = '';
  bool locationtap = false;
  var yourlocation;
  String? locationMessage;
  List<int> amounts = [200, 300, 500, 1000, 10000]; // List of amounts.
  int selectedIndex = -1;
  String selectedAddress = '';
  String selectedContact = '';
  String selectedChain = '';
  String selectedChainType = '';

  GstDetailsResponseItem GstResult = GstDetailsResponseItem();

  var countryname = '';
  String? latitude;
  String? longitude;
  bool popUp = false;
  bool showUpiScreen = true;

  String min_deposite = '0';
  String max_deposite = '0';

  bool isQRSelected = true;

  int selectedQRIndex = 0;
  bool upiScreenshotUpload = false;
  String upiScreenshot = '';
  ImagePicker _imagePicker = new ImagePicker();

  String selectedUPIId = '';
  String show_web_payment = '';
  String? show_admin_upi;
  List<UPIList> qrList = [];
  String? show_admin_bank;
  String? admin_bank_name;
  String? admin_bank_ifsc;
  String? admin_bank_customer_name;
  String? admin_bank_account;
  TextEditingController utrController = TextEditingController();
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  String checkPromoId = '';
  bool isloading = false;

  @override
  void initState() {
    // if (BuildType.isForPlayStore) {
    //   determinePosition();
    //   getCurrentLocation();
    // }

    super.initState();

    AppPrefrence.getString(AppConstants.KEY_USER_BALANCE).then((value) => {
          setState(() {
            balance = value;
          })
        });

    AppPrefrence.getString(AppConstants.KEY_USER_WINING_AMOUNT)
        .then((value) => {
              setState(() {
                winningAmount = value;
              })
            });

    AppPrefrence.getString(AppConstants.KEY_USER_BONUS_BALANCE)
        .then((value) => {
              setState(() {
                bonusAmount = value;
              })
            });

    AppPrefrence.getString(AppConstants.GST_PERCENT).then((value) => {
          setState(() {
            gstPercent = value;
          })
        });

    AppPrefrence.getString(AppConstants.REBATE_PERCENT).then((value) => {
          setState(() {
            rebatePercent = value;
          })
        });

    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
        .then((value) => {
              setState(() {
                userId = value;
                addCaseOfferList();
              })
            });

    AppPrefrence.getString(AppConstants.MIN_DEPOSITE).then((value) => {
          setState(() {
            min_deposite = value;
            if (widget.isFromCheck == 'joinpopup') {
              setState(() {
                AppConstants.movetowallet = true;
                amountController.text =
                    double.tryParse(widget.entryFee ?? '0')!.ceil().toString();
              });
            } else {
              amountController.text = min_deposite;
              if (value.isNotEmpty) {
                final enteredAmount = int.tryParse(value) ?? -1;
                final matchedIndex = amounts.indexOf(enteredAmount);

                setState(() {
                  if (matchedIndex != -1) {
                    selectedIndex =
                        matchedIndex; // highlight the matched amount tab
                  } else {
                    selectedIndex = -1; // no match, deselect all
                  }
                });
              } else {
                setState(() {
                  selectedIndex = -1; // empty input, deselect all
                });
              }
            }
          })
        });
    AppPrefrence.getString(AppConstants.MAX_DEPOSITE).then((value) => {
          setState(() {
            max_deposite = value;
          })
        });

    // Fetch a single String
    AppPrefrence.getObjectList<UPIList>(
      AppConstants.KEY_ADMIN_UPI_LIST,
      (json) => UPIList.fromJson(json),
    ).then((value) {
      setState(() {
        qrList = value;
        if (qrList.isNotEmpty) {
          selectedUPIId = qrList[0].upi_number ?? "";
        }
      });
    });

    // AppPrefrence.getString(AppConstants.KEY_ADMIN_BANK_NAME).then((value) {
    //   setState(() {
    //     admin_bank_name = value;
    //   });
    // });

    // AppPrefrence.getString(AppConstants.KEY_ADMIN_BANK_IFSC).then((value) {
    //   setState(() {
    //     admin_bank_ifsc = value;
    //   });
    // });

    // AppPrefrence.getString(AppConstants.KEY_ADMIN_BANK_CUSTOMER_NAME)
    //     .then((value) {
    //   setState(() {
    //     admin_bank_customer_name = value;
    //   });
    // });

    // AppPrefrence.getString(AppConstants.KEY_ADMIN_BANK_ACCOUNT).then((value) {
    //   setState(() {
    //     admin_bank_account = value;
    //   });
    // });

// Fetch List<String>
    // AppPrefrence.getString(AppConstants.KEY_SHOW_ADMIN_UPI).then((value) {
    //   setState(() {
    //     show_admin_upi = value;
    //     if (show_admin_upi == '1') {
    //       isQRSelected = true;
    //     } else {
    //       isQRSelected = false;
    //     }
    //   });
    // });

    // AppPrefrence.getString(AppConstants.KEY_SHOW_ADMIN_BANK).then((value) {
    //   setState(() {
    //     show_admin_bank = value;
    //   });
    // });

    // AppPrefrence.getString(AppConstants.SHARED_PREFERENCES_SHOW_WEB_PAYEMNT)
    //     .then((value) => {
    //           setState(() {
    //             show_web_payment = value;
    //           })
    //         });

    if (widget.promo_code.isNotEmpty) {
      setState(() {
        codeController.text = widget.promo_code;
      });
      applyPromoCode();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (widget.isFromCheck == 'joinpopup') {
      setState(() {
        AppConstants.movetowallet = false;
      });
    }
    Navigator.pop(context);
    return Future.value(false);
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                // image: DecorationImage(
                //     image: AssetImage(AppImages.commanBackground),
                //     fit: BoxFit.cover),
                color: Colors.white),
          ),
          new Scaffold(
            backgroundColor: Colors.transparent,
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
                    //     image: AssetImage(
                    //         "assets/images/Ic_creatTeamBackGround.png"),
                    //     fit: BoxFit.cover)

                    ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => {
                        if (widget.isFromCheck == 'joinpopup')
                          {
                            setState(() {
                              AppConstants.movetowallet = false;
                            }),
                          },
                        Navigator.pop(context)
                      },
                      child: new Container(
                        padding: EdgeInsets.only(left: 0, right: 8),
                        alignment: Alignment.centerLeft,
                        child: new Container(
                          height: 30,
                          child: Image(
                            image: AssetImage(AppImages.backImageURL),
                            fit: BoxFit.fill,
                            // color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Text("Add Cash",
                        style: TextStyle(
                            fontFamily: "Roboto",
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16)),
                  ],
                ),
              ),
            ),
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: ListView(
                    // padding: EdgeInsets.all(0),
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: new Container(
                          decoration: BoxDecoration(
                            color: LightprimaryColor,
                            border: Border.all(
                              color: borderColor, // Border color
                              width: 1.0, // Optional: Border width
                            ),
                            borderRadius: BorderRadius.circular(
                                6.0), // Add rounded corners
                          ),
                          padding: EdgeInsets.all(8),
                          //color: Colors.white,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              new Column(
                                children: [
                                  new Container(
                                    margin: EdgeInsets.only(bottom: 4),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Deposit',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        color: textCol,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 6),
                                        child: Container(
                                          height: 18,
                                          width: 18,
                                          child:
                                              Image.asset(AppImages.goldcoin),
                                        ),
                                      ),
                                      new Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          balance,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              //fontFamily: "Roboto",
                                              color: textCol,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              new Container(
                                  width: 1,
                                  height: 40,
                                  alignment: Alignment.center,
                                  color: Colors.white),
                              new Column(
                                children: [
                                  new Container(
                                    margin: EdgeInsets.only(bottom: 4),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Winning',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        color: textCol,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 6),
                                        child: Container(
                                          height: 18,
                                          width: 18,
                                          child:
                                              Image.asset(AppImages.goldcoin),
                                        ),
                                      ),
                                      new Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          winningAmount,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              // fontFamily: "Roboto",
                                              color: textCol,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              new Container(
                                  width: 1,
                                  height: 40,
                                  alignment: Alignment.center,
                                  color: Colors.white),
                              new Column(
                                children: [
                                  new Container(
                                    margin: EdgeInsets.only(bottom: 4),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Bonus',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        color: textCol,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 6),
                                        child: Container(
                                          height: 18,
                                          width: 18,
                                          child:
                                              Image.asset(AppImages.goldcoin),
                                        ),
                                      ),
                                      new Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          bonusAmount,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              // fontFamily: "Roboto",
                                              color: textCol,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // if (showUpiScreen == false)
                              //   new Container(
                              //     width: 1,
                              //     height: 40,
                              //     alignment: Alignment.center,
                              //     color: Color(0xFFf5bebe),
                              //   ),
                              // if (showUpiScreen == false)
                              //   new Column(
                              //     children: [
                              //       new Container(
                              //         margin: EdgeInsets.only(bottom: 4),
                              //         alignment: Alignment.center,
                              //         child: Text(
                              //           'Bonus',
                              //           textAlign: TextAlign.start,
                              //           style: TextStyle(
                              //             fontFamily: "Roboto",
                              //             fontSize: 12,
                              //             color: textCol,
                              //             fontStyle: FontStyle.normal,
                              //             fontWeight: FontWeight.w400,
                              //           ),
                              //         ),
                              //       ),
                              //       new Container(
                              //         alignment: Alignment.center,
                              //         child: Text(
                              //           bonusAmount,
                              //           textAlign: TextAlign.start,
                              //           style: TextStyle(
                              //               // fontFamily: "Roboto",
                              //               color: textCol,
                              //               fontWeight: FontWeight.bold,
                              //               fontSize: 16),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                            ],
                          ),
                        ),
                      ),

                      buildQRSection(),

                      // Bank Section
                      //if (!isQRSelected) buildBankSection(),
                      SizedBox(
                        height: 15,
                      ),
                      if (offersList.length > 0)
                        Container(
                          padding: EdgeInsets.only(bottom: 10, left: 16),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Do you have promotion code?',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 14,
                              color: textCol,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      offersList.length > 0 // || widget.show_promo_field == "1"
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Container(
                                child: Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    DefaultButton(
                                      width: 80,
                                      height: 45,
                                      margin: EdgeInsets.only(left: 10),
                                      color: primaryColor,
                                      textcolor: Colors.white,
                                      borderRadius: 5,
                                      text: codeController.text.isNotEmpty &&
                                              checkPromoId ==
                                                  codeController.text &&
                                              promoId > 0
                                          ? 'Remove'
                                          : "Apply",
                                      onpress: () {
                                        if (amountController.text.isEmpty) {
                                          MethodUtils.showError(
                                              context, 'Please enter amount.');
                                        } else if (codeController
                                            .text.isEmpty) {
                                          MethodUtils.showError(context,
                                              'Please enter promo code.');
                                        } else {
                                          if (promoId > 0 &&
                                              codeController.text.isNotEmpty &&
                                              checkPromoId ==
                                                  codeController.text) {
                                            setState(() {
                                              codeController.text = '';
                                              promoId = 0;
                                              checkPromoId = '';
                                            });

                                            MethodUtils.showSuccess(
                                              context,
                                              'Promo code removed.',
                                            );
                                          } else {
                                            applyPromoCode();

                                            // applyPromoCode();
                                          }
                                        }
                                      },
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 50,
                                        child: TextField(
                                          // focusNode: _focusNode2,
                                          controller: codeController,
                                          enabled: promoId > 0 ? false : true,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 10),
                                            counterText: "",
                                            fillColor: Colors.white,
                                            filled: true,
                                            hintStyle: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            hintText: 'Enter Promo Code',
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              // width: 0.0 produces a thin "hairline" border
                                              borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 0.0),
                                            ),
                                            disabledBorder:
                                                const OutlineInputBorder(
                                              // width: 0.0 produces a thin "hairline" border
                                              borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 0.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 0.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      promoId > 0
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: new Container(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Promocode Applied',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: "Roboto",
                                    fontSize: 14,
                                    color: greenColor,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                          : new Container(),
                      // offersList.isNotEmpty
                      //     ? Divider(
                      //         height: 1,
                      //         thickness: 1,
                      //       )
                      //     : SizedBox.shrink(),
                      offersList.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                  left: 16, right: 16, bottom: 5, top: 0),
                              child: Container(
                                height: 30,
                                color: lightGrayColor4,
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    new Container(
                                      margin: EdgeInsets.only(left: 0),
                                      child: Text('Available Offers',
                                          style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      // offersList.isNotEmpty
                      //     ? Divider(
                      //         height: 1,
                      //         thickness: 1,
                      //       )
                      //     : SizedBox.shrink(),
                      offersList.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Container(
                                height: 120,
                                child: ListView.builder(
                                    padding: EdgeInsets.only(right: 0),
                                    // physics:
                                    //     NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: offersList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            left: (offersList.indexOf(
                                                        offersList[index]) ==
                                                    0)
                                                ? 12
                                                : 4,
                                            right: (offersList.indexOf(
                                                        offersList[index]) ==
                                                    offersList.length - 1)
                                                ? 12
                                                : 0),
                                        child: Container(
                                          // width: MediaQuery.of(context)
                                          //         .size
                                          //         .width *
                                          //     0.8,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      AppImages.OffersBg),
                                                  fit: BoxFit.fill)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        offersList[index]
                                                                    .title !=
                                                                ""
                                                            ? Container(
                                                                width: offersList
                                                                            .length >
                                                                        1
                                                                    ? MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.35
                                                                    : MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.45,
                                                                child: Text(
                                                                  offersList[index]
                                                                          .title ??
                                                                      '',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "Roboto",
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              )
                                                            : Container(),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 10),
                                                          child: Container(
                                                            width: offersList.length >
                                                                    1
                                                                ? MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.35
                                                                : MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.45,
                                                            // margin:
                                                            //     EdgeInsets.only(
                                                            //         top: 5,
                                                            //         bottom: 10),
                                                            child: Text(
                                                              offersList[index]
                                                                      .description ??
                                                                  '',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Roboto",
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    GestureDetector(
                                                      behavior: HitTestBehavior
                                                          .translucent,
                                                      child: new Container(
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
                                                        ),
                                                        // height: 50,
                                                        // width: 70,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 4),
                                                          child: new Text(
                                                            checkPromoId ==
                                                                    offersList[
                                                                            index]
                                                                        .code
                                                                // &&
                                                                //         GstResult.update_promo_id ==
                                                                //             1
                                                                ? 'Applied'
                                                                    .toUpperCase()
                                                                : 'APPLY',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Roboto",
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        if (amountController
                                                            .text.isEmpty) {
                                                          MethodUtils.showError(
                                                              context,
                                                              'Please enter amount');
                                                        } else {
                                                          codeController.text =
                                                              offersList[index]
                                                                      .code ??
                                                                  '';

                                                          applyPromoCode();
                                                        }
                                                      },
                                                    ),
                                                    // Divider(
                                                    //   height: 1,
                                                    //   thickness: 1,
                                                    // ),
                                                    // Row(
                                                    //   mainAxisAlignment:
                                                    //       MainAxisAlignment
                                                    //           .spaceBetween,
                                                    //   crossAxisAlignment:
                                                    //       CrossAxisAlignment.center,
                                                    //   children: [

                                                    //   ],
                                                    // )
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              AppImages
                                                                  .OffersNameBg),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 9,
                                                          vertical: 4),
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Text(
                                                          offersList[index]
                                                                  .code ??
                                                              '',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Roboto",
                                                            color: greenColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12.9,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                          softWrap:
                                                              false, // prevents line breaks
                                                        ),
                                                      ),
                                                    ),
                                                    Column(
                                                      children: [
                                                        new Text(
                                                          "Valid till",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Roboto",
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 12,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        new Text(
                                                          offersList[index]
                                                              .expire_date!,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Roboto",
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            )
                          : SizedBox.shrink(),
                      SizedBox(
                        height: 60,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () {
                      focusNode1.unfocus();
                      focusNode2.unfocus();
                      if (amountController.text.isEmpty) {
                        MethodUtils.showError(context, 'Please enter amount');
                      } else if (amountController.text.startsWith('0')) {
                        MethodUtils.showError(
                            context, 'Please enter a valid amount');
                      } else if (double.parse(amountController.text) >
                          int.parse(max_deposite)) {
                        MethodUtils.showError(
                            context, 'Please enter amount upto $max_deposite');
                      } else if (double.parse(amountController.text) <
                          int.parse(min_deposite)) {
                        MethodUtils.showError(context,
                            'Please enter minimum amount $min_deposite');
                      } else {
                        currencyConvert();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: buttonGreenColor,
                        border: Border.all(
                          color: Color(0xFF6A0BF8),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      width: MediaQuery.of(context).size.width /
                          1.5, // Set width to half of screen
                      height: 50,
                      child: Center(
                        child: Text(
                          "Add Cash with crypto",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      // color: primaryColor,
                      // borderRadius: 30,
                      // textcolor: Colors.white,
                    ),
                  ),
                ),
                // UPI Button
                Padding(
                  padding: EdgeInsets.only(bottom: 70),
                  child: GestureDetector(
                    onTap: () async {
                      final url = Uri.parse('https://cricket-pro-tips.xyz/');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      } else {
                        MethodUtils.showError(context, 'Could not open URL');
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        border: Border.all(
                          color: Color(0xFF6A0BF8),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      width: MediaQuery.of(context).size.width /
                          1.5, // Set width to half of screen
                      height: 50,
                      child: Center(
                        child: Text(
                          "Add cash with UPI",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          isloading == true ? AppLoaderProgress() : Container()
        ],
      ),
    );
  }

  void addCaseOfferList() async {
    AppLoaderProgress.showLoader(context);
    GeneralRequest loginRequest = new GeneralRequest(user_id: userId);
    final client = ApiClient(AppRepository.dio);
    OfferListResponse transactionsResponse =
        await client.addCaseOfferList(loginRequest);
    AppLoaderProgress.hideLoader(context);
    if (transactionsResponse.status == 1) {
      offersList = transactionsResponse.result!.data!;
    } else {
      Fluttertoast.showToast(
          msg: transactionsResponse.message!,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1);
    }
    setState(() {});
  }

  void applyPromoCode({bool? noloader}) async {
    if (noloader != true) {
      FocusScope.of(context).unfocus();
      AppLoaderProgress.showLoader(context);
    }

    GeneralRequest loginRequest = new GeneralRequest(
        user_id: userId,
        promo: codeController.text.toString(),
        amount: amountController.text);
    final client = ApiClient(AppRepository.dio);
    GeneralResponse transactionsResponse =
        await client.applyPromoCode(loginRequest);
    if (noloader != true) {
      AppLoaderProgress.hideLoader(context);
    }
    if (transactionsResponse.status == 1) {
      promoAmount = (transactionsResponse.amount ?? '').toString();
      promoId = transactionsResponse.promo_id!;
      // MethodUtils.showSuccess(context, 'Promo Code Applied.');
      if (noloader != true) {
        MethodUtils.showSuccess(
          context,
          transactionsResponse.message,
        );
      }

      setState(() {
        checkPromoId = codeController.text.toString();
      });
    } else {
      promoId = 0;
      promoAmount = '0';
      setState(() {
        checkPromoId = '';
      });
      if (noloader != true) {
        MethodUtils.showError(
          context,
          transactionsResponse.message,
        );
      }
      // Fluttertoast.showToast(
      //     msg: transactionsResponse.message!,
      //     toastLength: Toast.LENGTH_SHORT,
      //     timeInSecForIosWeb: 1);
    }
    setState(() {});
  }

  void currencyConvert() async {
    setState(() {
      isloading = true;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${AppRepository.dio.options.baseUrl}api/auth/add-cash-popup',
        ),
      );

      request.headers['Authorization'] = AppConstants.token;
      request.headers['Devicetype'] = Platform.isIOS
          ? 'IOS'
          : Platform.isAndroid
              ? 'ANDROID'
              : 'WEB';
      request.headers['Versioncode'] = AppConstants.versionCode;
      request.headers['Accept'] = 'application/json';

      request.fields['user_id'] = userId;
      request.fields['amount'] = amountController.text;
      request.fields['promocode'] = codeController.text;

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      print('=== RESPONSE DETAILS ===');
      print(jsonResponse);

      if (jsonResponse['status'] == 1) {
        final result = jsonResponse['result'];

        /// ✅ Extract text fields safely
        String text1 = result['text1'] ?? '';
        String text1Value = result['text1_value'] ?? '';
        String text2 = result['text2'] ?? '';
        String text2Value = result['text2_value'] ?? '';
        String text3 = result['text3'] ?? '';
        String text3Value = result['text3_value'] ?? '';
        String text4 = result['text4'] ?? '';
        String text4Value = result['text4_value'] ?? '';
        String text5 = result['text5'] ?? '';
        String text5Value = result['text5_value'] ?? '';
        String ruleText = result['rule_text'] ?? '';
        String conversion_text = result['conversion_text'] ?? '';

        /// ✅ Extract wallet addresses list
        List wallets = result['wallet_address'] ?? [];
        List<Map<String, dynamic>> walletList = wallets
            .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
            .toList();

        /// ✅ Show dialog with dropdown for wallet addresses
        showAddCashDialog(
          context,
          walletAddresses: walletList,
          text1: text1,
          text1Value: text1Value,
          text2: text2,
          text2Value: text2Value,
          text3: text3,
          text3Value: text3Value,
          text4: text4,
          text4Value: text4Value,
          text5: text5,
          text5Value: text5Value,
          ruleText: ruleText,
          conversion_text: conversion_text,
        );
      } else {
        Fluttertoast.showToast(
          msg: jsonResponse['msg'] ?? 'Submission failed',
        );
      }
    } catch (e) {
      print('Error submitting transaction: $e');
      Fluttertoast.showToast(msg: 'Oops something went wrong...');
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  void submittnxDetails() async {
    // AppLoaderProgress.showLoader(context);
    String amount = '';
    setState(() {
      isloading = true;
      amount = amountController.text;
    });
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${AppRepository.dio.options.baseUrl}api/auth/add-fund-request'),
      );

      request.headers['Authorization'] = AppConstants.token;
      request.headers['Accept'] = 'application/json';

      request.fields['user_id'] = userId;
      request.fields['upi_id'] =
          (isQRSelected == true ? selectedUPIId : admin_bank_account)!;
      request.fields['payment_mode'] = isQRSelected ? 'QR' : 'BANK';
      request.fields['amount'] = amountController.text;
      request.fields['utr_number'] = utrController.text;
      request.fields['promocode'] = codeController.text;

      print('=== REQUEST DETAILS ===');
      print('URL: ${request.url}');
      print('Method: ${request.method}');
      print('Headers:');
      request.headers.forEach((key, value) {
        print('  $key: $value');
      });
      print('Fields:');
      request.fields.forEach((key, value) {
        print('  $key: $value');
      });

      // Add image file with dynamic content type detection
      if (upiScreenshot.isNotEmpty) {
        File file = File(upiScreenshot);
        if (await file.exists()) {
          // Get file extension to determine content type
          String extension = file.path.split('.').last.toLowerCase();
          MediaType contentType;

          // Determine content type based on file extension
          switch (extension) {
            case 'jpg':
            case 'jpeg':
              contentType = MediaType('image', 'jpeg');
              break;
            case 'png':
              contentType = MediaType('image', 'png');
              break;
            case 'gif':
              contentType = MediaType('image', 'gif');
              break;
            case 'bmp':
              contentType = MediaType('image', 'bmp');
              break;
            case 'webp':
              contentType = MediaType('image', 'webp');
              break;
            default:
              // Default to jpeg if unknown format
              contentType = MediaType('image', 'jpeg');
          }

          var multipartFile = await http.MultipartFile.fromPath(
            'image',
            file.path,
            filename: file.path.split('/').last,
            contentType: contentType,
          );
          request.files.add(multipartFile);

          print('Files:');
          print('  image: ${file.path} (${file.lengthSync()} bytes)');
          print('  content-type: ${contentType.mimeType}');
        }
      }

      print('=======================');

      // Send the request
      var response = await request.send();

      // Get the response
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      // Print response details
      print('=== RESPONSE DETAILS ===');
      print('Status Code: ${response.statusCode}');
      print('Response Headers:');
      response.headers.forEach((key, value) {
        print('  $key: $value');
      });
      print('Response Body:');
      print(jsonResponse);
      print('========================');

      // if (response.statusCode == 200) {
      if (jsonResponse['status'] == 1) {
        // Fluttertoast.showToast(
        //   msg: jsonResponse['message'] ?? 'Transaction submitted successfully',
        //   timeInSecForIosWeb: 3,
        // );
        // Clear form after successful submission
        amountController.clear();
        utrController.clear();
        setState(() {
          upiScreenshot = '';
        });
        showSuccessPopup(
            context, jsonResponse['status'], jsonResponse['message'], amount);
      } else {
        // Fluttertoast.showToast(
        //   msg: jsonResponse['message'] ?? 'Submission failed',
        //   timeInSecForIosWeb: 3,
        // );
        showSuccessPopup(
            context, jsonResponse['status'], jsonResponse['message'], amount);
      }
      // } else {
      //   Fluttertoast.showToast(
      //     msg: 'Oops something went wrong...',
      //     timeInSecForIosWeb: 3,
      //   );
      // }
    } catch (error) {
      print('Error submitting transaction: $error');
      print('Stack trace: ${StackTrace.current}');
      Fluttertoast.showToast(
        msg: 'Error submitting transaction',
        timeInSecForIosWeb: 3,
      );
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  void showSuccessPopup(BuildContext context, int transactionStatus,
      String transactionMessage, String transactionAmount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    transactionStatus == 1
                        ? Image.asset(
                            AppImages.successimage,
                            scale: 4,
                          )
                        : Container(
                            alignment: Alignment.center,
                            child: Image.asset(
                              AppImages.failimage,
                              scale: 4,
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 2),
                      child: Text(
                        transactionStatus == 1
                            ? transactionMessage
                            : transactionMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (transactionStatus == 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 2, bottom: 2),
                        child: Text(
                          "${transactionAmount.toString()}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: transactionAmount.isEmpty ||
                                    transactionAmount == ''
                                ? 0
                                : 18,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    // transactionStatus != 1
                    //     ? Padding(
                    //         padding: const EdgeInsets.only(top: 5, bottom: 2),
                    //         child: Text(
                    //           "to your myrex11 account!",
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(
                    //             color: Colors.black,
                    //             fontSize: 16,
                    //             fontFamily: "Roboto",
                    //             fontWeight: FontWeight.w500,
                    //           ),
                    //         ),
                    //       )
                    //     : Container(),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 2, bottom: 2),
                    //   child: Text(
                    //     muidPhonePe,
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(
                    //       color: Colors.grey,
                    //       fontFamily: "Roboto",
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ),
                    // ),
                    transactionStatus != 1
                        ? Padding(
                            padding: const EdgeInsets.only(top: 2, bottom: 2),
                            child: Text(
                              'Please try again',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : Container(),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: transactionStatus == 1
                                ? greenColor
                                : primaryColor, // Background color

                            elevation: 3, // Elevation
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(15), // Rounded corners
                            )),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            transactionStatus == 1 ? "Done" : "Try again",
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (transactionStatus == 1) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    if (transactionStatus == 1) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.close,
                      color: primaryColor,
                      size: 25,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  updateRadio(val) {
    setState(() {
      selectedQRIndex = val ?? 0;
    });
  }

  Widget buildQRSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildAmountField(),
        amountTabs(),
      ],
    );
  }

  Widget buildBankSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Container(
            decoration: BoxDecoration(
                color: Color(0Xff0af30000),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: [
                  buildCopyRow("Account", admin_bank_account ?? ''),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      height: 1,
                      color: Color(0xffF5BEBE),
                    ),
                  ),
                  buildCopyRow("IFSC", admin_bank_ifsc ?? ''),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      height: 1,
                      color: Color(0xffF5BEBE),
                    ),
                  ),
                  buildCopyRow("Account Name", admin_bank_customer_name ?? ''),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      height: 1,
                      color: Color(0xffF5BEBE),
                    ),
                  ),
                  buildCopyRow("Bank Name", admin_bank_name ?? ''),
                ],
              ),
            ),
          ),
        ),
        buildAmountField(),
        amountTabs(),
        // if (show_web_payment != '1') buildUploadField(),
        // if (show_web_payment != '1') buildUTRField(),
      ],
    );
  }

  Widget amountTabs() {
    return Column(
      children: [
        SizedBox(
          height: 12,
        ),
        Container(
          padding: EdgeInsets.only(bottom: 10, left: 16),
          alignment: Alignment.centerLeft,
          child: Text(
            'Choose your amount',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: "Roboto",
              fontSize: 14,
              color: textCol,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(amounts.length, (index) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    selectedIndex = index;

                    // Update the selected index.
                  });
                  // if (amountController.text.isEmpty) {
                  amountController.text = '${amounts[index]}';

                  if (checkPromoId.isNotEmpty) {
                    applyPromoCode(noloader: true);
                  }
                },
                child: Container(
                  width: 60,
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedIndex == index
                          ? LightprimaryColor
                          : Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    color: selectedIndex == index
                        ? LightprimaryColor // Highlight green if selected.
                        : Colors.white, // Default white.
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 3),
                        child: Container(
                          height: 14,
                          width: 14,
                          child: Image.asset(AppImages.goldcoin),
                        ),
                      ),
                      Text(
                        '${amounts[index]}',
                        style: TextStyle(
                          //  fontFamily: "Roboto",
                          color: selectedIndex == index
                              ? Color(0xff666666)
                              : Color(0xff666666),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          )),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget buildCopyRow(String label, String value) {
    return ListTile(
      dense: true, // ✅ reduces height automatically
      minVerticalPadding: 0,
      visualDensity:
          VisualDensity(horizontal: 0, vertical: 0), // ✅ reduces extra space
      contentPadding:
          EdgeInsets.symmetric(horizontal: 10, vertical: 0), // ✅ less padding
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label:",
            style: TextStyle(fontSize: 12), // optional: slightly smaller text
          ),
          Text(
            "$value",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold), // optional: slightly smaller text
          ),
        ],
      ),
      trailing: IconButton(
        padding: EdgeInsets.zero, // ✅ removes extra tap target padding
        constraints: BoxConstraints(), // ✅ removes default button constraints
        icon: SizedBox(
          height: 20, // ✅ slightly smaller icon area
          child: Image.asset(AppImages.copyqr),
        ),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: value)).then((_) {
            MethodUtils.showSuccess(context, "$label copied.");
          });
        },
      ),
    );
  }

  Widget launchAppbutton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: SizedBox(
        width: double.infinity, // full width button
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () async {
            final upiId = qrList[selectedQRIndex];
            final amount = amountController.text.trim().isEmpty
                ? "1"
                : amountController.text.trim();

            // Create UPI payment URI with required + recommended params
            final Uri uri = Uri.parse(
              "upi://pay?"
              "pa=$upiId&" // Payee VPA (UPI ID)
              "pn=myrex11&" // Payee name
              "am=$amount&" // Amount
              "cu=INR&" // Currency
              "tn=Deposit&" // Transaction note
              "tr=TXN${DateTime.now().millisecondsSinceEpoch}", // Unique transaction ref
            );

            try {
              if (await canLaunchUrl(uri)) {
                await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                );
              } else {
                debugPrint("No UPI app found.");
              }
            } catch (e) {
              debugPrint("Error launching UPI intent: $e");
            }
          },
          child: Text("Open UPI App"),
        ),
      ),
    );
  }

  Widget buildAmountField() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              'Enter Amount',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: "Roboto",
                fontSize: 14,
                color: textCol,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            child: TextField(
              focusNode: focusNode1,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
              ],
              controller: amountController,
              keyboardType: TextInputType.number,
              maxLength: max_deposite.length,
              style: TextStyle(fontSize: 14),
              onChanged: (value) {
                if (checkPromoId.isNotEmpty) {
                  applyPromoCode(noloader: true);
                }
                if (value.isNotEmpty) {
                  final enteredAmount = int.tryParse(value) ?? -1;
                  final matchedIndex = amounts.indexOf(enteredAmount);

                  setState(() {
                    if (matchedIndex != -1) {
                      selectedIndex =
                          matchedIndex; // highlight the matched amount tab
                    } else {
                      selectedIndex = -1; // no match, deselect all
                    }
                  });
                } else {
                  setState(() {
                    selectedIndex = -1; // empty input, deselect all
                  });
                }
              },
              decoration: InputDecoration(
                counterText: '',

                // ❌ remove counterText, use helperText instead
                helperText:
                    'Min $min_deposite & max $max_deposite allowed per day',
                helperStyle: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                ),
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(right: 4, left: 12),
                  child: Container(
                    height: 18,
                    width: 18,
                    child: Image.asset(AppImages.goldcoin),
                  ),
                ),
                prefixIconConstraints:
                    BoxConstraints(minWidth: 0, minHeight: 0),

                hintStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                hintText: 'Enter Amount',

                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 12),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: borderColor, width: 0.7),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: borderColor, width: 0.7),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildUploadField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: DottedBorder(
        color: borderColor,
        borderType: BorderType.RRect,
        radius: Radius.circular(10),
        strokeWidth: 1.2,
        dashPattern: [6, 3], // 6px dash, 3px gap
        child: upiScreenshot.isEmpty
            ? InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  upiScreenshotUpload = true;
                  if (await Permission.mediaLibrary.request().isGranted) {
                    showOptionsDialog(context);
                  }
                },
                child: Container(
                  color: Color(0Xff0af30000),
                  width: double.infinity,
                  height: 45,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 20,
                        child: Image.asset(AppImages.uploadss),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Upload File",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: FileImage(File(
                              upiScreenshot)), // Use FileImage instead of NetworkImage
                        ),
                      ),
                      height: 140,
                      width: MediaQuery.of(context).size.width,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            upiScreenshot = ''; // Clear the image
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.close,
                            color: primaryColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildUTRField() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 8),
            child: Text(
              'UTR Number',
              style: TextStyle(
                fontFamily: "Roboto",
                fontSize: 14,
                color: textCol,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // TextField
          TextField(
            focusNode: focusNode2,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9,a-z,A-Z]')),
            ],
            controller: utrController,
            textCapitalization: TextCapitalization.characters,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              counterText: "", // hides the counter
              // fillColor: const Color(0Xff0af30000),
              filled: true,
              hintStyle: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal,
              ),
              hintText: 'Enter UTR Number',

              // Reduce height
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 12,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: borderColor,
                  width: 0.7,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: borderColor,
                  width: 0.7,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  cashservisepopup() {
    return AlertDialog(
      title: Text('Service unavailable'),
      content: Text(
          'We are unavailable to provide add cash service at the moment till you can practice in free contests.'), // Message which will be pop up on the screen
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(width: 2, color: primaryColor)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Ok',
            style: TextStyle(color: primaryColor),
          ),
        ),
      ],
    );
  }

  Future<void> showOptionsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Select Profile Picture",
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: Text(
                    "Take Photo",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
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
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _getImage(context, ImageSource.gallery);
                  },
                ),
                Padding(padding: EdgeInsets.all(10)),
                GestureDetector(
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _getImage(BuildContext context, ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    FocusScope.of(context).unfocus();

    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        setState(() {
          upiScreenshot = pickedFile.path;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('UPI screenshot selected successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to select image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void showAddCashDialog(
    BuildContext context, {
    required List<Map<String, dynamic>> walletAddresses,
    String? text1,
    String? text1Value,
    String? text2,
    String? text2Value,
    String? text3,
    String? text3Value,
    String? text4,
    String? text4Value,
    String? text5,
    String? text5Value,
    String? ruleText,
    String? conversion_text,
  }) {
    Map<String, dynamic>? selectedWalletData =
        walletAddresses.isNotEmpty ? walletAddresses[0] : null;
    // walletAddresses.removeLast();
    selectedAddress = walletAddresses[0]['address'];
    selectedContact = walletAddresses[0]['contract'];
    selectedChain = walletAddresses[0]['chain'];
    selectedChainType = walletAddresses[0]['chainType'];

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Add Cash',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          Text(
                              walletAddresses.length > 1
                                  ? 'Select Chain'
                                  : 'Chain',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 118, 118, 118),
                                  fontFamily: 'Roboto')),
                          const SizedBox(height: 4),
                          walletAddresses.length > 1
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButton<Map<String, dynamic>>(
                                    value: selectedWalletData,
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                    items: walletAddresses.map<
                                        DropdownMenuItem<
                                            Map<String, dynamic>>>((wallet) {
                                      final chain =
                                          wallet['chain'] as String? ?? '';
                                      return DropdownMenuItem<
                                          Map<String, dynamic>>(
                                        value:
                                            wallet, // store full wallet object
                                        child: Text(chain),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedWalletData = value;

                                        // Save address and contract
                                        selectedAddress =
                                            value?['address'] as String? ?? '';
                                        selectedContact =
                                            value?['contract'] as String? ?? '';
                                        selectedChain =
                                            value?['chain'] as String? ?? '';
                                        selectedChainType =
                                            value?['chainType'] as String? ??
                                                '';
                                      });
                                    },
                                  ),
                                )
                              : selectedChain.isNotEmpty
                                  ? _contractinputBox(selectedChain,
                                      gesturetap: false)
                                  : Container(),

                          SizedBox(height: 10),

                          Text('Contract',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 118, 118, 118),
                                  fontFamily: 'Roboto')),
                          SizedBox(height: 4),
                          _contractinputBox(selectedContact),
                          SizedBox(height: 10),
                          Text('Crypto Address',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 118, 118, 118),
                                  fontFamily: 'Roboto')),
                          SizedBox(height: 4),
                          _inputBox(selectedAddress.toString()),
                          SizedBox(height: 10),
                          expantion(selectedAddress),
                          SizedBox(height: 6),
                          // Approx Conversion
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                text1 ?? '',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                    color: Color(0xff4E4E4E)),
                              ),
                              JustTheTooltip(
                                controller: tooltipController,
                                preferredDirection: AxisDirection.up,
                                margin: const EdgeInsets.only(left: 30),
                                tailLength: 10,
                                tailBaseWidth: 20,
                                backgroundColor: Colors.black,
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    text1Value ?? '',
                                    style: TextStyle(
                                      fontFamily: "Roboto",
                                      color: Colors.white,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                child: GestureDetector(
                                    onTap: () {
                                      tooltipController.showTooltip();
                                    },
                                    child: Icon(Icons.info_outline,
                                        size: 25, color: primaryColor)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          if (text2!.isNotEmpty)
                            _conversionRow(
                              text2 ?? '',
                              trailing: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 6),
                                    child: Container(
                                      height: 18,
                                      width: 18,
                                      child: Image.asset(AppImages.goldcoin),
                                    ),
                                  ),
                                  Text(
                                    text2Value ?? '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Roboto',
                                        color: Color(0xff3A3535)),
                                  ),
                                ],
                              ),
                            ),

                          if (text3!.isNotEmpty)
                            _conversionRow(
                              text3 ?? '',
                              trailing: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 6),
                                    child: Container(
                                      height: 18,
                                      width: 18,
                                      child: Image.asset(AppImages.ustd),
                                    ),
                                  ),
                                  Text(
                                    text3Value ?? '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Roboto',
                                        color: Color(0xff3A3535)),
                                  ),
                                ],
                              ),
                            ),

                          if (text4!.isNotEmpty)
                            _conversionRow(
                              text4 ?? '',
                              trailing: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 6),
                                    child: Container(
                                      height: 18,
                                      width: 18,
                                      child: Image.asset(AppImages.goldcoin),
                                    ),
                                  ),
                                  Text(
                                    text4Value ?? '',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w600,
                                      color: buttonGreenColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          if (text5!.isNotEmpty)
                            _conversionRow(
                              text4 ?? '',
                              trailing: Row(
                                children: [
                                  // Padding(
                                  //   padding: EdgeInsets.only(right: 6),
                                  //   child: Container(
                                  //     height: 18,
                                  //     width: 18,
                                  //     child: Image.asset(AppImages.goldcoin),
                                  //   ),
                                  // ),
                                  Text(
                                    text5Value ?? '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Roboto',
                                        color: Color(0xff3A3535)),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 12),

                          // Rules
                          if (conversion_text!.isNotEmpty)
                            Container(
                                // margin: EdgeInsets.only(
                                //     left: 8),
                                child: Html(
                              data: conversion_text,
                              style: {
                                "body": Style(
                                  margin: Margins.zero,
                                  padding: HtmlPaddings.zero,
                                ),
                                "p": Style(
                                  margin: Margins.zero,
                                  padding: HtmlPaddings.zero,
                                ),
                                "div": Style(
                                  margin: Margins.zero,
                                  padding: HtmlPaddings.zero,
                                ),
                              },
                            )),
                          if (conversion_text!.isNotEmpty) SizedBox(height: 6),
                          if (ruleText!.isNotEmpty)
                            Container(
                                // margin: EdgeInsets.only(
                                //     left: 8),
                                child: Html(
                              style: {
                                "body": Style(
                                  margin: Margins.zero,
                                  padding: HtmlPaddings.zero,
                                ),
                                "p": Style(
                                  margin: Margins.zero,
                                  padding: HtmlPaddings.zero,
                                ),
                                "div": Style(
                                  margin: Margins.zero,
                                  padding: HtmlPaddings.zero,
                                ),
                              },
                              data: ruleText,
                            )),
                          // Text(
                          //   ruleText ?? '',
                          //   style: TextStyle(fontSize: 12, color: Colors.grey),
                          // ),

                          const SizedBox(height: 16),

                          // Add Cash Button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                currencyAddCashRequest();
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => PaymentInAppWebView(
                                //       'http://nayawala.rglabs.net/?user_id=1&amount=1',
                                //       Color.fromARGB(255, 112, 91, 236),
                                //       '',
                                //     ),
                                //   ),
                                // );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonGreenColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  side: const BorderSide(
                                    color: Color(0xFF6A0BF8),
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Done',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -12,
                    right: -12,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 243, 237, 244),

                            border: Border.all(color: primaryColor),
                            shape: BoxShape.circle,
                            //color: Colors.white,
                          ),
                          child: Icon(
                            Icons.close,
                            color: primaryColor,
                            size: 20,
                          )),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

// Input Box Widget
  Widget _inputBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: LightprimaryColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                showCryptoAdressDialog(context,
                    address: text, title: 'Crypto Address');
              },
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black87,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Address copied')),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: const Icon(
                Icons.copy,
                size: 23,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contractinputBox(String text, {bool? gesturetap}) {
    return GestureDetector(
      onTap: () {
        if (gesturetap != false) {
          showCryptoAdressDialog(context,
              address: text, title: 'Crypto Contract');
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: LightprimaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black87,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            // InkWell(
            //   onTap: () {
            //     Clipboard.setData(ClipboardData(text: text));
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(content: Text('Address copied')),
            //     );
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.only(left: 10),
            //     child: const Icon(
            //       Icons.copy,
            //       size: 23,
            //       color: Colors.grey,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget expantion(String text) {
    return ExpansionTile(
      tilePadding: EdgeInsets.all(0),
      title: Text(
        'Show QR Code',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: Icon(
        Icons.qr_code,
        // color: Colors.black,
      ),
      childrenPadding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        Center(
          child: QrImageView(
            data: text,
            size: 130,
            embeddedImageStyle: QrEmbeddedImageStyle(
              size: const Size(110, 110),
            ),
          ),
        ),
      ],
    );
  }

  void showCryptoAdressDialog(
    BuildContext context, {
    String? address,
    String? title,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(address ?? ''),
                    ],
                  )),
              Positioned(
                top: -12,
                right: -12,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 243, 237, 244),

                        border: Border.all(color: primaryColor),
                        shape: BoxShape.circle,
                        //color: Colors.white,
                      ),
                      child: Icon(
                        Icons.close,
                        color: primaryColor,
                        size: 20,
                      )),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

// Conversion Row Widget
  Widget _conversionRow(String title, {required Widget trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xff4E4E4E)),
          ),
          trailing,
        ],
      ),
    );
  }

  void currencyAddCashRequest() async {
    setState(() {
      isloading = true;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${AppRepository.dio.options.baseUrl}api/auth/add-cash-initiate',
        ),
      );

      request.headers['Authorization'] = AppConstants.token;
      request.headers['Devicetype'] = Platform.isIOS
          ? 'IOS'
          : Platform.isAndroid
              ? 'ANDROID'
              : 'WEB';
      request.headers['Versioncode'] = AppConstants.versionCode;
      request.headers['Accept'] = 'application/json';

      request.fields['user_id'] = userId;
      request.fields['amount'] = amountController.text;
      request.fields['promocode'] = codeController.text;
      request.fields['address'] = selectedAddress;
      request.fields['contract'] = selectedContact;
      request.fields['chain'] = selectedChain;
      request.fields['chainType'] = selectedChainType;

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);
      print('=== REQUEST DETAILS ===');
      print('URL: ${request.url}');
      print('METHOD: ${request.method}');
      print('HEADERS:');
      request.headers.forEach((key, value) {
        print('  $key: $value');
      });

      print('FIELDS:');
      request.fields.forEach((key, value) {
        print('  $key: $value');
      });
      print('=======================');
      print('=== RESPONSE DETAILS ===');
      print(jsonResponse);

      if (jsonResponse['status'] == 1) {
        final result = jsonResponse['result'];
        Fluttertoast.showToast(
          msg: jsonResponse['msg'] ?? 'Submission failed',
        );
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: jsonResponse['msg'] ?? 'Submission failed',
        );
      }
    } catch (e) {
      print('Error submitting transaction: $e');
      Fluttertoast.showToast(msg: 'Oops something went wrong...');
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }
}
