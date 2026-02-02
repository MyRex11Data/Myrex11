import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myrex11/appUtilities/defaultbutton.dart';
import 'package:myrex11/util/customWidgets/customText.dart';
import 'package:intl/intl.dart';
import 'package:myrex11/appUtilities/app_colors.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/appUtilities/app_images.dart';
import 'package:myrex11/appUtilities/method_utils.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/base_response.dart';
import 'package:myrex11/repository/model/transactions_response.dart';
import 'package:myrex11/repository/model/transactions_request.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';

class RecentTransactions extends StatefulWidget {
  @override
  _RecentTransactionsState createState() => new _RecentTransactionsState();
}

class _RecentTransactionsState extends State<RecentTransactions> {
  TextEditingController codeController = TextEditingController();
  List<TransactionItem> transactionList = [];
  DateFormat dateFormat = new DateFormat("dd-MM-yyyy");
  late String userId = '0';
  String filterType = 'All';
  DateTime startDateTime = DateTime(1900);
  String start_date = '';
  String end_date = '';
  String current_date = DateFormat('MMM dd, yyyy').format(DateTime.now());
  @override
  void initState() {
    super.initState();
    AppPrefrence.getString(AppConstants.SHARED_PREFERENCE_USER_ID)
        .then((value) => {
              setState(() {
                userId = value;
                getMyTransaction();
              })
            });
  }

