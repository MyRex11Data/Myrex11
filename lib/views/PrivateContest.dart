import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myrex11/appUtilities/defaultbutton.dart';
import 'package:myrex11/buildType/buildType.dart';
import 'package:intl/intl.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/app_navigator.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/customWidgets/MatchHeader.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/repository/model/create_private_contest_request.dart';

class PrivateContest extends StatefulWidget {
  GeneralModel model;
  Function onTeamCreated;
  int currentContestIndex;
  List<dynamic> maxMinList;
  int _currentIndex;
  PrivateContest(this.currentContestIndex, this.model, this.onTeamCreated,
      this.maxMinList, this._currentIndex);
  @override
  _PrivateContestState createState() => new _PrivateContestState();
}

class _PrivateContestState extends State<PrivateContest> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  bool _enable = false;
  String entryFee = '0';
  String userId = '0';

  @override
  void initState() {
    super.initState();

    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
        .then((value) => {
              setState(() {
                userId = value;
              })
            });
    amountController.addListener(() {
      setState(() {
        if (amountController.text.isNotEmpty &&
            sizeController.text.isNotEmpty) {
          double total = (double.parse(amountController.text.toString()) *
                  AppConstants.DEFAULT_PERCENT) /
              double.parse(sizeController.text.toString());
          entryFee = NumberFormat("#.#").format(total);
          if (entryFee == "NaN") {
            entryFee = "0";
            setState(() {});
          }
          if (entryFee == "∞") {
            entryFee = "0";
            setState(() {});
          }
          print(["entryFee1", entryFee]);
        } else {
          entryFee = '0';
        }
      });
    });
    sizeController.addListener(() {
      setState(() {
        print(["DEFAULT_PERCENT", AppConstants.DEFAULT_PERCENT]);
        if (amountController.text.isNotEmpty &&
            sizeController.text.isNotEmpty) {
          double total = (double.parse(amountController.text.toString()) *
                  AppConstants.DEFAULT_PERCENT) /
              double.parse(sizeController.text.toString());
          entryFee = NumberFormat("#.#").format(total);
        } else {
          entryFee = '0';
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
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: Container(
        color: primaryColor,
        child: new Scaffold(
          backgroundColor: Colors.white,
          /*   appBar: PreferredSize(
            preferredSize: Size.fromHeight(55), // Set this height
            child: Container(
              padding: EdgeInsets.only(top: 0),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        new GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => {Navigator.pop(context)},
                          child: new Container(
                            alignment: Alignment.centerLeft,
                            child: new Container(
                              width: 16,
                              height: 16,
                              child: Image(
                                image: AssetImage(AppImages.backImageURL),
                                fit: BoxFit.fill,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: new Container(
                              child: new Text(
                            'Create Contest',
                            style: TextStyle(fontFamily: "Roboto",
                                fontFamily: "Roboto",
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          )),
                        ),
                      ],
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        child: Row(
                          children: [
                            // new Text('Ksh'+balance,
                            //     style: TextStyle(fontFamily: "Roboto",
                            //         fontFamily: "Roboto",
                            //         color: Colors.white,
                            //         fontWeight: FontWeight.normal,
                            //         fontSize: 15)),

                            Container(
                              height: 28,
                              width: 28,
                              child: Image(
                                image: AssetImage(
                                  AppImages.wallet_private,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () => {navigateToWallet(context)},
                    ),
                  ],
                ),
              ),
            ),
          ),*/

          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60), // Set this height
            child: Container(
              padding: EdgeInsets.only(
                top: 45,
                bottom: 10,
                left: 16,
              ),
              decoration: BoxDecoration(color: primaryColor
                  // image: DecorationImage(image: AssetImage("assets/images/Ic_creatTeamBackGround.png"),fit: BoxFit.cover)
                  ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 0,
                      ),
                      AppConstants.backButtonFunction(),
                      Text("Create Contest",
                          style: TextStyle(
                              fontFamily: "Roboto",
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16)),
                    ],
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      padding: EdgeInsets.only(left: 0, right: 10),
                      child: Row(
                        children: [
                          // new Text('Ksh'+balance,
                          //     style: TextStyle(fontFamily: "Roboto",
                          //         fontFamily: "Roboto",
                          //         color: Colors.white,
                          //         fontWeight: FontWeight.normal,
                          //         fontSize: 15)),

                          Container(
                            height: 32,
                            // width: 28,
                            child:
                                Image(image: AssetImage(AppImages.wallet_icon)),
                          )
                        ],
                      ),
                    ),
                    onTap: () => {navigateToWallet(context)},
                  ),
                ],
              ),
            ),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              decoration: BoxDecoration(
                  // image: DecorationImage(image: AssetImage(AppImages.commanBackground),fit: BoxFit.cover),
                  color: Colors.white),
              height: MediaQuery.sizeOf(context).height,
              child: new SingleChildScrollView(
                child: new Container(
                  child: new Column(
                    children: [
                      new MatchHeader(
                        widget.model.teamVs!,
                        widget.model.headerText!,
                        widget.model.isFromLive ?? false,
                        widget.model.isFromLiveFinish ?? false,
                        timerColor: primaryColor,
                      ),
                      new Container(
                        color: bgColor,
                        child: new Column(
                          children: [
                            Container(
                              color: LightprimaryColor,
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: new Text(
                                      'Entry Per Team',
                                      style: TextStyle(
                                          fontFamily: "Roboto",
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          decoration: TextDecoration.none),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: Container(
                                            height: 16,
                                            // width: 14,
                                            child:
                                                Image.asset(AppImages.goldcoin),
                                          ),
                                        ),
                                        new Text(
                                          //'₹' +
                                          entryFee,
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                                height: 1,
                                color: Color.fromARGB(255, 244, 200, 200)),
                            Container(
                              color: LightprimaryColor,
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.centerLeft,
                              child: new Text(
                                'Entry is calculated based on total prize amount & contest size',
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    decoration: TextDecoration.none),
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.only(left: 10, top: 20),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Give your contest a name',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 14,
                            color: Color(0xFF747474),
                            // fontFamily: AppConstants.textRegular,
                            // fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      new Container(
                        margin: EdgeInsets.all(10),
                        // height: 45,
                        child: TextField(
                          maxLength: 15,
                          controller: nameController,
                          decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            hintStyle: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 12,
                              color: Colors.grey,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                            ),
                            hintText: '',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            fillColor: Colors.white,
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Color(0xFFEDE2FE), width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: Color(0xFFEDE2FE), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: Color(0xFFEDE2FE), width: 1),
                            ),
                          ),
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            new Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Total winning amount ',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 14,
                                      //color: Colors.grey,

                                      color: Color(0xFF747474),
                                      // fontFamily: AppConstants.textRegular,
                                      // fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Container(
                                    height: 16,
                                    // width: 14,
                                    child: Image.asset(AppImages.goldcoin),
                                  ),
                                ],
                              ),
                            ),
                            new Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '*Min 0 & max 10000',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Container(
                        margin: EdgeInsets.all(10),
                        height: 45,
                        child: TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                            TextInputFormatter.withFunction(
                                (oldValue, newValue) {
                              String text = newValue.text;

                              // Prevent multiple leading zeros
                              if (text.startsWith('0')) {
                                if (text.length > 1) {
                                  if (text
                                      .replaceFirst(RegExp(r'^0+'), '')
                                      .isEmpty) {
                                    // If the text is all zeros, revert to oldValue
                                    return oldValue;
                                  } else {
                                    // Otherwise, remove leading zeros
                                    text =
                                        text.replaceFirst(RegExp(r'^0+'), '');
                                  }
                                }
                              }

                              return TextEditingValue(
                                text: text,
                                selection: TextSelection.collapsed(
                                    offset: text.length),
                              );
                            }),
                          ],
                          maxLength: 5,
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            hintStyle: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 12,
                              color: Colors.grey,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                            ),
                            hintText: '',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            fillColor: Colors.white,
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Color(0xFFEDE2FE), width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: Color(0xFFEDE2FE), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: Color(0xFFEDE2FE), width: 1),
                            ),
                          ),
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            new Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Contest size',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 14,
                                  color: Color(0xFF747474),
                                  // fontFamily: AppConstants.textRegular,
                                  //fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            new Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '*${widget.maxMinList[0]}',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Container(
                        margin: EdgeInsets.all(10),
                        height: 45,
                        child: TextField(
                          inputFormatters: [
                            // FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9]'),
                            ),
                            FilteringTextInputFormatter.deny(
                              RegExp(
                                  r'^0+'), //users can't type 0 at 1st position
                            ),
                          ],
                          maxLength: 3,
                          controller: sizeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            hintStyle: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 12,
                              color: Colors.grey,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                            ),
                            hintText: '',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            fillColor: Colors.white,
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Color(0xFFEDE2FE), width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: Color(0xFFEDE2FE), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: Color(0xFFEDE2FE), width: 1),
                            ),
                          ),
                        ),
                      ),
                      /* new Container(
                        child: new Row(
                          children: [
                            Switch(
                              value: _enable,
                              activeColor: Colors.black,
                              onChanged: (bool val) {
                                setState(() {
                                  _enable = val;
                                });
                              },
                            ),
                            new Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Allow friends to join with multiple teams.',
                                textAlign: TextAlign.start,
                                style: TextStyle(fontFamily: "Roboto",
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontFamily: AppConstants.textRegular,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),*/

                      GestureDetector(
                        onTap: () {
                          if (nameController.text.isEmpty) {
                            MethodUtils.showError(
                                context, "Please Enter Challenge Name");
                            return;
                          } else if (amountController.text.isEmpty) {
                            MethodUtils.showError(
                                context, "Please Enter Winning Amount");
                            return;
                          } else if (int.parse(
                                  amountController.text.toString()) >
                              10000) {
                            MethodUtils.showError(
                                context, "Please enter a valid amount");
                            return;
                          } else if (sizeController.text.isEmpty) {
                            MethodUtils.showError(
                                context, "Please Enter Challenge Size");
                            return;
                          } else if (int.parse(sizeController.text.toString()) <
                              2) {
                            MethodUtils.showError(context,
                                "You need to choose minimum 2 Challenges size");
                            return;
                          } else if (int.parse(sizeController.text.toString()) >
                              100) {
                            MethodUtils.showError(context,
                                "You can choose upto 100 Challenges size");
                            return;
                          }
                          navigateToWinningBreakupManager(
                            widget.currentContestIndex,
                            context,
                            widget.model,
                            new CreatePrivateContestRequest(
                              name: nameController.text.toString(),
                              user_id: userId,
                              matchkey: widget.model.matchKey,
                              win_amount: amountController.text.toString(),
                              maximum_user: sizeController.text.toString(),
                              entryfee: entryFee,
                              multi_entry: _enable ? '1' : '0',
                              sport_key: widget.model.sportKey,
                              is_public: '0',
                              fantasy_type_id:
                                  CricketTypeFantasy.getCricketType(
                                      widget.model.fantasyType.toString(),
                                      sportsKey: widget.model.sportKey),
                              fantasy_type: widget.model.fantasyType.toString(),
                              slotes_id: widget.model.slotId.toString(),
                            ),
                            widget.onTeamCreated,
                            widget._currentIndex,
                          );
                        },
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.only(
                              left: 20, right: 20, top: 30, bottom: 20),
                          decoration: BoxDecoration(
                            color: buttonGreenColor,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            border: Border.all(
                              color: Color(0xFF6A0BF8),
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            child: Center(
                              child: Text(
                                "Choose Winning Breakup",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: AppConstants.textBold,
                                ),
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
          ),
        ),
      ),
    );
  }
}
