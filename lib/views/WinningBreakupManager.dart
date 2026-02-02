import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/app_navigator.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/customWidgets/MatchHeader.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:myrex11/dataModels/GeneralModel.dart';
import 'package:myrex11/dataModels/JoinChallengeDataModel.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/category_contest_response.dart';
import 'package:myrex11/repository/model/create_private_contest_request.dart';
import 'package:myrex11/repository/model/create_private_contest_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';
import 'package:myrex11/views/MyJoinTeams.dart';

class WinningBreakupManager extends StatefulWidget {
  CreatePrivateContestRequest request;
  GeneralModel model;
  Function onTeamCreated;
  int currentContestIndex;
  int _currentIndex;
  WinningBreakupManager(this.currentContestIndex, this.request, this.model,
      this.onTeamCreated, this._currentIndex);
  @override
  _WinningBreakupManagerState createState() =>
      new _WinningBreakupManagerState();
}

class _WinningBreakupManagerState extends State<WinningBreakupManager> {
  TextEditingController numberController = TextEditingController();
  bool _enable = false;
  List<WinnersList> winnersList = [];
  List<WinnerBreakUpData> breakupData = [];
  List<ValueNotifier<String>> amountNotifiers = [];
  List<TextEditingController> percentControllers = [];
  bool _isUpdating = false;
  List<double> _fixedPercentages = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            /* set Status bar color in Android devices. */

            statusBarIconBrightness: Brightness.light,
            /* set Status bar icons color in Android devices.*/

