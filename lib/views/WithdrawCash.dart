import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:myrex11/hardwereInfoList/hardwereInfo.dart';
import 'package:myrex11/repository/model/gst_details_response.dart';
import 'package:myrex11/repository/model/tds_data.dart';
import 'package:intl/intl.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/bank_details_response.dart';
import 'package:myrex11/repository/model/base_request.dart';
import 'package:myrex11/repository/model/withdraw_amount_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';
import 'package:http/http.dart' as http;

class WithdrawCash extends StatefulWidget {
  String? type;
  bool? withdrawOption;
  String? affiliate_commission;
  String? transferPercent;

  WithdrawCash(
      {this.type,
      this.withdrawOption,
      this.affiliate_commission,
      this.transferPercent});

  @override
  _WithdrawCashState createState() => new _WithdrawCashState();
}

class _WithdrawCashState extends State<WithdrawCash> {
  TextEditingController amountController = TextEditingController();
  TextEditingController NodeController = TextEditingController();
  TextEditingController CryptoAddressController = TextEditingController();
  TextEditingController creditAmountController = TextEditingController();
  final tooltipController = JustTheController();
  String winningAmount = '0';
  String mobile = '0';
  String userId = '0';
  GetTDSData tdsData = GetTDSData();

  // String widget.type='bank';
  String gatewayCharges = 'Gateway charges 1.99% + 18%';
  BankDetailItem bankDetailItem = new BankDetailItem();
  BankDetailResponse? referBonusListResponse;
  bool popUp = false;
  String? withdraw_limit_string;
  String? withdraw_min_limit;
  String? withdraw_max_limit;

  String min_bank_withdraw = '0';

  String max_bank_withdraw = '0';

  String min_inst_withdraw = '0';

  String max_inst_withdraw = '0';

  String winning_to_transfer_min = '0';
  String winning_to_transfer_max = '0';

  TDSResultPopUp TdsResult = TDSResultPopUp();
  String? newText = '';
  bool isExpanded = false;

  String withdraw_request_id = '';
  int processingTime = 0;

  String CheckStatus = '';
  String Statusmessage = '';