  @override
  void dispose() {
    super.dispose();
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
    return Container(
      // color: primaryColor,
      child: Scaffold(
        backgroundColor: bgColor,
        /*  appBar: PreferredSize(
          preferredSize: Size.fromHeight(55), // Set this height
          child: Container(
            color: primaryColor,
            padding: EdgeInsets.only(top: 0),
            child: Padding(
              padding: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => {Navigator.pop(context)},
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 15, right: 8, top: 15, bottom: 15),
                      alignment: Alignment.centerLeft,
                      child: Container(
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
                  Container(
                    child: Text('Recent Transactions',
                        style: TextStyle(
                            fontFamily: "Roboto",
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16)),
                  ),
                ],
              ),
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
                // image: DecorationImage(
                //     image:
                //         AssetImage("assets/images/Ic_creatTeamBackGround.png"),
                //     fit: BoxFit.cover)

                color: primaryColor),
            child: Row(
              children: [
                new GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => {Navigator.pop(context)},
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
                Text("Recent Transactions",
                    style: TextStyle(
                        fontFamily: "Roboto",
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Container(
            decoration: BoxDecoration(
              // image: DecorationImage(
              //     image: AssetImage(AppImages.commanBackground),
              //     fit: BoxFit.cover),
              color: Colors.white,
              // border: Border.all(
              //   color: Color(0xFFe8adad), // Border color
              //   width: 1.0, // Optional: Border width
              // ),
              borderRadius: BorderRadius.circular(10.0), // Add
            ),
            height: MediaQuery.of(context).size.height,
            child: new Column(
              children: [
                new Divider(
                  height: 1,
                  thickness: 1,
                ),
                new Container(
                  height: 60,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: new Container(
                          margin: EdgeInsets.only(left: 10),
                          child: new Row(
                            children: [
                              new Container(
                                margin: EdgeInsets.only(left: 5, right: 5),
                                height: 25,
                                // width: 18,
                                child: Image(
                                  image: AssetImage(
                                    AppImages.filterIcon,
                                  ),
                                ),
                              ),
                              new Text('Filters',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18)),
                            ],
                          ),
                        ),
                        onTap: () {
                          _modalBottomSheetMenu(context);
                        },
                      ),
                      // new Container(
                      //     width: 150,
                      //     height: 45,
                      //     margin: EdgeInsets.all(10),
                      //     child: RaisedButton(
                      //       textColor: Colors.white,
                      //       elevation: .5,
                      //       color: greenColor,
                      //       child: Text(
                      //         'Download',
                      //         style:
                      //             TextStyle(fontSize: 14, color: Colors.white),
                      //       ),
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(5)),
                      //       onPressed: () {
                      //         transactionDownload();
                      //       },
                      //     ))
                    ],
                  ),
                ),

                // new Divider(height: 1,thickness: 1,),
                // new Container(
                //   height: 40,
                //   width: MediaQuery.of(context).size.width,
                //   color: bgColorDark,
                //   alignment: Alignment.center,
                //   child: new Text(current_date,
                //       style: TextStyle(
                //           fontFamily: AppConstants.textBold,
                //           color: Colors.black,
                //           fontWeight: FontWeight.w400,
                //           fontSize: 12)),
                // ),
                // new Divider(height: 1,thickness: 1,),
                Expanded(
                    child: Container(
                  child: SingleChildScrollView(
                    child: new Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        // border: Border.all(
                        //   color: Color(0xFFe8adad), // Border color
                        //   width: 0.4, // Optional: Border width
                        // ),
                        borderRadius:
                            BorderRadius.circular(10.0), // Add rounded corners
                      ),
                      child: transactionList.length > 0
                          ? new ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              itemCount: transactionList.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return new Container(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20, top: 10),
                                        child: new Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            new Container(
                                              //  margin: EdgeInsets.only(top: 10,bottom: 10),
                                              //   padding: EdgeInsets.fromLTRB(10,15,10,15),
                                              // alignment: Alignment.center,
                                              // decoration: BoxDecoration(
                                              //     border: Border.all(color: mediumGrayColor,),
                                              //     borderRadius: BorderRadius.circular(3),
                                              //     color: Colors.white
                                              // ),
                                              child: new Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: new Text(
                                                        transactionList[index]
                                                            .transaction_type!,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            color: textCol,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14)),
                                                  ),
                                                  new Container(
                                                    //  width: 100,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        new Text(
                                                            double.parse(transactionList[
                                                                            index]
                                                                        .deduct_amount!) >
                                                                    0
                                                                ? '- '
                                                                : double.parse(transactionList[index].deduct_amount!) ==
                                                                        0
                                                                    ? double.parse(transactionList[index].add_amount!) >
                                                                            0
                                                                        ? '+ '
                                                                        : ''
                                                                    : '',
                                                            style: TextStyle(
                                                                // fontFamily:
                                                                //     'Roboto',
                                                                color: double.parse(
                                                                            transactionList[index]
                                                                                .deduct_amount!) >
                                                                        0
                                                                    ? primaryColor
                                                                    : double.parse(transactionList[index].deduct_amount!) ==
                                                                            0
                                                                        ? double.parse(transactionList[index].add_amount!) >
                                                                                0
                                                                            ? greenColor
                                                                            : yellowColor
                                                                        : greenColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                fontSize: 16)),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 4),
                                                          child: Container(
                                                            height: 18,
                                                            width: 18,
                                                            child: Image.asset(
                                                                AppImages
                                                                    .goldcoin),
                                                          ),
                                                        ),
                                                        new Text(
                                                            double.parse(transactionList[index]
                                                                        .deduct_amount!) >
                                                                    0
                                                                ? transactionList[
                                                                        index]
                                                                    .deduct_amount!
                                                                : double.parse(transactionList[index].deduct_amount!) ==
                                                                        0
                                                                    ? double.parse(transactionList[index].add_amount!) >
                                                                            0
                                                                        ? transactionList[index]
                                                                            .add_amount!
                                                                        : transactionList[index]
                                                                            .deduct_amount!
                                                                    : transactionList[
                                                                            index]
                                                                        .add_amount!,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                color: double.parse(transactionList[index].deduct_amount!) >
                                                                        0
                                                                    ? primaryColor
                                                                    : double.parse(transactionList[index].deduct_amount!) ==
                                                                            0
                                                                        ? double.parse(transactionList[index].add_amount!) >
                                                                                0
                                                                            ? greenColor
                                                                            : yellowColor
                                                                        : greenColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            new Container(
                                              margin: EdgeInsets.only(top: 8),
                                              child: new Text(
                                                DateFormat(
                                                        "d MMMM, yyyy, hh:mm a")
                                                    .format(DateTime.parse(
                                                        transactionList[index]
                                                            .created
                                                            .toString())),
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    color: Color(0xff969696),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            new Container(
                                              child: new Text(
                                                'Transaction ID: ' +
                                                    transactionList[index]
                                                        .transaction_id!,
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    color: lightBlack,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if ((transactionList.indexOf(
                                              transactionList[index]) !=
                                          transactionList.length - 1))
                                        Divider(
                                          color: borderColor,
                                          thickness: 1,
                                        )
                                    ],
                                  ),
                                );
                              })
                          : Center(
                              child: Container(
                                  height: MediaQuery.of(context).size.width,
                                  child: Center(
                                      child: Text(
                                    'No data found.',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  )))),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _modalBottomSheetMenu(BuildContext context) {
    /*   showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0), topRight: Radius.circular(0))),
        builder: (builder) {
          return StatefulBuilder(
              builder: (context, setState) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        color: mediumGrayColor,
                        child: new Row(
                          children: [
                            new GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              child: new Container(
                                height: 40,
                                alignment: Alignment.center,
                                child: new Container(
                                  child: Icon(
                                    Icons.clear,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              onTap: () => {Navigator.pop(context)},
                            ),
                            new GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              child: new Container(
                                width: MediaQuery.of(context).size.width - 50,
                                alignment: Alignment.center,
                                child: new Text('Filter',
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16)),
                              ),
                              onTap: () => {},
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        child: new Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              new Container(
                                alignment: Alignment.center,
                                child: new Text('All',
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14)),
                              ),
                              Radio(
                                value: 'All',
                                groupValue: filterType,
                                activeColor: primaryColor,
                                onChanged: (value) {
                                  setState(() {
                                    filterType = value.toString();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            filterType = 'All';
                          });
                        },
                      ),
                      new Divider(
                        height: 2,
                        thickness: 1,
                      ),
                      InkWell(
                        child: new Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              new Container(
                                alignment: Alignment.center,
                                child: new Text('Deposits',
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14)),
                              ),
                              Radio(
                                value: 'Deposit',
                                groupValue: filterType,
                                activeColor: primaryColor,
                                onChanged: (value) {
                                  setState(() {
                                    filterType = value.toString();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            filterType = 'Deposit';
                          });
                        },
                      ),
                      new Divider(
                        height: 2,
                        thickness: 1,
                      ),
                      InkWell(
                        child: new Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              new Container(
                                alignment: Alignment.center,
                                child: new Text('Winnings',
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14)),
                              ),
                              Radio(
                                value: 'Winning',
                                groupValue: filterType,
                                activeColor: primaryColor,
                                onChanged: (value) {
                                  setState(() {
                                    filterType = value.toString();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            filterType = 'Winning';
                          });
                        },
                      ),
                      new Divider(
                        height: 2,
                        thickness: 1,
                      ),
                      InkWell(
                        child: new Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              new Container(
                                alignment: Alignment.center,
                                child: new Text('Withdraw',
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14)),
                              ),
                              Radio(
                                value: 'Withdraw',
                                groupValue: filterType,
                                activeColor: primaryColor,
                                onChanged: (value) {
                                  setState(() {
                                    filterType = value.toString();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            filterType = 'Withdraw';
                          });
                        },
                      ),
                      new Divider(
                        height: 2,
                        thickness: 1,
                      ),
                      InkWell(
                        child: new Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              new Container(
                                alignment: Alignment.center,
                                child: new Text('Affiliate Commission',
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14)),
                              ),
                              Radio(
                                value: 'Affiliate',
                                groupValue: filterType,
                                activeColor: primaryColor,
                                onChanged: (value) {
                                  setState(() {
                                    filterType = value.toString();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            filterType = 'Affiliate';
                          });
                        },
                      ),
                      new Divider(
                        height: 2,
                        thickness: 1,
                      ),
                      new Container(
                        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: new Row(
                          children: [
                            Flexible(
                              child: new Container(
                                margin: EdgeInsets.only(right: 5),
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    new Container(
                                      alignment: Alignment.centerLeft,
                                      child: new Text('From Date',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12)),
                                    ),
                                    new GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      child: new Container(
                                        margin:
                                            EdgeInsets.only(top: 5, bottom: 10),
                                        padding: EdgeInsets.all(8),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: mediumGrayColor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            color: Colors.white),
                                        child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            new Container(
                                              child: new Text(
                                                  start_date.isEmpty
                                                      ? 'Select Date'
                                                      : start_date,
                                                  style: TextStyle(
                                                      fontFamily: "Roboto",
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14)),
                                            ),
                                            new Container(
                                              child: Icon(
                                                Icons.keyboard_arrow_down,
                                                size: 30,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () async {
                                        startDateTime = (await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime.now()))!;

                                        start_date =
                                            dateFormat.format(startDateTime);
                                        setState(() {});
                                      },
                                    )
                                  ],
                                ),
                              ),
                              flex: 1,
                            ),
                            Flexible(
                              child: new Container(
                                margin: EdgeInsets.only(left: 5),
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    new Container(
                                      alignment: Alignment.centerLeft,
                                      child: new Text('End Date',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12)),
                                    ),
                                    new GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      child: new Container(
                                        margin:
                                            EdgeInsets.only(top: 5, bottom: 10),
                                        padding: EdgeInsets.all(8),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: mediumGrayColor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            color: Colors.white),
                                        child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            new Container(
                                              child: new Text(
                                                  end_date.isEmpty
                                                      ? 'Select Date'
                                                      : end_date,
                                                  style: TextStyle(
                                                      fontFamily: "Roboto",
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14)),
                                            ),
                                            new Container(
                                              child: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  size: 30),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () async {
                                        DateTime date = DateTime(1900);

                                        date = (await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: startDateTime,
                                            lastDate: DateTime.now()))!;

                                        end_date = dateFormat.format(date);
                                        setState(() {});
                                      },
                                    )
                                  ],
                                ),
                              ),
                              flex: 1,
                            )
                          ],
                        ),
                      ),
                      DefaultButton(
                        height: 45,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(10),
                        color: primaryColor,
                        text: "Apply",
                        textcolor: Colors.white,
                        borderRadius: 5,
                        onpress: () {
                          if (start_date.isEmpty) {
                            MethodUtils.showError(
                                context, 'Please select from date');
                          } else if (end_date.isEmpty) {
                            MethodUtils.showError(
                                context, 'Please select end date');
                          } else {
                            Navigator.pop(context);
                            getMyTransaction();
                          }
                        },
                      )
                      // new Container(
                      //     width: MediaQuery.of(context).size.width,
                      //     height: 45,
                      //     margin: EdgeInsets.all(10),
                      //     child: RaisedButton(
                      //       textColor: Colors.white,
                      //       elevation: .5,
                      //       color: primaryColor,
                      //       child: Text(
                      //         'Apply',
                      //         style: TextStyle(fontSize: 14,color: Colors.white),
                      //       ),
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius:
                      //           BorderRadius.circular(5)),
                      //       onPressed: () {
                      //
                      //       },
                      //     ))
                    ],
                  ));
        });*/

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight:
                        Radius.circular(10)) // Set the desired border radius
                ),
            contentPadding: EdgeInsets.all(0.0), //
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Container(
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      height: 50,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.transparent,
                          ),
                          new GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            child: new Container(
                              alignment: Alignment.center,
                              child: new Text('Filter',
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16)),
                            ),
                            onTap: () => {},
                          ),
                          new GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            child: new Container(
                              child: Icon(
                                Icons.clear,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                            onTap: () => {Navigator.pop(context)},
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            new Container(
                              alignment: Alignment.center,
                              child: new Text('All',
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                            ),
                            Radio(
                              value: 'All',
                              groupValue: filterType,
                              activeColor: primaryColor,
                              onChanged: (value) {
                                setState(() {
                                  filterType = value.toString();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          filterType = 'All';
                        });
                      },
                    ),
                    new Divider(
                      height: 2,
                      thickness: 1,
                    ),
                    InkWell(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            new Container(
                              alignment: Alignment.center,
                              child: new Text('Deposits',
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                            ),
                            Radio(
                              value: 'Deposit',
                              groupValue: filterType,
                              activeColor: primaryColor,
                              onChanged: (value) {
                                setState(() {
                                  filterType = value.toString();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          filterType = 'Deposit';
                        });
                      },
                    ),
                    new Divider(
                      height: 2,
                      thickness: 1,
                    ),
                    InkWell(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            new Container(
                              alignment: Alignment.center,
                              child: new Text('Winnings',
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                            ),
                            Radio(
                              value: 'Winning',
                              groupValue: filterType,
                              activeColor: primaryColor,
                              onChanged: (value) {
                                setState(() {
                                  filterType = value.toString();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          filterType = 'Winning';
                        });
                      },
                    ),
                    new Divider(
                      height: 2,
                      thickness: 1,
                    ),
                    InkWell(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            new Container(
                              alignment: Alignment.center,
                              child: new Text('Withdraw',
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                            ),
                            Radio(
                              value: 'Withdraw',
                              groupValue: filterType,
                              activeColor: primaryColor,
                              onChanged: (value) {
                                setState(() {
                                  filterType = value.toString();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          filterType = 'Withdraw';
                        });
                      },
                    ),
                    new Divider(
                      height: 2,
                      thickness: 1,
                    ),
                    InkWell(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            new Container(
                              alignment: Alignment.center,
                              child: new Text('Affiliate Commission',
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                            ),
                            Radio(
                              value: 'Affiliate',
                              groupValue: filterType,
                              activeColor: primaryColor,
                              onChanged: (value) {
                                setState(() {
                                  filterType = value.toString();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          filterType = 'Affiliate';
                        });
                      },
                    ),
                    new Divider(
                      height: 2,
                      thickness: 1,
                    ),
                    new Container(
                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: new Row(
                        children: [
                          Flexible(
                            child: new Container(
                              margin: EdgeInsets.only(right: 5),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  new Container(
                                    alignment: Alignment.centerLeft,
                                    child: new Text('From Date',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12)),
                                  ),
                                  new GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    child: new Container(
                                      margin:
                                          EdgeInsets.only(top: 5, bottom: 10),
                                      padding: EdgeInsets.all(8),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: mediumGrayColor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          color: Colors.white),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          new Container(
                                            child: new Text(
                                                start_date.isEmpty
                                                    ? 'Select Date'
                                                    : start_date,
                                                style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14)),
                                          ),
                                          new Container(
                                            child: Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 30,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      startDateTime = (await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now()))!;

                                      start_date =
                                          dateFormat.format(startDateTime);
                                      setState(() {});
                                    },
                                  )
                                ],
                              ),
                            ),
                            flex: 1,
                          ),
                          Flexible(
                            child: new Container(
                              margin: EdgeInsets.only(left: 5),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  new Container(
                                    alignment: Alignment.centerLeft,
                                    child: new Text('End Date',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12)),
                                  ),
                                  new GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    child: new Container(
                                      margin:
                                          EdgeInsets.only(top: 5, bottom: 10),
                                      padding: EdgeInsets.all(8),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: mediumGrayColor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          color: Colors.white),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          new Container(
                                            child: new Text(
                                                end_date.isEmpty
                                                    ? 'Select Date'
                                                    : end_date,
                                                style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14)),
                                          ),
                                          new Container(
                                            child: Icon(
                                                Icons.keyboard_arrow_down,
                                                size: 30),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      DateTime date = DateTime(1900);

                                      date = (await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: startDateTime,
                                          lastDate: DateTime.now()))!;

                                      end_date = dateFormat.format(date);
                                      setState(() {});
                                    },
                                  )
                                ],
                              ),
                            ),
                            flex: 1,
                          )
                        ],
                      ),
                    ),
                    DefaultButton(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.all(10),
                      color: primaryColor,
                      text: "Apply",
                      textcolor: Colors.white,
                      borderRadius: 5,
                      onpress: () {
                        if (start_date.isEmpty) {
                          MethodUtils.showError(
                              context, 'Please select from date');
                        } else if (end_date.isEmpty) {
                          MethodUtils.showError(
                              context, 'Please select end date');
                        } else {
                          Navigator.pop(context);
                          getMyTransaction();
                        }
                      },
                    )
                    // new Container(
                    //     width: MediaQuery.of(context).size.width,
                    //     height: 45,
                    //     margin: EdgeInsets.all(10),
                    //     child: RaisedButton(
                    //       textColor: Colors.white,
                    //       elevation: .5,
                    //       color: primaryColor,
                    //       child: Text(
                    //         'Apply',
                    //         style: TextStyle(fontSize: 14,color: Colors.white),
                    //       ),
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius:
                    //           BorderRadius.circular(5)),
                    //       onPressed: () {
                    //
                    //       },
                    //     ))
                  ],
                );
              },
            ),
            /*  children: <Widget>[]*/
          );
        });
  }

  void getMyTransaction() async {
    transactionList.clear();
    AppLoaderProgress.showLoader(context);
    TransactionRequest loginRequest = new TransactionRequest(
        user_id: userId,
        page: 0,
        filter_type: filterType,
        start_date: start_date,
        end_date: end_date);
    final client = ApiClient(AppRepository.dio);
    TransactionsResponse transactionsResponse =
        await client.getMyTransaction(loginRequest);
    AppLoaderProgress.hideLoader(context);
    if (transactionsResponse.status == 1) {
      // current_date=transactionsResponse.result!.data!.length>0?DateFormat('MMM dd,yyyy').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(transactionsResponse.result!.data![0].date!)):DateFormat('MMM dd,yyyy').format(DateTime.now());
      transactionList = transactionsResponse.result!.data!;
    }
    setState(() {});
  }

  void transactionDownload() async {
    AppLoaderProgress.showLoader(context);
    TransactionRequest loginRequest = new TransactionRequest(
        user_id: userId,
        page: 0,
        filter_type: filterType,
        start_date: start_date,
        end_date: end_date);
    final client = ApiClient(AppRepository.dio);
    GeneralResponse transactionsResponse =
        await client.transactionDownload(loginRequest);
    AppLoaderProgress.hideLoader(context);
    Fluttertoast.showToast(
        msg: transactionsResponse.message!,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1);
    setState(() {});
  }

  getFilterSheet() {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 10, right: 10),
            color: mediumGrayColor,
            child: new Row(
              children: [
                new GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: new Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: new Container(
                      child: Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  onTap: () => {Navigator.pop(context)},
                ),
                new GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: new Container(
                    width: MediaQuery.of(context).size.width - 50,
                    alignment: Alignment.center,
                    child: new Text('Filter',
                        style: TextStyle(
                            fontFamily: "Roboto",
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16)),
                  ),
                  onTap: () => {},
                ),
              ],
            ),
          ),
          InkWell(
            child: new Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Container(
                    alignment: Alignment.center,
                    child: new Text('All',
                        style: TextStyle(
                            fontFamily: "Roboto",
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14)),
                  ),
                  Radio(
                    value: 'All',
                    groupValue: filterType,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      setState(() {
                        filterType = value.toString();
                      });
                    },
                  ),
                ],
              ),
            ),
            onTap: () {
              setState(() {
                filterType = 'All';
              });
            },
          ),
          new Divider(
            height: 2,
            thickness: 1,
          ),
          InkWell(
            child: new Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Container(
                    alignment: Alignment.center,
                    child: new Text('Deposits',
                        style: TextStyle(
                            fontFamily: "Roboto",
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14)),
                  ),
                  Radio(
                    value: 'Deposit',
                    groupValue: filterType,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      setState(() {
                        filterType = value.toString();
                      });
                    },
                  ),
                ],
              ),
            ),
            onTap: () {
              setState(() {
                filterType = 'Deposit';
              });
            },
          ),
          new Divider(
            height: 2,
            thickness: 1,
          ),
          InkWell(
            child: new Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Container(
                    alignment: Alignment.center,
                    child: new Text('Winnings',
                        style: TextStyle(
                            fontFamily: "Roboto",
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14)),
                  ),
                  Radio(
                    value: 'Winning',
                    groupValue: filterType,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      setState(() {
                        filterType = value.toString();
                      });
                    },
                  ),
                ],
              ),
            ),
            onTap: () {
              setState(() {
                filterType = 'Winning';
              });
            },
          ),
          new Divider(
            height: 2,
            thickness: 1,
          ),
          InkWell(
            child: new Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Container(
                    alignment: Alignment.center,
                    child: new Text('Withdraw',
                        style: TextStyle(
                            fontFamily: "Roboto",
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14)),
                  ),
                  Radio(
                    value: 'Withdraw',
                    groupValue: filterType,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      setState(() {
                        filterType = value.toString();
                      });
                    },
                  ),
                ],
              ),
            ),
            onTap: () {
              setState(() {
                filterType = 'Withdraw';
              });
            },
          ),
          new Divider(
            height: 2,
            thickness: 1,
          ),
          InkWell(
            child: new Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Container(
                    alignment: Alignment.center,
                    child: new Text('Affiliate Commission',
                        style: TextStyle(
                            fontFamily: "Roboto",
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14)),
                  ),
                  Radio(
                    value: 'Affiliate',
                    groupValue: filterType,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      setState(() {
                        filterType = value.toString();
                      });
                    },
                  ),
                ],
              ),
            ),
            onTap: () {
              setState(() {
                filterType = 'Affiliate';
              });
            },
          ),
          new Divider(
            height: 2,
            thickness: 1,
          ),
          new Container(
            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: new Row(
              children: [
                Flexible(
                  child: new Container(
                    margin: EdgeInsets.only(right: 5),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Container(
                          alignment: Alignment.centerLeft,
                          child: new Text('From Date',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12)),
                        ),
                        new GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: new Container(
                            margin: EdgeInsets.only(top: 5, bottom: 10),
                            padding: EdgeInsets.all(8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: mediumGrayColor,
                                ),
                                borderRadius: BorderRadius.circular(2),
                                color: Colors.white),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Container(
                                  child: new Text(
                                      start_date.isEmpty
                                          ? 'Select Date'
                                          : start_date,
                                      style: TextStyle(
                                          fontFamily: "Roboto",
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                ),
                                new Container(
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 30,
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () async {
                            startDateTime = (await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now()))!;

                            start_date = dateFormat.format(startDateTime);
                            setState(() {});
                          },
                        )
                      ],
                    ),
                  ),
                  flex: 1,
                ),
                Flexible(
                  child: new Container(
                    margin: EdgeInsets.only(left: 5),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Container(
                          alignment: Alignment.centerLeft,
                          child: new Text('End Date',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12)),
                        ),
                        new GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: new Container(
                            margin: EdgeInsets.only(top: 5, bottom: 10),
                            padding: EdgeInsets.all(8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: mediumGrayColor,
                                ),
                                borderRadius: BorderRadius.circular(2),
                                color: Colors.white),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Container(
                                  child: new Text(
                                      end_date.isEmpty
                                          ? 'Select Date'
                                          : end_date,
                                      style: TextStyle(
                                          fontFamily: "Roboto",
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                ),
                                new Container(
                                  child:
                                      Icon(Icons.keyboard_arrow_down, size: 30),
                                )
                              ],
                            ),
                          ),
                          onTap: () async {
                            DateTime date = DateTime(1900);

                            date = (await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: startDateTime,
                                lastDate: DateTime.now()))!;

                            end_date = dateFormat.format(date);
                            setState(() {});
                          },
                        )
                      ],
                    ),
                  ),
                  flex: 1,
                )
              ],
            ),
          ),
          DefaultButton(
            height: 45,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(10),
            color: primaryColor,
            text: "Apply",
            textcolor: Colors.white,
            borderRadius: 5,
            onpress: () {
              if (start_date.isEmpty) {
                MethodUtils.showError(context, 'Please select from date');
              } else if (end_date.isEmpty) {
                MethodUtils.showError(context, 'Please select end date');
              } else {
                Navigator.pop(context);
                getMyTransaction();
              }
            },
          )
          // new Container(
          //     width: MediaQuery.of(context).size.width,
          //     height: 45,
          //     margin: EdgeInsets.all(10),
          //     child: RaisedButton(
          //       textColor: Colors.white,
          //       elevation: .5,
          //       color: primaryColor,
          //       child: Text(
          //         'Apply',
          //         style: TextStyle(fontSize: 14,color: Colors.white),
          //       ),
          //       shape: RoundedRectangleBorder(
          //           borderRadius:
          //           BorderRadius.circular(5)),
          //       onPressed: () {
          //
          //       },
          //     ))
        ],
      ),
    );
  }
}