            statusBarBrightness:
                Brightness.light) /* set Status bar icon color in iOS. */
        );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          new Scaffold(
            backgroundColor: Colors.white,
            /*  appBar: PreferredSize(
              preferredSize: Size.fromHeight(55), // Set this height
              child: Container(
                padding: EdgeInsets.only(top: 0),
                color: Colors.white,
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
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    new Container(
                      child: new Text('Create Contest',
                          style: TextStyle(
                              fontFamily: "Roboto",
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),*/

            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60), // Set this height
              child: Container(
                padding: EdgeInsets.only(
                  top: 45,
                  bottom: 12,
                  left: 16,
                ),
                decoration: BoxDecoration(color: primaryColor
                    // image: DecorationImage(image: AssetImage("assets/images/Ic_creatTeamBackGround.png"),fit: BoxFit.cover)
                    ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
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
                                // color: Colors.white,
                              ),
                            ),
                          ),
                        ),
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
                        child: Container(
                          height: 32,
                          // width: 28,
                          child:
                              Image(image: AssetImage(AppImages.wallet_icon)),
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
              child: new SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 50),
                child: new Container(
                  child: new Column(
                    children: [
                      new MatchHeader(
                          widget.model.teamVs!,
                          widget.model.headerText!,
                          widget.model.isFromLive ?? false,
                          widget.model.isFromLiveFinish ?? false),
                      new Container(
                        decoration: BoxDecoration(
                            border:
                                Border(top: BorderSide(color: primaryColor)),
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                            color: LightprimaryColor),
                        padding: EdgeInsets.all(10),
                        // color: bgColor,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            new Container(
                              child: new Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  new Container(
                                    margin: EdgeInsets.only(bottom: 5),
                                    alignment: Alignment.center,
                                    child: new Text(
                                      'Prize Pool',
                                      style: TextStyle(
                                          fontFamily: AppConstants.textRegular,
                                          color: secondaryTextColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          decoration: TextDecoration.none),
                                    ),
                                  ),
                                  new Container(
                                    height: 30,
                                    padding: EdgeInsets.only(right: 12),
                                    alignment: Alignment.centerLeft,
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
                                          // '₹' +
                                          widget.request.win_amount!,
                                          style: TextStyle(
                                              fontFamily:
                                                  AppConstants.textSemiBold,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                              decoration: TextDecoration.none),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            new Container(
                              child: new Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  new Container(
                                    margin: EdgeInsets.only(bottom: 5),
                                    alignment: Alignment.center,
                                    child: new Text(
                                      'Contest Size',
                                      style: TextStyle(
                                          fontFamily: AppConstants.textRegular,
                                          color: secondaryTextColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          decoration: TextDecoration.none),
                                    ),
                                  ),
                                  new Container(
                                    height: 30,
                                    alignment: Alignment.center,
                                    child: new Text(
                                      widget.request.maximum_user!,
                                      style: TextStyle(
                                          fontFamily: AppConstants.textSemiBold,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          decoration: TextDecoration.none),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            new Container(
                              child: new Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  new Container(
                                    margin: EdgeInsets.only(bottom: 5),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(left: 30),
                                    child: new Text(
                                      'Entry',
                                      style: TextStyle(
                                          fontFamily: AppConstants.textRegular,
                                          color: secondaryTextColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          decoration: TextDecoration.none),
                                    ),
                                  ),
                                  new Container(
                                    alignment: Alignment.centerRight,
                                    child: new Card(
                                      color: buttonGreenColor,
                                      child: new Container(
                                        height: 30,
                                        width: 65,
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5),
                                              child: Container(
                                                height: 16,
                                                // width: 14,
                                                child: Image.asset(
                                                    AppImages.goldcoin),
                                              ),
                                            ),
                                            new Text(
                                              widget.request.entryfee != null
                                                  ? widget.request.entryfee!
                                                  : '0',
                                              // double.parse(
                                              //         !)
                                              //     .toStringAsFixed(0),
                                              style: TextStyle(
                                                fontFamily: "Roboto",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.only(left: 10, top: 20),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Choose total number of winners',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 12,
                            color: secondaryTextColor,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      new Container(
                        margin: EdgeInsets.all(10),
                        child: new Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            new Container(
                              height: 45,
                              child: TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9]')),
                                ],
                                onChanged: (value) {
                                  _enable = false;
                                },
                                maxLength: 2,
                                controller: numberController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  // prefixIcon: Container(
                                  //   child: Image.asset(
                                  //     AppImages.goldcoin,
                                  //     scale: 2.2,
                                  //   ),
                                  // ),
                                  counterText: "",
                                  filled: true,
                                  hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: secondaryTextColor,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  hintText: 'Number of winners',
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
                            // Add these variables to your state class

                            new GestureDetector(
                              child: new Container(
                                alignment: Alignment.centerRight,
                                child: new Card(
                                  color: buttonGreenColor,
                                  child: new Container(
                                    height: 35,
                                    width: 70,
                                    alignment: Alignment.center,
                                    child: new Text(
                                      'SET',
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                _enable = true;

                                if (numberController.text.isEmpty) {
                                  MethodUtils.showError(
                                      context, 'Please enter challenges count');
                                  return;
                                }

                                FocusScope.of(context).unfocus();

                                if (numberController.text.startsWith('0')) {
                                  MethodUtils.showError(context,
                                      'Please enter valid challenges count');
                                  return;
                                }

                                if (int.parse(numberController.text) >
                                    int.parse(widget.request.maximum_user!)) {
                                  MethodUtils.showError(context,
                                      "Number of winners can't be more than number of participants.");
                                  return;
                                }

                                winnersList.clear();
                                percentControllers.clear();
                                amountNotifiers.clear();
                                _fixedPercentages.clear();

                                int count = int.parse(numberController.text);
                                double totalAmount =
                                    double.parse(widget.request.win_amount!);

                                // Calculate equal percentage for all ranks initially
                                double equalPercent = 100 / count;

                                /// 🔹 CREATE WINNERS
                                for (int i = 0; i < count; i++) {
                                  final percentController =
                                      TextEditingController(
                                    text: equalPercent.toStringAsFixed(2),
                                  );

                                  final amountNotifier = ValueNotifier<String>(
                                    (totalAmount * equalPercent / 100)
                                        .toStringAsFixed(2),
                                  );

                                  percentControllers.add(percentController);
                                  amountNotifiers.add(amountNotifier);
                                  _fixedPercentages.add(
                                      equalPercent); // Initially all are not fixed

                                  winnersList.add(
                                    WinnersList(
                                        i, amountNotifier, percentController),
                                  );
                                }

                                /// 🔥 ADD LISTENERS with hierarchical distribution logic
                                for (int i = 0;
                                    i < percentControllers.length;
                                    i++) {
                                  percentControllers[i].addListener(() {
                                    // Prevent infinite update loops
                                    if (_isUpdating) return;

                                    _isUpdating = true;

                                    try {
                                      // Get the changed value
                                      String textValue =
                                          percentControllers[i].text;
                                      if (textValue.isEmpty) {
                                        _isUpdating = false;
                                        return;
                                      }

                                      double newValue =
                                          double.tryParse(textValue) ?? 0;

                                      // Validate the value
                                      if (newValue < 0) {
                                        percentControllers[i].text = "0.00";
                                        newValue = 0;
                                      } else if (newValue > 100) {
                                        percentControllers[i].text = "100.00";
                                        newValue = 100;
                                      }

                                      // Mark this rank as "fixed" (user has manually set it)
                                      _fixedPercentages[i] = newValue;

                                      // Calculate total of fixed percentages (higher ranks + current rank)
                                      double fixedTotal = 0;
                                      for (int j = 0; j <= i; j++) {
                                        fixedTotal += _fixedPercentages[j];
                                      }

                                      // Check if fixed total exceeds 100%
                                      if (fixedTotal > 100) {
                                        // Adjust current value to not exceed 100%
                                        double maxAllowed = 100;
                                        for (int j = 0; j < i; j++) {
                                          maxAllowed -= _fixedPercentages[j];
                                        }

                                        percentControllers[i].text =
                                            maxAllowed.toStringAsFixed(2);
                                        newValue = maxAllowed;
                                        _fixedPercentages[i] = maxAllowed;
                                        fixedTotal = 100;
                                      }

                                      // Calculate remaining percentage for lower ranks
                                      double remaining = 100 - fixedTotal;

                                      // Distribute remaining among lower ranks (if any)
                                      int lowerRanksCount =
                                          percentControllers.length - (i + 1);
                                      if (lowerRanksCount > 0) {
                                        double equalShare =
                                            remaining / lowerRanksCount;

                                        // Update lower ranks
                                        for (int j = i + 1;
                                            j < percentControllers.length;
                                            j++) {
                                          percentControllers[j].text =
                                              equalShare.toStringAsFixed(2);
                                          _fixedPercentages[j] =
                                              equalShare; // Lower ranks are not fixed

                                          // Calculate and update amount
                                          double amount =
                                              (totalAmount * equalShare / 100);
                                          amountNotifiers[j].value =
                                              amount.toStringAsFixed(2);
                                        }
                                      }

                                      // Update amounts for all ranks
                                      for (int j = 0; j <= i; j++) {
                                        double amount = (totalAmount *
                                            _fixedPercentages[j] /
                                            100);
                                        amountNotifiers[j].value =
                                            amount.toStringAsFixed(2);
                                      }
                                    } catch (e) {
                                      print("Error in percentage update: $e");
                                    } finally {
                                      // Small delay to ensure UI updates complete
                                      Future.delayed(Duration(milliseconds: 10),
                                          () {
                                        _isUpdating = false;
                                      });
                                    }
                                  });
                                }

                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                      // new Container(
                      //   padding: EdgeInsets.only(top: 10, bottom: 20),
                      //   alignment: Alignment.center,
                      //   child: Text(
                      //     'If you want change winning breakup change winning %',
                      //     textAlign: TextAlign.start,
                      //     style: TextStyle(
                      //       fontSize: 14,
                      //       color: secondaryTextColor,
                      //       fontStyle: FontStyle.normal,
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                      // new Divider(
                      //   height: 1,
                      //   thickness: 1,
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              border:
                                  Border.all(color: borderColor, width: 0.7),
                              color: Colors.transparent),
                          child: Column(
                            children: [
                              new Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  color: LightprimaryColor,
                                ),
                                height: 40,
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    new Flexible(
                                      child: new Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 15),
                                        child: Text(
                                          'Rank',
                                          style: TextStyle(
                                              color: secondaryTextColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                    new Flexible(
                                      child: new Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          'Winning%',
                                          style: TextStyle(
                                              color: secondaryTextColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                    new Flexible(
                                      child: new Container(
                                        margin: EdgeInsets.only(
                                          right: 10,
                                        ),
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          'Winning Amount',
                                          style: TextStyle(
                                              color: secondaryTextColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                              ),
                              new Column(
                                children: winnersList,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          new Container(
              width: MediaQuery.of(context).size.width,
              height: 45,
              margin: Platform.isIOS
                  ? EdgeInsets.only(bottom: 25, left: 15, right: 15)
                  : EdgeInsets.zero,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Platform.isIOS ? 10 : 0)),
                ),
                // textColor: Colors.white,
                // elevation: .5,
                // color: primaryColor,
                child: Text(
                  'Create Contest',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                onPressed: () {
                  if (numberController.text.isEmpty) {
                    MethodUtils.showError(
                        context, "Number of winners can't be empty",
                        color: primaryColor);
                  } else if (numberController.text.isNotEmpty &&
                      _enable == false) {
                    MethodUtils.showError(context, "Set number of teams",
                        color: primaryColor);
                  } else if (numberController.text.startsWith('0')) {
                    MethodUtils.showError(
                        context, 'Please enter valid challenges count');
                  } else {
                    createContest(createContest: true);
                  }
                },
              ))
        ],
      ),
    );
  }

  void createContest({bool? createContest}) async {
    Contest contest = Contest();
    FocusScope.of(context).unfocus();
    breakupData.clear();
    for (int i = 0; i < winnersList.length; i++) {
      WinnerBreakUpData winnerBreakUpData = new WinnerBreakUpData();
      winnerBreakUpData.rank = (winnersList[i].index + 1).toString();
      winnerBreakUpData.winningPer =
          winnersList[i].percentController.text.toString();
      winnerBreakUpData.winningAmmount =
          winnersList[i].amountNotifier.toString();
      breakupData.add(winnerBreakUpData);
    }
    widget.request.pricecards = breakupData;
    AppLoaderProgress.showLoader(context);

    final client = ApiClient(AppRepository.dio);
    CreatePrivateContestResponse myBalanceResponse =
        await client.createContest(widget.request);
    AppLoaderProgress.hideLoader(context);
    if (myBalanceResponse.status == 1) {
      Fluttertoast.showToast(
          msg: 'Contest Created Successfully',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1);
      Contest contest = myBalanceResponse.result![0].contest!;
      if (widget.model.teamCount == 1) {
        MethodUtils.checkBalance(
            widget.currentContestIndex,
            new JoinChallengeDataModel(
                context,
                0,
                int.parse(widget.request.user_id!),
                contest.id!,
                widget.model.fantasyType!,
                // widget.model.slotId!,
                1,
                contest.is_bonus!,
                contest.win_amount!,
                contest.maximum_user!,
                widget.model.teamId.toString(),
                //contest.entryfee.toString(),
                double.parse(widget.request.entryfee!).toStringAsFixed(2),
                widget.model.matchKey!,
                widget.model.sportKey!,
                widget.model.joinedSwitchTeamId.toString(),
                false,
                0,
                0,
                onJoinContestResult,
                contest),
            createContest: createContest);
      } else if (widget.model.teamCount! > 0) {
        if (widget._currentIndex != 2) {
          Navigator.pop(context);
          Navigator.pop(context);
          navigateToMyJoinTeams(widget.currentContestIndex, context,
              widget.model, contest, onJoinContestResult);
        } else {
          Navigator.pop(context);
          Platform.isAndroid
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyJoinTeams(
                          widget.currentContestIndex,
                          widget.model,
                          contest,
                          onJoinContestResult))).then((value) {})
              : Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => MyJoinTeams(
                          widget.currentContestIndex,
                          widget.model,
                          contest,
                          onJoinContestResult))).then((value) {});
        }
        // navigateToMyJoinTeams(widget.currentContestIndex, context, widget.model,
        //     contest, onJoinContestResult);
      } else {
        // Navigator.pop(context);
        widget.model.onJoinContestResult = onJoinContestResult;
        widget.model.contest = contest;

        navigateToCreateTeam(context, widget.model);
      }
      return;
    }
    Fluttertoast.showToast(
        msg: myBalanceResponse.message!,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1);
  }

  void onJoinContestResult(int isJoined, String referCode) {
    if (widget.model.teamCount == 0 || widget.model.teamCount == 1) {
      Navigator.pop(context);
      Navigator.pop(context);
    }

    widget.model.teamCount = widget.model.teamCount! + 1;
    widget.onTeamCreated();
  }
}

class WinnersList extends StatefulWidget {
  final int index;
  final ValueNotifier<String> amountNotifier;
  final TextEditingController percentController;
  final bool isFixed;

  WinnersList(
    this.index,
    this.amountNotifier,
    this.percentController, {
    this.isFixed = false,
  });

  @override
  _WinnersListState createState() => _WinnersListState();
}

class _WinnersListState extends State<WinnersList> {
  String getOrdinal(int number) {
    if (number >= 11 && number <= 13) {
      return 'th';
    }
    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          height: 1,
          thickness: 1,
          color: widget.isFixed ? primaryColor : borderColor,
        ),
        Container(
          height: 55,
          padding: const EdgeInsets.all(8),
          decoration: widget.isFixed
              ? BoxDecoration(
                  color: primaryColor.withOpacity(0.05),
                  border: Border(
                    left: BorderSide(color: primaryColor, width: 3),
                  ),
                )
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// 🏆 Rank with lock icon for fixed percentages
              Container(
                width: 40,
                margin: const EdgeInsets.only(left: 5),
                child: Row(
                  children: [
                    if (widget.isFixed)
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(
                          Icons.lock_outline,
                          size: 14,
                          color: primaryColor,
                        ),
                      ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: widget.isFixed
                              ? primaryColor
                              : secondaryTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(text: '${widget.index + 1}'),
                          WidgetSpan(
                            child: Transform.translate(
                              offset: const Offset(1, -4),
                              child: Text(
                                getOrdinal(widget.index + 1),
                                style: TextStyle(
                                  fontSize: 9,
                                  color: widget.isFixed
                                      ? primaryColor
                                      : secondaryTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// 📊 Percentage Input
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                  width: 80,
                  height: 45,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      TextField(
                        controller: widget.percentController,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        cursorColor: primaryColor,
                        cursorWidth: 1,
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.isFixed
                              ? primaryColor
                              : secondaryTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          counterText: "",
                          filled: true,
                          fillColor: widget.isFixed
                              ? primaryColor.withOpacity(0.1)
                              : Colors.white,
                          hintText: "0.00",
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  widget.isFixed ? primaryColor : Colors.white,
                              width: widget.isFixed ? 2.0 : 1.5,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColor, width: 2.0),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        ),
                      ),
                      // Position the % symbol to the right of the text field
                      Positioned(
                        right: 8,
                        child: Text(
                          '%',
                          style: TextStyle(
                            fontSize: 14,
                            color: widget.isFixed
                                ? primaryColor
                                : Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// 💰 Amount (AUTO UPDATE)
              Container(
                // width: 80,
                margin: const EdgeInsets.only(right: 10),
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: SizedBox(
                        height: 18,
                        child: Image.asset(
                          AppImages.goldcoin,
                          color: widget.isFixed ? primaryColor : null,
                        ),
                      ),
                    ),
                    ValueListenableBuilder<String>(
                      valueListenable: widget.amountNotifier,
                      builder: (context, value, _) {
                        return Text(
                          value,
                          style: TextStyle(
                            color: widget.isFixed ? primaryColor : Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