  String testStatus = '';
  String bankName = '';
  String bankkAcc = '';
  List<String> nodes = [];
  String selectedNode = '';
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    print(widget.withdrawOption);
    AppPrefrence.getString(AppConstants.withdraw_limit_string).then((value) => {
          setState(() {
            withdraw_limit_string = value;
          })
        });
    AppPrefrence.getString(AppConstants.withdraw_min_limit).then((value) => {
          setState(() {
            withdraw_min_limit = value;
          })
        });
    AppPrefrence.getString(AppConstants.withdraw_max_limit).then((value) => {
          setState(() {
            withdraw_max_limit = value;
          })
        });
    AppPrefrence.getString(AppConstants.KEY_USER_WINING_AMOUNT)
        .then((value) => {
              setState(() {
                winningAmount = value;
              })
            });
    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_MOBILE)
        .then((value) => {
              setState(() {
                mobile = value;
              })
            });

    AppPrefrence.getString(AppConstants.MIN_BANK_WITHDRAW).then((value) => {
          setState(() {
            min_bank_withdraw = value;
          })
        });
    AppPrefrence.getString(AppConstants.MAX_BANK_WITHDRAW).then((value) => {
          setState(() {
            max_bank_withdraw = value;
          })
        });

    AppPrefrence.getString(AppConstants.MIN_INST_WITHDRAW).then((value) => {
          setState(() {
            min_inst_withdraw = value;
          })
        });
    AppPrefrence.getString(AppConstants.MAX_INST_WITHDRAW).then((value) => {
          setState(() {
            max_inst_withdraw = value;
          })
        });

    AppPrefrence.getString(AppConstants.MIN_WINNING_TRANSFER).then((value) => {
          setState(() {
            winning_to_transfer_min = value;
          })
        });
    AppPrefrence.getString(AppConstants.MAX_WINNING_TRANSFER).then((value) => {
          setState(() {
            winning_to_transfer_max = value;
          })
        });

    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
        .then((value) => {
              setState(() {
                userId = value;
                getBankDetail();
              })
            });

    amountController.addListener(() {
      setState(() {
        if (amountController.text.length > 0) {
          double amount = double.parse(amountController.text.toString());
          double gatewayCharge = (amount * 1.99) / 100;
          double gstCharge = (gatewayCharge * 18) / 100;
          double deductionCharge = gatewayCharge + gstCharge;
          gatewayCharges = "Gateway charges 1.99% + 18% = " +
              (new NumberFormat("##.##").format(deductionCharge));
          creditAmountController.text =
              NumberFormat("##.##").format(amount - deductionCharge);
        } else {
          creditAmountController.text = '';
          gatewayCharges = "Gateway charges 1.99% + 18%";
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencySymbol = '₹';
    final parts = newText!.split(currencySymbol);
    final beforeAmount = parts[0];
    final amount =
        parts.length > 1 ? '$currencySymbol${parts[1].split(' ').first}' : '';
    final afterAmount =
        parts.length > 1 ? parts[1].substring(parts[1].indexOf(' ') + 1) : '';

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            /* set Status bar color in Android devices. */
            statusBarIconBrightness: Brightness.light,
            /* set Status bar icons color in Android devices.*/
            statusBarBrightness:
                Brightness.light) /* set Status bar icon color in iOS. */
        );
    return Container(
      color: primaryColor,
      child: Stack(
        children: [
          Scaffold(
            bottomNavigationBar: BottomAppBar(
                color: bgColor,
                elevation: 0,
                child: GestureDetector(
                  onTap: () {
                    if (amountController.text.isEmpty ||
                        int.parse(amountController.text.toString()) <
                            int.parse(min_bank_withdraw))
                      MethodUtils.showError(
                          context,
                          "Please enter minimum " +
                              min_bank_withdraw.toString() +
                              " balance",
                          color: Colors.red);
                    else if (CryptoAddressController.text.isEmpty)
                      MethodUtils.showError(
                          context, "Please enter crypto address",
                          color: Colors.red);
                    else if (int.parse(amountController.text.toString()) >
                        int.parse(max_bank_withdraw))
                      MethodUtils.showError(
                          context,
                          "You can withdrawal up to " +
                              max_bank_withdraw.toString() +
                              " from balance",
                          color: Colors.red);
                    // else if (double.parse(amountController.text.toString()) >
                    //     double.parse(widget.withdrawOption == true
                    //         ? widget.affiliate_commission.toString()
                    //         : winningAmount))
                    //   MethodUtils.showError(context, "Insufficient Fund",
                    //       color: Colors.red);
                    else {
                      // withdrawUserBalance();
                      if (widget.withdrawOption == true) {
                        currencyConvert();
                      } else {
                        currencyConvert();
                      }
                    }
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
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
                    margin: EdgeInsets.fromLTRB(70, 0, 70, 15),
                    child: Center(
                      child: Text(
                        widget.type == 'winning_transfer'
                            ? 'Transfer Now'
                            : 'Withdraw Now'.toUpperCase(),
                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    // shape: RoundedRectangleBorder(
                    //     borderRadius:
                    //     BorderRadius.circular(5)),
                  ),
                )),
            backgroundColor: bgColor,
            /* appBar: PreferredSize(
              preferredSize: Size.fromHeight(55), // Set this height
              child: Container(
                color: primaryColor,
                padding: Platform.isAndroid
                    ? EdgeInsets.only(top: 0)
                    : EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => {Navigator.pop(context)},
                      child: new Container(
                        padding: EdgeInsets.all(15),
                        alignment: Alignment.centerLeft,
                        child: new Container(
                          width: 15,
                          height: 15,
                          child: Image(
                            image: AssetImage(AppImages.backImageURL),
                            fit: BoxFit.fill,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: new Text(
                          widget.type == 'winning_transfer'
                              ? 'Transfer to Deposit'
                              : 'Withdraw',
                          style: TextStyle(
                              fontFamily: "Roboto",
                              //fontFamily: "Roboto",
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),*/

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
                    // image:
                    //     AssetImage("assets/images/Ic_creatTeamBackGround.png"),
                    // fit: BoxFit.cover)

                    ),
                child: Row(
                  children: [
                    AppConstants.backButtonFunction(),
                    Text(
                        widget.type == 'winning_transfer'
                            ? 'Transfer to Deposit'
                            : 'Withdraw cash',
                        style: TextStyle(
                            fontFamily: "Roboto",
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16)),
                  ],
                ),
              ),
            ),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Stack(children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: LightprimaryColor,
                              border: Border.all(
                                color: primaryColor, // Set the border color
                                width: 0.7, // Optional: Set border width
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 8),
                                  alignment: Alignment.center,
                                  child: Text(
                                    widget.affiliate_commission != null
                                        ? 'Affiliate Wallet'
                                        : 'Your Winnings',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 16,
                                      color: Color(0xFF3e3c3c),
                                      // fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
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
                                      Text(
                                        widget.affiliate_commission != null
                                            ? widget.affiliate_commission
                                                .toString()
                                            : winningAmount,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          //  fontFamily: "Roboto",
                                          fontSize: 16,
                                          color: greenColor,
                                          // fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // widget.type == 'winning_transfer'
                        //     ? Container(
                        //         height: 15,
                        //       )
                        //     : Card(
                        //         elevation: 0,
                        //         margin: EdgeInsets.all(15),
                        //         shape: RoundedRectangleBorder(
                        //           side: BorderSide(color: borderColor, width: 1),
                        //           borderRadius: BorderRadius.circular(5),
                        //         ),
                        //         child: Container(
                        //           padding: EdgeInsets.all(15),
                        //           child: Row(
                        //             children: [
                        //               Container(
                        //                 margin: EdgeInsets.only(right: 10),
                        //                 padding: EdgeInsets.all(5),
                        //                 height: widget.type == 'paytm_instant'
                        //                     ? 30
                        //                     : 50,
                        //                 width: 50,
                        //                 child: Image.asset(
                        //                     widget.type == 'paytm_instant'
                        //                         ? AppImages.paytmIcon
                        //                         : AppImages.withdrawbank,
                        //                     fit: BoxFit.fill),
                        //               ),
                        //               Column(
                        //                 crossAxisAlignment:
                        //                     CrossAxisAlignment.start,
                        //                 children: [
                        //                   if (bankName.isNotEmpty)
                        //                     Text(
                        //                       widget.type == 'paytm_instant'
                        //                           ? 'PAYTM WALLET'
                        //                           : bankName,
                        //                       style: TextStyle(
                        //                           fontFamily: "Roboto",
                        //                           color: Colors.black,
                        //                           fontSize: 14,
                        //                           fontWeight: FontWeight.w500),
                        //                     ),
                        //                   Container(
                        //                     margin: EdgeInsets.only(top: 5),
                        //                     child: Text(
                        //                       widget.type == 'paytm_instant'
                        //                           ? mobile
                        //                           : bankkAcc,
                        //                       style: TextStyle(
                        //                           fontFamily: "Roboto",
                        //                           color: Colors.grey,
                        //                           fontSize: 14,
                        //                           fontWeight: FontWeight.w400),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               )
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        Container(
                          margin: EdgeInsets.only(left: 15, right: 15),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(bottom: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Amount',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: "Roboto",
                                    //fontFamily: "Roboto",
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                // height: 45,
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    TextField(
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[0-9.]')),
                                        DecimalInputFormatter(),
                                      ],
                                      controller: amountController,
                                      maxLength:
                                          widget.type == "bank_instant" ? 5 : 6,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            left: 35, top: 15, bottom: 15),
                                        counterText: "",
                                        fillColor: Colors.white,
                                        filled: true,
                                        //   prefixText: '₹ ',
                                        //   prefixStyle:  TextStyle(
                                        //   fontFamily: "Roboto",
                                        //   fontSize: 15,
                                        //   color: Colors.black,
                                        //   fontStyle: FontStyle.normal,
                                        //   fontWeight: FontWeight.bold,
                                        // ),
                                        // prefixIcon: Padding(
                                        //   padding:
                                        //       const EdgeInsets.only(left: 2, top: 8),
                                        //   child: Text('₹ ',
                                        //       style: TextStyle(
                                        //         fontFamily: "Roboto",
                                        //         fontSize: 15,
                                        //         color: Colors.black,
                                        //         fontStyle: FontStyle.normal,
                                        //         fontWeight: FontWeight.bold,
                                        //       )),
                                        // ),
                                        hintStyle: TextStyle(
                                          fontFamily: "Roboto",
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.normal,
                                        ),

                                        hintText: 'Enter Amount',

                                        disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                              color: Color(0xFFEDE2FE),
                                              width: 1),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                              color: Color(0xFFEDE2FE),
                                              width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                              color: Color(0xFFEDE2FE),
                                              width: 1),
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontFamily:
                                            'Roboto', // Change this to your desired font family
                                        fontSize:
                                            15, // Change this to your desired font size
                                        fontWeight: FontWeight
                                            .normal, // Change this to your desired font weight
                                        color: Colors
                                            .black, // Change this to your desired font color
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: 6, left: 10),
                                      child: Container(
                                        height: 18,
                                        width: 18,
                                        child: Image.asset(AppImages.goldcoin),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(bottom: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Node',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: "Roboto",
                                    //fontFamily: "Roboto",
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              if (nodes.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: LightprimaryColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButton<String>(
                                    focusColor: Colors.white,
                                    value: selectedNode, // String
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                    items: nodes
                                        .map<DropdownMenuItem<String>>((node) {
                                      return DropdownMenuItem<String>(
                                        value: node,
                                        child: Text(node),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedNode = value ?? '';
                                      });
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(bottom: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Crypto Ad.',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: "Roboto",
                                    //fontFamily: "Roboto",
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                // height: 45,
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    TextField(
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      controller: CryptoAddressController,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            left: 12, top: 15, bottom: 15),
                                        counterText: "",
                                        fillColor: Colors.white,
                                        filled: true,
                                        //   prefixText: '₹ ',
                                        //   prefixStyle:  TextStyle(
                                        //   fontFamily: "Roboto",
                                        //   fontSize: 15,
                                        //   color: Colors.black,
                                        //   fontStyle: FontStyle.normal,
                                        //   fontWeight: FontWeight.bold,
                                        // ),
                                        // prefixIcon: Padding(
                                        //   padding:
                                        //       const EdgeInsets.only(left: 2, top: 8),
                                        //   child: Text('₹ ',
                                        //       style: TextStyle(
                                        //         fontFamily: "Roboto",
                                        //         fontSize: 15,
                                        //         color: Colors.black,
                                        //         fontStyle: FontStyle.normal,
                                        //         fontWeight: FontWeight.bold,
                                        //       )),
                                        // ),
                                        hintStyle: TextStyle(
                                          fontFamily: "Roboto",
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.normal,
                                        ),

                                        hintText: 'Crypto Ad.',

                                        disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                              color: Color(0xFFEDE2FE),
                                              width: 1),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                              color: Color(0xFFEDE2FE),
                                              width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                              color: Color(0xFFEDE2FE),
                                              width: 1),
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontFamily:
                                            'Roboto', // Change this to your desired font family
                                        fontSize:
                                            15, // Change this to your desired font size
                                        fontWeight: FontWeight
                                            .normal, // Change this to your desired font weight
                                        color: Colors
                                            .black, // Change this to your desired font color
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // val=='paytm_instant'?new Container(
                        //   margin: EdgeInsets.only(left: 15,right: 15,top: 20),
                        //   child:""Column(
                        //     children: [
                        //      ""Container(
                        //         padding: EdgeInsets.only(bottom: 10),
                        //         alignment: Alignment.centerLeft,
                        //         child: Text(
                        //           'Amount to be credited',
                        //           textAlign: TextAlign.start,
                        //           style: TextStyle(fontFamily: "Roboto",
                        //             //fontFamily: "Roboto",
                        //             fontSize: 14,
                        //             color: Colors.black,
                        //             fontStyle: FontStyle.normal,
                        //             fontWeight: FontWeight.w500,
                        //           ),
                        //         ),
                        //       ),
                        //      ""Container(
                        //         child:""Stack(
                        //           alignment: Alignment.centerRight,
                        //           children: [
                        //            ""Container(
                        //               height: 45,
                        //               child: TextField(
                        //                 controller: creditAmountController,
                        //                 keyboardType: TextInputType.number,
                        //                 maxLength: 6,
                        //                 decoration: InputDecoration(
                        //                   counterText: "",
                        //                   fillColor: Colors.white,
                        //                   filled: true,
                        //                   prefixIcon:""Container(
                        //                     child: Center(
                        //                       widthFactor: 0.0,
                        //                       child: Text('₹',
                        //                           style: TextStyle(fontFamily: "Roboto",
                        //                             fontSize: 15,
                        //                             color: Colors.black,
                        //                             fontStyle:
                        //                             FontStyle.normal,
                        //                             fontWeight:
                        //                             FontWeight.bold,
                        //                           )),
                        //                     ),
                        //                   ),
                        //                   hintStyle: TextStyle(fontFamily: "Roboto",
                        //                     fontSize: 12,
                        //                     color: Colors.grey,
                        //                     fontStyle: FontStyle.normal,
                        //                     fontWeight: FontWeight.normal,
                        //                   ),
                        //                   hintText: 'Enter Amount',
                        //                   enabledBorder: const OutlineInputBorder(
                        //                     // width: 0.0 produces a thin "hairline" border
                        //                     borderSide:
                        //                     const BorderSide(color: Colors.grey, width: 0.0),
                        //                   ),
                        //                   focusedBorder: OutlineInputBorder(
                        //                     borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //      ""Container(
                        //         alignment: Alignment.centerLeft,
                        //         padding: EdgeInsets.only(top: 3),
                        //         child: Text(
                        //           gatewayCharges,
                        //           style:""TextStyle(fontFamily: "Roboto",
                        //               //fontFamily: AppConstants.textRegular,
                        //               fontSize: 12.0,
                        //               color: Colors.black,
                        //               fontWeight: FontWeight.w400),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ):Container(),
                        // val=='paytm_instant'?new Container(
                        //   alignment: Alignment.centerLeft,
                        //   padding: EdgeInsets.only(left: 15,top: 5,bottom: 5,right: 15),
                        //   child: Text(
                        //     "Paytm Instant min:- " + AppConstants.MIN_PAYTM_WITHDRAW_AMOUNT.toString() + " max:- " + AppConstants.MAX_PAYTM_WITHDRAW_AMOUNT.toString(),
                        //     style:""TextStyle(fontFamily: "Roboto",
                        //         //fontFamily: AppConstants.textRegular,
                        //         fontSize: 13.0,
                        //         color: Colors.grey,
                        //         fontWeight: FontWeight.w400),
                        //   ),
                        // ):

                        // widget.type=='bank_instant'? Column(
                        //   children: [
                        //    ""Container(
                        //       alignment: Alignment.centerLeft,
                        //       padding: EdgeInsets.only(left: 15,top: 5,bottom: 5,right: 15),
                        //       child: Text(
                        //         "Bank Instant min:- " + AppConstants.MIN_BANK_INSTANT_WITHDRAW_AMOUNT.toString() + " , Max:- " + AppConstants.MAX_BANK_INSTANT_WITHDRAW_AMOUNT.toString(),
                        //         style:""TextStyle(fontFamily: "Roboto",
                        //             //fontFamily: AppConstants.textRegular,
                        //             fontSize: 13.0,
                        //             color: Colors.grey,
                        //             fontWeight: FontWeight.w400),
                        //       ),
                        //     ),
                        //     SizedBox(height: 30,),
                        //     Text('')
                        //   ],
                        // ):

                        // widget.affiliate_commission != null
                        //     ? Container()
                        //     : Container(
                        //         alignment: Alignment.centerLeft,
                        //         padding: EdgeInsets.only(
                        //             left: 15, top: 10, bottom: 5, right: 15),
                        //         child: Text(
                        //           widget.type == "bank_instant"
                        //               ? withdraw_limit_string ?? ""
                        //               :
                        //               // "Min ₹200 & max ₹2,00,000 allowed per day ",
                        //               "Min ₹" +
                        //                   min_bank_withdraw.toString() +
                        //                   " & max ₹" +
                        //                   max_bank_withdraw.toString() +
                        //                   " allowed per day",
                        //           style: TextStyle(
                        //               fontFamily: "Roboto",
                        //               //fontFamily: AppConstants.textRegular,
                        //               fontSize: 13.0,
                        //               color: Colors.grey,
                        //               fontWeight: FontWeight.w400),
                        //         ),
                        //       ),
                        widget.type == 'winning_transfer'
                            ? buildTransferToDepositContainer(
                                amountRequested: amountController.text.isEmpty
                                    ? 0
                                    : double.parse(amountController.text),
                                extraPercentage:
                                    double.parse(widget.transferPercent ?? '0'),
                              )
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        widget.type == 'winning_transfer'
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(7))),
                                  child: Card(
                                    borderOnForeground: false,
                                    elevation: 0,
                                    // shape: RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.circular(8)),
                                    child: Column(
                                      children: [
                                        // Header
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              isExpanded = !isExpanded;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 11, vertical: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Important Note',
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontFamily: "Roboto",
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Icon(
                                                  isExpanded
                                                      ? Icons.expand_less
                                                      : Icons.expand_more,
                                                  size: 30,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Expanded Content
                                        if (isExpanded)
                                          SingleChildScrollView(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 11),
                                              child: Column(
                                                children: [
                                                  Container(
                                                      // margin: EdgeInsets.only(
                                                      //     left: 8),
                                                      child: Html(
                                                    data: referBonusListResponse ==
                                                            null
                                                        ? ""
                                                        : referBonusListResponse!
                                                            .result![0].content,
                                                  )),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(left: 8, right: 8),
                                child: Html(
                                  data: referBonusListResponse == null
                                      ? ""
                                      : referBonusListResponse!
                                          .result![0].content,
                                )),

                        //""Container(
                        //   alignment: Alignment.centerLeft,
                        //   padding: EdgeInsets.only(left: 15,bottom: 5,right: 15),
                        //   child: Text(
                        //     val=='paytm_instant'?'After full verification we started max 10k withdrawal in paytm instant':val=='bank_instant'?'After full verification we started max 50k withdrawal in bank instant':'After full verification we started max 200k withdrawal in bank',
                        //     style:""TextStyle(fontFamily: "Roboto",
                        //         //fontFamily: AppConstants.textRegular,
                        //         fontSize: 14.0,
                        //         height: 1.5,
                        //         color: Colors.grey,
                        //         fontWeight: FontWeight.w400),
                        //   ),
                        // ),

                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: <Widget>[
                        //    ""GestureDetector(
                        //       behavior: HitTestBehavior.translucent,
                        //       child:""Container(
                        //         margin: EdgeInsets.only(top: 10,left: 5),
                        //         child:""Row(
                        //           children: [
                        //            ""Container(
                        //               height: 20,
                        //               width: 35,
                        //               child: Radio(
                        //                 value: 'paytm_instant',
                        //                 groupValue: val,
                        //                 activeColor: Colors.black,
                        //                 onChanged: (value) {
                        //                   setState(() {
                        //                     val = value.toString();
                        //                   });
                        //                 },
                        //               ),
                        //             ),
                        //             Text(
                        //               'Paytm Wallet',
                        //               style:""TextStyle(fontFamily: "Roboto",
                        //                   fontSize: 14.0,
                        //                   color: Colors.black,
                        //                   fontWeight: FontWeight.w400),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       onTap: (){
                        //         setState(() {
                        //           val='paytm_instant';
                        //         });
                        //       },
                        //     ),
                        //     val=='paytm_instant'?new Container(
                        //       alignment: Alignment.center,
                        //       margin: EdgeInsets.only(left: 30),
                        //       child:""Html(data: "Only 1 withdrawal / transaction allowed per day. Minimum Rs. " + AppConstants.MIN_PAYTM_WITHDRAW_AMOUNT.toString()
                        //           + " & maximum Rs." + AppConstants.MAX_PAYTM_WITHDRAW_AMOUNT.toString() + " can be withdraw per day, Gateway charges 1.99% + GST applicable and will be"
                        //           + " deducted from withdrawal amount. If transaction failed for any reason / no PayTM wallet for registered mobile number / "
                        //           + "technical issue from PayTm, withdrawal amount will be credited back to users playing11 wallet within 7 to 10 working days, For "
                        //           + "instant withdrawal, your registered mobile number should have PayTm wallet account to withdraw instantly. playing11 has solely rights to"
                        //           + " withdraw this feature anytime.",
                        //         style: {
                        //           'html': Style(textAlign: TextAlign.start,color: Colors.grey,textDecoration: TextDecoration.none,
                        //               fontWeight: FontWeight.normal,lineHeight:LineHeight(1.5) )
                        //         },
                        //       ),
                        //     ):Container(),
                        //    ""GestureDetector(
                        //       behavior: HitTestBehavior.translucent,
                        //       child:""Container(
                        //         margin: EdgeInsets.only(top: 15,left: 5),
                        //         child:""Row(
                        //           children: [
                        //            ""Container(
                        //               height: 20,
                        //               width: 35,
                        //               child: Radio(
                        //                 value: 'bank',
                        //                 activeColor: Colors.black,
                        //                 groupValue: val,
                        //                 onChanged: (value) {
                        //                   setState(() {
                        //                     val = value.toString();
                        //                   });
                        //                 },
                        //               ),
                        //             ),
                        //             Text(
                        //               'Bank',
                        //               style:""TextStyle(fontFamily: "Roboto",
                        //                   fontSize: 14.0,
                        //                   color: Colors.black,
                        //                   fontWeight: FontWeight.w400),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       onTap: (){
                        //         setState(() {
                        //           val='bank';
                        //         });
                        //       },
                        //     ),
                        //    ""GestureDetector(
                        //       behavior: HitTestBehavior.translucent,
                        //       child:""Container(
                        //         margin: EdgeInsets.only(top: 15,left: 5),
                        //         child:""Row(
                        //           children: [
                        //            ""Container(
                        //               height: 20,
                        //               width: 35,
                        //               child: Radio(
                        //                 value: 'bank_instant',
                        //                 activeColor: Colors.black,
                        //                 groupValue: val,
                        //                 onChanged: (value) {
                        //                   setState(() {
                        //                     val = value.toString();
                        //                   });
                        //                 },
                        //               ),
                        //             ),
                        //             Text(
                        //               'Instant Withdrawal (Bank)',
                        //               style:""TextStyle(fontFamily: "Roboto",
                        //                   fontSize: 14.0,
                        //                   color: Colors.black,
                        //                   fontWeight: FontWeight.w400),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       onTap: (){
                        //         setState(() {
                        //           val='bank_instant';
                        //         });
                        //       },
                        //     ),
                        //     val=='bank_instant'?new Container(
                        //       alignment: Alignment.center,
                        //       margin: EdgeInsets.only(left: 30),
                        //       child:""Html(data: "<b>Important Note</b>" + " (Imps)<br><br>" +
                        //           "&#8226;" + " Maximum withdrawal of Rs. 50,000 is allowed per day.<br>" +
                        //           "&#8226;" + " For withdrawal of any amount flat Rs. 10 per transaction charge will be levied<br>" +
                        //           "&#8226;" + " To use this feature User must get his KYC verified on playing11.<br>" +
                        //           "&#8226;" + " Only one transaction can be made in 24 hrs.<br>",
                        //         style: {
                        //           'html': Style(textAlign: TextAlign.start,color: Colors.grey,textDecoration: TextDecoration.none,
                        //               fontWeight: FontWeight.normal,lineHeight:LineHeight(1.5) )
                        //         },
                        //       ),
                        //     ):Container(),
                        //   ],
                        // ),

                        // Padding(
                        //   padding: widget.type == "bank_instant"
                        //       ? const EdgeInsets.only(left: 4, right: 4, top: 50)
                        //       : const EdgeInsets.only(left: 4, right: 4, top: 210),
                        //   child: Container(
                        //     child: Html(
                        //       data: "To get information on procssing fees and withdrawing cash from your account, <a href=" +
                        //           AppConstants.withdrawcash_url +
                        //           "><font color='#009672'><u><strong>Click Here.</strong></u></font></a>",
                        //       onLinkTap: (
                        //         link,
                        //         _,
                        //         __,
                        //       ) {
                        //         if (link!.contains("withdraw-term-condition")) {
                        //           navigateToVisionWebView(context,
                        //               'Withdraw Amount and Processing Fee', link);
                        //         }
                        //       },
                        //       style: {
                        //         'html': Style(
                        //           textAlign: TextAlign.start,
                        //           color: Colors.grey,
                        //           textDecoration: TextDecoration.none,
                        //         )
                        //       },
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                    popUp == true ? cashservisepopup() : SizedBox(),
                  ]),
                ),
              ),
            ),
          ),
          if (isloading == true)
            Center(
                child: CircularProgressIndicator(
              color: primaryColor,
            ))
        ],
      ),
    );
  }

  String formatValue(double value) {
    // Check if the value ends with `.0`
    if (value == value.toInt()) {
      return '${value.toInt()}'; // Convert to an integer and display
    } else {
      return '${value.toStringAsFixed(2)}'; // Keep two decimal places
    }
  }

  Widget buildTransferToDepositContainer({
    required double amountRequested,
    required double extraPercentage,
  }) {
    double extraCash =
        double.parse((amountRequested * extraPercentage / 100).toString());
    double totalAmount = amountRequested + extraCash;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        // width: 350,
        // padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: Text(
                'Transfer to Deposit',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Get ${extraPercentage.toStringAsFixed(0)}% Extra Real Cash',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Roboto",
                  color: greenColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Divider(color: Color(0xffebebeb), thickness: 1.0, height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Amount Requested to transfer',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Roboto",
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '${formatValue(amountRequested)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Roboto",
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Extra Real Cash: ${extraPercentage.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Roboto",
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '+${formatValue(extraCash)}',
                    // '+₹${double.tryParse(extraCash.toString())}',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Roboto",
                      color: greenColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total amount to be received',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      formatValue(totalAmount),
                      // '₹  ${double.tryParse(totalAmount.toString())}',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void currencyConvert() async {
    //AppLoaderProgress.showLoader(context);
    setState(() {
      isloading = true;
    });
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${AppRepository.dio.options.baseUrl}api/auth/withdraw-popup',
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
      request.fields['node'] = selectedNode;
      request.fields['crypto_address'] = CryptoAddressController.text ?? "";

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      print('=== RESPONSE DETAILS ===');
      print(jsonResponse);

      if (jsonResponse['status'] == 1) {
        final result = jsonResponse['result'];

        /// ✅ Extract values safely
        String walletAddress = result['wallet_address'] ?? '';
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

        /// ✅ Example: show dialog / bottom sheet / next screen
        showWithdrawCashDialog(
          context,
          walletAddress: walletAddress,
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
      //  AppLoaderProgress.hideLoader(context);
    }
  }

  static Future<bool> _onWillPop() async {
    return Future.value(false);
  }

  void showWithdrawCashDialog(
    BuildContext context, {
    String? walletAddress,
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
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: Dialog(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Withdraw Cash',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      if (text1!.isNotEmpty)
                        _conversionRow(
                          text1 ?? '',
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
                                text1Value ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Roboto',
                                    color: Color(0xff3A3535)),
                              ),
                            ],
                          ),
                        ),

                      if (text2!.isNotEmpty)
                        _conversionRow(
                          text2 ?? '',
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
                      Divider(
                        color: borderColor,
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
                                  child: Image.asset(AppImages.ustd),
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

                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          withdrawUserBalance();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          child: Container(
                              height: 48,
                              width: MediaQuery.of(context).size.width,
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
                              margin: EdgeInsets.only(top: 18),
                              child: Center(
                                  child: Text(
                                "Withdraw".toUpperCase(),
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ))),
                        ),
                      ),
                      SizedBox(height: 6),
                      // Rules
                      if (conversion_text!.isNotEmpty)
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
                          data: conversion_text,
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

                      const SizedBox(height: 16),

                      // Add Cash Button
                    ],
                  ),
                ),
                Positioned(
                  top: -12,
                  right: -12,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.pop(context);
                      FocusScope.of(context).unfocus();
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
          ),
        );
      },
    );
  }

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

  cashservisepopup() {
    return Padding(
      padding: const EdgeInsets.only(top: 150.0),
      child: AlertDialog(
        title: Text('Service unavailable'),
        content: Text(
            'Currently we are unavailable to provide withdraw cash service.'),
        // Message which will be pop up on the screen
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
              style: TextStyle(fontFamily: "Roboto", color: primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void getBankDetail() async {
    AppLoaderProgress.showLoader(context);
    GeneralRequest loginRequest = GeneralRequest(
      user_id: userId,
      type: widget.type,
      affiliate_commission:
          widget.withdrawOption == null || !widget.withdrawOption! ? "0" : "1",
    );
    final client = ApiClient(AppRepository.dio);
    referBonusListResponse = await client.getBankDetails(loginRequest);
    AppLoaderProgress.hideLoader(context);
    if (referBonusListResponse!.status == 1) {
      bankDetailItem = referBonusListResponse!.result![0];
      bankName = bankDetailItem.bankname ?? '';
      bankkAcc = bankDetailItem.accno ?? '';
      nodes = referBonusListResponse!.result![0].node ?? [];
      selectedNode = nodes[0];

      // withraw_time_limit =
      //     int.parse(bankDetailItem.withdraw_time_limit.toString());
      setState(() {});
    }
  }

  void withdrawUserBalance() async {
    try {
      FocusScope.of(context).unfocus();
      AppLoaderProgress.showLoader(context);
      Map<String, dynamic> loginRequest = {
        "user_id": userId,
        "amount": amountController.text.toString(),
        "myIp": await HardWereInfo().ipAddress(),
        "payment_type": widget.type,
        "affiliate_commission":
            widget.withdrawOption == null || !widget.withdrawOption!
                ? "0"
                : "1",
        "node": selectedNode ?? '',
        "crypto_address": CryptoAddressController.text ?? "",
      };

      final client = ApiClient(AppRepository.dio);
      WithdrawResponse withdrawResponse =
          await client.withdrawUserBalance(loginRequest);

      // AppLoaderProgress.hideLoader(context);

      if (withdrawResponse.status == 1) {
        if (withdrawResponse.result!.status == 1) {
          Navigator.pop(AppConstants.context);

          Fluttertoast.showToast(msg: withdrawResponse.result!.msg.toString());

          AppPrefrence.putString(
            AppConstants.KEY_USER_WINING_AMOUNT,
            withdrawResponse.result!.wining.toString(),
          );
          widget.withdrawOption == true
              ? widget.affiliate_commission = double.parse(
                  withdrawResponse.result!.wining.toString(),
                ).toString()
              : winningAmount = double.parse(
                  withdrawResponse.result!.wining.toString(),
                ).toString();
          AppPrefrence.putString(
            AppConstants.KEY_USER_BALANCE,
            withdrawResponse.result!.amount.toString(),
          );
        } else {
          Fluttertoast.showToast(msg: withdrawResponse.result!.msg ?? "");
        }
      } else {
        Fluttertoast.showToast(
            msg: withdrawResponse.message ?? 'An error occurred');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to withdraw balance.');
    } finally {
      setState(() {
        AppLoaderProgress.hideLoader(context);
      });
    }
  }
}

class DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    // Allow empty input
    if (text.isEmpty) {
      return newValue;
    }

    // Match the regex pattern for valid input
    final regExp = RegExp(r'^\d+\.?\d{0,2}$');
    if (regExp.hasMatch(text)) {
      return newValue; // Input is valid
    }

    // If input is invalid, keep the old value
    return oldValue;
  }
}
